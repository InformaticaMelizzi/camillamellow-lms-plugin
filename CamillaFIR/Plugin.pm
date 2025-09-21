package Plugins::CamillaFIR::Plugin;

use strict;
use warnings;
use base qw(Slim::Plugin::Base);
use Slim::Utils::Log;
use Slim::Utils::Prefs;

our $VERSION = '0.1.3';
our $log = logger('plugin.camillafir');
our $prefs = preferences('plugin.camillafir');

sub initPlugin {
    my $class = shift;
    
    # Inizializza preferenze
    $prefs->init({
        enabled => 1,
        samplerate => 768000,
        chunksize => 2048,
        fir_left => '',
        fir_right => '',
        bypass => 0,
        volume => 100,
    });
    
    # Carica moduli aggiuntivi
    use Plugins::CamillaFIR::Settings;
    Plugins::CamillaFIR::Settings->init();
    
    $class->SUPER::initPlugin(
        version => $VERSION,
        display => 'CamillaFIR DSP',
        description => 'Advanced FIR processing with REW integration',
        icon => 'plugins/CamillaFIR/HTML/images/camillafir.png',
    );
    
    $log->info("CamillaFIR plugin v$VERSION loaded");
    return 1;
}

sub getDisplayName {
    return 'CamillaFIR DSP';
}

1;
