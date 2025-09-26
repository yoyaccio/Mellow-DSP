package Plugins::MellowDSP::Plugin;

use strict;
use warnings;
use base qw(Slim::Plugin::Base);
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Plugins::MellowDSP::Settings;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    my $class = shift;
    $log->info("MellowDSP plugin initialized");
    Plugins::MellowDSP::Settings->new;
    $class->SUPER::initPlugin(@_);
}

sub getDisplayName {
    return 'PLUGIN_MELLOWDSP';
}

1;
