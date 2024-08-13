<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.elliotwinkler.sync-obsidian-vault-periodically</string>

    <key>ProgramArguments</key>
    <array>
      <string>{{ HOME }}/.bin/sync-obsidian-vault-with-logging</string>
      <string>--no-color</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
      <key>Hour</key>
      <integer>0</integer>

      <key>Day</key>
      <integer>0</integer>
    </dict>

    <key>StandardOutPath</key>
    <string>{{ HOME }}/Library/Logs/com.elliotwinkler.sync-obsidian-vault-periodically.plist.stdout.log</string>

    <key>StandardErrorPath</key>
    <string>{{ HOME }}/Library/Logs/com.elliotwinkler.sync-obsidian-vault-periodically.plist.stderr.log</string>
  </dict>
</plist>
