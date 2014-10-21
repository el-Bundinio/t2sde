# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: architecture/mips/archtest.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

case "$SDECFG_MIPS_ENDIANESS" in
    EL)
	arch_bigendian=no
	arch_target="mipsel-t2-linux-gnu" ;;
    EB)
	arch_bigendian=yes
	arch_target="mips-t2-linux-gnu" ;;
esac
