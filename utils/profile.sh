check_var_exist() {
  if [ -z ${1+x} ]; then $2; fi
}
