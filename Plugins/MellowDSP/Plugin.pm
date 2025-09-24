package Plugins::MellowDSP::Plugin;

use strict;
use warnings;
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Web::Pages;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    Slim::Web::Pages->addPageFunction(
        'plugins/MellowDSP/settings/player.html',
        \&Plugins::MellowDSP::PlayerSettings::handler
    );
    return 1;
}

sub getDisplayName { 'PLUGIN_MELLOWDSP' }

1;
