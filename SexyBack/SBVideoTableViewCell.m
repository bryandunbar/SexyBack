//
//  SBVideoTableViewCell.m
//  SexyBack
//
//  Created by Bryan Dunbar on 1/26/15.
//  Copyright (c) 2015 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBVideoTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SBVideoTableViewCell()
-(void)commonInit;
@property (nonatomic, retain) MPMoviePlayerController *movie;
@end
@implementation SBVideoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"Bounds: %@", NSStringFromCGRect(self.bounds));
    self.movie.view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}
-(void)awakeFromNib {
    [self commonInit];
}

-(void)setVideoUrl:(NSString *)videoUrl {
    if (videoUrl != _videoUrl) {
        _videoUrl = videoUrl;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMPMoviePlayerPlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMPMoviePlayerPlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:nil];

        
        self.movie.contentURL = [NSURL URLWithString:self.videoUrl];
        [self.movie prepareToPlay];
    }
}

- (void)handleMPMoviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    NSDictionary *notificationUserInfo = [notification userInfo];
    NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    MPMovieFinishReason reason = [resultValue intValue];
    if (reason == MPMovieFinishReasonPlaybackError)
    {
        NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
        if (mediaPlayerError)
        {
            NSLog(@"playback failed with error description: %@", [mediaPlayerError localizedDescription]);
        }
        else
        {
            NSLog(@"playback failed without any given reason");
        }
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
}
-(void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.movie = [[MPMoviePlayerController alloc] init];
    self.movie.shouldAutoplay = NO;
    self.movie.controlStyle = MPMovieControlStyleDefault;

    self.movie.scalingMode = MPMovieScalingModeAspectFit;
    self.movie.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.movie.view];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.movie.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.movie.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.movie.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.movie.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.movie.view addConstraint:[NSLayoutConstraint constraintWithItem:self.movie.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0]];
    
}
-(void)prepareForReuse {
    [super prepareForReuse];
    [[NSNotificationCenter defaultCenter] removeObserver:self
name:MPMoviePlayerPlaybackDidFinishNotification
object:nil];
    [self.movie stop];
    
}

@end
