

#import "YCJComplaintReasonAlertView.h"

@interface YCJComplaintReasonAlertView()
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UILabel       *titleLB;
@property (nonatomic, strong) UIButton      *cancelBtn;
@property (nonatomic, strong) UIButton      *sureBtn;
@property (nonatomic, strong) UIButton      *currentBtn;
@property (nonatomic, copy) NSString        *currentReason;
@property (nonatomic, strong) NSMutableArray    *reasonList;
@end

@implementation YCJComplaintReasonAlertView

- (NSMutableArray *)reasonList {
    if (!_reasonList) {
        _reasonList = [NSMutableArray array];
    }
    return _reasonList;
}

- (instancetype)init {
    self = [super init];
    if (self) {}
    return self;
}

- (void)setupSubviews {
    
    NSArray *titles = @[ZCLocalizedString(@"爆机奖励领取", nil), ZCLocalizedString(@"操作按键失灵", nil), ZCLocalizedString(@"结算失败", nil)];
    [self.reasonList addObjectsFromArray:titles];
    [self addSubview:self.contentView];
    float frow = titles.count / 2.0;
    NSInteger row = ceil(frow);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSize(45));
        make.right.mas_equalTo(-kSize(45));
        make.centerY.equalTo(self);
        make.height.mas_equalTo((row) * 60 + 140);
    }];
    
    [self.contentView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    for (int i = 0; i < titles.count; i++) {
        NSInteger row = i / 2;
        NSInteger column = i % 2;
        UIButton *cBtn = [[UIButton alloc] init];
        cBtn.tag = i;
        [cBtn setTitle:titles[i] forState:UIControlStateNormal];
        if (i == 0) {
            [cBtn setTitleColor:kColorHex(0x46599C) forState:UIControlStateNormal];
            cBtn.borderWidth = 1;
            cBtn.borderColor = kColorHex(0x6984EA);
            cBtn.backgroundColor = kColorHex(0xE1E7FF);
            self.currentBtn = cBtn;
            self.currentReason = titles[i];
        } else {
            cBtn.backgroundColor = kColorHex(0xECECEC);
            [cBtn setTitleColor:kLightBlackColor forState:UIControlStateNormal];
        }
        cBtn.titleLabel.font = kPingFangRegularFont(14);
        
        cBtn.cornerRadius = kSize(4);
        [cBtn addTarget:self action:@selector(contentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cBtn];
        [cBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (column == 0) {
                make.left.mas_equalTo(20);
                make.right.equalTo(self.contentView.mas_centerX).offset(-5);
            } else {
                make.left.equalTo(self.contentView.mas_centerX).offset(5);
                make.right.mas_equalTo(-20);
            }
            make.top.equalTo(self.titleLB.mas_bottom).offset(20 + 60 * row);
            make.height.mas_equalTo(50);
        }];
    }
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.contentView.mas_centerX).offset(-5);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(5);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
}

- (void)show {
    /// 初始化视图
    [self setupSubviews];
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];

    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)contentBtnAction:(UIButton *)btn {
    if (btn.tag == self.currentBtn.tag) {
        return;
    }
    self.currentReason = self.reasonList[btn.tag];
    [btn setTitleColor:kColorHex(0x46599C) forState:UIControlStateNormal];
    btn.borderWidth = 1;
    btn.borderColor = kColorHex(0x6984EA);
    btn.backgroundColor = kColorHex(0xE1E7FF);
    
    self.currentBtn.borderColor = [UIColor clearColor];
    self.currentBtn.backgroundColor = kColorHex(0xECECEC);
    [self.currentBtn setTitleColor:kLightBlackColor forState:UIControlStateNormal];
    self.currentBtn = btn;
}

- (void)sureBtnAction {
    if (self.commonAlertViewDoneClickBlock) {
        self.commonAlertViewDoneClickBlock();
    }
    if ([[JKTools handelString:self.detailModel.detailId] isEqualToString:@""]){
        [MBProgressHUD showError:@"结算id无效"];
        return;
    }
    /// 机器类型 1：娃娃机 3,5都属于推币机 4,6都属于街机类型
    NSString *url = JKJieJiGameShensuUrlKey;
    if ([@[@"1", @"3", @"5"] containsObject:self.gameModel.type]) {
        url = JKTuiBiJiGameShensuUrlKey;
    } else if ([@[@"4", @"6"] containsObject:self.gameModel.type]) {
        url = JKJieJiGameShensuUrlKey;
    }
    [JKNetWorkManager postRequestWithUrlPath:url parameters:@{@"id":self.detailModel.detailId, @"type":@"4", @"reason": self.currentReason} finished:^(JKNetWorkResult * _Nonnull result) {
        [self dismiss];
        if(!result.error) {
            [MBProgressHUD showSuccess:@"申诉成功"];
        } else {
            [MBProgressHUD showSuccess:result.error.localizedDescription];
        }
    }];
}


#pragma mark -- lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = kCommonWhiteColor;
        _contentView.layer.cornerRadius = 9;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = ZCLocalizedString(@"选择申诉原因", nil);
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = kPingFangSemiboldFont(15);
        _titleLB.textColor = kCommonBlackColor;
    }
    return _titleLB;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:ZCLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColorHex(0x46599C) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kPingFangRegularFont(14);
        _cancelBtn.backgroundColor = kColorHex(0xEEF2FF);
        _cancelBtn.cornerRadius = kSize(4);
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:ZCLocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kPingFangRegularFont(14);
        _sureBtn.backgroundColor = kColorHex(0x6984EA);
        _sureBtn.cornerRadius = kSize(4);
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end
