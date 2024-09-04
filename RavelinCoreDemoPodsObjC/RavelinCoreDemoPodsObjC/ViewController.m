//
//  ViewController.m
//  RavelinCoreDemoPodsObjC

#import "ViewController.h"

@import RavelinCore;
@interface ViewController ()
@property (strong, nonatomic) Ravelin *ravelin;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.textField.delegate = self;
    
    // make Ravelin instance with api key
    self.ravelin = [Ravelin createInstance:@"local"];
}

- (IBAction)touchTrackButton:(id)sender {
    // Setup customer info and track their login
    self.ravelin.customerId = @"customer12345";

    // Send a device fingerprint with a completion block (if required)
    [self.ravelin trackFingerprint:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error) {
            NSDictionary *responseData;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
                NSLog(@"trackFingerprint - success");
                // track login
                [self.ravelin trackLogin:@"login"];
                self.ravelin.orderId = @"web-001";
                // track customer moving to a new page
                [self.ravelin trackPage:@"checkout"];
                // track logout
                [self.ravelin trackLogout:@"logout"];
            } else {
                // Status was not 200. Handle failure
                NSLog(@"trackFingerprint - failure");
            }
        } else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
    
    [self.ravelin trackFingerprintWithCompletionHandler:^(NSError *error) {
        [self.ravelin trackLoginEvent:@"" eventProperties:NULL completionHandler:^(NSError *error) {
        }];
    }];
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
