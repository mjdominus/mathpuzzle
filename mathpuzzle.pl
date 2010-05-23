#!/usr/bin/perl
use utf8;
my @vals = qw(+2 *2 -2 /2 -1
              +7 *2 -9 -5 /2
              *2 +8 /2 -7 +3
              +4 *3 -9 /3 -1
             );

my @pats = ([qw(a b * x /)],
	    [qw(a * cb x /)],
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

sub randn {
  my $n = shift;
  return int(rand($n));
}

sub randa {
  my @a = @_;
  my $n = randn(scalar @a);
  return $a[$n];
}
