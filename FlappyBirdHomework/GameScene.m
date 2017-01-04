#import "GameScene.h"

@interface GameScene () <SKPhysicsContactDelegate>
{
    LNBirdNode  *_bird;                 //鸟
    LNPlayer    *_BGMPlayer;            //背景音乐
    
    SKTexture   *_downPipeTexture;      //下管子贴图
    SKTexture   *_upperPipeTexture;     //上管子贴图
    SKAction    *_moveAndRemovePipes;   //管子 Action
    SKNode      *_pipesNode;            //管子 Node
    
    SKNode      *_allMovingNodes;       //所有移动的 Node(除了鸟)
    
    SKLabelNode *_scoreLabelNode;       //分属 Label
    NSInteger    _score;                //得分
    
    SKNode      *_guideNode;            //开始提示
    SKLabelNode *_gameOverNode;         //结束提示
    
    BOOL _canRestart;                   //重玩确认
    BOOL _gameOn;                       //开始游戏否
    BOOL _worldGravityOn;               //重力开启否
}

@end

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

@implementation GameScene

//管子中间的距离
static NSInteger const kPipeGap     = 150;

//碰撞测试的 Category
static const uint32_t birdCategory  = 1 << 0;
static const uint32_t worldCategory = 1 << 1;
static const uint32_t pipeCategory  = 1 << 2;
static const uint32_t scoreCategory = 1 << 3;

//场景进入显示后的设置
- (void) didMoveToView: (SKView *)view {
    
    self.scaleMode                    = SKSceneScaleModeAspectFill;
    self.physicsWorld.gravity         = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    
    _canRestart     = NO;
    _pipesNode      = [SKNode node];
    _allMovingNodes = [SKNode node];
    [_allMovingNodes addChild:_pipesNode];
    [self addChild:_allMovingNodes];
    
    //创建提示
    [self createGuide];
    //创建 BGM
    [self createBGM];
    //创建分数
    [self createScoreLabel];
    //创建鸟, 地面, 天空, 管子
    [self createBird];
    [self createGroundOn: (SKNode *)_allMovingNodes];
    [self createSkyOn:    (SKNode *)_allMovingNodes];
    [self createPipe];
}

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 生成小配件

//设置提示和游戏初始参数
- (void) createGuide {
    
    _gameOn         = false;
    _worldGravityOn = false;
    _guideNode      = [self createGuideNode];
    [self addChild:_guideNode];
}

//创建提示 node
- (SKNode *) createGuideNode {

    SKNode *node           = [SKNode node];
    
    SKLabelNode *readyNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    readyNode.text         = @"GET READY";
    readyNode.fontSize     = 50;
    readyNode.position     = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/5*4);
    [node addChild:readyNode];
    
    SKLabelNode *tapNode   = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    tapNode.text           = @"Tap to fly higher";
    tapNode.position       = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [node addChild:tapNode];
    
    return node;
}

//创建背景音乐
- (void) createBGM {

    _BGMPlayer = [LNPlayer createPlayer];
    [_BGMPlayer play];
}

//生成得分 Label
- (void) createScoreLabel {
    _score                      = 0;
    _scoreLabelNode             = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    _scoreLabelNode.text        = [NSString stringWithFormat:@"%ld",(long)_score];
    _scoreLabelNode.position    = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/4*3);
    _scoreLabelNode.zPosition   = 10;
    [self addChild:_scoreLabelNode];
}


//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 生成角色

//创建鸟, 设置位置, 开启物理引擎
- (void) createBird {
    
    _bird          = [LNBirdNode birdNode];
    _bird.position = CGPointMake(SCREEN_WIDTH/4, SCREEN_HEIGHT/4*3);
    
    [_bird turnOnPhysics];
    _bird.physicsBody.categoryBitMask    = birdCategory;
    _bird.physicsBody.collisionBitMask   = worldCategory | pipeCategory;
    _bird.physicsBody.contactTestBitMask = worldCategory | pipeCategory;
    
    [self addChild:_bird];
}


//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 生成背景

//生成连续的地面
- (void) createGroundOn: (SKNode *) fatherNode {
    
    LNConnectedNode *connectedGroundNode = [LNConnectedNode createConnectedGroundNode];
    [fatherNode addChild:connectedGroundNode];
    
    LNConnectedNode *physicsGround = [LNConnectedNode createPhysicsGround];
    physicsGround.physicsBody.categoryBitMask = worldCategory;
    [self addChild:physicsGround];
}

