package Plugins::MellowDSP::Settings;

use strict;
use warnings;
use base qw(Slim::Web::Settings);
use Slim::Utils::Prefs;
use Slim::Utils::Log;
use File::Basename;
use File::Copy qw(move);
use File::Path qw(make_path);
use POSIX qw(strftime);

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

my $base_dir = '/var/daphile/mellowdsp';
my $fir_dir  = "$base_dir/filters";
my $res_dir  = "$fir_dir/resampled";
my $logfile  = "$base_dir/mellowdsp.log";

sub name        { return 'PLUGIN_MELLOWDSP'; }
sub page        { return 'plugins/MellowDSP/settings/basic.html'; }
sub prefs       { return $prefs; }
sub needsClient { return 1; }

sub _to_hz {
    my ($s) = @_;
    return undef unless defined $s;
    $s =~ s/\s+//g;
    return int($1 * 1000 + 0.5) if $s =~ /^([\d.]+)k$/i;
    return int($s) if $s =~ /^\d+$/;
    return undef;
}

sub _sox_bin {
    for my $p (qw(/usr/bin/sox /usr/local/bin/sox /bin/sox)) {
        return $p if -x $p;
    }
    return undef;
}

sub _log {
    my ($msg) = @_;
    make_path($base_dir) unless -d $base_dir;
    open my $fh, '>>', $logfile;
    print $fh strftime("[%Y-%m-%d %H:%M:%S] ", localtime) . "$msg\n";
    close $fh;
}

sub _resample_fir {
    my ($src, $hz) = @_;
    return undef unless $src && -f $src && $hz;

    make_path($res_dir) unless -d $res_dir;

    my ($name, undef, $ext) = fileparse($src, qr/\.[^.]*/);
    $ext ||= '.wav';
    my $dst = "$res_dir/${name}_${hz}Hz$ext";

    my $sox = _sox_bin();
    unless ($sox) {
        _log("SoX non trovato, uso FIR originale: $src");
        return $src;
    }

    my @cmd = ($sox, '-V1', $src, '-r', $hz, $dst, 'rate', '-v');
    my $rc = system(@cmd);
    if ($rc == 0 && -f $dst) {
        _log("Resampled $src -> $dst ($hz Hz)");
        return $dst;
    } else {
        _log("Resample fallito rc=$rc per $src");
        return $src;
    }
}

sub handler {
    my ($class, $client, $params) = @_;

    if ($params->{saveSettings}) {
        make_path($fir_dir) unless -d $fir_dir;

        $prefs->client($client)->set('enabled',    $params->{enabled} ? 1 : 0);
        $prefs->client($client)->set('upsampling', $params->{upsampling});
        $prefs->client($client)->set('phase',      $params->{phase});
        $prefs->client($client)->set('depth',      $params->{depth});
        $prefs->client($client)->set('dither',     $params->{dither});
        $prefs->client($client)->set('precision',  $params->{precision});
        $prefs->client($client)->set('outputfmt',  $params->{outputfmt});
        $prefs->client($client)->set('fir_text',   $params->{fir_text});

        my $target_hz = _to_hz($params->{upsampling}) || 44100;

        for my $side (qw(left right)) {
            my $key = "fir_$side";
            my $file_key = "${key}_file";
            my $src = $params->{$key} || '';

            if ($params->{$file_key} && ref $params->{$file_key}) {
                my $src_tmp = $params->{$file_key}->{tmp};
                my $fname   = basename($params->{$file_key}->{filename} || "$side.wav");
                my $dst_raw = "$fir_dir/$fname";
                move($src_tmp, $dst_raw);
                $src = $dst_raw;
                _log("Uploaded FIR $side -> $dst_raw");
            }

            if ($src) {
                my $res = _resample_fir($src, $target_hz);
                $prefs->client($client)->set($key, $res);
            } else {
                $prefs->client($client)->set($key, '');
            }
        }
    }

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
