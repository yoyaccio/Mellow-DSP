package Plugins::MellowDSP::Plugin;

use strict;
use warnings;
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Slim::Web::Pages;
use Slim::Web::Settings;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    $log->info("MellowDSP plugin initializing...");
    
    Slim::Web::Settings->addPlayerSettings(
        'AUDIO',
        'MellowDSP',
        \&handler,
        'PLUGIN_MELLOWDSP'
    );
    
    return 1;
}

sub handler {
    my ($class, $client, $paramRef, $callback, @args) = @_;
    
    if ($paramRef->{'saveSettings'}) {
        $prefs->client($client)->set('enabled', $paramRef->{'enabled'} ? 1 : 0);
        $prefs->client($client)->set('upsampling', $paramRef->{'upsampling'} || '44.1k');
        $prefs->client($client)->set('phase_response', $paramRef->{'phase_response'} || 'linear');
        $prefs->client($client)->set('output_depth', $paramRef->{'output_depth'} || '24-bit');
        $prefs->client($client)->set('dithering', $paramRef->{'dithering'} || 'none');
        $prefs->client($client)->set('target_precision', $paramRef->{'target_precision'} || '24-bit');
    }
    
    $paramRef->{'enabled'} = $prefs->client($client)->get('enabled') || 0;
    $paramRef->{'upsampling'} = $prefs->client($client)->get('upsampling') || '44.1k';
    $paramRef->{'phase_response'} = $prefs->client($client)->get('phase_response') || 'linear';
    $paramRef->{'output_depth'} = $prefs->client($client)->get('output_depth') || '24-bit';
    $paramRef->{'dithering'} = $prefs->client($client)->get('dithering') || 'none';
    $paramRef->{'target_precision'} = $prefs->client($client)->get('target_precision') || '24-bit';
    
    return Slim::Web::HTTP::filltemplatefile('plugins/MellowDSP/settings/player.html', $paramRef);
}

sub getDisplayName {
    return 'PLUGIN_MELLOWDSP';
}

1;
