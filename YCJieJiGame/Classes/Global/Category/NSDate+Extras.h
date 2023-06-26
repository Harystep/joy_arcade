//
//  NSDate+Extras.h
//  HJCommunity
//
//  Created by John on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extras)

#pragma mark - 日期与字符串互相转换
/**
    当前时间：hh:mm:ss
    @return 时间字符串
 */
+ (NSString *)currentTime;

/**
    字符串转日期：NSString -> NSdate
    @param dateString 日期字符串，格式：yyyy-MM-dd
    @return 日期
*/
+ (NSDate *)defaultDataFromDataString:(NSString *)dateString;

/**
    字符串转日期：NSString -> NSdate
    @param dateString 日期字符串，格式：yyyy-MM-dd HH:ss
    @return 日期
*/
+ (NSDate *)dataFromDataString:(NSString *)dateString;

/**
    字符串转日期：NSString -> NSdate
    日期字符串格式任意，比如： yyyy-MM-dd HH:ss EEEE  ->  2020-03-30 12:00 星期一
    默认格式：yyyy-MM-dd HH:ss
    格式参数：年：  y or yyy or yyyy:2022 yy:22
            月：  M:3 MM 03 MMM3月 MMMM三月
            日：  d:3 dd:03 D:300，这一年中的第几天
            时：  h:3 hh:03 H:15，24小时制 HH:15
            分：  m:3 mm:03
            秒：  s:3 ss:03
            周：  E:Fri EEEE:Friday EEEEE:四 e:1～7，从周日算起 ee:01 eee:Fri eeee:Friday eeeee:F w:1，表示一年中的第几周 ww:01
            区：  z:GMT+8 zzzz:中国标准时间
            午：  ah:下午5 aH:下午17 am:下午53，单位分 as:下午52，单位秒
    参数外链接：http://www.unicode.org/reports/tr35/tr35-25.html
    @param dateString 日期字符串
    @param formatter 日期格式
    @return 日期
*/
+ (NSDate *)dataFromDataString:(NSString *)dateString dateFormat:(NSString *)formatter;

/**
    日期转字符串：NSDate -> NSString
    @param date 日期
    @return 日期字符串。输出时间格式：yyyy-MM-dd HH:mm
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
    日期转字符串：NSDate -> NSString
    @param date 日期
    @param dateFormat 输出日期格式，参照xm_dataFromDataString:dateFormat:
    @return 日期字符串。默认输出时间格式：yyyy-MM-dd HH:mm
 */
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

/**
 GTM时区 +8
 
 */
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

#pragma mark - 从日期获取周几
/**
   日期转星期索引：Date -> Index
   @param date 日期
   @return 日期索引字符串，从周日开始，1～7
*/
+ (NSString *)weekdayIndexStringFromDate:(NSDate *)date;

/**
    日期转星期：Date -> Week
    @param date 日期
    @return 日期字符串，星期天、星期一
 */
+ (NSString*)weekdayStringFromDate:(NSDate *)date;

/**
    字符串日期转星期：String -> Week
    @param dateString 日期字符串，格式以右边格式开头： yyyy-MM-dd or yyyy-MM-dd
    @return 日期字符串
*/
+ (NSString *)weekdayStringFromDateString:(NSString *)dateString;

/**
   当前日期在一年里第几周：() -> Index
   @return 第几周字符串，从1开始
*/
+ (NSString *)weekIndexStringAtOneYear;

#pragma mark - 时间戳 和 显示处理
/**
    时间戳转字符串: MiliSeconds -> String
    @param miliSeconds  时间戳，精确到毫秒
    @return 日期字符串。输出：今天、昨天、明天、月/日。
 */
+ (NSString *)dateMDDisplayString:(long long) miliSeconds;

/**
    时间戳转字符串：MiliSeconds -> String
    @param miliSeconds  时间戳，精确到毫秒
    @return 日期字符串。输出：今天、昨天、明天、年-月-日。
*/
+ (NSString *)dateYMDDisplayString:(long long) miliSeconds;

/**
    时间戳转字符串: MiliSeconds -> String
    @param miliSeconds  时间戳，精确到毫秒
    @format miliSeconds  输出格式，右边某一项：今天、昨天、明天、format。format参照xm_dataFromDataString:dateFormat:
    @return 日期字符串。输出：今天、昨天、明天、format。
*/
+ (NSString *)dateDisplayString:(long long)miliSeconds format:(NSString *)format;

