#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import "Result.h"
#import "Measurement.h"
#import "SettingsUtility.h"

@protocol ReloadFilterDelegate <NSObject>
-(void)testFilter:(SRKQuery*)query;
@end

@interface ResultsHeaderViewController : UIViewController {
    NSString *filter;
}

@property id<ReloadFilterDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIStackView *view1;
@property (nonatomic, strong) IBOutlet UIStackView *view2;
@property (nonatomic, strong) IBOutlet UIStackView *view3;
@property (strong, nonatomic) IBOutlet UILabel *testsLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberTestsLabel;
@property (strong, nonatomic) IBOutlet UILabel *networksLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberNetworksLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataUsageLabel;
@property (strong, nonatomic) IBOutlet UILabel *upLabel;
@property (strong, nonatomic) IBOutlet UILabel *downLabel;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;

@end
