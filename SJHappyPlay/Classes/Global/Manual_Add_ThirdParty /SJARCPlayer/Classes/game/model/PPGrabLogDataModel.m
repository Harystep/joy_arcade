#import "PPGrabLogDataModel.h"
#import "PPGrabLogTableViewCell.h"
#import "AppDefineHeader.h"

@implementation PPGrabLogDataModel
@synthesize hegiht_size_cell = _hegiht_size_cell;
- (NSString *)CellIdentifier
{
    return [PPGrabLogTableViewCell getCellIdentifier];
}
- (CGFloat)hegiht_size_cell
{
    return SF_Float(136);
}
+ (NSDictionary * )mj_replacedKeyFromPropertyName
{
    return @{@"g_id":@"id"};
}
- (NSString * )createTime{
  return [self compareCurrentTime:_createTime];
}
-(NSString *) compareCurrentTime:(NSString *)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}
@end
