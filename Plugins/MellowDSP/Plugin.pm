package Plugins::MellowDSP::Plugin;

use strict;
use warnings;
use base qw(Slim::Plugin::Base);
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Web::Pages;

my $log = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    my $class = shift;
    
    $log->info("MellowDSP v0.4.0.0 initializing...");
    
    $prefs->init({
        enabled => 0,
        upsampling => '44100',
        phase => 'linear',
        depth => '24',
        dither => 'none',
        precision => '24'
    });
    
    Slim::Web::Pages->addPageFunction(
        'plugins/MellowDSP/settings/index.html',
        \&settingsPage
    );
    
    $class->SUPER::initPlugin(@_);
    $log->info("MellowDSP v0.4.0.0 loaded successfully");
}

sub getDisplayName {
    return 'PLUGIN_MELLOWDSP';
}

sub settingsPage {
    my ($client, $params, $callback, $httpClient, $response) = @_;
    
    if ($params->{saveSettings}) {
        $prefs->set('enabled', $params->{enabled} ? 1 : 0);
        $prefs->set('upsampling', $params->{upsampling} || '44100');
        $prefs->set('phase', $params->{phase} || 'linear');
        $prefs->set('depth', $params->{depth} || '24');
        $prefs->set('dither', $params->{dither} || 'none');
        $prefs->set('precision', $params->{precision} || '24');
        
        $log->info("MellowDSP settings saved");
    }
    
    $params->{enabled} = $prefs->get('enabled') || 0;
    $params->{upsampling} = $prefs->get('upsampling') || '44100';
    $params->{phase} = $prefs->get('phase') || 'linear';
    $params->{depth} = $prefs->get('depth') || '24';
    $params->{dither} = $prefs->get('dither') || 'none';
    $params->{precision} = $prefs->get('precision') || '24';
    
    return Slim::Web::HTTP::filltemplatefile(
        'plugins/MellowDSP/settings/index.html',
        $params
    );
}

1;
