//
//  ViewController.m
//  RavelinCoreDemoPodsObjC

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <RavelinCore/Ravelin.h>
@interface ViewController ()
@property (strong, nonatomic) Ravelin *ravelin;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Make Ravelin instance with api keys
    self.ravelin = [Ravelin createInstance:@"publishable_key_xxxx"];
    
    // Setup customer info and track their login
    self.ravelin.customerId = @"customer1234";
    self.ravelin.orderId = @"web-001";
    [self.ravelin trackLogin:@"loginPage"];
    
    // Track customer moving to a new page
    [self.ravelin trackPage:@"checkout"];
    
    // Send a device fingerprint
    [self.ravelin trackFingerprint];
    
    // Send a device fingerprint with a completion block (if required)
    [self.ravelin trackFingerprint:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error) {
            NSDictionary *responseData;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
                // Do something with responseData
                NSLog(@"trackFingerprint - success");
            } else {
                // Status was not 200. Handle failure
                NSLog(@"trackFingerprint - failure");
            }
        } else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
    
    // Track a customer logout
    [self.ravelin trackLogout:@"logoutPage"];
}
@end
