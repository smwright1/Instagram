//
//  DetailsViewController.m
//  Instagram
//
//  Created by Storm Wright on 7/9/21.
//

#import "DetailsViewController.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "DateTools/DateTools.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *user = self.post.author;
    if (user != nil) {
        self.authorLabel.text = user.username;
    }
    else {
        self.authorLabel.text = @"🤖";
    }
    
    NSString *likes = [NSString stringWithFormat:@"%@", self.post.likeCount];
    self.likeLabel.text = [likes stringByAppendingString:@" likes"];
    
    self.captionLabel.text = self.post.caption;
    
    self.imageView.file = self.post.image;
    [self.imageView loadInBackground];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSDate *date = self.post.createdAt;
    self.timestampLabel.text = [[date shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
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
