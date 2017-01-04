//提供本项目用到的类似按钮功能的 Node(因为 SpriteKit 并没有提供 ButtonNode)

#import <SpriteKit/SpriteKit.h>

/** 本 Node 被点击的时候传递事件 */
typedef void(^ButtonNodeBlock)();

//➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

@interface ButtonNode : SKSpriteNode

/** 当点击时传递 */
@property (nonatomic, strong) ButtonNodeBlock block;

@end
