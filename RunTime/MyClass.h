//
//  MyClass.h
//  RunTime
//
//  Created by YK- on 2016/12/4.
//  Copyright © 2016年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject<NSCopying,NSCoding>

@property (nonatomic,strong) NSArray *array;
@property (nonatomic,copy) NSString *string;

-(void)method1;
-(void)method2;
+(void)classMethod1;

@end
