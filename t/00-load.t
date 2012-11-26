#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Plack::Middleware::StackTraceLog' ) || print "Bail out!\n";
}

diag( "Testing Plack::Middleware::StackTraceLog $Plack::Middleware::StackTraceLog::VERSION, Perl $], $^X" );
