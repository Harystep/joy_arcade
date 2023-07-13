#import "PPGameActionMoreModel.h"
#import "PPImageUtil.h"
@implementation PPGameActionMoreModel
- (instancetype)initWithActionType:(SDGameActionType)type
{
  self = [super init];
  if (self) {
    self.actionType = type;
    self.doneSubject = [RACSubject subject];
    self.isEnable = true;
    [self configData];
  }
  return self;
}
- (void)configData {
  switch (self.actionType) {
    case gameActionCoin:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_1"];
      self.disableButtonImage = [PPImageUtil imageNamed:@"ico_func_2_disable"];
      break;
    case gameActionCharge:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_2"];
      break;
    case gameActionCharter:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_3"];
      break;
    case gameActionLockMachine:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_4"];
      break;
    case gameActionCustomService:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_5"];
      break;
    case gameActionSetting:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_6"];
      break;
    case gameActionRule:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_7"];
      break;
    case gameActionCriticalMachine:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_8"];
      break;
    case gameActionSettlement:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_9"];
      self.disableButtonImage = [PPImageUtil imageNamed:@"ico_func_1_disable"];
      break;
    case gameActionExit:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_f_10"];
      break;
    case gameActionExchagne:
      self.buttonImage = [PPImageUtil imageNamed:@"ico_saint_exchange"];
      break;
    default:
      break;
  }
}
@end
