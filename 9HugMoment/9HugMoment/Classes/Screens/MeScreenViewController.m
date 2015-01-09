//
//  MeScreenViewController.m
//  9HugMoment
//

#import "MeScreenViewController.h"

@interface MeScreenViewController ()

@end

@implementation MeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [[FBSession activeSession] closeAndClearTokenInformation];
    [APP_DELEGATE.session closeAndClearTokenInformation];
    [[UserData currentAccount] clearCached];
    self.tabBarController.selectedIndex = 2;
}

@end
