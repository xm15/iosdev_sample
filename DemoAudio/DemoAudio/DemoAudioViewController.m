//
//  DemoAudioViewController.m
//  DemoAudio
//
//  Created by Shawn Welch on 10/26/11.
//  Copyright (c) 2011 anythingsimple.com. All rights reserved.
//

#import "DemoAudioViewController.h"

@implementation DemoAudioViewController
@synthesize artistLabel = _artistLabel, songLabel = _songLabel, player = _player, volumeSlider = _volumeSlider, playButton = _playButton;
@synthesize backgroundMusicSwitch = _backgroundMusicSwitch, ambientSoloSwitch = _ambientSoloSwitch;
@synthesize backgroundPlayer = _backgroundPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

#if !(TARGET_IPHONE_SIMULATOR)
    // Create a new iPod Music Player
    _player = [MPMusicPlayerController iPodMusicPlayer];
    
    // Add an observer for the player state
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateMainUI:) 
                                                 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object:nil];
    // Begin generating playback notifications
    [_player beginGeneratingPlaybackNotifications];

    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateMainUI:) 
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateMainUI:) 
                                                 name:MPMusicPlayerControllerVolumeDidChangeNotification
                                               object:nil];
    
    
    [self updateMainUI:nil];
#else
    _playButton.hidden = YES;
    _songLabel.text = @"Music Library Unavailable";
    _artistLabel.text = @"Please use iOS device";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iPhone Simulator" message:@"Music Library is not available on the iPhone Simulator" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
#endif
    
    // If other music is playing when the view loads, set the background music and
    // audio session to ambient automatically. 
    
    UInt32 otherAudioIsPlaying;
    UInt32 propertySize = sizeof (otherAudioIsPlaying);
    
    AudioSessionGetProperty (
                             kAudioSessionProperty_OtherAudioIsPlaying,
                             &propertySize,
                             &otherAudioIsPlaying
                             );
    
    if (otherAudioIsPlaying) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        [_ambientSoloSwitch setOn:NO];
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        [_ambientSoloSwitch setOn:YES];
    }
    
    
    // Set up and prepare the background music
    
    NSURL *soundEffectURL = [[NSBundle mainBundle] URLForResource:@"background-loop_01.aif" withExtension:nil];
    
    // Set up our sound effect
    NSError *error = nil;
    _backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundEffectURL error:&error];

    if(error == nil){
        [_backgroundPlayer setDelegate:self];

        // Use a negative number to repeat forever;
        [_backgroundPlayer setNumberOfLoops:-1];
        // Get the player ready to play
        [_backgroundPlayer prepareToPlay];
        
        // Turn on the background music switch
        // Manually call switch change (which will start playing music)
        [_backgroundMusicSwitch setOn:YES];
        [self backgroundMusicSwitchChange:nil];
    }
    else{
        _backgroundMusicSwitch.enabled = NO;
        _ambientSoloSwitch.enabled = NO;
        NSLog(@"There was an error loading the background AVAudioPlayer\n%@",[error localizedDescription]);
    }
    
}
- (IBAction)playTogglePressed:(id)sender{
    
    if(_player.playbackState != MPMusicPlaybackStatePlaying)
        [_player play];
    else
        [_player pause];
    
}

- (IBAction)volumeSliderChange:(id)sender{
    [_player setVolume:_volumeSlider.value];
}


- (IBAction)backgroundMusicSwitchChange:(id)sender{
    
    // Play or pause the background based on the state of the background music switch
    if(_backgroundMusicSwitch.on){
        [_backgroundPlayer play];
    }
    else{
        [_backgroundPlayer pause];
    }
    [self updateMainUI:nil];
}


- (IBAction)ambientSoloSwitchChange:(id)sender{
    if(_ambientSoloSwitch.on){
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    }
    else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    }
    [self updateMainUI:nil];
}


// Respond to button and present media picker
- (IBAction)musicLibraryButton:(id)sender{
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    // Create a new picker
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] 
                                       initWithMediaTypes:MPMediaTypeAnyAudio];
    // Set the picker's delegate as self
    [picker setDelegate:self];
    
    // Present picker as child view controller
    [self presentViewController:picker animated:YES completion:nil];
#else
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iPhone Simulator" message:@"Music Library is not available on the iPhone Simulator" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
#endif

}

