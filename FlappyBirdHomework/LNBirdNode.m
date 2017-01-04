#import "LNBirdNode.h"

@interface LNBirdNode ()
{
    SKAction *_flapAction;      //忽闪翅膀的 action
    SKAction *_upDownAction;    //原地上下的 action
}

@end

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

@implementation LNBirdNode

//创建基本鸟: 默认大小3. 只会动翅膀. 无物理属性, 不指定位置
- (instancetype) initWithTexture:(SKTexture *)texture {
    
    if (self = [super initWithTexture:texture]) {
        
        SKTexture *birdTexture1     = [SKTexture textureWithImageNamed:@"Bird1"];
        SKTexture *birdTexture2     = [SKTexture textureWithImageNamed:@"Bird2"];
        birdTexture1.filteringMode  = SKTextureFilteringNearest;
        birdTexture2.filteringMode  = SKTextureFilteringNearest;
        
        SKAction *birdTextureChange = [SKAction animateWithTextures:@[birdTexture1,birdTexture2]
                                                       timePerFrame:0.2];
        
        _flapAction = [SKAction repeatActionForever:birdTextureChange];
        
        [self setScale:3.0];
        [self runAction:_flapAction];
    }
    return self;
}

//工厂方法生成基本鸟
+ (instancetype) birdNode {
    
    SKTexture *texture = [SKTexture textureWithImageNamed:@"Bird1"];
    LNBirdNode *node   = [[LNBirdNode alloc] initWithTexture:texture];
    return node;
}


- (SKAction *)flapAction {
    return _flapAction;
}


- (SKAction *) upDownAction {
    
    SKAction *birdDown = [SKAction moveByX:0 y:-10 duration:0.5];
    SKAction *birdUp = [SKAction moveByX:0 y:10 duration:0.5];
    SKAction *birdUpDown = [SKAction sequence:@[birdDown,birdUp]];
    SKAction *birdUpDowns = [SKAction repeatActionForever:birdUpDown];
    
    return birdUpDowns;
}

- (void) turnOnPhysics {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.height/2];
    self.physicsBody.dynamic = YES;
    self.physicsBody.allowsRotation = YES;
}

@end
