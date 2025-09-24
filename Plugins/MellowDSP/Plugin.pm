package Plugins::MellowDSP::Plugin;

use strict;
use warnings;
use Slim::Utils::Log;
use Slim::Utils::Prefs;

# categoria log
my $log = Slim::Utils::Log->addLogCategory({
  category     => 'plugin.mellowdsp',
  defaultLevel => 'ERROR',
  description  => 'PLUGIN_MELLOWDSP',
});

# prefs del plugin
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
  # default prefs
  $prefs->init({ enabled => 0 });

  # registra pagina Settings solo se c'è la WebUI
  if ( main::WEBUI ) {
    require Plugins::MellowDSP::Settings;
    Plugins::MellowDSP::Settings->new;
  }

  return 1;
}

sub getDisplayName { return 'PLUGIN_MELLOWDSP'; }

1;
