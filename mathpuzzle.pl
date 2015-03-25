#!/usr/bin/perl
use utf8;

use Getopt::Std;
# -M max-multiplier
my %opt = (M => 3, A => 9);
getopts('M:A:', \%opt) or die "Usage\n";

my @pats = ([qw(a b * x /)],
	    [qw(a * b x /)],
	    [qw(* a b x /)],
	    [qw(a * b / x)],
	    [qw(* a b / x)],
	    [qw(* a / b x)],
	   );

my $bigC = randc(1/2, 3, 4);
for my $row (qw(A B C D)) {
    my $c = randc(2/3, 2, $bigC);
    $bigC = 2 if $c == $bigC;
    my $pat = randa(@pats);
}

for (@vals) { tr{*}{×}; tr{/}{÷}; }
for my $letter (qw(A B C D)) {
  for my $number (1..5) {
    $t{"$letter$number"} = shift @vals;
  }
}

binmode(STDOUT, ":utf8");

while (<>) {
  s/([A-D][1-5])/$t{$1}/g;
  print;
}

sub randc {
  my ($p, $a, $b) = @_;
  return  rand() < $p ? $a : $b;
}

# uniformly-distributed random integer
# between $max and $min inclusive
sub randr {
  my ($min, $max) = @_;
  return $min + randn($max+1-$min);
}

# uniform random integer in [0, n)
sub randn {
  my $n = shift;
  return int(rand($n));
}

# random array element
sub randa {
  my @a = @_;
  my $n = randn(scalar @a);
  return $a[$n];
}
