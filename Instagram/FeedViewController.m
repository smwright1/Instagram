//
//  FeedViewController.m
//  Instagram
//
//  Created by Storm Wright on 7/8/21.
//

#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LogInViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        
    }];
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInViewController *logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
    sceneDelegate.window.rootViewController = logInViewController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
