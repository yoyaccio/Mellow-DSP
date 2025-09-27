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
    
    $log->info("MellowDSP plugin loading...");
    
    # Inizializza preferenze default
    $prefs->init({
        enabled => 0,
        upsampling => '44100',
    });
    
    # Registra la pagina delle impostazioni
    Slim::Web::Pages->addPageFunction(
        'plugins/MellowDSP/settings/index.html',
        \&settingsPage
    );
    
    $class->SUPER::initPlugin(@_);
    $log->info("MellowDSP plugin loaded successfully");
}

sub getDisplayName {
    return 'PLUGIN_MELLOWDSP';
}

sub settingsPage {
    my ($client, $params, $callback, $httpClient, $response) = @_;
    
    # Salva impostazioni se richiesto
    if ($params->{saveSettings}) {
        $prefs->set('enabled', $params->{enabled} ? 1 : 0);
        $prefs->set('upsampling', $params->{upsampling} || '44100');
        $log->info("Settings saved: enabled=" . ($params->{enabled} || 0));
    }
    
    # Carica valori correnti
    $params->{enabled} = $prefs->get('enabled') || 0;
    $params->{upsampling} = $prefs->get('upsampling') || '44100';
    
    # Ritorna la pagina HTML processata
    return Slim::Web::HTTP::filltemplatefile(
        'plugins/MellowDSP/settings/index.html',
        $params
    );
}

1;
