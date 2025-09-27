package Plugins::MellowDSP::Settings;

use strict;
use warnings;
use base qw(Slim::Web::Settings);
use Slim::Utils::Log;
use Slim::Utils::Prefs;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub name {
    return 'PLUGIN_MELLOWDSP';
}

sub page {
    return 'plugins/MellowDSP/settings/basic.html';
}

sub prefs {
    return ($prefs, qw(enabled upsampling phase));
}

sub handler {
    my ($class, $client, $params) = @_;

    if ($params->{saveSettings}) {
        $prefs->set('enabled', $params->{enabled} ? 1 : 0);
        $prefs->set('upsampling', $params->{upsampling} || '44100');
        $prefs->set('phase', $params->{phase} || 'linear');
        
        $log->info("MellowDSP settings saved: enabled=" . ($params->{enabled} || 0));
    }

    $params->{enabled} = $prefs->get('enabled') || 0;
    $params->{upsampling} = $prefs->get('upsampling') || '44100';
    $params->{phase} = $prefs->get('phase') || 'linear';

    return $class->SUPER::handler($client, $params);
}

1;
