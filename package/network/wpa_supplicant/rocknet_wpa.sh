# --- T2-COPYRIGHT-NOTE-BEGIN ---
# T2 SDE: package/*/wpa_supplicant/rocknet_wpa.sh
# Copyright (C) 2004 - 2024 The T2 SDE Project
# 
# This Copyright note is generated by scripts/Create-CopyPatch,
# more information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2.
# --- T2-COPYRIGHT-NOTE-END ---

wpa_write_conf() {
	local if=$1
	local ssid=${wpa_ssid[$if]}
	local psk=${wpa_psk[$if]}
	# add quotes if necessary
	[[ "$ssid" != \"*\" ]] && ssid="\"$ssid\""
	[[ "$psk" != \"*\" ]] && psk="\"$psk\""

	cat > /var/run/wpa_supplicant-$if.conf <<EOT
ctrl_interface=/var/run/wpa_supplicant
network={
	ssid=$ssid
	psk=$psk
}
EOT
}

wpa_init_if() {
    if isfirst "wpa_$if"; then
	addcode up 5 2 "wpa_write_conf $if"
	addcode up 5 3 "wpa_supplicant -Dnl80211,wext -i$if -B \
-c/var/run/wpa_supplicant-$if.conf -P/var/run/wpa_supplicant-$if.pid"
	addcode down 5 2 "rm -f /var/run/wpa_supplicant-$if.{pid,conf}"
	addcode down 5 3 "kill \$(cat /var/run/wpa_supplicant-$if.pid)"
    fi
}

public_ssid() {
	wpa_init_if
	wpa_ssid[$if]="$*"
}

public_psk() {
	wpa_init_if
	wpa_psk[$if]="$*"
}
