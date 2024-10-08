#!/usr/bin/env perl
#
# TODO:
# - get file path from ARGV[0] for executable to be build in
# - handle command line arguments
# - return proper errors with non zero exit codes
#
use strict;
use warnings;
use autodie;
use diagnostics;
use feature 'say';
use feature 'switch';

my $fp;
my $c_file = $ARGV[-1];
my $option_flags = 0;
my $options = { 'lex' => 1 << 0, 'parse' => 1 << 1, 'codegen' => 1 << 2 };

for my $i (0 .. $#ARGV) {
    my $arg = $ARGV[$i];
    if ($arg =~ /^--/) {
        $option_flags |= $options->{lex};
    }
}

open($fp, "<", $c_file);

my $line_number = 1;

my $token = undef;

while (<$fp>) {
    my $line = $_;

    while (substr($line, 0, 1) ne '\n') {
        # I have to add every character to be found as the next token. Not all
        # tokens are exceptable syntax
        $line =~ /([[\](){};.|]|\w*)/a; #

        # However, if the "]" is the first (or the second if the first character
        # is a caret) character of a bracketed character class, it does not
        # denote the end of the class (as you cannot have an empty class) and is
        # considered part of the set of characters that can be matched without
        # escaping
        #
        $token = $1;

        if ($token ne '') {
            print("token: '$token'\n");
            $line = substr($line, length($token), length($line));
        }  else {
            my $front_empty = undef;
            ($front_empty) = ($line =~ /^\s*/);
            if (length($line) == length($front_empty)) {
                last;
            }
            $line = substr($line, length($front_empty), length($line));
            next;
        }

        my $identifier= undef;
        my $constant = undef;
        my $keyword_int = undef;
        ($identifier) = ($token=~ /([ a-zA-Z_]\w*\b)/a);
        ($constant) = ($token =~ /([0-9]+\b)/a);

        if (defined $identifier) {
            print("identifier: ", $identifier, "\n");
        } elsif (defined $constant) {
            print("constant: ", $constant, "\n");
        } elsif ($token =~ /\(/) {

        } elsif ($token =~ /\)/) {

        } elsif ($token =~ /\{/) {

        } elsif ($token =~ /\}/) {
        } elsif ($token =~ /\[/) {
        } elsif ($token =~ /\]/) {

        } elsif ($token =~ /int\b/a) {

        } elsif ($token =~ /void\b/a) {

        } elsif ($token =~ /;/a) {

        } else {
            print("Syntax error\n'$token' is not a token\n");
            exit 1;
        }

    }

    $line_number++;
}
