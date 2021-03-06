#import "TestSummaryTableViewCell.h"

@implementation TestSummaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setResult:(Result*)result andMeasurement:(Measurement*)measurement{
    //Setting generic parameters
    [self.notUploadedImage setTintColor:[UIColor colorNamed:@"color_gray7"]];
    if (measurement.is_uploaded || measurement.is_failed)
        [self.notUploadedImage setHidden:YES];
    else
        [self.notUploadedImage setHidden:NO];
    
    if (measurement.is_failed){
        [self setBackgroundColor:[UIColor colorNamed:@"color_gray1"]];
        [self.titleLabel setTextColor:[UIColor colorNamed:@"color_gray5"]];
        [self.statusImage setTintColor:[UIColor colorNamed:@"color_gray5"]];
        [self.statusImage setImage:[UIImage imageNamed:@"error"]];
    }
    else {
        [self setBackgroundColor:[UIColor colorNamed:@"color_white"]];
        [self.titleLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self.statusImage setImage:nil];
    }
    
    //Setting test specific UI
    if ([result.test_group_name isEqualToString:@"instant_messaging"]){
        [self rowInstantMessaging:measurement];
    }
    //__deprecated
    else if ([result.test_group_name isEqualToString:@"middle_boxes"]){
        [self rowMiddleBoxes:measurement];
    }
    else if ([result.test_group_name isEqualToString:@"websites"]){
        [self rowWebsites:measurement];
    }
    else if ([result.test_group_name isEqualToString:@"performance"]){
        [self rowPerformance:measurement];
    }
    else if ([result.test_group_name isEqualToString:@"circumvention"]){
        [self rowInstantMessaging:measurement];
    }
    else if ([result.test_group_name isEqualToString:@"experimental"]){
        [self rowExperimental:measurement];
    }
}

-(void)rowWebsites:(Measurement*)measurement{
    [self.titleLabel setText:[NSString stringWithFormat:@"%@", measurement.url_id.url]];
    [self.categoryImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"category_%@", measurement.url_id.category_code]]];
    if (measurement.is_failed)
        [self.categoryImage setTintColor:[UIColor colorNamed:@"color_gray5"]];
    else
        [self.categoryImage setTintColor:[UIColor colorNamed:@"color_gray7"]];
    if (!measurement.is_failed){
        if (!measurement.is_anomaly){
            [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
            [self.statusImage setTintColor:[UIColor colorNamed:@"color_green8"]];
        }
        else {
            [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
            [self.statusImage setTintColor:[UIColor colorNamed:@"color_yellow9"]];
        }
    }
}

-(void)rowInstantMessaging:(Measurement*)measurement{
    [self.titleLabel setText:[LocalizationUtility getNameForTest:measurement.test_name]];
    [self.categoryImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", measurement.test_name]]];
    if (measurement.is_failed)
        [self.categoryImage setTintColor:[UIColor colorNamed:@"color_gray5"]];
    else
        [self.categoryImage setTintColor:[UIColor colorNamed:@"color_gray7"]];
    if (!measurement.is_anomaly){
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
        [self.statusImage setTintColor:[UIColor colorNamed:@"color_green8"]];
    }
    else {
        [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
        [self.statusImage setTintColor:[UIColor colorNamed:@"color_yellow9"]];
    }
}

-(void)rowPerformance:(Measurement*)measurement{
    self.ndtSpaceConstraint.constant = self.frame.size.width/1.8;
    [self setNeedsUpdateConstraints];
    [self.titleLabel setText:[LocalizationUtility getNameForTest:measurement.test_name]];
    [self.detail1Image setHidden:NO];
    [self.detail2Image setHidden:NO];
    [self.detail1Label setHidden:NO];
    [self.detail2Label setHidden:NO];
    
    if (measurement.is_failed){
        [self.detail1Image setHidden:YES];
        [self.detail2Image setHidden:YES];
        [self.detail1Label setHidden:YES];
        [self.detail2Label setHidden:YES];
    }
    else {
        if (!measurement.is_anomaly)
            [self.statusImage setImage:nil];
        else
            [self.statusImage setImage:nil];
    }
    if ([measurement.test_name isEqualToString:@"ndt"]){
        TestKeys *testKeysNdt = [measurement testKeysObj];
        [self.stackView2 setHidden:NO];
        [self.detail1Image setImage:[UIImage imageNamed:@"download"]];
        [self.detail1Image setTintColor:[UIColor colorNamed:@"color_gray9"]];
        [self.detail2Image setImage:[UIImage imageNamed:@"upload"]];
        [self.detail2Image setTintColor:[UIColor colorNamed:@"color_gray9"]];
        [self.detail1Label setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self.detail2Label setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self setText:[testKeysNdt getDownloadWithUnit] forLabel:self.detail1Label inStackView:self.stackView1];
        [self setText:[testKeysNdt getUploadWithUnit] forLabel:self.detail2Label inStackView:self.stackView2];
    }
    else if ([measurement.test_name isEqualToString:@"dash"]){
        TestKeys *testKeysDash = [measurement testKeysObj];
        [self.stackView2 setHidden:YES];
        [self.detail1Image setImage:[UIImage imageNamed:@"video_quality"]];
        [self.detail1Image setTintColor:[UIColor colorNamed:@"color_gray9"]];
        [self.detail1Label setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self setText:[testKeysDash getVideoQuality:YES] forLabel:self.detail1Label inStackView:self.stackView1];
    }
    else if ([measurement.test_name isEqualToString:@"http_invalid_request_line"] ||
        [measurement.test_name isEqualToString:@"http_header_field_manipulation"]){
        [self.stackView2 setHidden:YES];
        [self.detail1Image setImage:[UIImage imageNamed:@"middle_boxes"]];
        [self.detail1Image setTintColor:[UIColor colorNamed:@"color_gray9"]];
        [self.detail1Label setTextColor:[UIColor colorNamed:@"color_gray9"]];
        if (measurement.is_failed)
            [self setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Failed", nil)
                 forLabel:self.detail1Label inStackView:self.stackView1];
        else if (!measurement.is_anomaly)
            [self setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.NotFound", nil)
                 forLabel:self.detail1Label inStackView:self.stackView1];
        else
            [self setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Found", nil)
                 forLabel:self.detail1Label inStackView:self.stackView1];
    }
}

-(void)rowMiddleBoxes:(Measurement*)measurement{
    [self.titleLabel setText:[LocalizationUtility getNameForTest:measurement.test_name]];
    if (!measurement.is_anomaly){
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
        [self.statusImage setTintColor:[UIColor colorNamed:@"color_green8"]];
    }
    else {
        [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
        [self.statusImage setTintColor:[UIColor colorNamed:@"color_yellow9"]];
    }
}

-(void)rowExperimental:(Measurement*)measurement{
    [self.titleLabel setText:measurement.test_name];
    [self.statusImage setImage:nil];
}

-(void)setText:(NSString*)text forLabel:(UILabel*)label inStackView:(UIStackView*)stackView{
    if (text == nil)
        text = NSLocalizedString(@"TestResults.NotAvailable", nil);
    [label setText:text];
    if ([text isEqualToString:NSLocalizedString(@"TestResults.NotAvailable", nil)]){
        [stackView setAlpha:0.3f];
    }
}

@end
