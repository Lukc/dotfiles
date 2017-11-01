
autoload -U colors
colors

if ls --version 2>&1 | grep -qi '\(gnu\|busybox\)'; then
	alias ls="ls --color=auto"
fi

if grep --version 2>&1 | grep -q -i gnu; then
	alias grep="grep --color=auto"
	alias cal="cal -m"
fi

# General aliases
alias :o="\$EDITOR"
alias :q="exit"
alias :reload=". /etc/zsh/zshrc"

alias "?"="man"

if which vimpager >& /dev/null; then
	alias cat="vimcat"
	alias less="vimpager -u $HOME/.vim/vimrc"
	alias "?"="man -P \"vimpager -u $HOME/.vim/vimrc\""
fi

function :error {
	echo "${fg_no_bold[red]}$@${reset_color}" >&1
}

##
# Reasons to rewrite:
#   - data structures (to store download/other backends)
#   - argparse
#   - no reserved case-insensitive globals (wtf $path)
##
function fetch {
	typeset -l url destination protocol url_path

	while (( $# > 0 )); do
		case "$1" in
			# FIXME: -e|--extract, using bsdtar for more magic.
			--*)
				:error "unrecognized argument: $1"
				return 1
			;;
			-*)
				:error "unrecognized argument: $1"
				return 1
			;;
			*)
				if [[ -z "$url" ]]; then
					url="$1"
				elif [[ -z "$destination" ]]; then
					destination="$1"
				else
					:error "unrecognized argument: $1"
					return 1
				fi
			;;
		esac

		shift 1
	done

	if [[ "$url" =~ : ]]; then
		echo "$url" | \
			sed "s|\([^:]*\):\(.*\)|\\1\\t\\2|" | \
			read protocol url_path
	fi

	if [[ -z "$destination" ]]; then
		case "$protocol" in
			http|https)
				destination="${url_path##*/}"
			;;
			github)
				protocol="git"
				destination="${url_path#*/}"
				url="https://github.com/$url_path"
			;;
			aur)
				protocol="git"
				destination="${url_path#*/}"
				url="https://aur.archlinux.org/$url_path"
			;;
			"")
				destination="${url##*/}"
			;;
		esac
	fi

	if [[ -z "$destination" ]]; then
		:error "destination missing"
		:error "usage: $0 <url> [destination]"
		return 1
	fi

	case "$protocol" in
		"git+"*)
			protocol="git"
			url="${url#git+}"
		;;
		"")
			protocol="file"
			url_path="${url}"
			url="file:${url}"
		;;
	esac

	echo "${fg_no_bold[blue]}$protocol${reset_color}:${fg_no_bold[green]}$url_path${reset_color} -> ${fg_no_bold[white]}$destination${reset_color}"

	case "$protocol" in
		file)
			cp -r "$url_path" "$destination"
		;;
		http|https)
			curl -L "$url" -o "$destination" -\#
		;;
		git)
			git clone "$url" "$destination"
		;;
		*)
			:error "Doesn’t know how to fetch $url"
			return 3
		;;
	esac
}
alias :f="fetch"

# Searches.
alias /="noglob ag"

# Deprecated stuff I’m not really using anymore.
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
