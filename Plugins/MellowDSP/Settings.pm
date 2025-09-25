package Plugins::MellowDSP::Settings;

use strict;
use warnings;
use base qw(Slim::Web::Settings);
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use File::Path qw(make_path);
use File::Spec::Functions qw(catdir catfile);

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    return $self;
}

sub name {
    return 'PLUGIN_MELLOWDSP';
}

sub page {
    return 'plugins/MellowDSP/settings/basic.html';
}

sub prefs {
    return ($prefs, qw(enabled upsampling phase depth dither precision outputfmt fir_left fir_right fir_text));
}

sub handler {
    my ($class, $client, $params) = @_;

    my $base = Slim::Utils::PluginManager->allPlugins->{'MellowDSP'}->{basedir};
    my $datadir = catdir($base, 'data');
    my $filters = catdir($datadir, 'filters');
    make_path($filters) unless -d $filters;

    if ($params->{saveSettings}) {
        foreach my $key (qw(enabled upsampling phase depth dither precision outputfmt fir_left fir_right fir_text)) {
            $prefs->client($client)->set($key, $params->{$key});
        }

        # scrive config.json di CamillaDSP
        my $jsonfile = catfile($datadir, 'camilladsp_config.json');
        if (open my $fh, '>', $jsonfile) {
            print $fh "{\n";
            print $fh "  \"samplerate\": \"$params->{upsampling}\",\n";
            print $fh "  \"dither\": \"$params->{dither}\",\n";
            print $fh "  \"bitdepth\": \"$params->{depth}\",\n";
            print $fh "  \"output_format\": \"$params->{outputfmt}\",\n";
            print $fh "  \"fir_left\": \"$params->{fir_left}\",\n";
            print $fh "  \"fir_right\": \"$params->{fir_right}\"\n";
            print $fh "}\n";
            close $fh;
        }

        $log->info("Saved settings and wrote CamillaDSP config: $jsonfile");
    }

    return $class->SUPER::handler($client, $params);
}

1;
