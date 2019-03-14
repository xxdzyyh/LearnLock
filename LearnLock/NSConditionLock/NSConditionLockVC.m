//
//  NSConditionLockVC.m
//  LearnLock
//
//  Created by xiaoniu on 2019/3/13.
//  Copyright © 2019 com.learn. All rights reserved.
//  
//  https://www.jianshu.com/p/ab5616da2715
//  NSConditionLock
//  
//  一般进行 lock 的时候，如果能成功，会直接 lock.
//  有那么一种场景，我的确想要 lock, 但是我需要在满足一定条件，才获取到 lock，不满足条件，我宁愿等。
//  这个时候可以使用 NSConditionLock
//   
//  创建条件锁，内置条件设置为0
//  [[NSConditionLock alloc] initWithCondition:0];
//  外界条件为1，如果内置条件为1,加锁成功，如果内置条件不为1，休眠 （休眠应该是可以被其他的操作唤醒）
//  [lock lockWhenCondition:1];
//


#import "NSConditionLockVC.h"

@interface NSConditionLockVC ()

@end

@implementation NSConditionLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:0];
    __block int i = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"i=%d,[lock lockWhenCondition:1];",i);
        // 外界传入条件为1，第一次执行，内置条件为0，无法获取锁，第二次执行，内置条件和外置条件都设置为1,可以获取锁
        [lock lockWhenCondition:1];
        NSLog(@"%d",i);
        [lock unlockWithCondition:0];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"i=%d,[lock lockWhenCondition:0];",i);
        [lock lockWhenCondition:0];
        NSLog(@"%d",i);
        i = 1;
        // 释放锁，同时将锁的内部条件设置为1
        [lock unlockWithCondition:1];
    });
}

@end
