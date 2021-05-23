if ! [[ -f /tmp/brew-openssl-dir ]]; then
  brew --prefix openssl > /tmp/brew-openssl-dir
fi

CONFIGURE_OPTS="--with-openssl-dir=$(< /tmp/brew-openssl-dir) --without-tcl --without-tk"
