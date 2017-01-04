#import "LNConnectedNode.h"

@implementation LNConnectedNode

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 创建连续 node

- (instancetype) createConnectedNodesWithAction: (SKAction *)action texture:(SKTexture *)texture base:(CGFloat)base {
    
    CGFloat realWidth  = texture.size.width * 3;
    CGFloat realHeight = texture.size.height * 3;
    
    int count = SCREEN_WIDTH / realWidth;
    
    LNConnectedNode *connectedNode = [LNConnectedNode node];
    
    for (int num = 0; num < count +2; num ++) {
        SKSpriteNode *tempNode = [SKSpriteNode spriteNodeWithTexture:texture];
        [tempNode setScale:3.0];
        CGFloat tempX = realWidth /2 + num * realWidth ;
        CGFloat tempY = realHeight/2 + base;
        tempNode.position = CGPointMake(tempX, tempY);
        [tempNode runAction:action];
        [connectedNode addChild:tempNode];
    }
    
    return connectedNode;
}

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 地面相关

//创建地面贴图
- (SKTexture *) createGroundTexture {
    
    SKTexture *texture    = [SKTexture textureWithImageNamed:@"Ground"];
    texture.filteringMode = SKTextureFilteringNearest;
    return texture;
}

//创建地面 action
- (SKAction *) createGroundAction {
    
    SKTexture *texture       = [SKTexture textureWithImageNamed:@"Ground"];
    CGFloat realWidth        = texture.size.width * 3;
    
    SKAction *groundMove     = [SKAction moveByX:-realWidth y:0 duration:0.02 * realWidth];
    SKAction *groundReset    = [SKAction moveByX:realWidth y:0 duration:0];
    SKAction *sequenceAction = [SKAction sequence:@[groundMove, groundReset]];
    SKAction *groundAction   = [SKAction repeatActionForever:sequenceAction];
    
    return groundAction;
}

//创建连续地面
+ (instancetype) createConnectedGroundNode {
    
    LNConnectedNode *node          = [LNConnectedNode node];
    SKAction *action               = [node createGroundAction];
    SKTexture *texture             = [node createGroundTexture];
    LNConnectedNode *connectedNode = [node createConnectedNodesWithAction:action
                                                                  texture:texture base:0];
    return connectedNode;
}

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 天空相关

//创建天空贴图
- (SKTexture *) createSkyTexture {
    
    SKTexture *texture    = [SKTexture textureWithImageNamed:@"Sky"];
    texture.filteringMode = SKTextureFilteringNearest;
    return texture;
}

//创建天空 action
- (SKAction *) createSkyAction {
    
    SKTexture *texture       = [SKTexture textureWithImageNamed:@"Sky"];
    CGFloat realWidth        = texture.size.width * 3;
    
    SKAction *skyMove        = [SKAction moveByX:-realWidth y:0 duration:0.1 * realWidth];
    SKAction *skyReset       = [SKAction moveByX:realWidth y:0 duration:0];
    SKAction *sequenceAction = [SKAction sequence:@[skyMove,skyReset]];
    SKAction *skyAction      = [SKAction repeatActionForever:sequenceAction];
    
    return skyAction;
}

//创建连续天空
+ (instancetype) createConnectedSkyNode {
    
    LNConnectedNode *node          = [LNConnectedNode node];
    SKAction *action               = [node createSkyAction];
    SKTexture *texture             = [node createSkyTexture];
    SKTexture *groundTexture       = [node createGroundTexture];
    CGFloat base                   = groundTexture.size.height * 3;
    LNConnectedNode *connectedNode = [node createConnectedNodesWithAction:action
                                                                  texture:texture base:base];
    return connectedNode;
}

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 创建物理地面

//工厂方法
+ (instancetype) createPhysicsGround {
    
    return [[LNConnectedNode node] createPhysicsGroundInstanceMethod];
}

//实例方法
- (instancetype) createPhysicsGroundInstanceMethod {
    
    SKTexture *texture       = [SKTexture textureWithImageNamed:@"Ground"];
    CGFloat groundRealHeight = texture.size.height * 3;
    CGSize size              = CGSizeMake(SCREEN_WIDTH, groundRealHeight);
    
    LNConnectedNode *physicsGround    = [LNConnectedNode node];
    physicsGround.physicsBody         = [SKPhysicsBody bodyWithRectangleOfSize:size];
    physicsGround.position            = CGPointMake(0, groundRealHeight/2 - 10);
    physicsGround.physicsBody.dynamic = NO;
    
    return physicsGround;
}

@end
