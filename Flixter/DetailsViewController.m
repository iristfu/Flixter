//
//  DetailsViewController.m
//  Flixter
//
//  Created by Iris Fu on 6/16/22.
//

#import "DetailsViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieReleaseDate;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsis;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTitle.text = self.detailsDict[@"original_title"];
    if ([self.detailsDict[@"poster_path"] isKindOfClass:[NSString class]]) {
         NSString *posterPath = self.detailsDict[@"poster_path"];
         NSString *posterBaseUrl = @"https://image.tmdb.org/t/p/w500";
         NSString *posterFullPath = [posterBaseUrl stringByAppendingString:posterPath];
         NSURL *posterURL = [NSURL URLWithString:posterFullPath];
         [self.movieImage setImageWithURL:posterURL];
     }
     else {
         self.movieImage = nil;
    }
    self.movieReleaseDate.text = [@"Release date: " stringByAppendingString:self.detailsDict[@"release_date"]];
    self.movieSynopsis.text = self.detailsDict[@"overview"];
}

@end
