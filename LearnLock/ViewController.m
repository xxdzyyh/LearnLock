//
//  ViewController.m
//  LearnLock
//
//  Created by xiaoniu on 2018/7/23.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "ViewController.h"
#import "NSLock/NSLockViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSString *name;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.dataSources = @[@{@"type":@"Method",@"className":@"synchronized",@"desc":@"@synchronized"},
                         @{@"type":@"Method",@"className":@"nslock",@"desc":@"@synchronized"},
                         @{@"type":@"Method",@"className":@"syncMain",@"desc":@"主线程同步"},
                         @{@"type":@"Method",@"className":@"syncBackground",@"desc":@"非主线程同步"},
                         @{@"type":@"Method",@"className":@"asyncMain",@"desc":@"主线程异步"},
                         @{@"type":@"Method",@"className":@"asyncBackground",@"desc":@"非主线程异步"},
                         @{@"type":@"VC",@"className":@"NSLockViewController",@"desc":@"NSLock"},
                         @{@"type":@"VC",@"className":@"NSConditionLockVC",@"desc":@"NSConditionLock"},
                         @{@"type":@"VC",@"className":@"NSContiditionVC",@"desc":@"NSCondition"},
                         @{@"type":@"VC",@"className":@"DispatchSemaphoreVC",@"desc":@"semaphore"},];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataSources[indexPath.row];
    NSString *type = dict[@"type"];
    NSString *className = dict[@"className"];
    
    if ([type isEqualToString:@"Method"]) {
        [self performSelector:NSSelectorFromString(className)];
    } else if ([type isEqualToString:@"VC"]) {
        
        [self.navigationController pushViewController:[NSClassFromString(className) new] animated:YES];
    }
    
}

- (void)synchronized {
    @synchronized(self) {
        
    }
}

- (void)nslock {
    
}

- (void)syncMain {
    NSLog(@"1. %s , %@",__func__,[NSThread currentThread]);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2. %s , %@",__func__,[NSThread currentThread]);
    });
    
    NSLog(@"3. %s , %@",__func__,[NSThread currentThread]);
}

- (void)syncBackground {
    /**
     * sysc不会开启新的线程，会在当前线程立即执行
     * async可以开启新的线程，
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1. %s , %@",__func__,[NSThread currentThread]);
        
        dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_sync(queue, ^{
            NSLog(@"2. %s , %@",__func__,[NSThread currentThread]);
        });
        
        NSLog(@"3. %s , %@",__func__,[NSThread currentThread]);
    });
}

- (void)asyncMain {
    NSLog(@"1. %s , %@",__func__,[NSThread currentThread]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"2. %s , %@",__func__,[NSThread currentThread]);
    });
    
    NSLog(@"3. %s , %@",__func__,[NSThread currentThread]);
}

- (void)asyncBackground {
    /**
     *
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1. %s , %@",__func__,[NSThread currentThread]);
        
        dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_async(queue, ^{
            NSLog(@"2. %s , %@",__func__,[NSThread currentThread]);
        });
        
        NSLog(@"3. %s , %@",__func__,[NSThread currentThread]);
    });
}


@end
