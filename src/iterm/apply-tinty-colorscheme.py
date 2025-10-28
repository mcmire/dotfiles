#!/usr/bin/env python3

"""
iTerm2 Tinty colorscheme sync script

This script reads the current Tinty theme and applies it to all iTerm2 sessions.

Requires 'iterm2' and 'pyyaml' packages.

You can read about Tinty here: <https://github.com/tinted-theming/tinty>

Loosely inspired by:
* <https://gist.github.com/jamesmacfie/2061023e5365e8b6bfbbc20792ac90f8#gistcomment-3599985>
* <https://iterm2.com/python-api/examples/setprofile.html>
* <https://grrr.tech/posts/2020/switch-dark-mode-os/>
"""

import asyncio
import subprocess
import yaml
from pathlib import Path
from typing import Dict
import iterm2


class TintyColorScheme:
    """Represents a Tinty color scheme with its name and colors."""
    
    def __init__(self, name: str, colors: Dict[str, str], color_scheme_file: Path):
        self.name = name
        self.colors = colors
        self.color_scheme_file = color_scheme_file
    
    def __repr__(self):
        return f"TintyColorScheme(name='{self.name}', colors={len(self.colors)})"


def get_tinty_data_dir() -> Path:
    """Get the Tinty data directory path by calling tinty config."""

    try:
        result = subprocess.run(
            ['tinty', 'config', '--data-dir-path'],
            capture_output=True,
            text=True,
            check=True
        )
        data_dir = result.stdout.strip()
        return Path(data_dir)
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Failed to get Tinty data directory: {e.stderr}")
    except FileNotFoundError:
        raise RuntimeError("tinty command not found. Is Tinty installed?")


def hex_to_iterm_color(hex_color: str) -> iterm2.Color:
    """Convert hex color string to iTerm2 Color object."""

    hex_color = hex_color.lstrip('#')
    r = int(hex_color[0:2], 16)
    g = int(hex_color[2:4], 16)
    b = int(hex_color[4:6], 16)
    return iterm2.Color(r, g, b)


def find_color_scheme_file(full_color_scheme_name: str) -> Path:
    """Find the YAML file for the given color scheme name."""

    tinty_data_dir = get_tinty_data_dir()
    tinty_color_schemes_dir = tinty_data_dir / "repos/schemes"
    
    if full_color_scheme_name.startswith("base24-"):
        base_dir = "base24"
        short_color_scheme_name = full_color_scheme_name[7:]
    elif full_color_scheme_name.startswith("base16-"):
        base_dir = "base16"
        short_color_scheme_name = full_color_scheme_name[7:]
    else:
        raise RuntimeError(f"Unknown base in color scheme '{full_color_scheme_name}'")
    
    color_scheme_path = tinty_color_schemes_dir / base_dir / f"{short_color_scheme_name}.yaml"
    if color_scheme_path.exists():
        return color_scheme_path 
    else:
        raise FileNotFoundError(f"Could not find Tinty scheme file in '{tinty_data_dir}' for '{full_color_scheme_name}'")


def load_color_scheme_colors(color_scheme_path: Path) -> Dict[str, str]:
    """Load color definitions from a Tinty scheme YAML file."""

    with open(color_scheme_path, 'r') as f:
        color_scheme_data = yaml.safe_load(f)
    
    colors = {}
    for i in range(24):
        key = f"base{i:02X}"
        if key in color_scheme_data['palette']:
            colors[key] = color_scheme_data['palette'][key]
    return colors


