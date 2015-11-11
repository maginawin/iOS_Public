//
//  WMMusicManager.h
//  MyWatch150812
//
//  Created by wangwendong on 15/8/23.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIEvent.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "WMMusicObject.h"

extern NSString *const kMusicManagerStateChanged;

@interface WMMusicManager : NSObject

+ (instancetype)sharedInstance;

- (void)remoteControlReceivedWithEvent:(UIEvent *)event;

//@property (strong, nonatomic) NSMutableArray *musics;
//@property (assign, nonatomic) NSInteger playIndex;
@property (strong, nonatomic) NSMutableDictionary *musicsDict;
@property (strong, nonatomic) NSString *playKey;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (NSArray *)musicArrayFromDict;

/**
 * @brief Play music which named musicName
 * @param musicName The music's name
 * @return If music name is available return YES, otherwise return NO
 */
- (BOOL)playMusicNamed:(NSString *)musicName;

//- (void)playMusicAtIndex:(NSInteger)index;
//
//- (void)pauseMusic;

- (void)stopMusic;

//- (void)playNext;
//
//- (void)playFore;

- (void)reloadMusics;

//- (void)playSearchSound:(BOOL)enable;

//- (void)playDisconnectedSound;

@end
