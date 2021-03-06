#import <UIKit/UIKit.h>
#import "TestUtility.h"
#import "RunButton.h"
#import "Suite.h"

@interface DashboardTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *cardbackgroundView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIImageView *testLogo;

-(void)setTestSuite:(AbstractSuite*)testSuite;
@end
