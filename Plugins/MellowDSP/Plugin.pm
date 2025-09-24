package Plugins::MellowDSP::Plugin;

use strict;
use warnings;
use Slim::Utils::Log;
use Slim::Utils::Prefs;

my $log = Slim::Utils::Log->addLogCategory({
  category     => 'plugin.mellowdsp',
  defaultLevel => 'ERROR',
  description  => 'PLUGIN_MELLOWDSP',
});

my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
  $prefs->init({ enabled => 0 });

  if ( main::WEBUI ) {
    require Plugins::MellowDSP::Settings;
    Plugins::MellowDSP::Settings->new;
  }
  return 1;
}

sub getDisplayName { return 'PLUGIN_MELLOWDSP'; }

1;
