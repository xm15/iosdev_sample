//
//  DemoAudioViewController.h
//  DemoAudio
//
//  Created by Shawn Welch on 10/26/11.
//  Copyright (c) 2011 anythingsimple.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MediaPlayer/MediaPlayer.h"

@interface DemoAudioViewController : UIViewController <MPMediaPickerControllerDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) MPMusicPlayerController *player;
@property (nonatomic, strong) AVAudioPlayer *backgroundPlayer;
@property (nonatomic, strong) IBOutlet UILabel *songLabel, *artistLabel;
@property (nonatomic, strong) IBOutlet UISlider *volumeSlider;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UISwitch *backgroundMusicSwitch, *ambientSoloSwitch;

- (IBAction)playTogglePressed:(id)sender;
- (IBAction)musicLibraryButton:(id)sender;
- (IBAction)volumeSliderChange:(id)sender;
- (IBAction)backgroundMusicSwitchChange:(id)sender;
- (IBAction)ambientSoloSwitchChange:(id)sender;


- (void)updateMainUI:(NSNotification*)notification;

@end
