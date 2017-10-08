//
//  Network.h
//  Watchbox
//
//  Created by Kristján Ingi Mikaelsson on 27/03/2015.
//  Copyright (c) 2015 Appollo x. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkResponse : NSObject

@property(strong, nonatomic) id error;
@property int status;
@property(strong, nonatomic) id body;
@property BOOL hasInternet;

@end

@interface Network : NSObject

@property BOOL isLoggingIn;
@property NSString* requestCompany;

-(void)path:(NSString *)path;
-(void)baseURL:(NSString *)baseURL;
-(void)params:(NSDictionary *)params;

-(void)get:(void (^)(NetworkResponse * response))callback;
-(void)post:(void (^)(NetworkResponse * response))callback;

@end

