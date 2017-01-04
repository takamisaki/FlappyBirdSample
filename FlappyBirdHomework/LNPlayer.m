#import "LNPlayer.h"

@implementation LNPlayer

+ (instancetype) createPlayer {
    
    NSURL *bgmURL        = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"BGM"
                                                                                   ofType: @"mp3"]];
    LNPlayer *player     = [[LNPlayer alloc] initWithContentsOfURL: bgmURL error: nil];
    player.numberOfLoops = -1;
    player.volume        = 0.5;
    return player;
}

@end
