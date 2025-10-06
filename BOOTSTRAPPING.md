# Bootstrapping a new computer

This document outlines tasks you will most likely have to perform
if you are setting up a *brand new* computer.

You should follow this guide
_instead_ of the installation instructions in the README.

You will have to make some substitutions until you have everything installed:

* You will need to use Safari instead of Chrome.
* You will need to use Terminal instead of iTerm.
* You will need to use `vi` instead of Neovim.

Then:

1. In order to use Git,
   which is required to clone this repo,
   you will need to download the macOS developer command-line tools.
   You can do this by running `xcode-select --install`.

2. In order to access passwords for Apple, GitHub, and other services,
   you'll need to sign in to 1Password.
   You can do this by opening Safari,
   going to `https://1password.com`,
   and signing in.
   You'll need your secret key.

3. In order to clone this repo,
   you will need to authenticate with GitHub.
   You can do this by generating an RSA key,
   opening Safari,
   logging in to GitHub,
   and uploading your key.
   Follow [this guide][github-ssh] for more on how to do this.
   When asked for a passphrase, create a new entry in 1Passsword.
   (You can use `vi` to edit `~/.ssh/config`.)

4. To install apps,
   you'll want to make sure you're signed into the right Apple ID.
   It's best if you use the same Apple ID across all devices you own
   (even work machines).
   You can sign in by opening an app like the App Store.

5. Clone this repo to somewhere on your computer
   (preferably your home directory).

6. Open Terminal, navigate to the repo you just cloned,
   and run `bin/bootstrap`.
   This will install Homebrew and a bunch of apps (Chrome, iTerm, etc.).
   It will also configure some defaults in System Preferences.

6. Open iTerm, go to Preferences, and remove the Default profile.
   This will make Solarized Dark the default,
   which is what you want.

7. Now you can proceed with the [installation instructions][installation] in
   the README (starting with step 4).

[github-ssh]: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
[installation]: ./README.md#run-the-install-script
