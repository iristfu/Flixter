//
//  GridViewController.m
//  Flixter
//
//  Created by Iris Fu on 6/17/22.
//

#import "GridViewController.h"
#import "CustomCollectionViewCell.h"
#import "MovieViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) NSArray *movies;
@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gridView.dataSource = self;
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=6eae1b2c2fcc45bb59980b5fb824e222"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.movies = dataDictionary[@"results"];
               [self.gridView reloadData];
           }
    }];
    [task resume];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    if ([movie[@"poster_path"] isKindOfClass:[NSString class]]) {
         NSString *posterPath = movie[@"poster_path"];
         NSString *posterBaseUrl = @"https://image.tmdb.org/t/p/w500";
         NSString *posterFullPath = [posterBaseUrl stringByAppendingString:posterPath];
         NSURL *posterURL = [NSURL URLWithString:posterFullPath];
         [cell.movieImage setImageWithURL:posterURL];
     }
    else {
        cell.movieImage.image = nil;
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}


@end