//生成连续的天空
- (void) createSkyOn: (SKNode *) fatherNode {
    
    LNConnectedNode *connectedSkyNode = [LNConnectedNode createConnectedSkyNode];
    connectedSkyNode.zPosition = -20;
    [fatherNode addChild:connectedSkyNode];
}


//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 生成管子

//设置管子和管子 Action
- (void) createPipe {
    
    _downPipeTexture                = [SKTexture textureWithImageNamed: @"PipeDown"];
    _upperPipeTexture               = [SKTexture textureWithImageNamed: @"PipeUp"];
    _downPipeTexture.filteringMode  = SKTextureFilteringNearest;
    _upperPipeTexture.filteringMode = SKTextureFilteringNearest;
    
    CGFloat distancePipeMoved       = SCREEN_WIDTH + _downPipeTexture.size.width * 3 * 2;
    SKAction *movePipes             = [SKAction moveByX: - distancePipeMoved y: 0
                                                duration: distancePipeMoved / 200];
    SKAction *removePipes           = [SKAction removeFromParent];
    _moveAndRemovePipes             = [SKAction repeatActionForever:
                                      [SKAction sequence: @[movePipes, removePipes]]];
    
    SKAction *spawnAction           = [SKAction performSelector :@selector(spawnPipe) onTarget:self];
    SKAction *delaySpawnAction      = [SKAction waitForDuration: 2.0];
    SKAction *regularAction         = [SKAction sequence: @[spawnAction, delaySpawnAction ]];
    SKAction *regualrForeverAction  = [SKAction repeatActionForever: regularAction];
    [self runAction:regualrForeverAction];
}


// 生成管子的方法: 只在游戏进行时生成. 管子套装包括:下管子, 上管子, 得分 Node
- (void) spawnPipe {
    
    if (_gameOn == true) {
        
        //一对管子的 father
        SKNode *pipePair      = [SKNode node];
        pipePair.position     = CGPointMake(SCREEN_WIDTH + _downPipeTexture.size.width*4, 0);
        pipePair.zPosition    = - 10;
        
        //设置下面管子的 Y 值
        CGFloat downPipeY     = arc4random() % (NSInteger) SCREEN_HEIGHT/3;
        CGFloat pipeSizeCount = _downPipeTexture.size.height * 3 /2 / SCREEN_HEIGHT;
        
        //fix 管子 Y 值的算法, 避免一管占据全屏
        if (pipeSizeCount >= 1) {
            downPipeY = downPipeY - pipeSizeCount * _downPipeTexture.size.height * 3 /2  ;
        }
        //生成下面的管子
        SKSpriteNode *downPipe = [SKSpriteNode spriteNodeWithTexture:_downPipeTexture];
        [downPipe setScale:3.0];
        CGSize dSize                            = downPipe.size;
        downPipe.position                       = CGPointMake(0, downPipeY);
        downPipe.physicsBody                    = [SKPhysicsBody bodyWithRectangleOfSize:dSize];
        downPipe.physicsBody.dynamic            = NO;
        downPipe.physicsBody.categoryBitMask    = pipeCategory;
        downPipe.physicsBody.contactTestBitMask = birdCategory;
        [pipePair addChild:downPipe];
        
        //生成上面的管子
        SKSpriteNode *upperPipe = [SKSpriteNode spriteNodeWithTexture:_upperPipeTexture];
        [upperPipe setScale:3.0];
        CGFloat uY                               = downPipeY + downPipe.size.height + kPipeGap;
        CGSize uSize                             = upperPipe.size;
        upperPipe.position                       = CGPointMake(0, uY);
        upperPipe.physicsBody                    = [SKPhysicsBody bodyWithRectangleOfSize:uSize];
        upperPipe.physicsBody.dynamic            = NO;
        upperPipe.physicsBody.categoryBitMask    = pipeCategory;
        upperPipe.physicsBody.contactTestBitMask = birdCategory;
        [pipePair addChild:upperPipe];
        [pipePair runAction:_moveAndRemovePipes];
        
        //生成得分 node, 隐形, 紧贴在管子的右侧
        SKNode *scoreLine                        = [SKNode node];
        CGFloat scoreLineX                       = upperPipe.size.width + _bird.size.width/2;
        CGFloat scoreLineY                       = SCREEN_HEIGHT/2;
        CGSize sSize                             = CGSizeMake(upperPipe.size.width, SCREEN_HEIGHT);
        scoreLine.position                       = CGPointMake(scoreLineX, scoreLineY);
        scoreLine.physicsBody                    = [SKPhysicsBody bodyWithRectangleOfSize:sSize];
        scoreLine.physicsBody.dynamic            = NO;
        scoreLine.physicsBody.categoryBitMask    = scoreCategory;
        scoreLine.physicsBody.contactTestBitMask = birdCategory;
        [pipePair addChild:scoreLine];
        [_pipesNode addChild:pipePair];
    }
}


