package Plugins::MellowDSP::PlayerSettings;
use strict;
use warnings;
use File::Path qw(make_path);
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Web::HTTP;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub settingsPage {
    my ($client, $params, $cb) = @_;
    my $cid = $client ? $client->id : 'global';

    if ($params->{saveSettings}) {
        for my $k (qw(enabled upsample_rate phase_response output_depth dithering target_precision
                       fir_enabled fir_gain_db fir_channel_left fir_channel_right output_mode)) {
            $prefs->client($client)->set($k, $params->{$k});
        }

        my $base = Slim::Utils::Prefs::getServerPrefs()->get('cachedir') . "/MellowDSP/$cid";
        my $fdir = "$base/filters"; my $cdir = "$base/configs"; make_path($fdir); make_path($cdir);

        for my $side (qw(left right)) {
            my $field = "fir_file_$side";
            if (my $fh = Slim::Web::HTTP::getUpload($params, $field)) {
                my $dest = "$fdir/$field.wav";
                open my $out, '>', $dest or $log->error("FIR save failed: $!"), next;
                binmode $out; while (read($fh, my $buf, 8192)) { print $out $buf }
                close $out;
                $prefs->client($client)->set($field, $dest);
            }
        }

        _write_yaml($client, $cid, $prefs, $cdir);
        system('systemctl','reload','camilladsp');
    }

    for my $k (qw(enabled upsample_rate phase_response output_depth dithering target_precision
                  fir_enabled fir_gain_db fir_channel_left fir_channel_right
                  fir_file_left fir_file_right output_mode)) {
        $params->{$k} = $prefs->client($client)->get($k);
    }
    $params->{player} = $cid;

    return Slim::Web::HTTP::filltemplatefile('plugins/MellowDSP/settings/basic.html', $params);
}

sub _write_yaml {
    my ($client, $cid, $prefs, $cdir) = @_;
    my $left  = $prefs->client($client)->get('fir_file_left')  || '';
    my $right = $prefs->client($client)->get('fir_file_right') || '';
    my $gain  = 0 + ($prefs->client($client)->get('fir_gain_db') || 0);
    my $chl   = 0 + ($prefs->client($client)->get('fir_channel_left')  || 0);
    my $chr   = 1 + ($prefs->client($client)->get('fir_channel_right') || 1);

    my $ups   = $prefs->client($client)->get('upsample_rate') || 44100;
    my $phase = $prefs->client($client)->get('phase_response') || 'linear';
    my $depth = $prefs->client($client)->get('output_depth') || 24;
    my $dith  = $prefs->client($client)->get('dithering') || 'none';
    my $mode  = $prefs->client($client)->get('output_mode') || 'server_dac';

    my $playback;
    if ($mode eq 'server_dac') {
        $playback = <<"YML";
  playback:
    type: Alsa
    device: "hw:0"
    format: S24LE
YML
    }
    elsif ($mode eq 'server_client_wav') {
        $playback = <<"YML";
  playback:
    type: Pipe
    command: "cat"
    format: S24LE
YML
    }
    elsif ($mode eq 'server_client_flac') {
        $playback = <<"YML";
  playback:
    type: Pipe
    command: "flac - -c"
    format: S24LE
YML
    }

    my $yaml = <<"YML";
version: 0.6
devices:
  capture: { type: Alsa, device: "hw:Loopback,1" }
$playback
resampler:
  type: Sinc
  parameters:
    phase_response: $phase
    cutoff: 0.97
    attenuation: 120
  sinc_type: Craven
  samplerate: $ups
pipeline:
  - type: Gain
    parameters: { gain: $gain }
  - type: Conv
    channel: 0
    parameters: { type: Wav, filename: "$left", channel: $chl }
  - type: Conv
    channel: 1
    parameters: { type: Wav, filename: "$right", channel: $chr }
  - type: Dither
    parameters: { type: @{[ _map_dither($dith) ]} }
  - type: Format
    parameters: { sampleformat: S$depth }
YML
    open my $fh, '>', "$cdir/$cid.yaml" or do { $log->error("YAML write failed: $!"); return };
    print $fh $yaml; close $fh;
}

sub _map_dither {
    my ($d) = @_;
    return 'None'       if $d eq 'none';
    return 'TPDF'       if $d eq 'triangular';
    return 'Shaped'     if $d eq 'shaped';
    return 'Lipshitz'   if $d eq 'lipshitz';
    return 'Fweighted'  if $d eq 'fweighted';
    return 'Eweighted'  if $d eq 'eweighted';
    return 'None';
}

1;
