package Plugins::MellowDSP::Plugin;

use strict;
use warnings;
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Plugins::MellowDSP::Settings;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    $log->info("MellowDSP plugin initialized");
    Plugins::MellowDSP::Settings->new;
    return 1;
}

sub getDisplayName {
    return 'PLUGIN_MELLOWDSP';
}

1;
