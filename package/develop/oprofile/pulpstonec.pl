#!/usr/bin/perl -w
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../oprofile/pulpstonec.pl
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

use strict;
use English;

my $min_points = 50;

my %tuples;

while (<>) {
	next unless /^\*\*\s+([0-9\.]+):\s+(\S+)\s+(\S+)/;
	$tuples{sprintf "%-14s\t%-22s", $2, $3} += $1;
}

foreach (keys %tuples) {
	next if $tuples{$_} < 50;
	printf "** %9.0f:\t%s\n", $tuples{$_}, $_;
}

