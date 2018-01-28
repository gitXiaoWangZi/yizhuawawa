//
//  AccountItem.h
//  zzl
//
//  Created by Mr_Du on 2017/11/21.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rich :NSObject <NSCoding,NSCopying>
@property (nonatomic , copy) NSString              * coin;

@end

@interface AccountItem : NSObject

@property (nonatomic , copy) NSString              * position;
@property (nonatomic , copy) NSString              * portrait;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * icode;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * channel;
@property (nonatomic , copy) NSString              * spoils;
@property (nonatomic , copy) NSString              * authed;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * exp;
@property (nonatomic , copy) NSString              * cid;
@property (nonatomic , copy) NSString              * verified;
@property (nonatomic , copy) NSString              * gender;
@property (nonatomic , copy) NSString              * birth;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * no;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * profession;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * weibo;
@property (nonatomic , copy) NSString              * emotion;
@property (nonatomic , strong) Rich              * rich;
@property (nonatomic , copy) NSString              * description;
@end


