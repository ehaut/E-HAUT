//
//  AppDelegate.m
//  EasyHautX
//
//  Created by zengxs on 2018/12/20.
//  Copyright © 2018 ehaut. All rights reserved.
//

#import "AppDelegate.h"
#import "httpclient.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSPanel *modalWindow;
@property (weak) IBOutlet NSTextField *serverTextField;
@property (weak) IBOutlet NSTextField *usernameTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet NSTextField *passwordKeyTextField;
@property (weak) IBOutlet NSTextField *acidTextField;
@property (weak) IBOutlet NSTextField *typeTextField;
@property (weak) IBOutlet NSTextField *nTextField;
@property (weak) IBOutlet NSTextField *dropTextField;
@property (weak) IBOutlet NSTextField *popTextField;
@property (weak) IBOutlet NSTextField *mbytesTextField;
@property (weak) IBOutlet NSTextField *minutesTextField;
@property (weak) IBOutlet NSTextField *macTextField;

@property (weak) IBOutlet NSTextField *responseArea;
@property (weak) IBOutlet NSTextField *versionLabel;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    @autoreleasepool {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
        NSString *labelVersion = [NSString stringWithFormat:@"Version %@", version];
        [self.versionLabel setStringValue:labelVersion];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)closeModal:(id)sender {
    @autoreleasepool {
        [self.modalWindow setIsVisible:false];
        [self.responseArea setStringValue:@""];
        [NSApp stopModal];
    }
}

- (IBAction)loginClicked:(id)sender {
    @autoreleasepool {
        Payload http_payload = (Payload)malloc(sizeof(struct payload_t));

        snprintf(http_payload->username, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_usernameTextField stringValue] UTF8String]);
        snprintf(http_payload->password, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_passwordTextField stringValue] UTF8String]);
        snprintf(http_payload->ac_id, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_acidTextField stringValue] UTF8String]);
        snprintf(http_payload->type, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_typeTextField stringValue] UTF8String]);
        snprintf(http_payload->n, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_nTextField stringValue] UTF8String]);
        snprintf(http_payload->drop, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_dropTextField stringValue] UTF8String]);
        snprintf(http_payload->pop, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_popTextField stringValue] UTF8String]);
        snprintf(http_payload->mbytes, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_mbytesTextField stringValue] UTF8String]);
        snprintf(http_payload->minutes, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_minutesTextField stringValue] UTF8String]);
        snprintf(http_payload->mac, PAYLOAD_FIELD_MAX_SIZE, "%s", [[_macTextField stringValue] UTF8String]);

        char *response = NULL;
        srun3k_login([[_serverTextField stringValue] UTF8String], http_payload,
                     [[_passwordKeyTextField stringValue] UTF8String], &response);

        [self.responseArea setStringValue:[[NSString alloc] initWithUTF8String:response]];

        [self.modalWindow setIsVisible:true];
        [NSApp runModalForWindow:self.modalWindow];

        free(response);
        free(http_payload);
    }
}

- (IBAction)logoutClicked:(id)sender {
    @autoreleasepool {
        Payload http_payload = (Payload)malloc(sizeof(struct payload_t));

        snprintf(http_payload->username, PAYLOAD_FIELD_MAX_SIZE, "%s",
                 [[self.usernameTextField stringValue] UTF8String]);
        snprintf(http_payload->type, PAYLOAD_FIELD_MAX_SIZE, "%s", [[self.typeTextField stringValue] UTF8String]);
        snprintf(http_payload->ac_id, PAYLOAD_FIELD_MAX_SIZE, "%s", [[self.acidTextField stringValue] UTF8String]);
        snprintf(http_payload->mac, PAYLOAD_FIELD_MAX_SIZE, "%s", [[self.macTextField stringValue] UTF8String]);

        char *response = NULL;
        srun3k_logout([[self.serverTextField stringValue] UTF8String], http_payload, &response);

        [self.responseArea setStringValue:[[NSString alloc] initWithUTF8String:response]];

        [self.modalWindow setIsVisible:true];
        [NSApp runModalForWindow:self.modalWindow];

        free(http_payload);
    }
}

- (IBAction)checkUpdate:(id)sender {
    @autoreleasepool {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/ehaut/EasyHautX/releases"]];
    }
}

@end
