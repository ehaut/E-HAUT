//
//  encrypt.h
//  EasyHautX
//
//  Created by zengxs on 2018/12/20.
//  Copyright © 2018 ehaut. All rights reserved.
//

#ifndef __ENCRYPT_H__
#define __ENCRYPT_H__ 1

#ifdef __cplusplus
extern "C" {
#endif

const char *username_encrypt(const char *username);

const char *password_encrypt(const char *password, const char *key);

#ifdef __cplusplus
}
#endif

#endif /* __ENCRYPT_H__ */
