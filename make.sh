find . -print -type d | grep \.vhdl$ | xargs -n 1 ghdl -i --workdir=work
find . -print -type d | grep \.vhdl$ | xargs -n 1 basename --suffix=.vhdl | xargs -n 1 ghdl -m --workdir=work