package Plugins::MellowDSP::Plugin;

use strict;
use warnings;
use base qw(Slim::Plugin::Base);
use Slim::Utils::Log;
use Slim::Utils::Prefs;
use Plugins::MellowDSP::Settings;

my $log   = logger('plugin.mellowdsp');
my $prefs = preferences('plugin.mellowdsp');

sub initPlugin {
    my $class = shift;
    $log->info("MellowDSP plugin initialized");
    $class->SUPER::initPlugin(@_);
    
    $prefs->init({
        enabled => 0,
        upsampling => '44100',
        phase => 'linear',
    });
}

sub getDisplayName {
    return 'PLUGIN_MELLOWDSP';
}

sub settingsClass {
    return 'Plugins::MellowDSP::Settings';
}

1;
