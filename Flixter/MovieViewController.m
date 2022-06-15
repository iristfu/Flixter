//
//  MovieViewController.m
//  Flixter
//
//  Created by Iris Fu on 6/15/22.
//

#import "MovieViewController.h"

@interface MovieViewController ()
@property (nonatomic, strong) NSArray *movies;
  //remember when a property is set, you must call it with self.myArray

@end

@implementation MovieViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=6eae1b2c2fcc45bb59980b5fb824e222"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
               
               // TODO: Get the array of movies
               self.movies = dataDictionary[@"results"];
               for (NSString* movie in self.movies) {
                   NSLog(@"%@", movie);
               }
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               
           }
       }];
    [task resume];
    
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
