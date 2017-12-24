
# Helpers for powerline-like output.
typeset -a blocks
function add_block {
	local fg="$1"
	local bg="$2"
	local text="$3"

	blocks+=("$fg" "$bg" "$text")
}

# Helper to convert color strings into usable color numbers.
# Well… many many colors are missing, but, what the hell? As long as we’re
# not using them, …
# FIXME: Need something more declarative, here.
function color {
	case "$1" in
		black)
			echo "16";;
		white)
			echo "253";;
		gr[ae]y)
			echo "240";;
		dark-gr[ae]y)
			echo "236";;
		light-gr[ae]y)
			echo "247";;
		darkest-red)
			echo "52";;
		red)
			echo "160";;
		bright-red)
			echo "196";;
		pink)
			echo "199";;
		cyan)
			echo "45";;
		bright-cyan)
			echo "51";;
		darkest-green)
			echo 22;;
		green)
			echo "118";;
		bright-green)
			echo "120";;
		brightest-green)
			echo "148";;
		dark-green)
			echo "70";;
		yellow)
			echo "220";;
		bright-yellow)
			echo "227";;
		orange)
			echo "166";;
		bright-orange)
			echo "209";;
		brightest-orange)
			echo "214";;
		blue)
			echo "69";;
		bright-blue)
			echo "75";;
		darkest-magenta)
			echo "57";;
		magenta)
			echo "141";;
		bright-magenta)
			echo "147";;
		*)
			echo "$1";;
	esac
}

# Displays a 256color color code. One for foregrounds, one for backgrounds.
function f { echo -e "\033[38;5;$(color ${1})m" }
function b { echo -e "\033[48;5;$(color ${1})m" }
function fb { echo -e "\033[1m\033[38;5;$(color ${1})m" }

function print_blocks {
	local index=1
	local background
	local f b text
	for f b text in ${blocks[@]}; do
		((index += 3))

		if [[ -v blocks[$((index + 1))] ]]; then
			background="${blocks[$((index + 1))]}"
		else
			background=""
		fi

		echo -n "%{$(f $f)$(b $b)%} $text %{$(f $b)%}"

		if [[ -n "$POWERLINE" && "$POWERLINE" != false ]]; then
			if [[ -n "$background" ]]; then
				echo -n "%{$(b ${background})%}"
			else
				echo -n "%{${reset_color}$(f $b)%}"
			fi
		fi
	done

	echo
}

function powerline {
	if [[ -f ./project.zsh ]]; then
		add_block black dark-green "project.zsh"
	elif [[ -f ./configure && -x ./configure ]]; then
		add_block black blue "./configure"
	elif [[ -f CMakeList.txt ]]; then
		add_block black blue "CMakeList.txt"
	fi

	if [[ -f ./Makefile ]]; then
		add_block black white "Makefile"
		if ! make -q &> /dev/null; then
			if [[ -n "$POWERLINE" && "$POWERLINE" != false ]]; then
				add_block red dark-grey "✘"
			else
				add_block red dark-grey "x"
			fi
		else
			add_block green dark-grey "✔"
		fi
	fi

	print_blocks
	(( ${#blocks[@]} > 0 )) && \
		echo -e "%{\033[00m%}"
	blocks=()
}

# vim: set ts=4 sw=4 cc=80 :
