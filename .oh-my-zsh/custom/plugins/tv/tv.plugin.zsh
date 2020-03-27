
function tv () {

  local usage="usage: tv [--help] <on | off>"

  # Check that there is only one arg
  if [ "$#" -ne "1" ]
  then
    echo "${usage}"
    return 1
  else
    # Case on the args
    case $1 in
      on)
        (echo 'on 0' | cec-client -s -d 1) && export DISPLAY=:0;;
      off)
        echo 'standby 0' | cec-client -s -d 1;;
      --help)
        echo "${usage}";;
      *)
        echo "${usage}"
        return 1;;
    esac
  fi
}
