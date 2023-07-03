
#import "YCJInvitionCodeView.h"
#import "YCJInviteCodeModel.h"

@interface YCJInvitionCodeView ()
@property (nonatomic, strong) UIView                *contentView;

@end

@implementation YCJInvitionCodeView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setInviteModel:(YCJInviteCodeModel *)inviteModel {
    
    NSArray *code = [self charsWithString:inviteModel.code];
    CGFloat padding = 8;
    CGFloat width = (kScreenWidth - 2 * kMargin - 16) / 8;
    for (int i = 0; i < code.count; i++) {
        UIButton *codeBtn = [[UIButton alloc] init];
        codeBtn.frame = CGRectMake((38 + 8) * i, 0, 38, 50);
        codeBtn.frame = CGRectMake((width) * i - padding * 0.5, 0, width - 8, 50);
        NSLog(@"%f", width);
        [codeBtn setBackgroundImage:[UIImage imageNamed:@"icon_invition_code_bg"] forState:UIControlStateNormal];
        [codeBtn setTitle:code[i] forState:UIControlStateNormal];
        [codeBtn setTitleColor:kColorHex(0x333333) forState:UIControlStateNormal];
        codeBtn.titleLabel.font = kPingFangSemiboldFont(24);
        [self.contentView addSubview:codeBtn];
    }
}

- (NSArray *)charsWithString:(NSString *)str {
    NSMutableArray *codes = [NSMutableArray array];
    for (int i = 0; i < str.length; i++) {
        char character = [str characterAtIndex:i];
        [codes addObject:[NSString stringWithFormat:@"%c", character]];
    }
    
    return [codes copy];
}

#pragma mark -
#pragma mark -- configUI
- (void)configUI{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark -
#pragma mark -- lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

@end
