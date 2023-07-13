#import "PPChatMessageTableViewCell.h"
#import "PPChatMessageDataModel.h"
#import "Masonry.h"

#import "AppDefineHeader.h"

@interface PPChatMessageTableViewCell ()
@property (nonatomic, weak) UIView * theContentView;
@property (nonatomic, weak) UILabel * theContentLabel;
@end
@implementation PPChatMessageTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (PPChatMessageDataModel * )targetModle {
  return (PPChatMessageDataModel * )self.dataModel;
}
- (void)loadHomeDataModel:(PPHomeBaseDataModel *)model {
  [super loadHomeDataModel:model];
  self.contentView.backgroundColor = [UIColor clearColor];
  self.backgroundColor = [UIColor clearColor];
  self.theContentLabel.attributedText = [self targetModle].chatMessage;
}
#pragma mark - lazy UI
- (UIView * )theContentView{
  if (!_theContentView) {
    UIView * theView = [[UIView alloc] init];
    [self.contentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.contentView);
      make.left.equalTo(self.contentView);
      make.right.equalTo(self.contentView);
      make.bottom.equalTo(self.contentView).offset(-SF_Float(10));
    }];
    theView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    theView.layer.masksToBounds = true;
    theView.layer.cornerRadius = SF_Float(16);
    _theContentView = theView;
  }
  return _theContentView;
}
- (UILabel * )theContentLabel{
  if (!_theContentLabel) {
    UILabel * theView = [[UILabel alloc] init];
    [self.contentView addSubview:theView];
    [theView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.theContentView).offset(SF_Float(22));
      make.top.equalTo(self.theContentView).offset(SF_Float(15));
      make.right.equalTo(self.theContentView.mas_right).offset(SF_Float(-22));
      make.bottom.equalTo(self.theContentView.mas_bottom).offset(SF_Float(-15));
    }];
    _theContentLabel = theView;
  }
  return _theContentLabel;
}
@end
