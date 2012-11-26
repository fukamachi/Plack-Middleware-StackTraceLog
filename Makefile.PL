use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Plack::Middleware::StackTraceLog',
    AUTHOR              => q{Eitarow Fukamachi <e.arrows@gmail.com>},
    VERSION_FROM        => 'lib/Plack/Middleware/StackTraceLog.pm',
    ABSTRACT_FROM       => 'lib/Plack/Middleware/StackTraceLog.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Plack' => 0,
        'Devel::StackTrace' => 0,
        'Data::Dumper' => 0,
        'DateTime' => 0,
        'Try::Tiny' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Plack-Middleware-StackTraceLog-*' },
);
