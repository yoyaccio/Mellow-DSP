package Plugins::MellowDSP::PlayerSettings;

use strict;
use warnings;
use Slim::Utils::Prefs;
use Slim::Utils::Log;

my $prefs = preferences('plugin.mellowdsp');
my $log   = logger('plugin.mellowdsp');

sub handler {
    my ($client, $params, $callback, @args) = @_;

    if ($params->{saveSettings}) {
        $prefs->client($client)->set('enabled', $params->{pref_enabled} ? 1 : 0);
    }

    $params->{pref_enabled} = $prefs->client($client)->get('enabled') || 0;

    return Slim::Web::HTTP::filltemplatefile(
        'plugins/MellowDSP/settings/basic.html',
        $params
    );
}

1;
