package Plugins::MellowDSP::Plugin;
use strict;
use warnings;
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Plugins::MellowDSP::PlayerSettings;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    Plugins::MellowDSP::PlayerSettings->init();
    return 1;
}

sub getDisplayName { 'PLUGIN_MELLOWDSP' }

1;
