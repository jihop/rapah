//
//  RAHViewController.h
//  RapAH
//
//  Created by Jiho Park on 3/3/13.
//  Copyright (c) 2013 Drewnie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RAHViewController : UIViewController <MPMediaPickerControllerDelegate>

@property (nonatomic,retain) IBOutlet UILabel *nowPlayingLabel;
@property (nonatomic,retain) IBOutlet UIButton *playOrPauseButton;
@property (nonatomic,retain) IBOutlet UIButton *nextButton;
@property (nonatomic,retain) IBOutlet UIButton *prevButton;

@property (nonatomic,retain) IBOutlet UIButton *airhornButton;

@property (nonatomic,retain) IBOutlet UIButton *settingsButton;
@property (nonatomic,retain) IBOutlet UIButton *loadMusicButton;
@property (nonatomic,retain) IBOutlet UIButton *facebookButton;
@property (nonatomic,retain) IBOutlet UIButton *twitterButton;

@property (nonatomic,retain) MPMusicPlayerController *musicPlayer;


@end
