//
//  WMMusicManager.m
//  MyWatch150812
//
//  Created by wangwendong on 15/8/23.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "WMMusicManager.h"
#import "AppDelegate.h"
//#import "WMMusicObject.h"
#import "WMBLEManager.h"

NSString *const kMusicManagerStateChanged = @"kMusicManagerStateChanged";

@interface WMMusicManager () <AVAudioPlayerDelegate>


@property (assign, nonatomic) BOOL isPlayingBeforeInterruption;

@end

@implementation WMMusicManager

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self configureBase];
    }
    
    return self;
}

#pragma mark - Public

- (NSArray *)musicArrayFromDict {
    NSMutableArray *value = [NSMutableArray array];
    
    if (self.musicsDict.count > 0) {
        for (NSString *key in _musicsDict) {
            WMMusicObject *music = _musicsDict[key];
            [value addObject:music];
        }
    }
    
    return value;
}

- (BOOL)playMusicNamed:(NSString *)musicName {
    if (!musicName) {
        return NO;
    }
    
    if (_musicsDict.count < 1) {
        return NO;
    }
    
    WMMusicObject *music = [_musicsDict objectForKey:musicName];
    
    if (!music) {
        return NO;
    }
    
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:music.url error:nil];
    _audioPlayer.delegate = self;
    [_audioPlayer setNumberOfLoops:INT_MAX];
    [_audioPlayer play];
    _playKey = music.name;
    
    return YES;
}

//- (void)playMusicAtIndex:(NSInteger)index {
//    if (_musics.count <= 0) {
//        _playIndex = 0;
//        return;
//    }
//    
//    index = index % _musics.count;
//    
//    WMMusicObject *music = _musics[index];
//    
//    
//    if (_audioPlayer) {
//        [_audioPlayer stop];
//        _audioPlayer = nil;
//    }
//    
//    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:music.url error:nil];
//    _audioPlayer.delegate = self;
//    [_audioPlayer play];
//    _playIndex = index;
//    
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kMusicManagerStateChanged object:nil];
//}

- (void)pauseMusic {
    if (_audioPlayer.isPlaying) {
        [_audioPlayer pause];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMusicManagerStateChanged object:nil];
}

- (void)stopMusic {
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stop];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMusicManagerStateChanged object:nil];
}

//- (void)playNext {
//    _playIndex += 1;
//    [self playMusicAtIndex:_playIndex];
//    
////    [[NSNotificationCenter defaultCenter] postNotificationName:kMusicManagerStateChanged object:nil];
//}

//- (void)playFore {
//    _playIndex -= 1;
//    
//    if (_playIndex < 0) {
//        _playIndex = _musics.count - 1;
//    }
//    
//    [self playMusicAtIndex:_playIndex];
//    
////    [[NSNotificationCenter defaultCenter] postNotificationName:kMusicManagerStateChanged object:nil];
//}

- (void)reloadMusics {
    [_musicsDict removeAllObjects];
    
    MPMediaQuery *playListQuery = [MPMediaQuery songsQuery];
    NSArray *playlists = [playListQuery collections];
    if (playlists.count > 0) {
        for (MPMediaPlaylist *playList in playlists) {
            NSArray *songs = [playList items];
            for (MPMediaItem *song in songs) {
                WMMusicObject *music = [[WMMusicObject alloc] init];
                music.name = [song valueForProperty:MPMediaItemPropertyTitle];
                music.url = [song valueForProperty:MPMediaItemPropertyAssetURL];
                music.artist = [song valueForProperty:MPMediaItemPropertyArtist];
                MPMediaItemArtwork *work = [song valueForKey:MPMediaItemPropertyArtwork];
                UIImage *image = [work imageWithSize:CGSizeMake(132.f, 132.f)];
                music.image = image;
                
                [_musicsDict setObject:music forKey:music.name];
            }
        }
    }
    
//    _playIndex = 0;
}

