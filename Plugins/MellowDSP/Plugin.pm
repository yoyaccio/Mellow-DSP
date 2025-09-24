package Plugins::MellowDSP::Plugin;

use strict;
use warnings;

use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Web::Settings;

use Plugins::MellowDSP::PlayerSettings;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    $log->info("Inizializzazione MellowDSP...");

    Slim::Web::Settings->addSettingsPage(
        {
            'id'     => 'MellowDSP',
            'name'   => 'PLUGIN_MELLOWDSP',
            'module' => 'Plugins::MellowDSP::PlayerSettings',
        }
    );

    return 1;
}

sub getDisplayName {
    return 'PLUGIN_MELLOWDSP';
}

1;
