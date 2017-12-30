//
//  XZIncrementalIMGTools.m
//  IncrementalDoadImageDemo
//
//  Created by Leo on 28/12/2017.
//  Copyright © 2017 leios. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <CoreFoundation/CoreFoundation.h>
#import "XZIncrementalIMGTools.h"
@interface XZIncrementalIMGTools() <NSURLConnectionDataDelegate>
@property (nonatomic,strong) NSMutableData *imgMutData;

@property (nonatomic,assign) long long dataLength;

@property (nonatomic,assign) BOOL isFinished;

@property (nonatomic,assign) CGImageSourceRef incrementalImgSource;

@property (nonatomic,strong) NSURLConnection *connect;

@end

@implementation XZIncrementalIMGTools


-(id)initWithImageUrlString:(NSString *)imgUrlStr{
    
    if (self = [super init]) {
        
        self.incrementalImgSource = CGImageSourceCreateIncremental(NULL);
        
        [self downLoadImgWithImgUrlStr:imgUrlStr];
        
        self.imgMutData = [[NSMutableData alloc]init];
        
        self.isFinished = NO;
    }
    return self;
}

- (void)downLoadImgWithImgUrlStr:(NSString *)imgUrl{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl]];
    self.connect = [[NSURLConnection alloc]initWithRequest:req delegate:self];
    [self.connect start];
}

#pragma mark -- Connection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    self.dataLength = response.expectedContentLength;
    NSLog(@"Data Length: %lld", self.dataLength);
    
    NSString *mimeType = response.MIMEType;
    NSLog(@"MIME TYPE %@", mimeType);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.imgMutData appendData:data];
    self.isFinished = (self.imgMutData.length == self.dataLength);
    CGImageSourceUpdateData(self.incrementalImgSource, (CFDataRef)self.imgMutData, self.isFinished);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(self.incrementalImgSource, 0, NULL);
    
    self.incrementalImgBlock([UIImage imageWithCGImage:imageRef]);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"完成");
}
@end
