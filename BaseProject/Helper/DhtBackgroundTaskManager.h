//
//  DhtBackgroundTaskManager.h
//  KidTaxiLib
//
//  Created by Nguyen Van Dung on 9/13/16.
//  Copyright © 2016 Dht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DhtBackgroundTaskManager : NSObject
+(instancetype)sharedBackgroundTaskManager;
-(UIBackgroundTaskIdentifier)beginNewBackgroundTask;
-(void)endAllBackgroundTasks;
@end
