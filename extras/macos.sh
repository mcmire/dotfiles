#!/usr/bin/env bash

# This script attempts to use the command line to normalize preferences across
# as many common MacOS applications as possible. It relies heavily on use of the
# `defaults` tool, which reads data from plist files and other sources [1].
#
# This tool does not have a lot of documentation around it, but it works
# generally like this:
#
#     defaults write <domain> <name> <type> <value>
#
# As illustrated here, preferences in MacOS are grouped by a "domain", which
# usually refers to a single application, but can also just be a general
# category (such as NSGlobalDomain).
#
# You can get a list of all possible domains by running:
#
#     defaults domains | tr -s ', ' "\n"
#
# And you can obtain the current set of preferences for any domain by running:
#
#     defaults read <domain>
#
# Of course, this is interesting from an exploration point of view, but if you
# actually want to make changes to the preferences, then it's a little more
# difficult. Which domain do you use? If you're making changes to a third-party
# application, it's fairly easy, because the domain will be named after the app
# itself (with some kind of prefix like `com.apple`). For core MacOS
# functionality, however, it's more nebulous. Unfortunately, since `defaults` is
# a low-level way of setting preferences and could change from version to
# version of MacOS, Apple does not have a list of domains that it keeps
# preferences under.
#
# That said, one of the premier experts on these preferences is Mathias Bynens,
# (most of the settings here are borrowed from his dotfiles [2], in fact).
# According to his answer on this Stack Overflow question [3], there are visible
# settings and there are hidden settings you can change. The visible settings
# are easy to detect via `defaults`. Here is the typical workflow:
#
#   defaults read > /tmp/defaults-before.txt
#   # Make the change you want in System Preferences, or in app-specific prefs
#   defaults read > /tmp/defaults-after.txt
#   diff -u /tmp/defaults-before.txt /tmp/defaults-after.txt
#
# Note that `defaults` also takes a `-currentHost` setting, so if you can't find
# anything there, also try this (e.g. this is the case for keyboard mappings):
#
#   defaults -currentHost read > /tmp/defaults-before.txt
#   # Make the change you want in System Preferences, or in app-specific prefs
#   defaults -currentHost read > /tmp/defaults-after.txt
#   diff -u /tmp/defaults-before.txt /tmp/defaults-after.txt
#
# Under the hood, third-party apps may store their preferences in property list
# files, or plists, which are kept in ~/Library/Preferences. Some of these are
# binary, so you will need to use `plutil` to read them. For instance:
#
#     cp ~/Library/Preferences/com.manytricks.Moom.plist /tmp/Moom.plist
#     # Will convert the file to XML and rewrite it
#     plutil -convert xml1 /tmp/Moom.plist
#
# If you can't find anything using `defaults` or plists, then you've probably
# run into hidden settings, and these are a lot harder to find. If you're really
# dedicated, you can use GDB as detailed here [4].
#
# [1]: https://apple.stackexchange.com/a/337785
# [2]: https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.macos
# [3]: https://superuser.com/questions/455755/how-to-explore-more-defaults-write-tweaks-on-os-x
# [4]: http://web.archive.org/web/20091227153657/http://arcticmac.home.comcast.net/~arcticmac/tutorials/gdbFindingPrefs.html

###############################################################################
# Prelude
###############################################################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Also kill all applications we are configuring, to ensure that the preferences
# we are about to set will get applied.
killall Finder &>/dev/null || true
killall Dock &>/dev/null || true
killall Moom &>/dev/null || true

# Ask for the administrator password up front
sudo -v

###############################################################################
# Saving
###############################################################################

# Save new documents to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Save screenshots to a Screenshots folder
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

###############################################################################
# Writing
###############################################################################

# Disable automatic capitalization as it's annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it's annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct as it's annoying when writing notes
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Keyboard
###############################################################################

