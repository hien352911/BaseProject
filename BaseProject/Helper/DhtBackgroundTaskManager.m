//
//  DhtBackgroundTaskManager.m
//  KidTaxiLib
//
//  Created by Nguyen Van Dung on 9/13/16.
//  Copyright © 2016 Dht. All rights reserved.
//

#import "DhtBackgroundTaskManager.h"

@interface DhtBackgroundTaskManager()
@property (nonatomic, strong) NSMutableArray* bgTaskIdList;
@property (assign) UIBackgroundTaskIdentifier masterTaskId;
@end

@implementation DhtBackgroundTaskManager

+ (instancetype)sharedBackgroundTaskManager {
    static DhtBackgroundTaskManager* sharedBGTaskManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBGTaskManager = [[DhtBackgroundTaskManager alloc] init];
    });
    return sharedBGTaskManager;
}

- (id)init {
    self = [super init];
    if(self) {
        _bgTaskIdList = [NSMutableArray array];
        _masterTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

-(UIBackgroundTaskIdentifier)beginNewBackgroundTask {
    UIApplication* application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTaskId = UIBackgroundTaskInvalid;
    if([application respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)]){
        bgTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
            [self.bgTaskIdList removeObject:@(bgTaskId)];
            [application endBackgroundTask:bgTaskId];
            bgTaskId = UIBackgroundTaskInvalid;
            [self beginNewBackgroundTask];
        }];
        if ( self.masterTaskId == UIBackgroundTaskInvalid ) {
            self.masterTaskId = bgTaskId;
        } else {
            [self.bgTaskIdList addObject:@(bgTaskId)];
            [self endBackgroundTasks];
        }
    }
    
    return bgTaskId;
}

-(void)endBackgroundTasks {
    [self drainBGTaskList:NO];
}

-(void)endAllBackgroundTasks {
    [self drainBGTaskList:YES];
}

-(void)drainBGTaskList:(BOOL)all {
    //mark end of each of our background task
    UIApplication* application = [UIApplication sharedApplication];
    if([application respondsToSelector:@selector(endBackgroundTask:)]){
        NSUInteger count=self.bgTaskIdList.count;
        for ( NSUInteger i=(all?0:1); i<count; i++ ) {
            UIBackgroundTaskIdentifier bgTaskId = [[self.bgTaskIdList objectAtIndex:0] integerValue];
            [application endBackgroundTask:bgTaskId];
            [self.bgTaskIdList removeObjectAtIndex:0];
        }
        if ( self.bgTaskIdList.count > 0 ) {
        }
        if ( all ) {
            [application endBackgroundTask:self.masterTaskId];
            self.masterTaskId = UIBackgroundTaskInvalid;
        } else {
        }
    }
}

@end
