package Plugins::MellowDSP::PlayerSettings;

use strict;
use warnings;
use base qw(Slim::Web::Settings);

my $prefs = preferences('plugin.mellowdsp');

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub name { 'PLUGIN_MELLOWDSP' }

sub page { 'plugins/MellowDSP/settings/player.html' }

sub prefs { ($prefs, qw(enabled upsample_rate)) }

sub handler {
    my ($class, $client, $params) = @_;
    my $cp = $prefs->client($client);

    if ($params->{saveSettings}) {
        $cp->set('enabled', $params->{pref_enabled} ? 1 : 0);
        $cp->set('upsample_rate', $params->{pref_upsample_rate} || '44100');
    }

    $params->{pref_enabled}       = $cp->get('enabled')       || 0;
    $params->{pref_upsample_rate} = $cp->get('upsample_rate') || '44100';

    return $class->SUPER::handler($client, $params);
}

1;
