//
//  ViewController.m
//  DigiMeHack
//
//  Created by Daníel Sigurbjörnsson on 07/10/2017.
//  Copyright © 2017 Daníel Sigurbjörnsson. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Chameleon.h"
#import "FlatUIKit.h"
#import "MBCircularProgressBarView.h"
#import "listViewController.h"

@interface ViewController (){
    NSString* kAppID;
    NSString* kContractID1;
    NSString* kContractID2;
    NSString* kP12FileName1;
    NSString* kP12FileName2;
    NSString* kP12Password;
    
    NSDictionary* data;
    NSArray* dataEntries;
    
    NSMutableArray* userVacs;
    
    FUIButton* getDigiMeData;
    BOOL showingcountries;
}
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressCircle;
@property (weak, nonatomic) IBOutlet UILabel *WelcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *InfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *gettingData;
@property (weak, nonatomic) IBOutlet UILabel *startingInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.view.bounds andColors:@[[UIColor flatOrangeColor], [UIColor flatYellowColorDark]]];
    _InfoLabel.hidden = YES;
    
    //setup constants....
    kAppID  = @"dannihack";
    kContractID1 = @"DxTyYh4JMhCCngwTHiHnqoJs6ObHBbr4"; // 3 months
    kContractID2 = @"apm6txyF3f7jwevEQDnm5XYWTrqNblgi"; // 2 years
    kP12FileName1 = @"CA_RSA_PRIVATE_KEY1";
    kP12FileName2 = @"CA_RSA_PRIVATE_KEY2";
    kP12Password = @"digime";

    NSString* path = [[NSBundle mainBundle] pathForResource:@"key"
                                                    ofType:@"txt"];
    NSString* content = [[NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [DigiMeFramework sharedInstance].delegate = self;
    
    UIButton* sendstuff = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [sendstuff addTarget:self action:@selector(sendTheStuff) forControlEvents:UIControlEventTouchUpInside];
    [sendstuff setBackgroundColor:[UIColor redColor]];
    
    getDigiMeData = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 75)];
    [getDigiMeData addTarget:self action:@selector(getDigiMeData) forControlEvents:UIControlEventTouchUpInside];
    [getDigiMeData setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height*0.65)];
    [getDigiMeData setTitle:@"VAX ME" forState:UIControlStateNormal];
    getDigiMeData.buttonColor = [UIColor flatGreenColor];
    getDigiMeData.shadowColor = [UIColor flatGreenColorDark];
    getDigiMeData.shadowHeight = 3.0f;
    getDigiMeData.cornerRadius = 6.0f;
    getDigiMeData.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [getDigiMeData setClipsToBounds:YES];
    [getDigiMeData setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [getDigiMeData setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    //press state events for continueButton
    [getDigiMeData addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [getDigiMeData addTarget:self action:@selector(buttonReleaseInside:) forControlEvents:UIControlEventTouchUpInside];
    [getDigiMeData addTarget:self action:@selector(buttonReleaseOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    UIButton* logStuff = [[UIButton alloc] initWithFrame:CGRectMake(250, 250, 100, 100)];
    [logStuff addTarget:self action:@selector(processDigiMeData) forControlEvents:UIControlEventTouchUpInside];
    [logStuff setBackgroundColor:[UIColor blueColor]];
    
    //[self.view addSubview:sendstuff];
    [self.view addSubview:getDigiMeData];
    //[self.view addSubview:logStuff];
    
    [self.progressCircle setCenter:getDigiMeData.center];
    self.progressCircle.value = 0.0;
    self.progressCircle.backgroundColor = [UIColor clearColor];
    self.progressCircle.hidden = YES;
    
    [_InfoLabel setCenter:getDigiMeData.center];
    
    _gettingData.hidden = YES;
}

-(void)setupViews{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(showingcountries){
        return;
    }
}

-(void)sendTheStuff{
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary* params = @{
                             @"data":userVacs
                             };
    NSLog(@"data to be sent: %@", params);
    if(userVacs){
        [manager POST:@"http://130.208.244.92:8282" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"operation.responseObjetc: %@", operation.responseObject);
            _InfoLabel.text = @"GOT DATA!";
            _gettingData.hidden = YES;
            
            [self handleResponse:operation.responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error in request: %@", error);
        }];
    }else{
        NSLog(@"ERROR: no data retrieved from digi.me");
    }
}

-(void)handleResponse:(id)response{
    listViewController *show = [[listViewController alloc] init];
    show.data = response;
    
    [self presentViewController:show animated:YES completion:nil];
}

-(void)getDigiMeData{

//    listViewController *show = [[listViewController alloc] init];
//    [self presentViewController:show animated:YES completion:nil];
//    showingcountries = YES;
//
//    return;
    //hide button
    getDigiMeData.hidden = YES;
    _startingInfo.hidden = YES;
    _gettingData.hidden = NO;
    
    [[DigiMeFramework sharedInstance] digimeFrameworkInitiateDataRequestWithAppID:kAppID contractID:kContractID1 rsaPrivateKeyHex:@"308204a50201000282010100bf398b09f4c2f78d0c89410143fa50916dd9c580fadcedf3ce455eda9b5f0035199c6583b318b488d4b6e2ea816c201825c9e8ecce4c1c5d1dfa5eb3b7d849e35b2630a856c7a39c5b8a77c490d1f21c15046e855f8b09a8d02166f508cafa9f7e7a33c50ad9d68e8361dec4cee2a85afe4ce012527aba0161c6752058444cece62d5451b6b9a703ec685c0023ed1b1684bc12861b77c7dc16e21e5ba86c50a2b630a571f99d91d89d752ce74015b7a346e318804ca60ae6f7844f9d2b0ef428ac8d2ba35ced54fd7b889e4a29d38abd5a71b5b3d1e1c0f221243a193b8b066cd2cbd54deaaed22d886e134ed20481ccc07f720cb33d34867c4ca80edf9504d102030100010282010100a4178ef67630b0193b7eb4678f9bc773645e919b02aa7f0ece1cbd2ebe51216e6f91c392e626f714cbe43c889b92db5f9d5dcc21194e3ab0b53ed9f1427bb9bbfdc5a1cf72d851cfa4c607cc87b1811f13f1ff9d37c5a9fe50cbb8fbe015be470b5376054a30706b4ed6b7410f7f7494d0cfcb202de2dea6bcee7e27c956a2e2d34e37cb07a1623a0b9498a0b72fc4ef89fd51cb3ccb0f0e06f18efb0a0306181e959076f24fd6515a2984c23db22c482ad153f5a5ee775fc517f40683031a1e9d9bd09061b7ed07148ea1c2376b2c8eaa64b23e27ef8bddf4eaab57f702863316a2ed04925c75fa493450b4b31baed50c44f33e9e7270e85615d72c4ab8f82102818100dea97bf32303e78a7ebc38eb779303ece0cc16daceff111f76530200b939d003ee64a0d75aaa7b1809960e10a0dfb13c98d77b0ecef670de6fe1e83d73c3421fa3c56255f970476723f36b0238f8e58ed9f167148061be3244a7697f16f28222be38dd5e97089cd741ac3ebffbcf0c5d31775a9dcfa4d3358dee573a407f077d02818100dbdb15dcc5be9b6100b84ef04b39fac2c4a9ba2bd676464ba2a9fa3d3b686f5cd5fde519ebbfacbf3f08f581ad9100c5ee85fb05452f5abfcb65dfcd39ab48b5e31fa65c10316e348763dd088d627f68c15364b48569d0d0bca115ac2ae71930936776159f278cb723aabe17e69a8ae41646237d316e570d5d56994a3d153ae502818100aabb327bc081a1ed2438973c9637786f0dfff0165f5a5d7ace73dfb9464dfa1ec991077399e5d6f51b849fcc484ebdcc453614f9c9e055b379feb2e14bfe90994a2e73b490cb7334b6f053412506549f30a655eff670fc31f74a972e081e7382c87139ece9ca84d8d95685d717f22efcd68d3a427f9157125d7e400c3ea028d1028181008e4839dcd7c8a42be1d86595d34961849cdbaed56204c73779bd016a9140e41933900dad79c961159fc8bf81bdff027e1600755492d2b3ab3e09df0da4cdb9cfa47e3e1e848848e70bdbd01711d0f5dda887bcbbab3fb0d8f5ca560946f6aa71aa63a1a31a8df0de30e1f605e7c28a32544bedf9be7cc72faa013a513638c01502818019244f4ae5f0dcc0bbf73a8400d5fbc024e7d99812ca6a2fd967ac200c39e7ae0e771d8988d64b405e939e03c8843141c89d62551882a39e63c49a24c45893d52e333ed9c6f250316b3d2ddf1ccb3a75ecfa8aa2a6df14e1e6d1f904ba8d32ae2334903c6ba73753f65fbe27b9dfdc569f26dd4a06653a4dfdd67ea2aa58d011"];
}

-(void)processDigiMeData{
    
    _progressCircle.hidden = YES;
    _InfoLabel.hidden = NO;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        _InfoLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:nil];
    
    userVacs = [[NSMutableArray alloc] initWithArray:@[]];
    for(NSString* i in data){
        NSArray* dataFromEntry = data[i];
        id firstObject = dataFromEntry[0];
        if([[[firstObject objectForKey:@"code"] substringToIndex:3] isEqualToString:@"J07"]){
            //will get all objects from json
            NSLog(@"dataFromEntry: %@", dataFromEntry);
            for(id object in dataFromEntry){
                NSString* codename = [object objectForKey:@"codename"];
                NSString* codes = [object objectForKey:@"codes"];
                [userVacs addObject:@{@"codename": codename, @"codes":codes}];
            }
        }
    }
    
    //data ready, call backend
    [self sendTheStuff];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)digimeFrameworkLogWithMessage:(NSString *)message{
    NSLog(@"log message: %@", message);
}

-(void)digimeFrameworkDidChangeOperationState:(DigiMeFrameworkOperationState)state{
    NSLog(@"state did change: %ld", state);
    if(state == 5){
        _progressCircle.hidden = NO;
    }
    
}

-(void)digimeFrameworkJsonFilesDownloadProgress:(float)progress{
    NSLog(@"Download process: %f", progress);
    CGFloat progress2 = progress;
    [UIView animateWithDuration:1.f animations:^{
        self.progressCircle.value = progress2*100;
    }];
}

-(void)digimeFrameworkReceiveDataWithFileNames:(NSArray<NSString *> *)fileNames filesWithContent:(NSDictionary *)filesWithContent error:(NSError *)error{
    
    data = filesWithContent;
    dataEntries = fileNames;
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [self processDigiMeData];
    });
}

// Scale up on button press
- (void) buttonPress:(UIButton*)button {
    button.transform = CGAffineTransformMakeScale(0.9, 0.9);
}
- (void) buttonReleaseInside:(UIButton*)button {
    button.transform = CGAffineTransformMakeScale(1.0, 1.0);
}
- (void) buttonReleaseOutside:(UIButton*)button {
    button.transform = CGAffineTransformMakeScale(1.0, 1.0);
}


@end