// Respond with selected items
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker 
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [_player setQueueWithItemCollection:mediaItemCollection];
    [_player play];
}

// Respond with canceled picker
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateMainUI:(NSNotification*)notification{

#if !(TARGET_IPHONE_SIMULATOR)
    
    _volumeSlider.value = _player.volume;
    
    // Set the song label and artist label
    // While not used in this project, other properties you can access from the player items include:
    /*
     MPMediaItemPropertyPersistentID;     // @"persistentID",        NSNumber of uint64_t (unsigned long long),    filterable
     MPMediaItemPropertyMediaType;        // @"mediaType",           NSNumber of MPMediaType (NSInteger),          filterable
     MPMediaItemPropertyTitle;            // @"title",               NSString,                                     filterable
     MPMediaItemPropertyAlbumTitle;       // @"albumTitle",          NSString,                                     filterable
     MPMediaItemPropertyAlbumPersistentID // @"albumPID",            NSNumber of uint64_t (unsigned long long),    filterable
     MPMediaItemPropertyArtist;           // @"artist",              NSString,                                     filterable
     MPMediaItemPropertyArtistPersistentID // @"artistPID",          NSNumber of uint64_t (unsigned long long),    filterable
     MPMediaItemPropertyAlbumArtist;      // @"albumArtist",         NSString,                                     filterable
     MPMediaItemPropertyAlbumArtistPersistentID// @"albumArtistPID",      NSNumber of uint64_t (unsigned long long),    filterable
     MPMediaItemPropertyGenre;            // @"genre",               NSString,                                     filterable
     MPMediaItemPropertyGenrePersistentID // @"genrePID",            NSNumber of uint64_t (unsigned long long),    filterable
     MPMediaItemPropertyComposer;         // @"composer",            NSString,                                     filterable
     MPMediaItemPropertyComposerPersistentID // @"composerPID",         NSNumber of uint64_t (unsigned long long),    filterable
     MPMediaItemPropertyPlaybackDuration; // @"playbackDuration",    NSNumber of NSTimeInterval (double)
     MPMediaItemPropertyAlbumTrackNumber; // @"albumTrackNumber",    NSNumber of NSUInteger
     MPMediaItemPropertyAlbumTrackCount;  // @"albumTrackCount",     NSNumber of NSUInteger
     MPMediaItemPropertyDiscNumber;       // @"discNumber",          NSNumber of NSUInteger
     MPMediaItemPropertyDiscCount;        // @"discCount",           NSNumber of NSUInteger
     MPMediaItemPropertyArtwork;          // @"artwork",             MPMediaItemArtwork
     MPMediaItemPropertyLyrics;           // @"lyrics",              NSString
     MPMediaItemPropertyIsCompilation;    // @"isCompilation",       NSNumber of BOOL,                             filterable
     MPMediaItemPropertyReleaseDate       // @"releaseDate",         NSDate
     MPMediaItemPropertyBeatsPerMinute    // @"beatsPerMinute",      NSNumber of NSUInteger
     MPMediaItemPropertyComments          // @"comments",            NSString
     MPMediaItemPropertyAssetURL          // @"assetURL",            NSURL
     MPMediaItemPropertyIsCloudItem       // @"isCloudItem",         NSNumber of BOOL,                             filterable
     */
    _songLabel.text = [_player.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    _artistLabel.text = [_player.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    
    
    switch (_player.playbackState) {
        case MPMusicPlaybackStateStopped:

            [_playButton setTitle:@"Play" forState:UIControlStateNormal];
            
            break;
        case MPMusicPlaybackStatePlaying:
            [_playButton setTitle:@"Pause" forState:UIControlStateNormal];
            break;
        case MPMusicPlaybackStatePaused:
            [_playButton setTitle:@"Play" forState:UIControlStateNormal];
            break;
        case MPMusicPlaybackStateInterrupted:
            [_playButton setTitle:@"Pause" forState:UIControlStateNormal];
            break;
        case MPMusicPlaybackStateSeekingForward:
            [_playButton setTitle:@"Pause" forState:UIControlStateNormal];
            break;
        case MPMusicPlaybackStateSeekingBackward:
            [_playButton setTitle:@"Pause" forState:UIControlStateNormal];
            break;
    }
    
#endif
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationPortrait|UIDeviceOrientationPortraitUpsideDown;
}


@end
