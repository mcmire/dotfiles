<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.elliotwinkler.sync-writings-repo-periodically</string>

    <key>ProgramArguments</key>
    <array>
      <string>{{ HOME }}/.bin/sync-obsidian-vault-with-logging</string>
      <string>--vault-directory</string>
      <string>{{ HOME }}/personal-content--writings</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
      <key>Hour</key>
      <integer>0</integer>

      <key>Minute</key>
      <integer>10</integer>
    </dict>

    <key>StandardOutPath</key>
    <string>{{ HOME }}/Library/Logs/com.elliotwinkler.sync-writings-repo-periodically.plist.stdout.log</string>

    <key>StandardErrorPath</key>
    <string>{{ HOME }}/Library/Logs/com.elliotwinkler.sync-writings-repo-periodically.plist.stderr.log</string>
  </dict>
</plist>
