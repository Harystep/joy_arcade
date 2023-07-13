//
//  SJGuidViewController.m
//  wawajiGame
//
//  Created by sander shan on 2022/10/25.
//

#import "SJGuidViewController.h"

#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface SJGuidViewController ()

@property (nonatomic, weak) UIImageView * theBgImageView;

@property (nonatomic, weak) UIImageView * theFireGuidImageView;

@end

@implementation SJGuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self theBgImageView];
    
    [self theFireGuidImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimissViewController)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)dimissViewController {
    [self dismissViewControllerAnimated:false completion:nil];
}

- (UIImage *)getImage{
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 1.0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(con, [UIColor blackColor].CGColor);//背景色
    CGContextFillRect(con, [UIScreen mainScreen].bounds);
    CGContextAddEllipseInRect(con, self.fireFrame);
    CGContextSetBlendMode(con, kCGBlendModeClear);
    CGContextFillPath(con);
    UIImage *ima = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ima;
}


#pragma mark - lazy UI

- (UIImageView *)theBgImageView{
    if (!_theBgImageView) {
        UIImageView * theView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:theView];
        
        [theView setImage:[self getImage]];
        theView.alpha = 0.5;
        _theBgImageView = theView;
    }
    return _theBgImageView;
}

- (UIImageView *)theFireGuidImageView{
    if (!_theFireGuidImageView) {
        UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_fire_guid"]];
        [self.view addSubview:theView];
        [theView setFrame:CGRectMake(self.fireFrame.origin.x - DSize(220), self.fireFrame.origin.y - DSize(130), DSize(316), DSize(227))];
        _theFireGuidImageView = theView;
    }
    return _theFireGuidImageView;
}

@end
