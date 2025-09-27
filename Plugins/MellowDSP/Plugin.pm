package Plugins::MellowDSP::Plugin;

use strict;
use warnings;
use base qw(Slim::Plugin::Base);
use Slim::Utils::Log;
use Slim::Utils::Prefs;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    my $class = shift;
    $log->info("MellowDSP plugin initialized");
    $class->SUPER::initPlugin(@_);
}

sub getDisplayName {
    return 'PLUGIN_MELLOWDSP';
}

1;
