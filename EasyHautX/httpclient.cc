//
//  httpclient.cc
//  EasyHautX
//
//  Created by zengxs on 2018/12/20.
//  Copyright © 2018 ehaut. All rights reserved.
//

#include <iostream>
#include <list>
#include <string.h>

#include <curl/curl.h>

#include "encrypt.h"
#include "httpclient.h"

using namespace std;

typedef pair<const char *, const char *> Param;
typedef list<Param> ParamList;

std::string readBuffer;

// 生成 curl post payload
static curl_httppost *construct_post_payload(ParamList param_list) {
    struct curl_httppost *post = NULL, *last = NULL;

    for (auto param : param_list)
        curl_formadd(&post, &last, CURLFORM_COPYNAME, param.first, CURLFORM_COPYCONTENTS, param.second, CURLFORM_END);
    return post;
}

// http response 写入回调函数
size_t writefunc(void *contents, size_t size, size_t nmemb, void *userp) {
    size_t real_size = size * nmemb;
    readBuffer.append((const char *)contents, real_size);
    return real_size;
}

size_t srun3k_login(const char *url, payload_t *payload, const char *key, char **response) {
    CURL *curl;
    CURLcode res;

    // 初始化全局 curl 环境
    curl_global_init(CURL_GLOBAL_ALL);

    // 初始化 curl 句柄
    curl = curl_easy_init();
    if (curl && payload) {
        // 设置 url
        curl_easy_setopt(curl, CURLOPT_URL, url);

        // 构造 post 参数
        ParamList list{
            make_pair("action", "login"),
            make_pair("username", username_encrypt(payload->username)),
            make_pair("password", password_encrypt(payload->password, key)),
            make_pair("drop", payload->drop),
            make_pair("pop", payload->pop),
            make_pair("type", payload->type),
            make_pair("n", payload->n),
            make_pair("mbytes", payload->mbytes),
            make_pair("minutes", payload->minutes),
            make_pair("ac_id", payload->ac_id),
            make_pair("mac", payload->mac),
        };
        struct curl_httppost *post = construct_post_payload(list);
        curl_easy_setopt(curl, CURLOPT_HTTPPOST, post);

        // 设置 http 响应处理
        readBuffer.clear();
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writefunc);

        // 发送 http 请求
        res = curl_easy_perform(curl);

        // 清理 post
        curl_formfree(post);
        curl_easy_cleanup(curl);

        if (res != CURLE_OK) {
            return 0;
        } else {
            std::cout << readBuffer << std::endl;
            size_t ret_size = sizeof(char) * readBuffer.length();
            *response = (char *)malloc(ret_size);
            snprintf(*response, ret_size, "%s", readBuffer.c_str());
            return ret_size;
        }
    }
    return 0;
}

size_t srun3k_logout(const char *url, Payload payload, char **response) {
    CURL *curl;
    CURLcode res;

    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();

    if (curl && payload) {
        curl_easy_setopt(curl, CURLOPT_URL, url);
        ParamList params{
            make_pair("action", "logout"),    make_pair("username", payload->username),
            make_pair("type", payload->type), make_pair("ac_id", payload->ac_id),
            make_pair("mac", payload->mac),
        };
        struct curl_httppost *post = construct_post_payload(params);
        curl_easy_setopt(curl, CURLOPT_HTTPPOST, post);

        readBuffer.clear();
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writefunc);

        res = curl_easy_perform(curl);

        curl_formfree(post);
        curl_easy_cleanup(curl);

        if (res == CURLE_OK) {
            std::cout << readBuffer << std::endl;
            size_t ret_size = sizeof(char) * readBuffer.length();
            *response = (char *)malloc(ret_size);
            snprintf(*response, ret_size, "%s", readBuffer.c_str());
            return ret_size;
        }
    }

    return 0;
}
