<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.elliotwinkler.create-backup-periodically</string>

    <key>ProgramArguments</key>
    <array>
      <string>{{ HOME }}/.bin/create-backup-from-launchd</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
      <key>Hour</key>
      <integer>1</integer>

      <key>Minute</key>
      <integer>0</integer>
    </dict>

    <key>StandardOutPath</key>
    <string>{{ HOME }}/Library/Logs/com.elliotwinkler.create-backup-periodically.plist.stdout.log</string>

    <key>StandardErrorPath</key>
    <string>{{ HOME }}/Library/Logs/com.elliotwinkler.create-backup-periodically.plist.stderr.log</string>
  </dict>
</plist>
