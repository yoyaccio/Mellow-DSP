package Plugins::MellowDSP::Plugin;
use strict;
use warnings;

use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Web::Pages;
use Slim::Web::Settings;

use Plugins::MellowDSP::PlayerSettings;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    $log->info("Initializing MellowDSP plugin");

    # Registriamo la pagina web
    Slim::Web::Pages->addPageFunction(
        'plugins/MellowDSP/settings/basic.html',
        \&Plugins::MellowDSP::PlayerSettings::settingsPage
    );

    # Registriamo la scheda Player
    Slim::Web::Settings::Player::registerSettingsPage(
        'MellowDSP',
        \&Plugins::MellowDSP::PlayerSettings::settingsPage,
        'PLUGIN_MELLOWDSP'
    );

    return 1;
}

1;
