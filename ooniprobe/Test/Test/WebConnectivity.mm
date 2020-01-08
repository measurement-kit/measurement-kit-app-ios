#import "WebConnectivity.h"
#import "MessageUtility.h"

@implementation WebConnectivity : AbstractTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"web_connectivity";
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
    if (self.inputs == nil || [self.inputs count] == 0){
        //Download urls and then alloc class
        [TestUtility downloadUrls:^(NSArray *urls) {
            [self setUrls:urls];
            [self setDefaultMaxRuntime];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRuntime" object:nil];
            [super runTest];
        } onError:^(NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showError" object:nil];
            [super testEnded];
        }];
    }
    else {
        [self setUrls:self.inputs];
        [super runTest];
    }
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     null => failed
     false => not blocked
     string (dns, tcp-ip, http-failure, http-diff) => anomalous
     */
    if (json.test_keys.blocking == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = ![json.test_keys.blocking isEqualToString:@"0"];
    [super onEntry:json obj:measurement];
}

/*
 if the option max_runtime is already set in the option and is not MAX_RUNTIME_DISABLED let's use it
 else if the input are sets we calculate 5 seconds per input
 at last we check if max_runtime is enabled, in  that case we use the value in the settings
 */
-(int)getRuntime{
    if (self.settings.options.max_runtime != nil &&
        ![self.settings.options.max_runtime isEqual: MAX_RUNTIME_DISABLED]){
        return 30 + [self.settings.options.max_runtime intValue];
    }
    else if (self.settings.inputs != nil)
        return 30 + (int)[self.settings.inputs count] * 5;
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime_enabled"] boolValue]){
        NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        return 30 + [max_runtime intValue];
    }
    return [MAX_RUNTIME_DISABLED  intValue];
}

-(void)setUrls:(NSArray*)inputs{
    self.settings.inputs = inputs;
    self.inputs = nil;
}

-(void)setDefaultMaxRuntime {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime_enabled"] boolValue]){
        NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        self.settings.options.max_runtime = max_runtime;
    }
    else
        self.settings.options.max_runtime = MAX_RUNTIME_DISABLED;
}

@end