# Disable press-and-hold for keys, so that key repeat actually functions
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set the fastest keyboard repeat rate (at least the fastest through System
# Preferences)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Map Caps Lock to Escape for Vim
# Sources:
# * <https://apple.stackexchange.com/questions/4813/changing-modifier-keys-from-the-command-line/277544>
# * <https://apple.stackexchange.com/questions/280855/changing-right-hand-command-alt-key-order-to-be-like-a-windows-keyboard>
defaults -currentHost write NSGlobalDomain com.apple.keyboard.modifiermapping.1452-641-0 -array '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer><key>HIDKeyboardModifierMappingDst</key><integer>30064771113</integer></dict>'

# Require use of the Function key to use function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

###############################################################################
# Trackpad
###############################################################################

# Turn off "Look up & data detectors" gesture
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool false

# Turn off Pinch to Zoom gesture
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool false

# Turn off "Smart Zoom" gesture
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -bool false

# Turn off rotate gesture
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool false

# Turn off "Swipe between pages" gesture
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool false

# Turn off "Swipe between full-screen apps" gesture
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -bool false

# Turn off "Notification Center" gesture
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -bool false

# Turn off "Mission Control" gesture
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -bool false

# Turn off "Launchpad" gesture
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false

# Turn off "Show Desktop" gesture
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -bool false

###############################################################################
# Display
###############################################################################

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

###############################################################################
# Dock
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Use large icons since I'm not going to have much in the Dock
defaults write com.apple.dock tilesize -int 68

# Hide the Dock by default
defaults write com.apple.dock autohide -bool true

# Enable magnification
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 63

# TODO: Any way to preload the Dock with apps?

###############################################################################
# TextEdit
###############################################################################

# Use plain text mode for TextEdit
defaults write com.apple.TextEdit RichText -bool false

# Turn off automatic spell check, grammar check, smart quotes, etc.
defaults write com.apple.TextEdit CheckSpellingWhileTyping -bool false
defaults write com.apple.TextEdit CorrectSpellingAutomatically -bool false
defaults write com.apple.TextEdit SmartCopyPaste -bool false
defaults write com.apple.TextEdit SmartDashes -bool false
defaults write com.apple.TextEdit SmartQuotes -bool false
defaults write com.apple.TextEdit TextReplacement -bool false

# Set default font and font size
defaults write com.apple.TextEdit NSFixedPitchFont -string "FiraCode-Regular"
defaults write com.apple.TextEdit NSFixedPitchFontSize -int 15

###############################################################################
# iTerm
###############################################################################

# Allow programs like tmux to access the clipboard
defaults write com.googlecode.iterm2 AllowClipboardAccess -bool true

# Always show the tab bar even with only one tab open
defaults write com.googlecode.iterm2 HideTab -bool false

###############################################################################
# Moom
###############################################################################

# Don't show news updates on first launch
defaults write com.manytricks.moom 'Automatic News Updates: Popped Up Once' -bool true

# Turn off automatic news updates
defaults write com.manytricks.moom 'Automatic News Updates: Suppress' -bool true

# Set the number of rows to 6, to make a 6x6 grid
defaults write com.manytricks.moom 'Configuration Grid: Rows' -int 6

# Use Cmd-Opt-F for the keyboard shortcut
defaults write com.manytricks.moom 'Keyboard Controls' '<dict><key>Identifier</key><string>Keyboard Controls</string><key>Key Code</key><integer>3</integer><key>Modifier Flags</key><integer>1573160</integer><key>Visual Representation</key><string>⌥⌘F</string></dict><dict><key>'

# Set up mappings (1 - left half, 2 - right half, F - full screen)
defaults write com.manytricks.moom 'Custom Controls' '<array>
  <dict>
    <key>Action</key>
    <integer>19</integer>
    <key>Apply to Overlapping Windows</key>
    <false/>
    <key>Auto-Trigger</key>
    <false/>
    <key>Auto-Trigger Display Count</key>
    <integer>1</integer>
    <key>Center Mode</key>
    <integer>0</integer>
    <key>Collapsed</key>
    <false/>
    <key>Confine to Display</key>
    <false/>
    <key>Hot Key</key>
    <dict>
      <key>Identifier</key>
      <string>8746A2B6-F8D6-4211-A71F-4D058D547A5E</string>
      <key>Key Code</key>
      <integer>18</integer>
      <key>Modifier Flags</key>
      <integer>256</integer>
      <key>Visual Representation</key>
      <string>1</string>
    </dict>
    <key>Identifier</key>
    <string>8746A2B6-F8D6-4211-A71F-4D058D547A5E</string>
    <key>Loop Through Displays</key>
    <false/>
    <key>Move Delta</key>
    <integer>50</integer>
    <key>Move Delta Unit</key>
    <integer>0</integer>
    <key>Move Direction</key>
    <integer>5</integer>
    <key>Move to Edge/Corner Direction</key>
    <integer>5</integer>
    <key>Relative Frame</key>
    <string>{{0, 0}, {0.5, 1}}</string>
    <key>Resize Anchor</key>
    <integer>10</integer>
    <key>Resize Height Unit</key>
    <integer>0</integer>
    <key>Resize Proportionally</key>
    <false/>
    <key>Resize Size</key>
    <string>{1438, 848}</string>
    <key>Resize Width Unit</key>
    <integer>0</integer>
  </dict>
  <dict>
    <key>Action</key>
    <integer>19</integer>
    <key>Apply to Overlapping Windows</key>
    <false/>
    <key>Auto-Trigger</key>
    <false/>
    <key>Auto-Trigger Display Count</key>
    <integer>1</integer>
    <key>Center Mode</key>
    <integer>0</integer>
    <key>Collapsed</key>
    <false/>
    <key>Confine to Display</key>
    <false/>
    <key>Hot Key</key>
    <dict>
      <key>Identifier</key>
      <string>E57B71EE-5B9F-4DAC-88BD-C068A90F5703</string>
      <key>Key Code</key>
      <integer>19</integer>
      <key>Modifier Flags</key>
      <integer>256</integer>
      <key>Visual Representation</key>
      <string>2</string>
    </dict>
    <key>Identifier</key>
    <string>E57B71EE-5B9F-4DAC-88BD-C068A90F5703</string>
    <key>Loop Through Displays</key>
    <false/>
    <key>Move Delta</key>
    <integer>50</integer>
    <key>Move Delta Unit</key>
    <integer>0</integer>
    <key>Move Direction</key>
    <integer>5</integer>
    <key>Move to Edge/Corner Direction</key>
    <integer>5</integer>
    <key>Relative Frame</key>
    <string>{{0.5, 0}, {0.5, 1}}</string>
    <key>Resize Anchor</key>
    <integer>10</integer>
    <key>Resize Height Unit</key>
    <integer>0</integer>
    <key>Resize Proportionally</key>
    <false/>
    <key>Resize Size</key>
    <string>{1438, 848}</string>
    <key>Resize Width Unit</key>
    <integer>0</integer>
  </dict>
  <dict>
    <key>Action</key>
    <integer>19</integer>
    <key>Apply to Overlapping Windows</key>
    <false/>
    <key>Auto-Trigger</key>
    <false/>
    <key>Auto-Trigger Display Count</key>
    <integer>1</integer>
    <key>Center Mode</key>
    <integer>0</integer>
    <key>Collapsed</key>
    <false/>
    <key>Confine to Display</key>
    <false/>
    <key>Hot Key</key>
    <dict>
      <key>Identifier</key>
      <string>F51AFD13-68B8-4737-A16B-2B680D36DAD9</string>
      <key>Key Code</key>
      <integer>3</integer>
      <key>Modifier Flags</key>
      <integer>256</integer>
      <key>Visual Representation</key>
      <string>F</string>
    </dict>
    <key>Identifier</key>
    <string>F51AFD13-68B8-4737-A16B-2B680D36DAD9</string>
    <key>Loop Through Displays</key>
    <false/>
    <key>Move Delta</key>
    <integer>50</integer>
    <key>Move Delta Unit</key>
    <integer>0</integer>
    <key>Move Direction</key>
    <integer>5</integer>
    <key>Move to Edge/Corner Direction</key>
    <integer>5</integer>
    <key>Relative Frame</key>
    <string>{{0, 0}, {1, 1}}</string>
    <key>Resize Anchor</key>
    <integer>10</integer>
    <key>Resize Height Unit</key>
    <integer>0</integer>
    <key>Resize Proportionally</key>
    <false/>
    <key>Resize Size</key>
    <string>{1438, 848}</string>
    <key>Resize Width Unit</key>
    <integer>0</integer>
  </dict>
</array>'

###############################################################################
# Stay
###############################################################################

# Disable modal that appears when storing windows for all applications
defaults write com.cordlessdog.Stay SuppressStoreAllSuccess -bool true

###############################################################################
# Prologue
###############################################################################

# Restart applications again, so you can use the new settings right away.
killall Finder &>/dev/null || true
killall Dock &>/dev/null || true
killall Moom &>/dev/null || true
