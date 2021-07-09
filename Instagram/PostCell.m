//
//  PostCell.m
//  Instagram
//
//  Created by Storm Wright on 7/9/21.
//

#import "PostCell.h"
#import "Post.h"
#import <Parse/Parse.h>
#import "DateTools/DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPost:(Post *)post {
    _post = post;

    PFUser *user = post.author;
    if (user != nil) {
        self.authorLabel.text = user.username;
    }
    else {
        self.authorLabel.text = @"🤖";
    }

    NSString *likes = [NSString stringWithFormat:@"%@", post.likeCount];
    self.likeLabel.text = [likes stringByAppendingString:@" likes"];

    self.captionLabel.text = post.caption;

    self.imageView.file = post.image;
    [self.imageView loadInBackground];


    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSDate *date = self.post.createdAt;
    self.timestampLabel.text = [[date shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
}

@end
