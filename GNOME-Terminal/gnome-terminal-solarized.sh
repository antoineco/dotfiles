#!/bin/bash

# Make sure we meet basic requirements (GNOME 3.12+)
gnomeVersion="$(expr "$(gnome-shell --version)" : '.* \(.*[.].*[.].*\)$')"
if [[ ("$(echo "$gnomeVersion" | cut -d"." -f1)" -lt 3 || \
	"$(echo "$gnomeVersion" | cut -d"." -f1)" -eq 3 && \
	"$(echo "$gnomeVersion" | cut -d"." -f2)" -lt 12) ]]
then
	echo "GNOME 3.12+ required (currently using GNOME $gnomeVersion)"
	exit 1
fi


# dconf path to gnome-terminal default profile
dconf_profiles_dir="/org/gnome/terminal/legacy/profiles:/"
profile_id="$(dconf read ${dconf_profiles_dir}default | sed s/\'//g)"
profile_path="${dconf_profiles_dir}:${profile_id}/"

# dump conf before changes
before=$(dconf dump "$profile_path")


echo "> Applying Solarize theme and configuration in "$profile_path"..."

dconf write "$profile_path"visible-name "'Solarized Dark'"
dconf write "$profile_path"default-size-columns 120
dconf write "$profile_path"default-size-rows 32
dconf write "$profile_path"use-system-font false
dconf write "$profile_path"font "'Source Code Pro 10'"
dconf write "$profile_path"use-theme-colors false
dconf write "$profile_path"foreground-color "'rgb(131,148,150)'"
dconf write "$profile_path"background-color "'rgb(0,43,54)'"
dconf write "$profile_path"cursor-colors-set true
dconf write "$profile_path"bold-color-same-as-fg false
dconf write "$profile_path"bold-color "'rgb(147,161,161)'"
dconf write "$profile_path"cursor-foreground-color "'rgb(131,148,150)'"
dconf write "$profile_path"cursor-background-color "'rgb(38,139,210)'"
dconf write "$profile_path"highlight-colors-set true
dconf write "$profile_path"highlight-background-color "'rgb(7,54,66)'"
dconf write "$profile_path"highlight-foreground-color "'rgb(131,148,150)'"
dconf write "$profile_path"palette "['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']"


# dump conf after changes
after=$(dconf dump "$profile_path")


diff="$(diff <(echo "$before" ) <(echo "$after"))"
if [[ "$?" -ne 0 ]]; then
	echo -e "> Showing changed keys\n"
	echo "$diff"
else
	echo "> No change!"
fi
