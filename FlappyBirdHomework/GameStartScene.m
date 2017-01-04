#import "GameStartScene.h"
#import "ButtonNode.h"

@interface GameStartScene ()
{
    ButtonNode  *_startButtonNode;  //开始按钮
    SKNode      *_backgroundNode;   //包含所有的除了开始按钮的 Nodes
    LNPlayer    *_BGMPlayer;        //背景音乐
}

@end

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

@implementation GameStartScene

//场景显示后的配置
- (void) didMoveToView: (SKView *)view {
    
    self.scaleMode  = SKSceneScaleModeAspectFill;

    _backgroundNode = [SKNode node];
    [self addChild:_backgroundNode];
    
    [self createStartButton];
    [self createLabelNodeOn: _backgroundNode];
    [self createBird];
    [self createGroundOn:_backgroundNode];
    [self createSkyOn:_backgroundNode];
    [self createBGM];
}

//创建背景音乐
- (void) createBGM {
    
    _BGMPlayer = [LNPlayer createPlayer];
    [_BGMPlayer play];
}

//创建开始按钮
- (void) createStartButton {
    
    _startButtonNode             = [[ButtonNode alloc] initWithImageNamed:@"start"];
    _startButtonNode.position    = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/4);
    
    __weak typeof(self) weakSelf = self;
    _startButtonNode.block       = ^(){
        [weakSelf startClicked];
    };
    
    [self addChild:_startButtonNode];
}

//创建游戏题目
- (void) createLabelNodeOn: (SKNode *)fatherNode {
    
    SKLabelNode *labelNode = [[SKLabelNode alloc]initWithFontNamed:@"Chalkduster"];
    labelNode.text         = @"FLAPPY BIRD";
    labelNode.fontSize     = 45;
    labelNode.position     = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3*2);
    [fatherNode addChild:labelNode];
}

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
#pragma mark - 主体

/* 创建鸟
    1. 创建鸟
    2. 创建鸟的Action并运行
    3. 作为 Child 添加到背景 Node 里
 */
- (void) createBird {
    
    LNBirdNode *bird = [LNBirdNode birdNode];
    bird.position    = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    SKAction    *flap    = [bird flapAction];
    SKAction    *upDown  = [bird upDownAction];
    SKAction    *actions = [SKAction group:@[flap,upDown]];
    [bird runAction:actions];

    [_backgroundNode addChild:bird];
}

//创建连续地面
- (void) createGroundOn: (SKNode *) fatherNode {
    
    LNConnectedNode *connectedGroundNode = [LNConnectedNode createConnectedGroundNode];
    [fatherNode addChild:connectedGroundNode];
}

//创建连续天空
- (void) createSkyOn: (SKNode *) fatherNode {
    
    LNConnectedNode *connectedSkyNode = [LNConnectedNode createConnectedSkyNode];
    [fatherNode addChild:connectedSkyNode];
}

/* 点击"Start"按钮调用的方法
    1. 停止所有Node 的运动 和 BGM
    2. 传递点击消息给 Controller
*/
- (void) startClicked {
    
    _backgroundNode.speed = 0;
    
    [_BGMPlayer stop];
    
    if (self.block) {
        self.block();
    }
}

@end
