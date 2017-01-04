//连续连接的 Node 专用类, 比如连续的地面, 天空
#import <SpriteKit/SpriteKit.h>

@interface LNConnectedNode: SKSpriteNode

/** 生成连续的地面 */
+ (instancetype) createConnectedGroundNode;

/** 生成连续的天空 */
+ (instancetype) createConnectedSkyNode;

/** 生成物理地面 */
+ (instancetype) createPhysicsGround;

@end
