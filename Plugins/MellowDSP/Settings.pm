package Plugins::MellowDSP::Settings;

use strict;
use warnings;
use base qw(Slim::Web::Settings);
use Slim::Utils::Prefs;
use Slim::Utils::Log;
use File::Basename;
use File::Copy;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

# Directory target per i FIR
my $fir_dir = '/var/daphile/mellowdsp/filters';

sub name        { return 'PLUGIN_MELLOWDSP'; }
sub page        { return 'plugins/MellowDSP/settings/basic.html'; }
sub prefs       { return $prefs; }
sub needsClient { return 1; }

sub handler {
    my ($class, $client, $params) = @_;

    if ($params->{saveSettings}) {
        # Abilita cartella FIR se non esiste
        mkdir $fir_dir unless -d $fir_dir;

        # Salva checkbox e menù
        $prefs->client($client)->set('enabled',    $params->{enabled} ? 1 : 0);
        $prefs->client($client)->set('upsampling', $params->{upsampling});
        $prefs->client($client)->set('phase',      $params->{phase});
        $prefs->client($client)->set('depth',      $params->{depth});
        $prefs->client($client)->set('dither',     $params->{dither});
        $prefs->client($client)->set('precision',  $params->{precision});
        $prefs->client($client)->set('outputfmt',  $params->{outputfmt});
        $prefs->client($client)->set('fir_text',   $params->{fir_text});

        # Gestione upload file FIR Left
        if ($params->{fir_left_file} && ref $params->{fir_left_file}) {
            my $src = $params->{fir_left_file}->{tmp};
            my $dst = $fir_dir . '/' . basename($params->{fir_left_file}->{filename});
            move($src, $dst);
            $prefs->client($client)->set('fir_left', $dst);
        } else {
            $prefs->client($client)->set('fir_left', $params->{fir_left});
        }

        # Gestione upload file FIR Right
        if ($params->{fir_right_file} && ref $params->{fir_right_file}) {
            my $src = $params->{fir_right_file}->{tmp};
            my $dst = $fir_dir . '/' . basename($params->{fir_right_file}->{filename});
            move($src, $dst);
            $prefs->client($client)->set('fir_right', $dst);
        } else {
            $prefs->client($client)->set('fir_right', $params->{fir_right});
        }
    }

    # Recupera valori correnti
    $params->{enabled}    = $prefs->client($client)->get('enabled')    || 0;
    $params->{upsampling} = $prefs->client($client)->get('upsampling') || '44.1k';
    $params->{phase}      = $prefs->client($client)->get('phase')      || 'linear';
    $params->{depth}      = $prefs->client($client)->get('depth')      || '16-bit';
    $params->{dither}     = $prefs->client($client)->get('dither')     || 'none';
    $params->{precision}  = $prefs->client($client)->get('precision')  || '16-bit';
    $params->{outputfmt}  = $prefs->client($client)->get('outputfmt')  || 'flac';
    $params->{fir_left}   = $prefs->client($client)->get('fir_left')   || '';
    $params->{fir_right}  = $prefs->client($client)->get('fir_right')  || '';
    $params->{fir_text}   = $prefs->client($client)->get('fir_text')   || '';

    return $class->SUPER::handler($client, $params);
}

1;