async def update_iterm_profile(
    # iterm_profile: iterm2.Profile,
    iterm_profile: iterm2.PartialProfile,
    colors: Dict[str, str],
) -> None:
    """
    Update an iTerm2 profile from Tinty base16/base24 colors.
    
    Base16 color mapping (16 colors):
    - base00: Background, ANSI Black
    - base05: Foreground, ANSI White
    - base08-base0F: ANSI colors (normal and bright variants reuse same colors)
    
    Base24 color mapping (24 colors):
    - base00-base0F: Same as Base16
    - base10-base17: Separate bright ANSI color variants
      - base10: Bright Black
      - base11: Unused (darkest background shade)
      - base12: Bright Red
      - base13: Bright Orange
      - base14: Bright Green
      - base15: Bright Cyan
      - base16: Bright Blue
      - base17: Bright Magenta
    """

    is_base24 = 'base10' in colors
    
    # Background and foreground
    await iterm_profile.async_set_background_color(hex_to_iterm_color(colors['base00']))
    await iterm_profile.async_set_foreground_color(hex_to_iterm_color(colors['base05']))

    await iterm_profile.async_set_ansi_0_color(hex_to_iterm_color(colors['base00']))   # Black
    await iterm_profile.async_set_ansi_1_color(hex_to_iterm_color(colors['base08']))   # Red
    await iterm_profile.async_set_ansi_2_color(hex_to_iterm_color(colors['base0B']))   # Green
    await iterm_profile.async_set_ansi_3_color(hex_to_iterm_color(colors['base0A']))   # Yellow
    await iterm_profile.async_set_ansi_4_color(hex_to_iterm_color(colors['base0D']))   # Blue
    await iterm_profile.async_set_ansi_5_color(hex_to_iterm_color(colors['base0E']))   # Magenta
    await iterm_profile.async_set_ansi_6_color(hex_to_iterm_color(colors['base0C']))   # Cyan
    await iterm_profile.async_set_ansi_7_color(hex_to_iterm_color(colors['base05']))   # White
    await iterm_profile.async_set_ansi_15_color(hex_to_iterm_color(colors['base07']))  # Bright White
    
    # ANSI color mapping
    if is_base24:
        # Base24: Use base10-base17 for bright variants
        await iterm_profile.async_set_ansi_8_color(hex_to_iterm_color(colors['base10']))   # Bright Black
        await iterm_profile.async_set_ansi_9_color(hex_to_iterm_color(colors['base12']))   # Bright Red
        await iterm_profile.async_set_ansi_10_color(hex_to_iterm_color(colors['base14']))  # Bright Green
        await iterm_profile.async_set_ansi_11_color(hex_to_iterm_color(colors['base13']))  # Bright Yellow (Orange)
        await iterm_profile.async_set_ansi_12_color(hex_to_iterm_color(colors['base16']))  # Bright Blue
        await iterm_profile.async_set_ansi_13_color(hex_to_iterm_color(colors['base17']))  # Bright Magenta
        await iterm_profile.async_set_ansi_14_color(hex_to_iterm_color(colors['base15']))  # Bright Cyan
    else:
        # Base16: Reuse base colors for bright variants
        await iterm_profile.async_set_ansi_8_color(hex_to_iterm_color(colors['base03']))   # Bright Black
        await iterm_profile.async_set_ansi_9_color(hex_to_iterm_color(colors['base08']))   # Bright Red
        await iterm_profile.async_set_ansi_10_color(hex_to_iterm_color(colors['base0B']))  # Bright Green
        await iterm_profile.async_set_ansi_11_color(hex_to_iterm_color(colors['base0A']))  # Bright Yellow (Orange)
        await iterm_profile.async_set_ansi_12_color(hex_to_iterm_color(colors['base0D']))  # Bright Blue
        await iterm_profile.async_set_ansi_13_color(hex_to_iterm_color(colors['base0E']))  # Bright Magenta
        await iterm_profile.async_set_ansi_14_color(hex_to_iterm_color(colors['base0C']))  # Bright Cyan
    
    # Additional colors
    await iterm_profile.async_set_bold_color(hex_to_iterm_color(colors['base05']))
    await iterm_profile.async_set_selection_color(hex_to_iterm_color(colors['base02']))
    await iterm_profile.async_set_selected_text_color(hex_to_iterm_color(colors['base05']))
    await iterm_profile.async_set_cursor_color(hex_to_iterm_color(colors['base05']))
    await iterm_profile.async_set_cursor_text_color(hex_to_iterm_color(colors['base00']))

    print(f"Updated iTerm profile '{iterm_profile.name}' with new colors")


def get_current_tinty_color_scheme_name() -> str:
    """Read the current Tinty color scheme name."""

    current_color_scheme_path = get_tinty_data_dir() / "current_scheme"
    
    with open(current_color_scheme_path, 'r') as f:
        color_scheme_name = f.read().strip()

    return color_scheme_name


def get_current_tinty_color_scheme() -> TintyColorScheme:
    """Read and load the current Tinty color scheme."""

    current_color_scheme_name = get_current_tinty_color_scheme_name()
    print(f"Current Tinty scheme: {current_color_scheme_name}")

    color_scheme_file_path = find_color_scheme_file(current_color_scheme_name)
    print(f"Current Tinty color scheme file: {color_scheme_file_path}")
    
    colors = load_color_scheme_colors(color_scheme_file_path)
    print(f"Loaded {len(colors)} colors from color scheme")
    
    return TintyColorScheme(current_color_scheme_name, colors, color_scheme_file_path)


async def find_iterm_profile(name, iterm_connection) -> iterm2.PartialProfile:
    """Find an iTerm profile by the given name, or raise an error."""

    partial_iterm_profiles = await iterm2.PartialProfile.async_query(iterm_connection)
    iterm_profile = None

    for partial_iterm_profile in partial_iterm_profiles:
        if partial_iterm_profile.name == name:
            return partial_iterm_profile

    raise RuntimeError(f"Could not find iTerm profile called {name}. Please create one manually and re-run this script.")


async def globally_set_iterm_profile(
    iterm_profile: iterm2.PartialProfile,
    iterm_connection: iterm2.Connection
) -> None:
    """Apply the given profile to all iTerm sessions."""

    app = await iterm2.async_get_app(iterm_connection)
    if not app:
        raise RuntimeError("Could not find iTerm app")
    
    num_sessions_updated = 0
    for window in app.windows:
        for tab in window.tabs:
            for session in tab.sessions:
                # Note: We need a PartialProfile, not a full Profile,
                # or else we get a "request malformed" error.
                # This isn't noted in the iTerm API docs.
                await session.async_set_profile(iterm_profile)
                num_sessions_updated += 1
    
    print(f"Applied theme to {num_sessions_updated} session(s)")


async def main(iterm_connection):
    """The entrypoint to this script."""

    tinty_color_scheme = get_current_tinty_color_scheme()
    iterm_profile = await find_iterm_profile(tinty_color_scheme.name, iterm_connection)
    await update_iterm_profile(iterm_profile, tinty_color_scheme.colors)
    await globally_set_iterm_profile(iterm_profile, iterm_connection)


iterm2.run_until_complete(main)
