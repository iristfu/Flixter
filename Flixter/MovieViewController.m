//
//  MovieViewController.m
//  Flixter
//
//  Created by Iris Fu on 6/15/22.
//

#import "MovieViewController.h"
#import "DetailsViewController.h"
#import "customClassTableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface MovieViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@end

@implementation MovieViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMovies];
}

-(void) loadMovies {
    // Start the activity indicator
    [self.activityIndicator startAnimating];
    
    // Initialize a UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=6eae1b2c2fcc45bb59980b5fb824e222"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               [self showAlertError];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               
               // TODO: Get the array of movies
               self.movies = dataDictionary[@"results"];
//               for (NSString* movie in self.movies) {
//                   NSLog(@"%@", movie);
//               }
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               [self.tableView reloadData];

           }
        [self beginRefresh:refreshControl];
        // Stop the activity indicator
        // Hides automatically if "Hides When Stopped" is enabled
        [self.activityIndicator stopAnimating];
       }];
    [task resume];
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
         // Reload the tableView now that there is new data
          [self.tableView reloadData];

         // Tell the refreshControl to stop spinning
          [refreshControl endRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    customClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
//    NSLog(@"%@", self.movies);
    NSDictionary *movie = self.movies[indexPath.row];
//    NSLog(@"%@", movie);
    if ([movie[@"poster_path"] isKindOfClass:[NSString class]]) {
         NSString *posterPath = movie[@"poster_path"];
         NSString *posterBaseUrl = @"https://image.tmdb.org/t/p/w500";
         NSString *posterFullPath = [posterBaseUrl stringByAppendingString:posterPath];
         NSURL *posterURL = [NSURL URLWithString:posterFullPath];
         [cell.posterImage setImageWithURL:posterURL];
     }
     else {
         cell.posterImage.image = nil;
    }
    cell.titleLabel.text = movie[@"original_title"];
    cell.synopsisLabel.text = movie[@"overview"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}


- (void)showAlertError {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *buttonOk = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionTryAgain];
    }];
       
    [controller addAction:buttonOk];
    [self presentViewController:controller animated:YES completion:nil];
}
 
-(void) actionTryAgain {
    [self loadMovies];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    NSIndexPath *movieIndexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *movieData = self.movies[movieIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController]; // this line is needed so the next line is valid; need to set the segue
    detailVC.detailsDict = movieData;
}

@end

