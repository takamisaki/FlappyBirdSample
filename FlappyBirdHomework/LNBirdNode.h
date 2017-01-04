//本项目用的鸟都是这个类的实例
#import <SpriteKit/SpriteKit.h>

@interface LNBirdNode : SKSpriteNode

/** 生成鸟 */
+ (instancetype) birdNode;

/** 忽闪翅膀的 Action */
- (SKAction *) flapAction;

/** 原地上下的 Action */
- (SKAction *) upDownAction;

/** 开启重力的方法 */
- (void) turnOnPhysics;

@end
