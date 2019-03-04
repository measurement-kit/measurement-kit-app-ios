//
//  NetworkTest.m
//  OONIProbeUnitTests
//
//  Created by Lorenzo Primiterra on 01/03/2019.
//  Copyright © 2019 OONI. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Network.h"

#define BLANK @""
#define ASN @"asn"
#define NETWORK_NAME @"network_name"
#define COUNTRY_CODE @"country_code"

@interface NetworkTest : XCTestCase

@end

@implementation NetworkTest
Network *network;

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    network = [Network new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAsn {
    XCTAssert([[network getAsn] isEqualToString:NSLocalizedString(@"TestResults.UnknownASN", nil)]);
    network.asn = BLANK;
    XCTAssert([[network getAsn] isEqualToString:NSLocalizedString(@"TestResults.UnknownASN", nil)]);
    network.asn = ASN;
    XCTAssert([[network getAsn] isEqualToString:ASN]);
}

- (void)testNetworkName {
    XCTAssert([[network getNetworkName] isEqualToString:NSLocalizedString(@"TestResults.UnknownASN", nil)]);
    network.network_name = BLANK;
    XCTAssert([[network getNetworkName] isEqualToString:NSLocalizedString(@"TestResults.UnknownASN", nil)]);
    network.network_name = NETWORK_NAME;
    XCTAssert([[network getAsn] isEqualToString:NETWORK_NAME]);
}

-(void)testNameOrAsn{
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:NSLocalizedString(@"TestResults.UnknownASN", nil)]);
    network.network_name = BLANK;
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:NSLocalizedString(@"TestResults.UnknownASN", nil)]);
    network.asn = BLANK;
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:NSLocalizedString(@"TestResults.UnknownASN", nil)]);
    network.asn = @"ASN";
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:NETWORK_NAME]);
    network.network_name = NETWORK_NAME;
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:NETWORK_NAME]);
}

- (void)testCountry {
    XCTAssert([[network getCountry] isEqualToString:NSLocalizedString(@"TestResults.UnknownASN", nil)]);
    network.country_code = BLANK;
    XCTAssert([[network getCountry] isEqualToString:NSLocalizedString(@"TestResults.UnknownASN", nil)]);
    network.country_code = COUNTRY_CODE;
    XCTAssert([[network getCountry] isEqualToString:COUNTRY_CODE]);

}

@end