# --- ROCK-COPYRIGHT-NOTE-BEGIN ---
# 
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# Please add additional copyright information _after_ the line containing
# the ROCK-COPYRIGHT-NOTE-END tag. Otherwise it might get removed by
# the ./scripts/Create-CopyPatch script. Do not edit this copyright text!
# 
# ROCK Linux: rock-src/package/*/xfree86/xf_config.sh
# Copyright (C) 1998 - 2004 ROCK Linux Project
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version. A copy of the GNU General Public
# License can be found at Documentation/COPYING.
# 
# Many people helped and are helping developing ROCK Linux. Please
# have a look at http://www.rocklinux.org/ and the Documentation/TEAM
# file for details.
# 
# --- ROCK-COPYRIGHT-NOTE-END ---

if [ "$prefix_auto" = 1 ] ; then
  prefix="usr/X11R6"
  set_confopt
fi


# extract additional gl* stuff
x_extract_gl() {
	mkdir release ; ln -s ../.. release/xc
	tar $taropt $archdir/mangl.tar.bz2
	tar $taropt $archdir/manglu.tar.bz2
	tar $taropt $archdir/manglx.tar.bz2
	rm -rf release
}

# extract the Matrox HALlib (additional TV/DVI out support on x86)
x_extract_hallib() {
	echo "Extracting mgaHALlib (For Matrox (>G400) cards) ..."
	tar $taropt `match_source_file -p mga`

	mga_compat_version=4.3.0
	cp mgadrivers-*-src/$mga_compat_version/drivers/src/HALlib/mgaHALlib.a \
	  programs/Xserver/hw/xfree86/drivers/mga/HALlib/mgaHALlib.a
	cp mgadrivers-*-src/$mga_compat_version/drivers/src/HALlib/binding.h \
	  programs/Xserver/hw/xfree86/drivers/mga/HALlib/binding.h
	rm -rf mgadrivers-*-src 

	if [ "$arch" = "x86" ] ; then
		echo "Enabling Matrox HALlib (since this is x86) ..."
		cat >> config/cf/host.def << EOT

/* Additinal TC/DVI support since this is x86 */
#define         HaveMatroxHal           YES
EOT
	fi
}

# some fixup
x_fixes() {
	cp -v programs/twm/system.twmrc programs/twm/system.twmrc.orig
	find \( -name 'config.guess' -o -name 'config.sub' \) \
		-exec chmod +x '{}' ';'
}

# prepare the X dirtree
x_dirtree() {
	mkdir -p $root/etc/X11
	mkdir -p $root/$libdir/X11/fonts/TrueType

	rm -fv $root/usr/X11
	rm -fv $root/usr/bin/X11
	rm -fv $root/usr/lib/X11
	rm -fv $root/usr/lib64/X11
	rm -fv $root/usr/include/X11

	ln -sv X11R6 $root/usr/X11
	ln -sv ../X11/bin $root/usr/bin/X11
	ln -sv ../X11/lib/X11 $root/usr/lib/X11
	[[ $libdir = *lib64 ]] && ln -sv ../X11/lib64/X11 $root/usr/lib64/X11
	ln -sv ../X11/include/X11 $root/usr/include/X11
}

# install the World
x_postmake() {
	rm -fv $root/etc/fonts/*.bak

	echo "Copy TWM config files ..."
	cp -v programs/twm/system.twmrc.orig \
	  programs/twm/sample-twmrc/original.twmrc
	cp -v programs/twm/sample-twmrc/*.twmrc $root/$prefix/lib/X11/twm/
	register_wm twm TWM /usr/X11/bin/twm

	echo "Copying default example configs ..."
	cp -fv $base/package/x11/xorg/xorg.conf.data \
		$root/etc/X11/xorg.conf.example
	cp -fv $root/etc/X11/xorg.conf{.example,}
	cp -fv $base/package/x11/xorg/local.conf.data \
		$root/etc/fonts/local.conf

	echo "Installing xfs init script ..."
	install_init xfs $base/package/x11/xorg/xfs.init


	register_xdm xdm 'X11 display manager' "/usr/X11R6/bin/xdm -nodaemon"


	echo "Installing the xdm start script (multiplexer) ..."
	cp $confdir/startxdm.sh $root/usr/X11R6/bin/startxdm
	chmod +x $root/usr/X11R6/bin/startxdm

	echo "Installing X Setup Script ..."
	cp -fv $base/package/x11/xorg/stone_mod_xorg.sh $root/etc/stone.d/mod_xorg.sh
	echo "export WINDOWMANAGER=kde" > $root/etc/profile.d/windowmanager

	echo "Installing X Cron Script ..."
	rock_substitute $base/package/x11/xorg/xorg.cron > \
		$root/etc/cron.daily/80-xorg
	chmod +x $root/etc/cron.daily/80-xorg
}

# configure the World
x_config() {
	echo "Configuring X ..."
	pkginstalled zlib && cat >> config/cf/host.def << EOT

/* Disable the internal zlib to use the system installed one */
#define		HasZlib			YES
EOT

	pkginstalled expat && cat >> config/cf/host.def << EOT

/* Disable the internal expat library to use the system installed one */
#define		HasExpat		YES
EOT

	cat >> config/cf/host.def << EOT

/* Less warnings with recent gccs ... */
#define		DefaultCCOptions	-ansi GccWarningOptions

/* Make sure config files are allways installed ... */
#define		InstallXinitConfig	YES
#define		InstallXdmConfig	YES
#define		InstallFSConfig		YES

/* do not install duplicate crap in /etc/X11 */
#define		UseSeparateConfDir	NO

EOT
}

