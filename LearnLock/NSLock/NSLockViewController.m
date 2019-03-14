//
//  NSLockViewController.m
//  LearnLock
//
//  Created by xiaoniu on 2019/3/13.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "NSLockViewController.h"

@interface NSLockViewController ()

@end

@implementation NSLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self threadNotSafe];
}

- (void)threadNotSafe {
    __block  int total = 0;
    
    for (int i=0; i<3; i++) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            total++;
            NSLog(@"total=%d",total);
            total--;
            NSLog(@"total=%d",total);
        });
    }
    
//    2019-03-13 09:57:05.063271+0800 LearnLock[16661:8000427] total=1
//    2019-03-13 09:57:05.063271+0800 LearnLock[16661:8000428] total=2
//    2019-03-13 09:57:05.063303+0800 LearnLock[16661:8000426] total=3
//    2019-03-13 09:57:05.063819+0800 LearnLock[16661:8000427] total=2
//    2019-03-13 09:57:05.064076+0800 LearnLock[16661:8000426] total=1
//    2019-03-13 09:57:05.064209+0800 LearnLock[16661:8000428] total=0
//
//    在某一个时刻，total的值是不确定    
}

/**
 *  NSLock，lock 和 unlock调用必须在同一线程，重复调用 lock 会永久锁死线程。对未 lock 的线程进行 unlock也会出错
 */
- (void)threadSafe {
    __block  int total = 0;
    NSLock *lock = [NSLock new];
    
    for (int i=0; i<3; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [lock lock];
            total++;
            NSLog(@"total=%d",total);
            total--;
            NSLog(@"total=%d",total);
            [lock unlock];
        });
    }
}

@end
