//
//  constants.h
//  Unseen
//
//  Created by Matthew Atkins on 28/08/2012.
//  Copyright (c) 2012 Yoomee. All rights reserved.
//

#ifdef DEBUG
    // Set this URL to your locally accessible instance of the Unseen API for devuce testing
    #define kBaseURL @"http://10.0.1.17:3000"
    //#define kBaseURL @"http://unseenamsterdam.com"
#else
    #define kBaseURL @"http://unseenamsterdam.com"
#endif

#define kEdition @"2014"