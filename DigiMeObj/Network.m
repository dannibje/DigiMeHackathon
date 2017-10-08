//
//  Network.m
//  Watchbox
//
//  Created by Kristján Ingi Mikaelsson on 27/03/2015.
//  Copyright (c) 2015 Appollo x. All rights reserved.
//

#import "Network.h"
#import "AFNetworking.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "Appdelegate.h"

@implementation NetworkResponse

@end

@interface Network()

@property (strong,nonatomic) NSString * path;
@property (strong,nonatomic) NSString * baseURL;
@property (strong,nonatomic) NSString * url;
@property (strong,nonatomic) NSString * signature;
@property (strong,nonatomic) NSDictionary * givenParams;
@property (strong,nonatomic) NSMutableDictionary * params;
@property (strong,nonatomic) NetworkResponse * response;
@property (strong,nonatomic) AFHTTPRequestOperationManager * manager;

@end

@implementation Network

- (instancetype)init
{
    self = [super init];
    if (self) {
        //sup
    }
    return self;
}

-(void)path:(NSString *)path{
    _path = path;
}

-(void)baseURL:(NSString *)baseURL{
    _baseURL = baseURL;
}

-(void)params:(NSDictionary *)params{
    _givenParams = params;
}

-(void)get:(void (^)(NetworkResponse * response))callback{
    
    [self setupWithVerb:@"GET"];
    
    if(!_response.hasInternet){
        return callback(_response);
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [_manager GET:_url parameters:_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //NSLog(@"JSON from %@ %@",_path, operation.responseObject);
        NSLog(@"Network success %@",_path);
        
        _response.status = operation.response.statusCode;
        _response.body = operation.responseObject;
        
        return callback(_response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"JSON error from %@ %@",_path, operation.responseObject);
        
        _response.error = operation.responseObject && [operation.responseObject objectForKey:@"error"] ? [operation.responseObject objectForKey:@"error"] : error;
        _response.status = operation.response.statusCode;
        _response.body = operation.responseObject;
        
        if(!_response.error){
            _response.error = @"Error without a description";
        }
        
        return callback(_response);
    }];
}

-(void)post:(void (^)(NetworkResponse * response))callback{
    
    [self setupWithVerb:@"POST"];
    
    if(_isLoggingIn && !_response.hasInternet){
        _response.error = @"NO INTERNET";
        return callback(_response);
    }
    
    if(!_response.hasInternet){
        _response.error = @"NO INTERNET";
        return callback(_response);
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [_manager POST:_url parameters:_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //NSLog(@"JSON from %@ %@",_path, operation.responseObject);
        NSLog(@"Network success %@",_path);
        
        _response.status = operation.response.statusCode;
        _response.body = operation.responseObject;
        
        return callback(_response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"JSON error from %@ %@",_path, operation.responseObject);
        
        _response.error = operation.responseObject && [operation.responseObject objectForKey:@"error"] ? [operation.responseObject objectForKey:@"error"] : error;
        _response.status = (int)operation.response.statusCode;
        _response.body = operation.responseObject;
        
        return callback(_response);
    }];
}

-(void)setupWithVerb:(NSString *)verb{
    _response = [[NetworkResponse alloc]init];
    
    if(!_response.hasInternet){
        _response.error = @"ERROR"; //Swap out for something cool
    }
    
    if(!_path){
        _path = @"";
    }
    
    if(!_baseURL){
        _baseURL = @"130.244.204.125:8282";
    }
    
    _manager = [AFHTTPRequestOperationManager manager];
    
    //[_manager.requestSerializer setValue:companyId forHTTPHeaderField:@"Workbox-Company"];
    
    _params = [[NSMutableDictionary alloc]initWithDictionary:_givenParams];
    //[_params addEntriesFromDictionary:@{@"apiKey":[Utils apiKey]}];
    
    _url = ![_path isEqualToString:@""] ? [NSString stringWithFormat:@"%@%@",_baseURL,_path] : _baseURL;
    
    //MBY /r works
    NSMutableString * toHash = [NSMutableString stringWithFormat:@"%@\n%@\n%@\n",verb,@"suup",_path];
    
    NSMutableArray * unsortedKeys = [[NSMutableArray alloc]init];
    
    for (NSString* key in _params) {
        [unsortedKeys addObject:key];
    }
    
    int index = 0;
    NSArray *keys = [unsortedKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString * key in keys) {
        if(index != 0){
            [toHash appendString:@"&"];
        }
        
        NSString * value = [self URLEncodeStringFromString:[_params objectForKey:key]];
        [toHash appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        index++;
    }
    
    _signature = @"suuup";
    
    [_params addEntriesFromDictionary:@{@"signature":_signature}];
    
    //    NSLog(@"URL IS %@",_url);
    //    NSLog(@"PARAMS %@",_params);
    //    NSLog(@"TOHASH \n%@",toHash);
    //    NSLog(@"KEYS %@",keys);
    //    NSLog(@"SECRETKEY : %@",[Utils secretKey]);
    //    NSLog(@"HASH: %@",_signature);
}

- (NSString *)URLEncodeStringFromString:(NSString *)string{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

@end

