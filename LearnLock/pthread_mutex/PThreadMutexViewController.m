//
//  PThreadMutexViewController.m
//  LearnLock
//
//  Created by xiaoniu on 2019/3/13.
//  Copyright © 2019 com.learn. All rights reserved.
//
#import "PThreadMutexViewController.h"
#include <sys/_pthread/_pthread_types.h>

@interface PThreadMutexViewController ()

@end

@implementation PThreadMutexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)threadSafe {
    __block  int total = 0;
    NSLock *lock = [NSLock new];
    
    pthread_mutexattr_t arrt;
    
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
