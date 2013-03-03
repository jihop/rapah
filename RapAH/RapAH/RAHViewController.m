//
//  RAHViewController.m
//  RapAH
//
//  Created by Jiho Park on 3/3/13.
//  Copyright (c) 2013 Drewnie. All rights reserved.
//

#import "RAHViewController.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface RAHViewController ()

@end

@implementation RAHViewController

@synthesize musicPlayer;

@synthesize nowPlayingLabel;
@synthesize playOrPauseButton;
@synthesize prevButton;
@synthesize nextButton;

@synthesize airhornButton;

@synthesize settingsButton;
@synthesize loadMusicButton;
@synthesize facebookButton;
@synthesize twitterButton;


- (void)viewDidLoad {
    [super viewDidLoad];

    //-- UI Setup --//
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_Blue_640x1146.png"]];

    
    //-- Music Player Setup --//
    
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    
    //-- Button Targets --//
    
    [loadMusicButton addTarget:self action:@selector(loadMusicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [playOrPauseButton addTarget:self action:@selector(playOrPauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [airhornButton addTarget:self action:@selector(airhornButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {

    [self unregisterMediaPlayerNotifications];
    [super dealloc];
}


#pragma mark MUSIC PLAYER FUNCTIONS

- (void) registerMediaPlayerNotifications {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    [notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: musicPlayer];
    [musicPlayer beginGeneratingPlaybackNotifications];
}

- (void)unregisterMediaPlayerNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object: musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object: musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerVolumeDidChangeNotification
                                                  object: musicPlayer];
    [musicPlayer endGeneratingPlaybackNotifications];
}


- (void) handle_NowPlayingItemChanged: (id) notification
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    /*
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    [artworkImageView setImage:artworkImage];
     */
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        nowPlayingLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    } else {
        nowPlayingLabel.text = @"Title: Unknown title";
    }
    /*
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        artistLabel.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    } else {
        artistLabel.text = @"Artist: Unknown artist";
    }
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        albumLabel.text = [NSString stringWithFormat:@"Album: %@",albumString];
    } else {
        albumLabel.text = @"Album: Unknown album";
    }
     */
}

- (void) handle_PlaybackStateChanged: (id) notification {
    
    NSLog(@"Changed Play State");
    /*
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    if (playbackState == MPMusicPlaybackStatePaused) {
        [playOrPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playOrPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        [playOrPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        [musicPlayer stop];
    }
     */
}

- (IBAction)volumeChanged:(id)sender
{
    //[musicPlayer setVolume:[volumeSlider value]];
}

- (IBAction)playPause:(id)sender
{
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [musicPlayer pause];
    } else {
        [musicPlayer play];
    }
}

- (IBAction)previousSong:(id)sender
{
    [musicPlayer skipToPreviousItem];
}

- (IBAction)nextSong:(id)sender
{
    [musicPlayer skipToNextItem];
}


#pragma mark BUTTON PRESS FUNCTIONS

- (void)airhornButtonPressed:(id)sender {
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"AirHorn" ofType:@"mp3"];
    NSURL *soundFileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    
    // Registers the audio route change listener callback function
    /*
    AudioSessionAddPropertyListener (
                                     kAudioSessionProperty_AudioRouteChange,
                                     audioRouteChangeListenerCallback,
                                     self
                                     );
     */
    
    // Activates the audio session.
    
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: soundFileURL error: nil];

    [newPlayer prepareToPlay];
    [newPlayer setVolume: 1.0];
    //[newPlayer setDelegate: self];
    [newPlayer play];
}

- (void)loadMusicButtonPressed:(id)sender {
    
    NSLog(@"Loading Music");
    
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    mediaPicker.prompt = @"Select songs to play";
    [self presentViewController:mediaPicker animated:YES completion:nil];
    [mediaPicker release];
}

- (void)playOrPauseButtonPressed:(id)sender {
    
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [musicPlayer pause];
    } else {
        [musicPlayer play];
    }
}


#pragma mark MEDIA PICKER DELEGATE

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems:(MPMediaItemCollection *) mediaItemCollection {
    if (mediaItemCollection) {
        
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [musicPlayer play];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [musicPlayer play];

}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark MISC FUNCTIONS

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
