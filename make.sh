rm -f work/work-obj93.cf
find . -print -type d | grep \.vhdl$ | grep -v VENDOR | xargs -n 1 ghdl -i --workdir=work
find . -print -type d | grep \.vhdl$ | grep -v VENDOR | xargs -n 1 basename --suffix=.vhdl | xargs -n 1 ghdl -m --workdir=work