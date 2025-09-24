package Plugins::MellowDSP::Settings;

use strict;
use warnings;
use base qw(Slim::Web::Settings);
use Slim::Utils::Prefs;
use Slim::Utils::Log;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

# titolo mostrato nella UI (usa strings.txt)
sub name        { return 'PLUGIN_MELLOWDSP'; }
# template TT2 da rendere
sub page        { return 'plugins/MellowDSP/settings/basic.html'; }
# prefs radice del plugin
sub prefs       { return $prefs; }
# richiede selezione player -> appare sotto Settings → Player
sub needsClient { return 1; }

sub handler {
  my ($class, $client, $params) = @_;

  if ($params->{saveSettings}) {
    $prefs->client($client)->set('enabled', $params->{enabled} ? 1 : 0);
  }

  $params->{enabled} = $prefs->client($client)->get('enabled') || 0;

  return $class->SUPER::handler($client, $params);
}

1;
