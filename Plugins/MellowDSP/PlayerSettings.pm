package Plugins::MellowDSP::PlayerSettings;
use strict;
use warnings;
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Web::HTTP;
use Slim::Web::Pages;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub init {
    Slim::Web::Pages->addPageFunction(
        'plugins/MellowDSP/settings/player.html',
        \&settingsPage
    );
    return 1;
}

sub settingsPage {
    my ($client, $params, $cb, @args) = @_;
    my $c = $prefs->client($client);

    if ($params->{saveSettings}) {
        $c->set('enabled',          $params->{enabled} ? 1 : 0);
        $c->set('upsample_rate',    $params->{upsample_rate}    || '44100');
        $c->set('phase_response',   $params->{phase_response}   || 'linear');
        $c->set('output_depth',     $params->{output_depth}     || '24');
        $c->set('dithering',        $params->{dithering}        || 'none');
        $c->set('target_precision', $params->{target_precision} || '24');
        $c->set('output_format',    $params->{output_format}    || 'wav');
        $c->set('mode',             $params->{mode}             || 'server_dac_wav');
        $c->set('fir_file_left',    $params->{fir_file_left}    || '');
        $c->set('fir_file_right',   $params->{fir_file_right}   || '');
    }

    $params->{enabled}          = $c->get('enabled')          || 0;
    $params->{upsample_rate}    = $c->get('upsample_rate')    || '44100';
    $params->{phase_response}   = $c->get('phase_response')   || 'linear';
    $params->{output_depth}     = $c->get('output_depth')     || '24';
    $params->{dithering}        = $c->get('dithering')        || 'none';
    $params->{target_precision} = $c->get('target_precision') || '24';
    $params->{output_format}    = $c->get('output_format')    || 'wav';
    $params->{mode}             = $c->get('mode')             || 'server_dac_wav';
    $params->{fir_file_left}    = $c->get('fir_file_left')    || '';
    $params->{fir_file_right}   = $c->get('fir_file_right')   || '';
    $params->{player}           = $client ? $client->id() : '';

    return Slim::Web::HTTP::filltemplatefile(
        'plugins/MellowDSP/settings/player.html',
        $params
    );
}

1;
