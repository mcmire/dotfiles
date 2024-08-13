<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.elliotwinkler.sync-obsidian-vault-when-changed</string>

    <key>ProgramArguments</key>
    <array>
      <string>{{ HOME }}/.bin/sync-obsidian-vault-when-changed</string>
      <string>--no-color</string>
    </array>

    <key>KeepAlive</key>
    <true/>

    <key>RunAtLoad</key>
    <true/>

    <key>StandardOutPath</key>
    <string>{{ HOME }}/Library/Logs/com.elliotwinkler.sync-obsidian-vault-when-changed.plist.stdout.log</string>

    <key>StandardErrorPath</key>
    <string>{{ HOME }}/Library/Logs/com.elliotwinkler.sync-obsidian-vault-when-changed.plist.stderr.log</string>
  </dict>
</plist>
