#import "PPSaintPostionPlayingView.h"
#import "Masonry.h"
#import "AppDefineHeader.h"
#import "UIImageView+WebCache.h"
#import "PPUserInfoService.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface PPSaintPostionPlayingView ()
@property (nonatomic, weak) UIImageView * thePlayer1ImageView;
@property (nonatomic, weak) UILabel * thePlayer1Label;
@property (nonatomic, weak) UIImageView * thePlayer2ImageView;
@property (nonatomic, weak) UILabel * thePlayer2Label;
@property (nonatomic, weak) UIImageView * thePlayer3ImageView;
@property (nonatomic, weak) UILabel * thePlayer3Label;
@property (nonatomic, weak) UIImageView * thePlayer4ImageView;
@property (nonatomic, weak) UILabel * thePlayer4Label;
@property (nonatomic, weak) UIView * thePlayer1SateView;
@property (nonatomic, weak) UIView * thePlayer2SateView;
@property (nonatomic, weak) UIView * thePlayer3SateView;
@property (nonatomic, weak) UIView * thePlayer4SateView;
@property (nonatomic, weak) UIButton * theSettlementButton;
@end
@implementation PPSaintPostionPlayingView
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.frame = CGRectMake(0, 0, DSize(360), DSize(133));
    [self configView];
    self.playerPostion = 0;
    self.theSettlementSubject = [RACSubject subject];
  }
  return self;
}
#pragma mark - config
- (void)configView {
  [self thePlayer1ImageView];
  [self thePlayer2ImageView];
  [self thePlayer3ImageView];
  [self thePlayer4ImageView];
  self.thePlayer1Label.text = @"1P";
  self.thePlayer2Label.text = @"2P";
  self.thePlayer3Label.text = @"3P";
  self.thePlayer4Label.text = @"4P";
  [self theSettlementButton];
}
#pragma mark - set
- (void)setPlayerList:(NSArray<SDSaintSeatInfoModel *> *)playerList {
  _playerList = playerList;
  self.thePlayer1ImageView.image = [UIImage new];
  self.thePlayer2ImageView.image = [UIImage new];
  self.thePlayer3ImageView.image = [UIImage new];
  self.thePlayer4ImageView.image = [UIImage new];
  self.playerPostion = 0;
  for (SDSaintSeatInfoModel * seatInfo in playerList) {
    if ([seatInfo.memberId isEqualToString:[PPUserInfoService get_Instance].userMemberId]) {
      self.playerPostion = seatInfo.position;
    }
    if (seatInfo.headUrl) {
      switch (seatInfo.position) {
        case 1:
          [self.thePlayer1ImageView sd_setImageWithURL:[NSURL URLWithString:seatInfo.headUrl]];
          break;
        case 2:
          [self.thePlayer2ImageView sd_setImageWithURL:[NSURL URLWithString:seatInfo.headUrl]];
          break;
        case 3:
          [self.thePlayer3ImageView sd_setImageWithURL:[NSURL URLWithString:seatInfo.headUrl]];
          break;
        case 4:
          [self.thePlayer4ImageView sd_setImageWithURL:[NSURL URLWithString:seatInfo.headUrl]];
          break;
        default:
          break;
      }
    }
  }
}
#pragma mark - set
- (void)setPlayerPostion:(NSInteger)playerPostion {
  _playerPostion = playerPostion;
  if (self.playerPostion == 0) {
    [self.theSettlementButton setHidden:true];
    self.thePlayer1ImageView.layer.borderWidth = 0;
    self.thePlayer2ImageView.layer.borderWidth = 0;
    self.thePlayer3ImageView.layer.borderWidth = 0;
    self.thePlayer4ImageView.layer.borderWidth = 0;
  } else {
    [self.theSettlementButton setHidden:false];
    if (self.playerPostion == 1) {
      [self.theSettlementButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(DSize(87));
        make.width.mas_equalTo(DSize(80));
        make.height.mas_equalTo(DSize(49));
        make.centerX.equalTo(self.thePlayer1ImageView.mas_centerX);
      }];
      self.thePlayer1ImageView.layer.borderWidth = DSize(4);
    } else if (self.playerPostion == 2) {
      [self.theSettlementButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(DSize(87));
        make.width.mas_equalTo(DSize(80));
        make.height.mas_equalTo(DSize(49));
        make.centerX.equalTo(self.thePlayer2ImageView.mas_centerX);
      }];
      self.thePlayer2ImageView.layer.borderWidth = DSize(4);
    } else if (self.playerPostion == 3) {
      [self.theSettlementButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(DSize(87));
        make.width.mas_equalTo(DSize(80));
        make.height.mas_equalTo(DSize(49));
        make.centerX.equalTo(self.thePlayer3ImageView.mas_centerX);
      }];
      self.thePlayer3ImageView.layer.borderWidth = DSize(4);
    } else if (self.playerPostion == 4) {
      [self.theSettlementButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(DSize(87));
        make.width.mas_equalTo(DSize(80));
        make.height.mas_equalTo(DSize(49));
        make.centerX.equalTo(self.thePlayer4ImageView.mas_centerX);
      }];
      self.thePlayer4ImageView.layer.borderWidth = DSize(4);
    }
  }
}
#pragma mark - action
- (void)onTapSettlementPress:(id)sender {
  [self.theSettlementSubject sendNext:sender];
}
#pragma mark - lzay
- (UIImageView * )thePlayer1ImageView{
  if (!_thePlayer1ImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self);
      make.top.equalTo(self);
      make.width.and.height.mas_equalTo(DSize(56));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(28);
    theView.layer.borderColor = [UIColor colorForHex:@"#FAE55E"].CGColor;
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _thePlayer1ImageView = theView;
  }
  return _thePlayer1ImageView;
}
- (UIImageView * )thePlayer2ImageView{
  if (!_thePlayer2ImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(DSize(96));
      make.top.equalTo(self);
      make.width.and.height.mas_equalTo(DSize(56));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(28);
    theView.layer.borderColor = [UIColor colorForHex:@"#FAE55E"].CGColor;
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _thePlayer2ImageView = theView;
  }
  return _thePlayer2ImageView;
}
- (UIImageView * )thePlayer3ImageView{
  if (!_thePlayer3ImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(DSize(192));
      make.top.equalTo(self);
      make.width.and.height.mas_equalTo(DSize(56));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(28);
    theView.layer.borderColor = [UIColor colorForHex:@"#FAE55E"].CGColor;
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _thePlayer3ImageView = theView;
  }
  return _thePlayer3ImageView;
}
- (UIImageView * )thePlayer4ImageView{
  if (!_thePlayer4ImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(DSize(288));
      make.top.equalTo(self);
      make.width.and.height.mas_equalTo(DSize(56));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(28);
    theView.layer.borderColor = [UIColor colorForHex:@"#FAE55E"].CGColor;
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _thePlayer4ImageView = theView;
  }
  return _thePlayer4ImageView;
}
- (UIView * )thePlayer1SateView{
  if (!_thePlayer1SateView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(44));
      make.height.mas_equalTo(DSize(20));
      make.centerX.equalTo(self.thePlayer1ImageView.mas_centerX);
      make.top.equalTo(self.thePlayer1ImageView.mas_bottom).offset(DSize(-10));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(10);
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _thePlayer1SateView = theView;
  }
  return _thePlayer1SateView;
}
- (UIView * )thePlayer2SateView{
  if (!_thePlayer2SateView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(44));
      make.height.mas_equalTo(DSize(20));
      make.centerX.equalTo(self.thePlayer2ImageView.mas_centerX);
      make.top.equalTo(self.thePlayer2ImageView.mas_bottom).offset(DSize(-10));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(10);
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _thePlayer2SateView = theView;
  }
  return _thePlayer2SateView;
}
- (UIView * )thePlayer3SateView{
  if (!_thePlayer3SateView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(44));
      make.height.mas_equalTo(DSize(20));
      make.centerX.equalTo(self.thePlayer3ImageView.mas_centerX);
      make.top.equalTo(self.thePlayer3ImageView.mas_bottom).offset(DSize(-10));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(10);
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _thePlayer3SateView = theView;
  }
  return _thePlayer3SateView;
}
- (UIView * )thePlayer4SateView{
  if (!_thePlayer4SateView) {
    UIView * theView = [[UIView alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(DSize(44));
      make.height.mas_equalTo(DSize(20));
      make.centerX.equalTo(self.thePlayer4ImageView.mas_centerX);
      make.top.equalTo(self.thePlayer4ImageView.mas_bottom).offset(DSize(-10));
    }];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = DSize(10);
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _thePlayer4SateView = theView;
  }
  return _thePlayer4SateView;
}
- (UILabel * )thePlayer1Label{
  if (!_thePlayer1Label) {
    UILabel * theView = [[UILabel alloc] init];
    [self.thePlayer1SateView addSubview:theView];
      theView.font = AutoMediumPxFont(20);
    theView.textColor = [UIColor whiteColor];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.thePlayer1SateView);
    }];
    _thePlayer1Label = theView;
  }
  return _thePlayer1Label;
}
- (UILabel * )thePlayer2Label{
  if (!_thePlayer2Label) {
    UILabel * theView = [[UILabel alloc] init];
    [self.thePlayer2SateView addSubview:theView];
      theView.font = AutoMediumPxFont(20);
    theView.textColor = [UIColor whiteColor];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.thePlayer2SateView);
    }];
    _thePlayer2Label = theView;
  }
  return _thePlayer2Label;
}
- (UILabel * )thePlayer3Label{
  if (!_thePlayer3Label) {
    UILabel * theView = [[UILabel alloc] init];
    [self.thePlayer3SateView addSubview:theView];
      theView.font = AutoMediumPxFont(20);
    theView.textColor = [UIColor whiteColor];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.thePlayer3SateView);
    }];
    _thePlayer3Label = theView;
  }
  return _thePlayer3Label;
}
- (UILabel * )thePlayer4Label{
  if (!_thePlayer4Label) {
    UILabel * theView = [[UILabel alloc] init];
    [self.thePlayer4SateView addSubview:theView];
      theView.font = AutoMediumPxFont(20);
    theView.textColor = [UIColor whiteColor];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.thePlayer4SateView);
    }];
    _thePlayer4Label = theView;
  }
  return _thePlayer4Label;
}
- (UIButton * )theSettlementButton{
  if (!_theSettlementButton) {
    UIButton * theView = [[UIButton alloc] init];
    [self addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self).offset(DSize(87));
      make.width.mas_equalTo(DSize(80));
      make.height.mas_equalTo(DSize(49));
      make.centerX.equalTo(self.thePlayer1ImageView.mas_centerX);
    }];
    [theView setImage:[PPImageUtil imageNamed:@"ico_settlement_bt"] forState:UIControlStateNormal];
    [theView addTarget:self action:@selector(onTapSettlementPress:) forControlEvents:UIControlEventTouchUpInside];
    _theSettlementButton = theView;
  }
  return _theSettlementButton;
}
@end
