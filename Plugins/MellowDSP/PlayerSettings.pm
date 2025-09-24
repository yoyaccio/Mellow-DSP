package Plugins::MellowDSP::PlayerSettings;

use strict;
use warnings;
use Slim::Utils::Prefs;
use Slim::Utils::Log;

my $prefs = preferences('plugin.mellowdsp');
my $log   = logger('plugin.mellowdsp');

sub handler {
    my ($class, $client, $params, $callback, @args) = @_;

    if ($params->{saveSettings}) {
        $prefs->set('enabled', $params->{enabled} ? 1 : 0);
        $prefs->set('upsample_rate', $params->{upsample_rate} || '44100');
    }

    $params->{enabled}       = $prefs->get('enabled')       || 0;
    $params->{upsample_rate} = $prefs->get('upsample_rate') || '44100';

    return Slim::Web::HTTP::filltemplatefile(
        'plugins/MellowDSP/settings/basic.html',
        $params
    );
}

1;
