# ditfiles zprofile

ditfiles_source_dir() {
  print -r -- "${${(%):-%x}:A:h}"
}

DITFILES_ZPROFILE_DIR="$(ditfiles_source_dir)"
source "$DITFILES_ZPROFILE_DIR/zsh/modules/00-login-env.zsh"

unset -f ditfiles_source_dir
unset DITFILES_ZPROFILE_DIR
