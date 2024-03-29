# -*- perl -*-
BEGIN { $|=1; $^W=1; }

use strict;
use Test;

BEGIN { plan tests => 20 }; # implement formInfo, formForget?

use Tcl::pTk;

$Tcl::pTk::DEBUG = 1;

my $mw = MainWindow->new;
eval { $mw->geometry('+10+10'); };  # This works for mwm and interactivePlacement

# Makesure windowingsystem doesn't bomb-out
my $ws = $mw->windowingsystem;

ok( defined($ws));

# This will skip if Tix not present
my $tixPresent = $mw->interp->pkg_require('Tix');


##
## More than simple tests
##
{

    my $b = $mw->Button();

    my $method;
    for my $mgr ( qw/grid pack form/ )  # 'place' needs args so ignored here
       {
         print "testing manager: $mgr ...\n";
         
         if( ($mgr eq 'form') && !$tixPresent ){
                 foreach (1..5){
                         skip("Tix package not present. Not texting form mgr");
                 }
                 next;
         }

         $method = $mgr;
         eval { $b->$method(); };
         ok ($@, '', "Fatal!. Even managing one widget with $mgr failed");
         eval { $mw->update; };
         ok ($@, '', "Uh. Idletask problem after $mgr widget");

         $method = $mgr . 'Info';
         eval { my %opts = $b->$method(); };
         ok ($@, '', "Fatal!. Even info on one widget failed with $mgr");

         $method = $mgr . 'Forget';
         eval { $b->$method(); };
         ok ($@, '', "Fatal!. Even unmanage one widget failed with $mgr");
         eval { $mw->update; };
         ok ($@, '', "Uh. $mgr idletask problem with unmanage");
       }

    $b->destroy;
    eval { $mw->update; };
    ok ($@, '', "Uh. Idletask problem on destroy widget");
}
##
##
##
{
   print "grid serveral buttons at once\n";
   my $b1 = $mw->Button;
   my $b2 = $mw->Button;
   eval { $b1->grid($b2); };
   ok ($@, '', "Failed to place 2 buttons with one grid call");
   $b1->destroy;
   $b2->destroy;
}
##
## Relative placement grid tests that fail in Tk800.005
##
{
    print "grid and rel. placements\n";

    my $b = $mw->Button();
    #eval { $b->grid('-'); };
    $b->grid('-');
    ok ($@, '', "Problem with relative extent the column span by 1");
    my %opt;
    %opt = $b->gridInfo;
    ok ($opt{-columnspan}, 2, "'-' gives wrong column span");

    $b->destroy;
}
1;
__END__

