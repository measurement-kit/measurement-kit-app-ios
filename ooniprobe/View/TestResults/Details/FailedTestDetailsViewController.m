#import "FailedTestDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FailedTestDetailsViewController ()

@end

@implementation FailedTestDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:self.measurement.url_id.url];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHexString:color_yellow5 alpha:1.0f]];
    [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow5 alpha:1.0f]];
    [self.statusImage setImage:[UIImage imageNamed:@"help"]];
    [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Failed.Title", nil)];
    [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Failed.Paragraph", nil)];
    [self.tryAgainButton setTitle:NSLocalizedString(@"TestResults.Details.Failed.TryAgain", nil) forState:UIControlStateNormal];
    self.tryAgainButton.layer.cornerRadius = self.tryAgainButton.bounds.size.height/2;
    self.tryAgainButton.layer.masksToBounds = YES;
    self.tryAgainButton.layer.borderWidth = 0.5f;
    self.tryAgainButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


@end