- (void)playSearchSound:(BOOL)enable {
    if (_audioPlayer.isPlaying) {
        [self stopMusic];
    }
    
    if (!enable) {
        
        return;
    }
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Crystal" withExtension:@"wav"];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    _audioPlayer.numberOfLoops = -1;
    [_audioPlayer play];
}

- (void)playDisconnectedSound {
    if (_audioPlayer.isPlaying) {
        [self stopMusic];
    }
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Jump" withExtension:@"wav"];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    _audioPlayer.numberOfLoops = 1;
    [_audioPlayer play];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self playMusicNamed:_playKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMusicManagerStateChanged object:nil];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    if (_audioPlayer.isPlaying) {
        _isPlayingBeforeInterruption = YES;
    } else {
        _isPlayingBeforeInterruption = NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMusicManagerStateChanged object:nil];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    if (_isPlayingBeforeInterruption) {
        [self playMusicNamed:_playKey];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMusicManagerStateChanged object:nil];
}

/** Remote control received with event */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPause: //暂停||开始
            [self pauseMusic];
            break;
        case UIEventSubtypeRemoteControlPlay:
            [self playMusicNamed:_playKey];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack: //上一曲
//            [self playFore];
            break;
        case UIEventSubtypeRemoteControlNextTrack: //下一曲
//            [self playNext];
            break;
        case UIEventSubtypeRemoteControlStop: {
            [self stopMusic];
            break;
        }
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMusicManagerStateChanged object:nil];
}

//- (void)kBLEManagerNotiMusicControl:(NSNotification *)noti {
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        NSNumber *num = noti.object;
//        NSInteger typeValue = num.integerValue;
//        
//        switch (typeValue) {
//            case BLEManagerNotiMusicControlTypePlay: {
//                [self playMusicAtIndex:_playIndex];
//                break;
//            }
//            case BLEManagerNotiMusicControlTypeStop: {
//                [self stopMusic];
//                break;
//            }
//            case BLEManagerNotiMusicControlTypeLast: {
//                [self playFore];
//                break;
//            }
//            case BLEManagerNotiMusicControlTypeNext: {
//                [self playNext];
//                break;
//            }
//        }
//    });
//}

//- (void)kBLEManagerNotiOldMusicControl:(NSNotification *)noti {
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        NSNumber *num = noti.object;
//        NSInteger typeValue = num.integerValue;
//        
//        switch (typeValue) {
//            case 0x01: {
//                if (_audioPlayer.isPlaying) {
//                    [self stopMusic];
//                } else {
//                    [self playMusicAtIndex:_playIndex];
//                }
//                break;
//            }
//            case 0x02: {
//                [self playFore];
//                break;
//            }
//            case 0x03: {
//                [self playNext];
//                break;
//            }
//        }
//    });
//}

#pragma mark - Configure

- (void)configureBase {
    // 给 Audio 添加远程设备支持
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 查询所有音乐
    _musicsDict = [NSMutableDictionary dictionary];
    MPMediaQuery *playListQuery = [MPMediaQuery songsQuery];
    NSArray *playlists = [playListQuery collections];
    if (playlists.count > 0) {
        for (MPMediaPlaylist *playList in playlists) {
            NSArray *songs = [playList items];
            for (MPMediaItem *song in songs) {
                WMMusicObject *music = [[WMMusicObject alloc] init];
                music.name = [song valueForProperty:MPMediaItemPropertyTitle];
                music.url = [song valueForProperty:MPMediaItemPropertyAssetURL];
                music.artist = [song valueForProperty:MPMediaItemPropertyArtist];
                MPMediaItemArtwork *work = [song valueForKey:MPMediaItemPropertyArtwork];
                UIImage *image = [work imageWithSize:CGSizeMake(132.f, 132.f)];
                music.image = image;
                
                [_musicsDict setObject:music forKey:music.name];
            }
        }
    }
    
//    _playIndex = 0;
    
    // 添加音乐通知监听
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kBLEManagerNotiMusicControl:) name:kBLEManagerNotiMusicControl object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kBLEManagerNotiOldMusicControl:) name:kBLEManagerNotiOldMusicControl object:nil];
    
}

@end