//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 碰撞判断

- (void) didBeginContact: (SKPhysicsContact *)contact {
    
    //如果游戏在运行
    if (_allMovingNodes.speed > 0)
    {
        //如果和得分 node 碰撞(即成功通过了管子)
        if ( (contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory )
        {
            SKAction *coinSoundAction = [SKAction playSoundFileNamed:@"pipe.mp3"
                                                   waitForCompletion:YES];
            SKAction *wait            = [SKAction waitForDuration:0.5];
            SKAction *sequence        = [SKAction sequence:@[coinSoundAction, wait]];
            [self runAction:sequence];
            
            _score ++;
            _scoreLabelNode.text = [NSString stringWithFormat:@"%ld",(long)_score];
            SKAction *fontBigger = [SKAction scaleTo:1.5 duration:0.1];
            SKAction *fontNormal = [SKAction scaleTo:1 duration:0];
            SKAction *fontChange = [SKAction sequence:@[fontBigger,fontNormal]];
            [_scoreLabelNode runAction:fontChange];
        }
        
        //如果是撞了地面或者管子, 进行游戏结束设置
        else
        {
            [_BGMPlayer stop];
            _gameOn = false;

            SKAction *contactSoundAction = [SKAction playSoundFileNamed:@"punch.mp3"
                                                      waitForCompletion:YES];
            SKAction *wait               = [SKAction waitForDuration:0.5];
            SKAction *sequence           = [SKAction sequence:@[contactSoundAction, wait]];
            [self runAction:sequence];

            _allMovingNodes.speed        = 0;
            _canRestart                  = YES;
            _gameOverNode                = [self createGameOverNode];
            [self addChild:_gameOverNode];
        }
    }
}


//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 游戏结束

//游戏失败后创建的 Label
- (SKLabelNode *) createGameOverNode {
    
    SKLabelNode *node = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    node.text         = @"Tap to restart";
    node.fontSize     = 50;
    node.position     = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    return node;
}

//复位游戏
- (void) restart {
    
    [self createBGM];
    [_pipesNode removeAllChildren];

    _allMovingNodes.speed      = 1;
    _canRestart                = NO;
    _score                     = 0;
    _scoreLabelNode.text       = [NSString stringWithFormat:@"%ld",(long)_score];
    _bird.position             = CGPointMake(SCREEN_WIDTH/4, SCREEN_HEIGHT/4*3);
    _bird.physicsBody.velocity = CGVectorMake(0, 0);
}

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - touchBegan设置

//开关引力: 游戏提示时,鸟不下坠. 游戏开始后,引力正常.
- (void) switchWorldGravity {
    
    if (_worldGravityOn == false) {
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.0);

    }else{
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    }
    _worldGravityOn = !_worldGravityOn;
}

//点击设置
- (void) touchesBegan: (NSSet<UITouch *> *)touches withEvent: (UIEvent *)event {
    
    //点击后鸟下坠速度归零, 给一个上升力
    if (_allMovingNodes.speed > 0) {
        _bird.physicsBody.velocity = CGVectorMake(0.0, 0.0);
        [_bird.physicsBody applyImpulse:CGVectorMake(0.0, 10.0)];
    }
    
    //如果是游戏结束状态, 移除所有已有 node, 重新开始游戏, 设置引力
    if (_canRestart == YES) {
        [_gameOverNode removeFromParent];
        [self restart];
        [self switchWorldGravity];
    }
    
    //如果是游戏提示状态, 移除提示, 开始游戏, 设置引力
    if (_gameOn == false) {
        [_guideNode removeFromParent];
        _gameOn = true;
        [self switchWorldGravity];
    }
}

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 小鸟微调

//调整鸟嘴方向
- (CGFloat) clamp: (CGFloat)min and: (CGFloat)max and: (CGFloat)value {
    
    if (value > max) {
        return max;
    
    }else if (value < min){
        return min;
    
    }else{
        return value;
    }
}

//调整tap 后鸟的速度
- (void) update: (CFTimeInterval)currentTime {
    
    CGFloat velocityDy = _bird.physicsBody.velocity.dy;
    _bird.zRotation    = [self clamp:-1 and:0.5 and:velocityDy * (velocityDy < 0? 0.003:0.001)];
}

@end
