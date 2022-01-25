asdf_dir=$(brew --prefix asdf)

if [[ -f $asdf_dir/libexec/asdf.sh ]]; then
  source $asdf_dir/libexec/asdf.sh
fi
