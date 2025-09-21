package Plugins::CamillaFIR::Settings;

use strict;
use warnings;
use Slim::Web::Pages;
use Slim::Utils::Prefs;
use Slim::Utils::Log;

our $log = logger('plugin.camillafir');
our $prefs = preferences('plugin.camillafir');

sub init {
    # Registra pagine web
    Slim::Web::Pages->addPageFunction(
        'plugins/CamillaFIR/settings/basic.html',
        \&basicSettings
    );
    
    Slim::Web::Pages->addPageFunction(
        'plugins/CamillaFIR/uploadfir',
        \&uploadFIR
    );
}

sub basicSettings {
    my ($client, $params) = @_;
    
    if ($params->{'saveSettings'}) {
        $prefs->set('enabled', $params->{'enabled'} ? 1 : 0);
        $prefs->set('samplerate', $params->{'samplerate'} || 768000);
        $prefs->set('chunksize', $params->{'chunksize'} || 2048);
        $prefs->set('bypass', $params->{'bypass'} ? 1 : 0);
        
        $log->info("Settings saved");
    }
    
    $params->{'prefs'} = $prefs;
    return Slim::Web::HTTP::filltemplatefile('plugins/CamillaFIR/settings/basic.html', $params);
}

sub uploadFIR {
    my ($client, $params) = @_;
    
    # Gestione upload FIR files
    if ($params->{'upload_left'} && $params->{'upload_left_filename'}) {
        my $content = $params->{'upload_left'};
        my $filename = $params->{'upload_left_filename'};
        $filename =~ s/.*[\/\\]//;
        
        my $path = "/media/hdd/system/fir_left.wav";
        open(my $fh, '>', $path) or die "Cannot write $path";
        binmode $fh;
        print $fh $content;
        close($fh);
        
        $prefs->set('fir_left', $filename);
        $log->info("Uploaded FIR left: $filename");
    }
    
    if ($params->{'upload_right'} && $params->{'upload_right_filename'}) {
        my $content = $params->{'upload_right'};
        my $filename = $params->{'upload_right_filename'};
        $filename =~ s/.*[\/\\]//;
        
        my $path = "/media/hdd/system/fir_right.wav";
        open(my $fh, '>', $path) or die "Cannot write $path";
        binmode $fh;
        print $fh $content;
        close($fh);
        
        $prefs->set('fir_right', $filename);
        $log->info("Uploaded FIR right: $filename");
    }
    
    return basicSettings($client, $params);
}

1;
