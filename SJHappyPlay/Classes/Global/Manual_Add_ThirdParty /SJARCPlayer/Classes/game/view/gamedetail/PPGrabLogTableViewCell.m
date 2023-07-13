#import "PPGrabLogTableViewCell.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPGrabLogDataModel.h"
#import "UIImageView+WebCache.h"
#import "AppDefineHeader.h"

@interface PPGrabLogTableViewCell ()
@property (nonatomic, weak) UIImageView * theAvatarImageView;
@property (nonatomic, weak) UILabel * theNameLabel;
@property (nonatomic, weak) UILabel * theDetailLabel;
@end
@implementation PPGrabLogTableViewCell
- (PPGrabLogDataModel * )targetModel {
  return (PPGrabLogDataModel * )self.dataModel;
}
- (void)loadHomeDataModel:(PPHomeBaseDataModel *)model {
  [super loadHomeDataModel:model];
  [self.theAvatarImageView sd_setImageWithURL:[NSURL URLWithString: [self targetModel].url]];
  self.theNameLabel.text = [self targetModel].name;
  self.theDetailLabel.text = [self targetModel].createTime;
}
#pragma mark - layz UI
- (UIImageView * )theAvatarImageView{
  if (!_theAvatarImageView) {
    UIImageView * theView = [[UIImageView alloc] init];
    [self.contentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.and.height.mas_equalTo(SF_Float(96));
      make.centerY.equalTo(self.contentView);
      make.left.equalTo(self.contentView).offset(SF_Float(50));
    }];
    theView.layer.cornerRadius = SF_Float(48);
    theView.layer.masksToBounds = true;
    theView.contentMode = UIViewContentModeScaleAspectFit;
    _theAvatarImageView = theView;
  }
  return _theAvatarImageView;
}
- (UILabel * )theNameLabel{
  if (!_theNameLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.contentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.theAvatarImageView.mas_right).offset(SF_Float(32));
      make.bottom.equalTo(self.contentView.mas_centerY).offset(SF_Float(-7));
    }];
      theView.font = AutoPxFont(28);
    theView.textColor = [UIColor colorForHex:@"#333333"];
    _theNameLabel = theView;
  }
  return _theNameLabel;
}
- (UILabel * )theDetailLabel{
  if (!_theDetailLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.contentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.theAvatarImageView.mas_right).offset(SF_Float(32));
      make.top.equalTo(self.contentView.mas_centerY).offset(SF_Float(7));
    }];
      theView.font = AutoPxFont(24);
    theView.textColor = [UIColor colorForHex:@"#999999"];
    _theDetailLabel = theView;
  }
  return _theDetailLabel;
}
@end
