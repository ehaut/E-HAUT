//
//  httpclient.h
//  EasyHautX
//
//  Created by zengxs on 2018/12/20.
//  Copyright © 2018 ehaut. All rights reserved.
//

#ifndef __HTTPCLIENT_H__
#define __HTTPCLIENT_H__ 1

#ifdef __cplusplus
extern "C" {
#endif

#define PAYLOAD_FIELD_MAX_SIZE 36

typedef struct payload_t {
    char username[PAYLOAD_FIELD_MAX_SIZE]; // origin username, not encrypted
    char password[PAYLOAD_FIELD_MAX_SIZE]; // origin password, not encrypted
    char drop[PAYLOAD_FIELD_MAX_SIZE];
    char pop[PAYLOAD_FIELD_MAX_SIZE];
    char type[PAYLOAD_FIELD_MAX_SIZE];
    char n[PAYLOAD_FIELD_MAX_SIZE];
    char mbytes[PAYLOAD_FIELD_MAX_SIZE];
    char minutes[PAYLOAD_FIELD_MAX_SIZE];
    char ac_id[PAYLOAD_FIELD_MAX_SIZE];
    char mac[PAYLOAD_FIELD_MAX_SIZE];
} * Payload;

size_t srun3k_login(const char *, Payload, const char *, char **);
size_t srun3k_logout(const char *, Payload, char **);

#ifdef __cplusplus
}
#endif

#endif
