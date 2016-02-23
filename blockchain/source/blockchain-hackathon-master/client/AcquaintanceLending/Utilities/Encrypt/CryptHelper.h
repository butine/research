//
//  CryptHelper.h
//  ST
//
//  Created by YangNan on 15/4/2.
//  Copyright (c) 2015年 Teng Niu. All rights reserved.
//

#ifndef __ST__LockHelper__
#define __ST__LockHelper__

#include <iostream>

class CryptHelper {
private:
    std::string key;
    
public:
    CryptHelper();
    std::string getKey();
};

#endif /* defined(__ST__LockHelper__) */
