# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../sysvinit/stone_mod_init.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# Copyright (C) 1998 - 2003 ROCK Linux Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---
#
# [MAIN] 85 init System Init Configuration

write_config() {
	cp /etc/inittab{,.new}
	sed s/.:initdefault/$rl:initdefault/ /etc/inittab.new > /etc/inittab
	rm -f /etc/inittab.new
}

set_rl() {
	gui_menu default_runlevel "Select the default runlevel (Current: $rl)" \
	  '1 ... Single user mode'				'rl=1' \
	  '2 ... Multi user mode without network'		'rl=2' \
	  '3 ... Multi user mode (normal operation)'		'rl=3' \
	  '4 ... Custom use'					'rl=4' \
	  '5 ... Multi user mode with graphical login manager'	'rl=5'

	write_config
}

main() {
    while
	rl=`grep initdefault /etc/inittab | cut -d : -f2`

	gui_menu gpm 'System Init Configuration.
Select an item to change the value:' \
		"Default runlevel... $rl"   'set_rl' \
		'' '' \
		'Edit the /etc/inittab file'				\
			"gui_edit 'The inittab file' /etc/inittab"
    do : ; done
}

