#import "TestDetailsViewController.h"
#import "TestDetailsFooterViewController.h"
#import "Tests.h"
#import "TestRunningViewController.h"
#import "UploadFooterViewController.h"
#import "ReachabilityManager.h"
#import "ThirdPartyServices.h"
#import "RunningTest.h"

@interface TestDetailsViewController ()

@end

@implementation TestDetailsViewController
@synthesize result, measurement;

- (void)viewDidLoad {
    [super viewDidLoad];
    [NavigationBarUtility setNavigationBar:self.navigationController.navigationBar color:[TestUtility getBackgroundColorForTest:result.test_group_name]];
    self.navigationController.navigationBar.topItem.title = @"";
    self.title = [LocalizationUtility getNameForTest:measurement.test_name];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFooter) name:@"uploadFinished" object:nil];
    self.scrollView.alwaysBounceVertical = NO;

    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(advancedScreens)];
    //assign button to navigationbar
    self.navigationItem.rightBarButtonItem = moreButton;
    [self reloadFooter];
    isInExplorer = ![self.measurement hasReportFile];
    if ([self.measurement hasReportFile]){
        [self.measurement checkPublished:^(BOOL found){
            isInExplorer = found;
            if (found && self.measurement.report_id != NULL)
                [TestUtility deleteMeasurementWithReportId:self.measurement.report_id];
        } onError:^(NSError *error) {
            isInExplorer = FALSE;
        }];
    }
}


- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (!parent) {
        [NavigationBarUtility setBarTintColor:self.navigationController.navigationBar
                                        color:[TestUtility getBackgroundColorForTest:result.test_group_name]];
    }
}

- (void)advancedScreens{
    UIAlertAction* rawDataButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"TestResults.Details.RawData", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
        if ([[ReachabilityManager sharedManager] noInternetAccess] && isInExplorer){
                [MessageUtility
                 alertWithTitle:NSLocalizedString(@"Modal.Error", nil)
                 message:NSLocalizedString(@"Modal.Error.RawDataNoInternet", nil) inView:self];
                return;
            }
            [self rawData];
        }];
    
    UIAlertAction* logButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"TestResults.Details.ViewLog", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
        [self viewLogs];
    }];
    
    UIAlertAction* shareExplorerURLButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"TestResults.Details.ShareExplorerURL", nil)
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
        [self shareExplorerUrl];
    }];

    UIAlertAction* copyExplorerURLButton = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"TestResults.Details.CopyExplorerURL", nil)
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
        [self copyExplorerUrl];
    }];

    NSMutableArray *buttons = [NSMutableArray new];
    [buttons addObject:rawDataButton];
    if ([self.measurement hasLogFile])
        [buttons addObject:logButton];
    if (self.measurement.report_id != NULL && ![self.measurement.report_id isEqualToString:@""]){
        [buttons addObject:shareExplorerURLButton];
        [buttons addObject:copyExplorerURLButton];
    }
    [MessageUtility alertWithTitle:nil message:nil buttons:buttons inView:self];
}

- (IBAction)viewLogs{
    segueType = @"log";
    [self performSegueWithIdentifier:@"toViewLog" sender:self];
}

- (IBAction)rawData{
    segueType = @"json";
    [self performSegueWithIdentifier:@"toViewLog" sender:self];
}

-(NSString*)getExplorerUrl{
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://explorer.ooni.io/measurement/%@", self.measurement.report_id];
    if ([self.measurement.test_name isEqualToString:@"web_connectivity"])
        [url appendFormat:@"?input=%@", self.measurement.url_id.url];
    return url;
}

-(IBAction)copyExplorerUrl{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self getExplorerUrl];
    [MessageUtility showToast:NSLocalizedString(@"Toast.CopiedToClipboard", nil) inView:self.view];
}

-(IBAction)shareExplorerUrl{
    NSURL *url = [NSURL URLWithString:[self getExplorerUrl]];
    NSArray* dataToShare = @[url];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    if ( [activityViewController respondsToSelector:@selector(popoverPresentationController)] )
    {
        activityViewController.popoverPresentationController.sourceView = self.view;
        activityViewController.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

#pragma mark - Navigation

-(void)reloadFooter{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.measurement.is_uploaded || self.measurement.is_failed){
            self.scrollViewFooterConstraint.constant = -45;
            [self.scrollView setNeedsUpdateConstraints];
        }
        else {
            self.scrollViewFooterConstraint.constant = 0;
            [self.scrollView setNeedsUpdateConstraints];
        }
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toViewLog"]){
        LogViewController *vc = (LogViewController *)segue.destinationViewController;
        [vc setType:segueType];
        [vc setMeasurement:measurement];
    }
    else if ([[segue identifier] isEqualToString:@"footer"]){
        TestDetailsFooterViewController *vc = (TestDetailsFooterViewController * )segue.destinationViewController;
        [vc setResult:result];
        [vc setMeasurement:measurement];
    }
    else if ([[segue identifier] isEqualToString:@"toTestRun"]){
        NSString *testSuiteName = self.measurement.result_id.test_group_name;
        AbstractSuite *testSuite = [[AbstractSuite alloc] initSuite:testSuiteName];
        AbstractTest *test = [[AbstractTest alloc] initTest:self.measurement.test_name];
        [testSuite setTestList:[NSMutableArray arrayWithObject:test]];
        [testSuite setResult:self.measurement.result_id];
        if ([testSuiteName isEqualToString:@"websites"])
            [(WebConnectivity*)test setInputs:[NSArray arrayWithObject:self.measurement.url_id.url]];
        [self.measurement setReRun];
        [[RunningTest currentTest] setAndRun:[NSMutableArray arrayWithObject:testSuite]];
    }
    else if ([[segue identifier] isEqualToString:@"footer_upload"]){
        UploadFooterViewController *vc = (UploadFooterViewController * )segue.destinationViewController;
        [vc setResult:result];
        [vc setMeasurement:measurement];
        [vc setUpload_all:false];
    }
}


@end
