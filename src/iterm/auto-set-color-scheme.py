#!/usr/bin/env python3

# Adapted from:
# * <https://gist.github.com/jamesmacfie/2061023e5365e8b6bfbbc20792ac90f8#gistcomment-3599985>
# * <https://iterm2.com/python-api/examples/setprofile.html>
#
# And roughly inspired by:
# * <https://grrr.tech/posts/2020/switch-dark-mode-os/>

import asyncio
import iterm2
import subprocess

def determine_color_scheme_mode():
    process = subprocess.run(["color-scheme-mode"], capture_output=True, text=True)

    if process.returncode != 0:
        raise RuntimeError("Could not retrieve color scheme, please check output of color-scheme-mode")

    return process.stdout.rstrip()

def determine_desired_profile_name(color_scheme_mode):
    if color_scheme_mode == "light":
        return "Solarized Light"
    elif color_scheme_mode == "dark":
        return "Solarized Dark"
    else:
        raise RuntimeError("Unknown color scheme mode {}".format(color_scheme_mode))

async def find_iterm_profile_called(name, connection):
    partial_profiles = await iterm2.PartialProfile.async_query(connection)
    profile = None
    for partial_profile in partial_profiles:
        if partial_profile.name == name:
            profile = await partial_profile.async_get_full_profile()
            break

    if not profile:
        raise RuntimeError("Could not find profile matching {}", name)

    return profile

async def globally_set_iterm_profile(profile, connection):
    app = await iterm2.async_get_app(connection)
    for window in app.windows:
        for tab in window.tabs:
            for session in tab.sessions:
                await session.async_set_profile(profile)

async def main(connection):
    color_scheme_mode = determine_color_scheme_mode()
    desired_profile_name = determine_desired_profile_name(color_scheme_mode)
    profile = await find_iterm_profile_called(desired_profile_name, connection)
    await globally_set_iterm_profile(profile, connection)

iterm2.run_until_complete(main)
