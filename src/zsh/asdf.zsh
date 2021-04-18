asdf_dir=$(brew --prefix asdf)

if [[ -f $asdf_dir/asdf.sh ]]; then
  source $asdf_dir/asdf.sh
fi
