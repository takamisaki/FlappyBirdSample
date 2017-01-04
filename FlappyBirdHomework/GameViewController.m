#import "GameViewController.h"
#import "GameScene.h"
#import "GameStartScene.h"

@implementation GameViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    [self loadStartScene];
}

//载入游戏初始界面, 设置场景 block 调用转场方法
- (void) loadStartScene {
    
    GameStartScene *startScene = (GameStartScene *)[SKScene nodeWithFileNamed:@"GameStartScene"];
    
    __weak typeof(self) weakSelf = self;
    startScene.block = ^(){
        [weakSelf transferToGameScene];
    };
    
    SKView *skView        = (SKView *)self.view;
    skView.showsFPS       = YES;
    skView.showsNodeCount = YES;
    
    [skView presentScene:startScene];
}

//转场至游戏进行界面(调用淡入淡出效果)
- (void) transferToGameScene {
    
    GameScene    *scene          = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    SKView       *skView         = (SKView *)self.view;
    SKTransition *fadeTransition = [SKTransition crossFadeWithDuration:1];
    
    [skView presentScene:scene transition:fadeTransition];
}


//隐藏顶部 Bar
- (BOOL) prefersStatusBarHidden {
    return YES;
}

@end
