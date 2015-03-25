#!/usr/bin/perl
use utf8;

use Getopt::Std;
# -M max-multiplier
my %opt = (M => 3, A => 9, z => 0);
getopts('zM:A:', \%opt) or die "Usage\n";

my @pats = ([qw(a b * x /)],
	    [qw(a * b x /)],
	    [qw(* a b x /)],
	    [qw(a * b / x)],
	    [qw(* a b / x)],
	    [qw(* a / b x)],
	   );

my %optab = ('+' => sub { $_[0] + $_[1] },
             '*' => sub { $_[0] * $_[1] },
             '/' => sub { $_[0] / $_[1] }
            );

# select multipliers
my @multipliers = select_multipliers(4, 2, $opt{M});

# for each group, pick a, b at random, either positive or negative
# generate five values, including calculation of x
# insert into %t

for my $letter (qw(A B C D)) {
  my @pat = @{randa(@pats)};
  die if @pat != 5;
  my $multiplier = shift @multipliers;
  my @ops = gen_ops($letter, $multiplier, @pat);
  for my $i (0 .. 4) {
    $t{$letter . ($i+1)} = op_string($ops[$i]);
  }
}

binmode(STDOUT, ":utf8");

while (<>) {
  s/([A-D][1-5])/$t{$1}/g;
  print;
}

sub gen_ops {
  my ($letter, $multiplier, @pat) = @_;
  my @ops;
  do {
    @ops = ();
    for my $i (0 .. 4) {
      if ($pat[$i] eq "a" || $pat[$i] eq "b" ) {
        my $min = $pat[$i] eq "a" && $letter eq "A" ? 1 : -$opt{A};
        push @ops, ["+", select_adder($min, $opt{A})];
      } elsif ($pat[$i] eq "*" || $pat[$i] eq "/") {
        push @ops, [$pat[$i], $multiplier];
      } elsif ($pat[$i] eq "x") {
        push @ops, ["+", -total(@ops)];
      }
    }
  } until ops_acceptable(@ops);
  return @ops;
}

sub ops_acceptable {
  my (@ops) = @_;
  for my $i (0 .. $#ops) {
    return unless op_acceptable($ops[$i]);
    my $x = total(@ops[0..$i]);
    return unless $x == int($x);
  }
  return 1;
}

sub op_acceptable {
  my ($op) = @_;
  return 1 unless $op->[0] eq "+";
  return 0 if $op->[1] == 0 && ! $opt{z};
  return 0 if abs($op->[1]) > $opt{A};
  return 1;
}

# If we start with 0, what's the total after we perform these operations?
sub total {
  my @ops = @_;
  my $x = 0;
  for my $op (@ops) {
    $x = $optab{$op->[0]}->($x, $op->[1]);
  }
  return $x;
}

# select N multipliers
# min is first
# then min or min+1
# then min or min+1 or min+2
# etc.
# but there must be one that is the Max.
#
# If Max is really big, maybe increase min by more than 1 each time
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

sub op_string {
  my ($op) = @_;
  if ($op->[0] eq "+") { return adder_string($op->[1]) }
  elsif ($op->[0] eq "*") { return '×' . $op->[1] }
  elsif ($op->[0] eq "/") { return '÷' . $op->[1] }
  else { die "Unknown op->[0] = '$op->[0]'" }
}

sub adder_string {
  my ($n) = @_;
  return $n < 0 ? "$n" : "+$n";
}

# select uniformly
# but disallow zero unless -z was given
sub select_adder {
  my ($min, $max) = @_;
  my $sel;
  do {
    $sel = randr($min, $max);
  } while $sel == 0 && !$opt{z};
  return $sel;
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
