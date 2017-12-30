//
//  XZIncrementalIMGTools.h
//  IncrementalDoadImageDemo
//
//  Created by Leo on 28/12/2017.
//  Copyright © 2017 leios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XZIncrementalIMGTools : NSObject

-(id)initWithImageUrlString:(NSString *)imgUrlStr;

@property (nonatomic,copy) void (^incrementalImgBlock)(UIImage *img);

@end
