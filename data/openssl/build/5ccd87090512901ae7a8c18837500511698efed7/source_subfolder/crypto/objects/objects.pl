#! /usr/bin/env perl
# Copyright 2000-2021 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the Apache License 2.0 (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html

use Getopt::Std;
use FindBin;
use lib "$FindBin::Bin/../../util/perl";
use OpenSSL::copyright;

our($opt_n);
getopts('n');

# The year the output file is generated.
my $YEAR = OpenSSL::copyright::latest(($0, $ARGV[1], $ARGV[0]));

open (NUMIN,"$ARGV[1]") || die "Can't open number file $ARGV[1]";
$max_nid=0;
$o=0;
while(<NUMIN>)
	{
	s|\R$||;
	$o++;
	s/#.*$//;
	next if /^\s*$/;
	$_ = 'X'.$_;
	($Cname,$mynum) = split;
	$Cname =~ s/^X//;
	if (defined($nidn{$mynum}))
		{ die "$ARGV[1]:$o:There's already an object with NID ",$mynum," on line ",$order{$mynum},"\n"; }
	if (defined($nid{$Cname}))
		{ die "$ARGV[1]:$o:There's already an object with name ",$Cname," on line ",$order{$nid{$Cname}},"\n"; }
	$nid{$Cname} = $mynum;
	$nidn{$mynum} = $Cname;
	$order{$mynum} = $o;
	$max_nid = $mynum if $mynum > $max_nid;
	}
close NUMIN;

open (IN,"$ARGV[0]") || die "Can't open input file $ARGV[0]";
$Cname="";
$o=0;
while (<IN>)
	{
	s|\R$||;
	$o++;
        if (/^!module\s+(.*)$/)
		{
		$module = $1."-";
		$module =~ s/\./_/g;
		$module =~ s/-/_/g;
		}
        if (/^!global$/)
		{ $module = ""; }
	if (/^!Cname\s+(.*)$/)
		{ $Cname = $1; }
	if (/^!Alias\s+(.+?)\s+(.*)$/)
		{
		$Cname = $module.$1;
		$myoid = $2;
		$myoid = &process_oid($myoid);
		$Cname =~ s/-/_/g;
		$ordern{$o} = $Cname;
		$order{$Cname} = $o;
		$obj{$Cname} = $myoid;
		$_ = "";
		$Cname = "";
		}
	s/!.*$//;
	s/#.*$//;
	next if /^\s*$/;
	($myoid,$mysn,$myln) = split ':';
	$mysn =~ s/^\s*//;
	$mysn =~ s/\s*$//;
	$myln =~ s/^\s*//;
	$myln =~ s/\s*$//;
	$myoid =~ s/^\s*//;
	$myoid =~ s/\s*$//;
	if ($myoid ne "")
		{
		$myoid = &process_oid($myoid);
		}

	if ($Cname eq "" && ($myln =~ /^[_A-Za-z][\w.-]*$/ ))
		{
		$Cname = $myln;
		$Cname =~ s/\./_/g;
		$Cname =~ s/-/_/g;
		if ($Cname ne "" && defined($ln{$module.$Cname}))
			{ die "objects.txt:$o:There's already an object with long name ",$ln{$module.$Cname}," on line ",$order{$module.$Cname},"\n"; }
		}
	if ($Cname eq "")
		{
		$Cname = $mysn;
		$Cname =~ s/-/_/g;
		if ($Cname ne "" && defined($sn{$module.$Cname}))
			{ die "objects.txt:$o:There's already an object with short name ",$sn{$module.$Cname}," on line ",$order{$module.$Cname},"\n"; }
		}
	if ($Cname eq "")
		{
		$Cname = $myln;
		$Cname =~ s/-/_/g;
		$Cname =~ s/\./_/g;
		$Cname =~ s/ /_/g;
		if ($Cname ne "" && defined($ln{$module.$Cname}))
			{ die "objects.txt:$o:There's already an object with long name ",$ln{$module.$Cname}," on line ",$order{$module.$Cname},"\n"; }
		}
	$Cname =~ s/\./_/g;
	$Cname =~ s/-/_/g;
	$Cname = $module.$Cname;
	$ordern{$o} = $Cname;
	$order{$Cname} = $o;
	$sn{$Cname} = $mysn;
	$ln{$Cname} = $myln;
	$obj{$Cname} = $myoid;
	if (!defined($nid{$Cname}))
		{
		$max_nid++;
		$nid{$Cname} = $max_nid;
		$nidn{$max_nid} = $Cname;
print STDERR "Added OID $Cname\n";
		}
	$Cname="";
	}
close IN;

if ( $opt_n ) {
    foreach (sort { $a <=> $b } keys %nidn)
            {
            print $nidn{$_},"\t\t",$_,"\n";
            }
    exit;
}

print <<"EOF";
/*
 * WARNING: do not edit!
 * Generated by crypto/objects/objects.pl
 *
 * Copyright 2000-$YEAR The OpenSSL Project Authors. All Rights Reserved.
 * Licensed under the Apache License 2.0 (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#ifndef OPENSSL_OBJ_MAC_H
# define OPENSSL_OBJ_MAC_H
# pragma once

#define SN_undef                        "UNDEF"
#define LN_undef                        "undefined"
#define NID_undef                       0
#define OBJ_undef                       0L
EOF

sub expand
	{
	my $string = shift;

	1 while $string =~ s/\t+/' ' x (length($&) * 8 - length($`) % 8)/e;

	return $string;
	}

foreach (sort { $a <=> $b } keys %ordern)
	{
	$Cname=$ordern{$_};
	print "\n";
	print expand("#define SN_$Cname\t\t\"$sn{$Cname}\"\n") if $sn{$Cname} ne "";
	print expand("#define LN_$Cname\t\t\"$ln{$Cname}\"\n") if $ln{$Cname} ne "";
	print expand("#define NID_$Cname\t\t$nid{$Cname}\n") if $nid{$Cname} ne "";
	print expand("#define OBJ_$Cname\t\t$obj{$Cname}\n") if $obj{$Cname} ne "";
	}

print <<EOF;

#endif /* OPENSSL_OBJ_MAC_H */
EOF

sub process_oid
	{
	local($oid)=@_;
	local(@a,$oid_pref);

	@a = split(/\s+/,$myoid);
	$pref_oid = "";
	$pref_sep = "";
	if (!($a[0] =~ /^[0-9]+$/))
		{
		$a[0] =~ s/-/_/g;
		if (!defined($obj{$a[0]}))
			{ die "$ARGV[0]:$o:Undefined identifier ",$a[0],"\n"; }
		$pref_oid = "OBJ_" . $a[0];
		$pref_sep = ",";
		shift @a;
		}
	$oids = join('L,',@a) . "L";
	if ($oids ne "L")
		{
		$oids = $pref_oid . $pref_sep . $oids;
		}
	else
		{
		$oids = $pref_oid;
		}
	return($oids);
	}
