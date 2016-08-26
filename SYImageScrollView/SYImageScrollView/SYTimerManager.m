//
//  SYTimerManager.m
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/24.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import "SYTimerManager.h"



@interface SYTimerManager()

@property (nonatomic, strong)NSMutableDictionary *timerContainer;

@end

@implementation SYTimerManager

+(instancetype)sharedManager
{
    static SYTimerManager *manager;
    
    if (!manager) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            manager = [[SYTimerManager alloc] init];
            manager.timerContainer = [[NSMutableDictionary alloc] init];
            
        });
        
    }
    
    return manager;
    
    
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action
{
    if (!timerName) {
        return;
    }
    
    if (!queue) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerContainer setObject:timer forKey:timerName];
    }
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1*NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        action();
        
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
        
    });
    
    
    
}

- (void)cancelTimerWithName:(NSString *)timerName
{
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    
    dispatch_source_cancel(timer);
    
    
}






@end
