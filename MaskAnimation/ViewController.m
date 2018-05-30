//
//  ViewController.m
//  MaskAnimation
//
//  Created by Golden on 2017/12/8.
//  Copyright © 2017年 Golden. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CAShapeLayer *maskLayer;
@property (strong, nonatomic) UIImageView *fontView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //底层为灰色的背景图片
    [self.view addSubview:[self creatScaleWithImage:[UIImage imageNamed:@"gray"]]];
    
    //添加遮罩层
    CAShapeLayer *layer = [self creatRoundlayer];
    [self.view.layer addSublayer:layer];
    
    //上层为彩色层
    self.fontView = [self creatScaleWithImage:[UIImage imageNamed:@"color"]];
    [self.view addSubview:self.fontView];
    self.fontView.layer.mask = layer;
    
    [self startAnimaiton];
  
    UIButton *button = [UIButton buttonWithType:0];
    button.frame = CGRectMake(10, 10, 100, 40);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:button];
}

- (void)click:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    //coreanimation暂停和继续动画
    if (sender.selected) {
        //暂停layer动画
        //1.取出当前时间，转成动画暂停的时间
        CFTimeInterval pauseTime = [self.fontView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        self.fontView.layer.timeOffset = pauseTime;
        //3.将动画的运行速度设置为0， 默认的运行速度是1.0
        self.fontView.layer.speed = 0;
    }else {
        //继续layer动画
        CFTimeInterval pausedTime = [self.fontView.layer
                                     timeOffset];
        self.fontView.layer.speed = 1.0;
        self.fontView.layer.timeOffset = 0.0;
        self.fontView.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.fontView.layer
                                         convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.fontView.layer.beginTime = timeSincePause;
    }
}

- (UIImageView *)creatScaleWithImage:(UIImage *)image {
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = self.view.frame;
    imageView.center = self.view.center;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (CAShapeLayer *)creatRoundlayer {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x, self.view.center.y+43) radius:[UIScreen mainScreen].bounds.size.width/2 - 30 startAngle:145*(M_PI/180) endAngle:35*(M_PI/180) clockwise:YES];
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.path = path.CGPath;
    self.maskLayer.fillColor = [UIColor clearColor].CGColor;
    self.maskLayer.strokeColor = [UIColor redColor].CGColor;
    self.maskLayer.lineWidth = 70;
    return self.maskLayer;
}

- (void)startAnimaiton {
    //开始执行扇形动画
    CABasicAnimation *strokeEndAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAni.fromValue = @0;
    strokeEndAni.toValue = @1;
    strokeEndAni.duration = 5;
    //重复次数
    strokeEndAni.repeatCount = 1;
    [_maskLayer addAnimation:strokeEndAni forKey:@"ani"];
}

@end
