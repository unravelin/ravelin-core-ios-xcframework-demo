//
//  ViewController.m
//  RavelinCoreDemoPodsObjC

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <RavelinCore/Ravelin.h>
@interface ViewController ()
@property (strong, nonatomic) Ravelin *ravelin;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.textField.delegate = self;
    
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


- (BOOL)textField:(UITextField *)iTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // avoid checking the pasteboard when a user is typing and only adding a single character at a time
    if(string.length <= 1) { return YES; }
    // Check if the textfield contains pasted text
    if([string containsString:[UIPasteboard generalPasteboard].string]) {
        // Send paste event to Ravelin
        NSString *pageTitle = @"home";
        NSString *pasteLength = [NSString stringWithFormat:@"%ld", (long)[UIPasteboard generalPasteboard].string.length];
        NSDictionary *meta = @{@"pasteLength": pasteLength};
        [self.ravelin track:pageTitle eventName:@"paste" eventProperties:meta];
    }
    
    return YES;
}

@end
