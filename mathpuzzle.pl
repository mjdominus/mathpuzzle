#!/usr/bin/perl
use utf8;
my @vals = qw(+2 *2 -2 /2 -1
              +7 *2 -9 -5 /2
              *2 +8 /2 -7 +3
              +4 *3 -9 /3 -1
             );
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
