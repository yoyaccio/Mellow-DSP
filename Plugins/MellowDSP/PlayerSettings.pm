package Plugins::MellowDSP::PlayerSettings;
use strict;
use warnings;

use Slim::Utils::Prefs;

my $prefs = preferences('plugin.mellowdsp');

sub settingsPage {
    my ($client, $params, $callback, @args) = @_;

    if ($params->{saveSettings}) {
        $prefs->client($client)->set('enabled', $params->{enabled} ? 1 : 0);
        $prefs->client($client)->set('upsample_rate', $params->{upsample_rate} || '44100');
        $prefs->client($client)->set('dithering', $params->{dithering} || 'none');
        $prefs->client($client)->set('fir_file_left', $params->{fir_file_left} || '');
        $prefs->client($client)->set('fir_file_right', $params->{fir_file_right} || '');
        $prefs->client($client)->set('output_format', $params->{output_format} || 'wav');
    }

    $params->{enabled}        = $prefs->client($client)->get('enabled');
    $params->{upsample_rate}  = $prefs->client($client)->get('upsample_rate');
    $params->{dithering}      = $prefs->client($client)->get('dithering');
    $params->{fir_file_left}  = $prefs->client($client)->get('fir_file_left');
    $params->{fir_file_right} = $prefs->client($client)->get('fir_file_right');
    $params->{output_format}  = $prefs->client($client)->get('output_format');

    return Slim::Web::HTTP::filltemplatefile(
        'plugins/MellowDSP/settings/basic.html',
        $params
    );
}

1;
