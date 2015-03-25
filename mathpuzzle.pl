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

# select multipliers
my @multipliers = select_multipliers(4, 2, $opt{M});

# for each group, pick a, b at random, either positive or negative
# generate five values, including calculation of x
# insert into %t

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

# select N multipliers
# min is first
# then min or min+1
# then min or min+1 or min+2
# etc.
# but there must be one that is the Max.
sub select_multipliers {
  my ($N, $min, $Max) = @_;
  my $max = $min;
  my $gotMax = 0;
  my @M;
  while (@M < $N-1) {
    push @M, randr($min, $max++); # max goes up by 1 each time
    $max = $Max if $max > $Max;  # Max is the absolute cap
    $gotMax = 1 if $M[-1] == $Max;
  }
  if ($gotMax) { push @M, randr($min, $max++) } else { push @M, $Max }
  return @M;
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
