#!/usr/bin/perl
use utf8;

my $MAX = $ARGV[0] =~ /^[1-9]\d*$/ ? shift() : 10;
my %t;

for my $row (qw(A B C D)) {
  my @c = (0) x 5;
  for my $i (0 .. $#c -1 ) {
    $c[$i] = randr(-$MAX, $MAX);
    redo if $c[$i] == 0;
    $c[-1] -= $c[$i];
  }
  redo unless -$MAX <= $c[-1] && $c[-1] <= $MAX;
  for my $i (0 .. $#c) {
    $t{"$row$i"} = $c[$i] < 0 ? $c[$i] : "+$c[$i]";
  }
}

for (@vals) { tr{*}{×}; tr{/}{÷}; }

binmode(STDOUT, ":utf8");

while (<>) {
  s/([A-D][1-5])/$t{$1}/g;
  print;
}

# A puzzle number
sub n {
  my $scale = shift;  # current scale factor
  my $range = (0, 10, 7, 5, 3)[$scale];
  return randr(-$range, $range);
}

# Multiplier
sub ml {
  my ($bigC) = shift;
  return ["×", $bigC];
}

# Divider
sub dv {
  my ($bigC) = shift;
  return ["÷", $bigC];
}

# random number: choose $a with probability $p, otherwise $b
sub randc {
  my ($p, $a, $b) = @_;
  return rand() < $p ? $a : $b;
}

# between lo and hi, inclusive
sub randr {
  my ($lo, $hi) = @_;
  return $lo + int(rand($hi+1-$lo));
}

# between 0 and n-1, inclusive
sub randn {
  my $n = shift;
  return randr(0, $n-1);
}

# random array element
sub randa {
  my @a = @_;
  my $n = randn(scalar @a);
  return $a[$n];
}
