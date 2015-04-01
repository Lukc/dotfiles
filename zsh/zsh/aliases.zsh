
# This condition is a big assumption, but it’s been sufficient for me.
if [[ "$(uname -s)" == "Linux" ]]; then
	alias ls="ls --color=auto"
fi

# This one caused me some trouble on non-GNU Linuxes.
if grep --version 2>&1 | grep -q -i gnu; then
	alias grep="grep --color=auto"
	alias cal="cal -m"
fi

# General aliases
# Never used those.
alias :e="\$EDITOR"
alias :q="exit"
alias :w="wget"
alias l="ls -A -F"
alias ll="ls -h -l "
alias la="ls -a"
alias sm="screen -DRAa -S main"

# Missing Lua, but Lua 5.2 present? Let’s alias!
if ! which lua 2>&1 >/dev/null; then
	if which lua5.2 2>&1 >/dev/null; then
		alias lua=lua5.2
	fi
fi

# vim: set ts=4 sw=4 cc=80 :
