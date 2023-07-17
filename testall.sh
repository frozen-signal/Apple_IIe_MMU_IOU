red=$(printf '\033[31m')
endColor=$(printf '\033[0m')

find . -print -type d | grep \.vhdl$ | xargs -n 1 basename --suffix=.vhdl | grep _TB | xargs -n 1 ghdl -r --workdir=work | sed -e "s/error/${red}error${endColor}/g"