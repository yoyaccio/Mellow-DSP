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
    make_path($datadir) unless -d $datadir;

    if ($params->{saveSettings}) {
        foreach my $key (qw(enabled upsampling phase depth dither precision outputfmt fir_left fir_right fir_text)) {
            $prefs->client($client)->set($key, $params->{$key});
        }
        $log->info("MellowDSP settings saved");
    }

    return $class->SUPER::handler($client, $params);
}

1;
