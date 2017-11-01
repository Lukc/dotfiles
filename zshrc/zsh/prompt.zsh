
# Others prompts
PS2="%{$fg_no_bold[yellow]%}%_>%{${reset_color}%} "
PS3="%{$fg_no_bold[yellow]%}?#%{${reset_color}%} "

function precmd {
	r=$?

	local path_color user_color host_color return_code user_at_host
	local cwd sign branch vcs diff remote deco branch_color
	local base_color

	title

	if [[ ! -e "$PWD" ]]; then
		path_color="${fg_no_bold[black]}"
	elif [[ -O "$PWD" ]]; then
		path_color="${fg_no_bold[white]}"
	elif [[ -w "$PWD" ]]; then
		path_color="${fg_no_bold[blue]}"
	else
		path_color="${fg_no_bold[red]}"
	fi

	case ${HOST%%.*} in
		turing)
			base_color=magenta ;;
		[Ss]overeign)
			base_color=blue ;;
		[Aa]kira)
			base_color=yellow ;;
		[Nn]emo)
			base_color=yellow ;;
		[Rr]umia)
			base_color=orange ;;
		natsu)
			base_color=cyan ;;
		*)
			base_color=green ;;
	esac

	sign=">"

	case ${USER%%.*} in
		root)
			user_color="%{$(f bright-red)%}"
			host_color="%{$(f red)%}"
			sign="%{${fg_bold[red]}%}$sign"
		;;
		*)
			host_color="%{$(f ${host_color:-$base_color})%}"
			user_color="%{$(f ${user_color:-bright-$base_color})%}"
			sign="%{${fg_bold[$base_color]}%}$sign"
		;;
	esac

	deco="%{${fg_bold[blue]}%}"

	chroot_info=
	if [[ -e /etc/chroot ]]; then
		chroot_color="${host_color:-$base_color}"
		chroot_info="%{${fg_bold[white]}%}(${chroot_color}$(< /etc/chroot)%{${fg_bold[white]}%})"
	fi

	return_code="%(?..${deco}-%{${fg_no_bold[red]}%}%?${deco}- )"
	#user_at_host="%{${user_color}%}%n%{${fg_bold[white]}%}/%{${host_color}%}%m"
	user_at_host="%{${host_color}%}%m%{${fg_bold[white]}%}/%{${user_color}%}%n"
	cwd="%{${path_color}%}%48<...<%~"

	PS1="$(powerline)${return_code}${user_at_host}"
	PS1="${chroot_info:+$chroot_info }$PS1 ${cwd} ${sign}%{${reset_color}%} "

	# Right prompt with VCS info
	if [[ -e .git ]]; then
		vcs=git
		branch=$(git branch | grep '\*' | cut -d " " -f 2)
		diff="$( (( $(git diff | wc -l) != 0 )) && echo '*')"
		vcs_color="${fg_bold[white]}"
	elif [[ -e .hg ]]; then
		vcs=hg
		branch=
		vcs_color="${fg_bold[white]}"
	fi

	if [[ -n "$diff" ]]; then
		branch_color="${fg_bold[yellow]}"
		diff=" ±"
	else
		branch_color="${fg_bold[white]}"
	fi

	if [[ -n "$vcs" ]]; then
		RPS1="- %{${vcs_color}%}$vcs%{${reset_color}%}:%{$branch_color%}$branch$diff%{${reset_color}%} -"
	else
		RPS1=""
	fi

	RPS1="$RPS1%{${reset_color}%}"
}

function zle-line-init zle-keymap-select {
	CMD_PROMPT="%{$(b orange)$(fb darkest-red)%} CMD %{${reset_color}%}"
	INS_PROMPT="%{$(b brightest-green)$(fb darkest-green)%} INS %{${reset_color}%}"

	precmd

	RPS1="${RPS1:+$RPS1 }${${KEYMAP/vicmd/$CMD_PROMPT}/(main|viins)/$INS_PROMPT}"
	zle reset-prompt
}


zle -N zle-line-init
zle -N zle-keymap-select
#zle -N reset-prompt

# vim: set ts=4 sw=4 cc=80 :
