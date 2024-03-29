# -*- perl -*-
BEGIN { $|=1; $^W=1; }
use strict;
use Test;

BEGIN
  {
   plan test => 22-2;
  };

use Tcl::pTk;

my $mw;
eval {$mw = MainWindow->new();};
ok($@, "", "can't create MainWindow");
ok(Tcl::pTk::Exists($mw), 1, "MainWindow creation failed");

my $foo = 12;
my @opt = (0..20);

# Granfather documented use of just -variable
my $opt = $mw->Optionmenu(-variable => \$foo,
	                  -options => \@opt)->pack;

ok($@, "", "can't create Optionmenu");
ok(Tcl::pTk::Exists($opt), 1, "Optionmenu creation failed");

ok($ {$opt->cget(-variable)}, $foo, "setting of -variable failed");
ok($opt->cget(-variable),\$foo, "Wrong variable");

my $optmenu = $opt->cget(-menu);
ok($optmenu ne "", 1, "can't get menu from Optionmenu");
ok(ref $optmenu, 'Tcl::pTk::Menu', "reference returned is not a Tk::Menu");# or Tcl::pTk::Menu?
ok($optmenu->index("last"), 20, "wrong number of elements in menu");
ok($optmenu->entrycget("last", -label), "20", "wrong label");


# Test use of both variables on the list of lists case
my $foo3 = 5;
my $bar3 = "";
my $opt3 = $mw->Optionmenu(-variable => \$foo3,
                           -textvariable => \$bar3,
			   -options => [map { [ "Label $_"  => $_ ] } @opt],
			  )->pack;
ok($@, "", "can't create Optionmenu");
ok(Tcl::pTk::Exists($opt3), 1, "Optionmenu creation failed");

ok($ {$opt3->cget(-variable)}, $foo3, "setting of -variable failed");
#TODO ok($bar3, "Label $foo3", "textvariable set to wrong value");
my $opt3menu = $opt3->cget(-menu);
ok($opt3menu ne "", 1, "can't get menu from Optionmenu");
ok($opt3menu->entrycget("last", -label), "Label 20", "wrong label");

# See if we have fixed use of just -variable in the list of lists case
my $foo2 = 5;
my $opt2 = $mw->Optionmenu(-variable => \$foo2,
			   -options => [map { [ "Label $_"  => $_ ] } @opt],
			  )->pack;
ok($@, "", "can't create Optionmenu");
ok(Tcl::pTk::Exists($opt2), 1, "Optionmenu creation failed");

ok($ {$opt2->cget(-variable)}, $foo2, "setting of -variable failed");
my $opt2menu = $opt2->cget(-menu);
ok($opt2menu ne "", 1, "can't get menu from Optionmenu");
ok($opt2menu->entrycget("last", -label), "Label 20", "wrong label");

#TODO ok($ {$opt2->cget(-textvariable)}, "Label $foo2", "wrong label");

$mw->after(1000,sub{$mw->destroy});


MainLoop;
__END__
