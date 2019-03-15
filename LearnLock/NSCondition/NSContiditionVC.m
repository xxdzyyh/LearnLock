//
//  NSContiditionVC.m
//  LearnLock
//
//  Created by xiaoniu on 2019/3/14.
//  Copyright © 2019 com.learn. All rights reserved.
//

#import "NSContiditionVC.h"

@interface NSContiditionVC ()

@end

@implementation NSContiditionVC

/**
A condition object acts as both a lock and a checkpoint in a given thread. 
The lock protects your code while it tests the condition and performs the task triggered by the condition.
The checkpoint behavior requires that the condition be true before the thread proceeds with its task. 
While the condition is not true, the thread blocks. 
It remains blocked until another thread signals the condition object.

 The semantics for using an NSCondition object are as follows:
Lock the condition object.
Test a boolean predicate. (This predicate is a boolean flag or other variable in your code that indicates whether it is safe to perform the task protected by the condition.)
If the boolean predicate is false, call the condition object’s wait or waitUntilDate: method to block the thread. 
 Upon returning from these methods, go to step 2 to retest your boolean predicate. (Continue waiting and retesting the predicate until it is true.)
If the boolean predicate is true, perform the task.
Optionally update any predicates (or signal any conditions) affected by your task.
When your task is done, unlock the condition object.
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    __block int a = 0;
    NSLog(@"a=0");
    NSCondition *cond = [NSCondition new];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"a=1");
        a = 1;
        
        // 随机唤醒1个在等待 condition 的线程，可以多次调用，唤醒多个线程
        [cond signal];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"a=2");
        a = 2;
        // 唤醒所有在等待 condition 的线程
        [cond broadcast];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cond lock];
        NSLog(@"等待条件 1");
        while (a != 1) {
            [cond wait];
        }
        NSLog(@"条件获得 1");
        [cond unlock];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cond lock];
        NSLog(@"等待条件 2");
        while (a != 2) {
            [cond wait];
        }
        NSLog(@"条件获得 2");
        [cond unlock];
    });   
}

@end
