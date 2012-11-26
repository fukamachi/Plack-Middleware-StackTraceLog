package Plack::Middleware::StackTraceLog;
use strict;
use warnings;
use parent qw(Plack::Middleware);
use Devel::StackTrace;
use Try::Tiny;
use DateTime;
use Data::Dumper;
use Plack::Util::Accessor qw( logger );

our $VERSION = '0.01';

our $StackTraceClass = 'Devel::StackTrace';

sub call {
    my ($self, $env) = @_;

    my $trace;
    local $SIG{__DIE__} = sub {
        $trace = $StackTraceClass->new(
            indent => 1, message => munge_error($_[0], [ caller ]),
            ignore_package => __PACKAGE__,
        );

        die @_;
    };

    my $caught;
    my $res = try {
        $self->app->($env);
    } catch {
        $caught = $_;

        [ 500, [ "Content-Type", "text/plain" ], ["Internal Server Error"] ];
    };

    if ($trace && $caught) {
        $self->logger->(DateTime->now(time_zone => 'Asia/Tokyo'), "\n");

        $self->logger->("\n");

        local $Data::Dumper::Indent = 0;
        local $Data::Dumper::Terse = 1;
        for my $key (sort keys %$env) {
            $self->logger->("\t", $key, ':', "\t", (Dumper $env->{$key}), "\n");
        }

        $self->logger->("\n");
        $self->logger->($trace->as_string);
        $self->logger->("\n\n\n");
    }

    return $res;
}

# copied from Plack::Middleware::StackTrace.
sub munge_error {
    my ($err, $caller) = @_;
    return $err if ref $err;

    # Ugly hack to remove " at ... line ..." automatically appended by perl
    # If there's a proper way to do this, please let me know.
    $err =~ s/ at \Q$caller->[1]\E line $caller->[2]\.\n$//;

    return $err;
}

1;

__END__

=head1 NAME

Plack::Middleware::StackTraceLog - Logs when your app dies

=head1 SYNOPSIS

 enable 'StackTraceLog';

=head1 DESCRIPTION

Plack::Middleware::StackTraceLog catches exceptions (run-time errors) and logs the stacktrace.

=head1 CONFIGURATION

=over 4

=item logger

  open my $fh, '>>', '/var/log/app/error_log' or die "Cannot load error_log file: $!";
  enable "Plack::Middleware::StackTraceLog",
      logger => sub { print $fh @_ };

=back

=head1 AUTHOR

Eitarow Fukamachi

=head1 SEE ALSO

L<Plack::Middleware::StackTrace> L<Plack::Middelware>

=cut
