//
//  AppDelegate.h
//  DigiMeObj
//
//  Created by Daníel Sigurbjörnsson on 07/10/2017.
//  Copyright © 2017 Daníel Sigurbjörnsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

