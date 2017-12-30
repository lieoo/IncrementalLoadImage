//
//  ViewController.m
//  IncrementalLoadImageDemo
//
//  Created by Leo on 30/12/2017.
//  Copyright © 2017 leios. All rights reserved.
//
#import "ViewController.h"
#import "XZIncrementalIMGTools.h"
#define IMGUrl @"https://cdn.eso.org/images/publicationjpg/eso1242a.jpg" //11.61M 的图片
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *XZImgView;
@property (weak, nonatomic) IBOutlet UIImageView *XZOldImageView;
@property (nonatomic,strong) XZIncrementalIMGTools *imgTool;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startIncrementloadImg]; //增量加载
    
    [self startOldWayToLoadImg]; //直接加载
    
    /*
     增量加载图片 优点 用户提交较高，不用全部等待图片加载完毕后
     缺点 相对于直接加载图片来说 较为占用内存
     
     */
}


- (void)startIncrementloadImg{
    self.imgTool = [[XZIncrementalIMGTools alloc]initWithImageUrlString:IMGUrl];
    
    __weak typeof(self) WeakSelf = self;
    [self.imgTool setIncrementalImgBlock:^(UIImage *img) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WeakSelf.XZImgView setImage:img];
        });
    }];
}

- (void)startOldWayToLoadImg{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImg) object:nil];
    [operationQueue addOperation:op];
}


- (void)loadImg{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:IMGUrl]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.XZOldImageView.image = [UIImage imageWithData:data];
    });
}

@end