/**
    时间戳转日期加星期: MiliSeconds -> Date Week
    @param miliSeconds  时间戳，精确到毫秒
    @format miliSeconds   format  星期x 。format参照xm_dataFromDataString:dateFormat:
    @return 日期字符串。输出：format  星期x
*/
+ (NSString *)timestampToDateAndWeek:(long long)miliSeconds format:(NSString *)format;

/**
    时间戳转日期: MiliSeconds -> Date Week
    @param miliSeconds  时间戳，精确到毫秒
    @format miliSeconds   format 。format参照xm_dataFromDataString:dateFormat:
    @return 日期字符串。输出：format
*/
+ (NSString *)timestampToDate:(long long)miliSeconds format:(NSString *)format;

/**
    时间戳转日期：MiliSeconds -> date
    @param miliSeconds  时间戳，精确到毫秒
    @return 日期。
 */
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)miliSeconds;

/**
    获取当前时间戳
    @return 时间戳字符串，精确到毫秒
 */
+ (NSString *)timeString;

/**
   时间秒数转字符串
   @param interval  秒数
   @return 时间字符串
*/
+ (NSString *)timeStringFromInterval:(NSTimeInterval)interval;


#pragma mark - 日期计算
/**
    获取今天之前的第几天日期
    @param days  今天前第几天
    @return 日期
*/
+ (NSDate *)dateBeforNow:(NSInteger)days;

/**
    获取今天之后的第几天日期
    @param days  今天后第几天
    @return 日期
*/
+ (NSDate *)dateAfterNow:(NSInteger)days;

/**
    获取当天第一秒的时间戳
    以东八区时区为准
    @return 时间戳
*/
+ (NSTimeInterval)theFirstSecondOfToday;

/**
    两个日期相差几天
    @param fromDate  开始日期
    @param toDate    结束日期
    @return 相差天数
 */
+ (NSInteger)daysBetweenWith:(NSDate *)fromDate otherDate:(NSDate *)toDate;

/**
    两个日期相差多少秒
    @param fromDate  开始日期
    @param toDate    结束日期
    @return 相差秒数
 */
+ (NSInteger)timeIntervalBetweenWith:(NSDate *)fromDate otherDate:(NSDate *)toDate;
#pragma mark - other
/**
    判断日期是不是今天
    @param dateString 日期字符串，格式以右边格式开头： yyyy-MM-dd or yyyy-MM-dd
    @return YES：今天，NO：不是今天
*/
+ (BOOL)dateStringIsToday:(NSString *)dateString;

/**
    根据出生日期计算年龄，小数。
    例如：2020/3/3出生，现在2021/4/3，结果1.1左右
    @param birthdayDate 出生日期
    @return 岁数，小数
 */
+ (CGFloat)ageForBirthday:(NSDate *)birthdayDate;

/**
    获取从今天前后一周日期时间
    @param dateFormat  时间格式。format参照xm_dataFromDataString:dateFormat:
    @param forward     时间获取方向。YES:从今天开始后一周 NO：前一周到今天
    @return 日期字符串数组。
*/
+ (NSArray *)oneWeekDateStringAroundNow:(NSString *)dateFormat direction:(BOOL)forward;

/**
    指定日期里当月的天数
    @param date  时间格式。format参照xm_dataFromDataString:dateFormat:
    @return 当月的天数。
*/
+ (NSInteger)daysInMonthFromDate:(NSDate*)date;
#pragma mark - dateFormatter
/**
   单例日期格式转换
   @return 时间字符串
*/
+ (NSDateFormatter *)dateFormatter;


#pragma mark - const
/**
   一小时的秒数，没有计算
   @return 一小时的秒数
*/
+ (NSTimeInterval)oneHourTimeInterval;

/**
   一天的秒数，没有计算
   @return 一天的秒数
*/
+ (NSTimeInterval)oneDayTimeInterval;

/**
   一年的秒数。一年365天，没有计算
   @return 一年的秒数
*/
+ (NSTimeInterval)oneYearTimeInterval;

/**
   一周字符串，从周天开始
   @return 一周字符串
*/
+ (NSArray *)oneWeekDayString;

@end

NS_ASSUME_NONNULL_END
