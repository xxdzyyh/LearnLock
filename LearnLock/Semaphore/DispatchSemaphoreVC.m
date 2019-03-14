//
//  DispatchSemaphoreVC.m
//  LearnLock
//
//  Created by xiaoniu on 2019/3/14.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "DispatchSemaphoreVC.h"

@interface DispatchSemaphoreVC ()

@end

@implementation DispatchSemaphoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test];
}

- (void)test {
    
    // 设定一个信号，当前可用为0
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"semaphore = 0 无法执行");
        // 如果 semaphore > 0 ,wait 会使 semaphore - 1，否则会阻塞当前线程，所以不要主线程 wait
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        NSLog(@"Run Task 1 Start");
        sleep(1);
        NSLog(@"Run Task 1 End");
        dispatch_semaphore_signal(semaphore);
    });
    
    NSLog(@"semaphore 即将+1");
    // semaphore + 1
    dispatch_semaphore_signal(semaphore);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"semaphore = 0 无法执行");
        // 如果 semaphore > 0 ,wait 会使 semaphore - 1，否则会阻塞当前线程，所以不要主线程 wait
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"Run Task 2 Start");
        sleep(1);
        NSLog(@"Run Task 2 End");
        dispatch_semaphore_signal(semaphore);
    });
    
}

@end
