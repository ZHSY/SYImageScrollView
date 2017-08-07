//
//  SYTimerManager.h
//  SYIMageScrollView
//
//  Created by 夜雨 on 16/8/24.
//  Copyright © 2016年 zhsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYTimerManager : NSObject

+(instancetype)sharedManager;

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action;

- (void)cancelTimerWithName:(NSString *)timerName;



@end
