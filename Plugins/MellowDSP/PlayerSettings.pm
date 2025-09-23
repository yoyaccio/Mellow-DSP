package Plugins::MellowDSP::PlayerSettings;

use strict;
use warnings;

use Slim::Utils::Prefs;
use Slim::Utils::Log;

my $prefs = preferences('plugin.mellowdsp');
my $log   = logger('plugin.mellowdsp');

sub settingsPage {
    my ($client, $params) = @_;

    if ($params->{saveSettings}) {
        $prefs->client($client)->set('enabled', $params->{enabled} ? 1 : 0);
        $prefs->client($client)->set('upsample_rate', $params->{upsample_rate} || '44100');
        $prefs->client($client)->set('phase_response', $params->{phase_response} || 'linear');
        $prefs->client($client)->set('output_depth', $params->{output_depth} || '24');
        $prefs->client($client)->set('dithering', $params->{dithering} || 'none');
        $prefs->client($client)->set('format', $params->{format} || 'wav');
        $prefs->client($client)->set('fir_file_left', $params->{fir_file_left} || '');
        $prefs->client($client)->set('fir_file_right', $params->{fir_file_right} || '');
    }

    $params->{enabled}        = $prefs->client($client)->get('enabled');
    $params->{upsample_rate}  = $prefs->client($client)->get('upsample_rate');
    $params->{phase_response} = $prefs->client($client)->get('phase_response');
    $params->{output_depth}   = $prefs->client($client)->get('output_depth');
    $params->{dithering}      = $prefs->client($client)->get('dithering');
    $params->{format}         = $prefs->client($client)->get('format');
    $params->{fir_file_left}  = $prefs->client($client)->get('fir_file_left');
    $params->{fir_file_right} = $prefs->client($client)->get('fir_file_right');

    return Slim::Web::HTTP::filltemplatefile(
        'plugins/MellowDSP/settings/basic.html',
        $params
    );
}

1;
