# --- T2-COPYRIGHT-NOTE-BEGIN ---
# T2 SDE: package/*/perl/perllocal_hack.sh
# Copyright (C) 2004 - 2022 The T2 SDE Project
# 
# This Copyright note is generated by scripts/Create-CopyPatch,
# more information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2.
# --- T2-COPYRIGHT-NOTE-END ---

if atstage native; then

# Quick & Dirty hack for the perllocal problem
# .. to be included by packages which do 'share' the perllocal.pod file
#
eval `perl -V:archlib`
hook_add premake 1 "( cd $archlib; mv -v perllocal.pod perllocal.pod.sik || true; )"
hook_add postmake 9 "( cd $archlib; mv -v perllocal.pod $pkg.pod || true;
		       mv -v perllocal.pod.sik perllocal.pod || true; )"
var_append flist''del '|' "${archlib#/}/perllocal.pod"

fi
