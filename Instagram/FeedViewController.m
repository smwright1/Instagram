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
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfPosts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
    [self.refreshControl setTintColor:[UIColor lightGrayColor]];
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Instagram Script Logo"]];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    titleImageView.frame = CGRectMake((-1 * titleImageView.frame.size.width)/2, (-1 * titleImageView.frame.size.height) / 2,titleImageView.frame.size.width , titleImageView.frame.size.height);
    [backView addSubview:titleImageView];
    self.navigationItem.titleView = backView;
    
    [self fetchPosts];
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
            NSLog(@"Feed loaded successfully");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)logOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        
    }];
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInViewController *logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
    sceneDelegate.window.rootViewController = logInViewController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post =self.arrayOfPosts[indexPath.row];
    cell.post = post;
    
    return cell;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:self.arrayOfPosts
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
            [self.tableView reloadData];

            [refreshControl endRefreshing];

        }];
    
        [task resume];
}

- (void)clickPost: (Post *) post{
    [self performSegueWithIdentifier:@"DetailsSegue" sender:post];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailsViewSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.arrayOfPosts[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}

@end
