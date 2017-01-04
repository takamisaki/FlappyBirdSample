//游戏初始场景

typedef void(^GameStartSceneBlock)();

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

@interface GameStartScene : SKScene

/** 传给 controller 点击事件 */
@property (nonatomic, copy) GameStartSceneBlock block;

@end
