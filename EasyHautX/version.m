//
//  version.m
//  EasyHautX
//
//  Created by zengxs on 2018/12/21.
//  Copyright © 2018 ehaut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "version.h"

static char short_vesrion[30];
static char full_version[60];
static char user_agent[60];

const char *ehautx_short_version(void) {
    @autoreleasepool {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
        snprintf(short_vesrion, sizeof(short_vesrion), "%s", [version UTF8String]);
        return short_vesrion;
    }
}

const char *ehautx_version(void) {
    snprintf(full_version, sizeof(full_version), "EasyHautX v%s", ehautx_short_version());
    return full_version;
}

const char *ehautx_user_agent(void) {
    snprintf(user_agent, sizeof(user_agent), "EasyHautX/%s", ehautx_short_version());
    return user_agent;
}
