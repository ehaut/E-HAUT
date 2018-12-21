//
//  encrypt.cc
//  EasyHautX
//
//  Created by zengxs on 2018/12/20.
//  Copyright © 2018 ehaut. All rights reserved.
//

#include <iostream>
#include <sstream>
#include <string>

#include <string.h>

#include "encrypt.h"

using namespace std;

#define USERNAME_MAX_LENGTH 1024
#define PASSWORD_MAX_LENGTH 2048

static char username_buffer[USERNAME_MAX_LENGTH];
static char password_buffer[PASSWORD_MAX_LENGTH];

const char *username_encrypt(const char *username) {
    ostringstream oss;
    for (int i = 0; i < strlen(username); ++i)
        oss << (char)(username[i] + 4);

    snprintf(username_buffer, sizeof(username_buffer), "{SRUN3}\r\n%s", oss.str().c_str());
    return username_buffer;
}

const char *password_encrypt(const char *password, const char *key) {
    ostringstream oss;
    for (int i = 0; i < strlen(password); ++i) {
        char ki = password[i] ^ key[strlen(key) - i % strlen(key) - 1];
        char _l = (ki & 0x0f) + 0x36;
        char _h = (ki >> 4 & 0x0f) + 0x63;
        if (i % 2 == 0)
            oss << _l << _h;
        else
            oss << _h << _l;
    }

    snprintf(password_buffer, sizeof(password_buffer), "%s", oss.str().c_str());
    return password_buffer;
}
