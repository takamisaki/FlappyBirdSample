#import "ButtonNode.h"

@implementation ButtonNode

- (instancetype) initWithImageNamed:(NSString *)name {
    
    if (self = [super initWithImageNamed:name]) {
       [self setUserInteractionEnabled:YES];
    }
    return self;
}

//点击开始事件: 点击时播放音效和动画
- (void) touchesBegan: (NSSet<UITouch *> *)touches withEvent: (UIEvent *)event {
    
    SKAction *buttonDown       = [SKAction moveByX: 0 y: -3 duration: 0.1];
    SKAction *clickSoundAction = [SKAction playSoundFileNamed: @"click.wav" waitForCompletion: YES];
    SKAction *waitAction       = [SKAction waitForDuration: 1];
    SKAction *buttonActions    = [SKAction sequence: @[clickSoundAction, buttonDown, waitAction]];
    [self runAction: buttonActions];
    
    if (self.block) {
        self.block();
    }

}

@end
