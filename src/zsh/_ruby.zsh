#export RUBY_CONFIGURE_OPTS="--with-zlib-dir=$(brew --prefix zlib) --with-openssl-dir=$(brew --prefix openssl@1.1) --with-readline-dir=$(brew --prefix readline) --with-libyaml-dir=$(brew --prefix libyaml)"

#RUBY_CONFIGURE_OPTS="--with-make-prog=/usr/bin/make"
#export MAKE=/usr/bin/make

if [[ $DOTFILES_INSIDE_SUBSHELL -ne 1 ]]; then
  # macOS ships with /usr/bin/make, but if you have Xcode installed then you get
  # a second version of make at /Applications/Xcode.app/Contents/Developer. The
  # difference is that while /usr/bin/make is compiled for the arm64e
  # architecture, /Applications/Xcode.app/Contents/Developer/usr/bin/make is
  # only compiled for arm64. Ruby will (for some reason) use the latter version
  # of make when compiling extensions for gems, including gems that ship with
  # Ruby like rbs. This leads to tools like asdf and rbenv, both of which use
  # ruby-build, to fail while installing Ruby ([1]). To fix this we just always
  # use the Xcode version.
  #
  # [1]: https://github.com/ruby/rbs/issues/877
  #PATH=/Applications/Xcode.app/Contents/Developer/usr/bin:$PATH
fi

#eval "$(rbenv init - zsh)"
