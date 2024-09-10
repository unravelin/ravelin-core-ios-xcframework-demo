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
}

- (IBAction)touchTrackButton:(id)sender {
    [self useCore];
}

- (void)useCore {

    // Make Ravelin instance with API keys
    // to assist with early stage development/debug
    // execute 'python3 simple_server.py' in a terminal session
    // and use "local" as the apiKey
    // for further development and release, replace with your Ravelin Publishable API Key
    // self.ravelin = [Ravelin createInstance:@"publishable_key_live_----"];
    self.ravelin = [Ravelin createInstance:@"local"];

    self.ravelin.customerId = @"customer012345";

    // Send a device fingerprint with a completion block
    [self.ravelin trackFingerprint:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error) {
            NSDictionary *responseData;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
                NSLog(@"trackFingerprint - success");
                // track login
                [self.ravelin trackLogin:@"login"];
                self.ravelin.orderId = @"order-001";
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
}

- (BOOL)textField:(UITextField *)iTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // avoid checking the pasteboard when a user is typing and only adding a single character at a time
    if(string.length <= 1) { return YES; }
    // Check if the textfield contains pasted text
    if([string containsString:[UIPasteboard generalPasteboard].string]) {
        [self.ravelin trackPaste:@"home" pastedValue:string];
    }

    return YES;
}

@end
