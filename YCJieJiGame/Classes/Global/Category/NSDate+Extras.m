//
//  NSDate+Extras.m
//  HJCommunity
//
//  Created by John on 2021/6/22.
//

#import "NSDate+Extras.h"
/// 时间格式全局变量
static NSDateFormatter *g_XMFormat;

@implementation NSDate (Extras)
#pragma - public
#pragma mark - 日期与字符串互相转换
+ (NSString *)currentTime {
    return [self stringFromDate:[NSDate date] dateFormat:@"HH:mm:ss"];
}

/// NSString -> NSDate  yyyy-MM-dd
+ (NSDate *)defaultDataFromDataString:(NSString *)dateString {
    return [self dataFromDataString:dateString dateFormat:@"yyyy-MM-dd"];
}

/// NSString -> NSDate yyyy-MM-dd HH:mm
+ (NSDate *)dataFromDataString:(NSString *)dateString {
    return [self dataFromDataString:dateString dateFormat:@"yyyy-MM-dd HH:mm"];
}

/// NSString -> NSDate 自己带格式
+ (NSDate *)dataFromDataString:(NSString *)dateString dateFormat:(NSString *)formatterStr {
    if (dateString.length <= 0) {
        return nil;
    }
    NSDateFormatter* fmt = [self dateFormatter];
    fmt.dateFormat = formatterStr;
    if (!formatterStr) {
        fmt.dateFormat = @"yyyy-MM-dd HH:ss";
    }
    return [fmt dateFromString:dateString];
}

/// NSDate -> NSStrng  时间格式：yyyy-MM-dd HH:mm
+ (NSString *)stringFromDate:(NSDate *)date {
    return [self stringFromDate:date dateFormat:@"yyyy-MM-dd HH:mm"];
}

// /// NSDate -> NSStrng  格式自定义
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
    NSDateFormatter *fmt = [self dateFormatter];
    fmt.dateFormat = dateFormat;
    if (dateFormat.length <= 0) {
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return [fmt stringFromDate:date];
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+ (NSString *)weekdayIndexStringFromDate:(NSDate *)date {
    return [self stringFromDate:date dateFormat:@"e"];
}

/// 日期 转 星期
+ (NSString *)weekdayStringFromDate:(NSDate *)date {
    NSString *weekIndx = [self stringFromDate:date dateFormat:@"e"];
    NSArray *weekdays = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    NSString *weekStr = weekdays[0];
    NSInteger indx = weekIndx.integerValue;
    if (indx <= 7) {
        weekStr = weekdays[indx-1];
    }
    return weekStr;
}

/// 字符串日期 转 星期
+ (NSString *)weekdayStringFromDateString:(NSString *)dateString {
    if (dateString.length < 10) {
        return nil;
    }
    NSDateFormatter *format = [self dateFormatter];
    NSString *temDateStr = [dateString substringToIndex:10];
    if ([temDateStr containsString:@"-"]) {
        format.dateFormat = @"yyyy-MM-dd";
    } else {
        format.dateFormat = @"yyyy/MM/dd";
    }
    NSDate *date = [format dateFromString:temDateStr];
    return [self weekdayStringFromDate:date];
}

+ (NSString *)weekIndexStringAtOneYear {
    return [self stringFromDate:[NSDate date] dateFormat:@"w"];
}

#pragma mark - 时间戳 和 显示处理
// 时间显示内容 今天、昨天、明天、月日
+ (NSString *)dateMDDisplayString:(long long) miliSeconds {
    return [self dateDisplayString:miliSeconds format:@"MM/dd"];
}

//时间显示内容 年-月-日 昨天 今天 明天
+ (NSString *)dateYMDDisplayString:(long long)miliSeconds {
    return [self dateDisplayString:miliSeconds format:@"yyyy-MM-dd"];
}

// 时间显示内容 今天、昨天、明天、月日
+ (NSString *)dateDisplayString:(long long)miliSeconds format:(NSString *)format {
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSString *dateStr = @"";
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    if (nowCmps.month == myCmps.month && nowCmps.year == myCmps.year) {
        if (nowCmps.day == myCmps.day ) {
            dateStr = @"今天";
        } else if(myCmps.day - nowCmps.day == 1) {
            dateStr = @"明天";
        }else if(myCmps.day - nowCmps.day == -1) {
            dateStr = @"昨天";
        }
    }
    
    NSDateFormatter *ymdDateFmt = [[NSDateFormatter alloc ] init];
    ymdDateFmt.dateFormat = format;
    
    return [NSString stringWithFormat:@"%@ %@", [ymdDateFmt stringFromDate:myDate], dateStr];
}


+ (NSString *)timestampToDateAndWeek:(long long)miliSeconds format:(NSString *)format{
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];

    NSString *weekStr = [self weekdayStringFromDate:myDate];
    
    NSDateFormatter *ymdDateFmt = [[NSDateFormatter alloc ] init];
    ymdDateFmt.dateFormat = format;
    
    return [NSString stringWithFormat:@"%@ %@", [ymdDateFmt stringFromDate:myDate], weekStr];
    
    
}

+ (NSString *)timestampToDate:(long long)miliSeconds format:(NSString *)format{
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];

    NSDateFormatter *ymdDateFmt = [[NSDateFormatter alloc ] init];
    ymdDateFmt.dateFormat = format;
    
    return [NSString stringWithFormat:@"%@", [ymdDateFmt stringFromDate:myDate]];
    
}

/// 时间戳转日期
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)miliSeconds {
    return [NSDate dateWithTimeIntervalSince1970:miliSeconds/1000.0f];
}

// 获取当前时间 - 是精确到毫秒
+ (NSString *)timeString {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    return [NSString stringWithFormat:@"%.0f", time];
}

+ (NSString *)timeStringFromInterval:(NSTimeInterval)interval {
    NSInteger temInterval = (NSInteger)interval;
    NSInteger seconds = temInterval % 60;
    NSInteger minutes = (temInterval / 60) % 60;
    NSInteger hours = (temInterval / 3600);
    NSString *timeStr = nil;
    if (hours > 0) {
        timeStr = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hours, minutes, seconds];
    } else {
        timeStr = [NSString stringWithFormat:@"%02zd:%02zd", minutes, seconds];
    }
    
    return timeStr;
}

+ (NSString *)fuzzyDate:(NSDate *)date {
    NSDate *nowDate = [NSDate date];
    NSUInteger timeInterval = [date timeIntervalSinceDate:nowDate]; // 两个时间差
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *nowDateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:nowDate];
    
    NSDateComponents *selfDateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:date];
    
    if (timeInterval < 5 * 60) {
        return @"刚刚";
    } else if (timeInterval < 60 * 60) {
        return [NSString stringWithFormat:@"%lu分钟前", timeInterval / 60];
    } else if (timeInterval < [self oneDayTimeInterval] && nowDateComponents.day == selfDateComponents.day) {
        return [NSString stringWithFormat:@"%lu小时前", timeInterval / (60 * 60)];
    } else if (timeInterval < [self oneDayTimeInterval] && nowDateComponents.day != selfDateComponents.day) {
        return @"昨天";
    } else if (([nowDateComponents weekOfMonth] == [selfDateComponents weekOfMonth]) && ([nowDateComponents weekOfYear] == [selfDateComponents weekOfYear])) {
        NSArray* weekdays = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
        return weekdays[selfDateComponents.weekday];
    } else if ([date timeIntervalSince1970] == 0) {
        return nil;
    } else {
        NSDateFormatter* dateFormatter = [self dateFormatter];
        [dateFormatter setDateFormat:@"yy-MM-dd"];
        return [dateFormatter stringFromDate:date];
    }
}

#pragma mark - 日期计算
///获取今天之前的第几天日期
+ (NSDate *)dateBeforNow:(NSInteger)days {
    return [NSDate dateWithTimeIntervalSinceNow:(-days * [self oneDayTimeInterval])];
}

///获取今天之后的第几天日期
+ (NSDate *)dateAfterNow:(NSInteger)days {
    return [NSDate dateWithTimeIntervalSinceNow:(days * [self oneDayTimeInterval])];
}

+ (NSTimeInterval)theFirstSecondOfToday {
    NSTimeInterval nowTimeInterval = [[NSDate date]timeIntervalSince1970];
    NSInteger oneDaySeconds = [self oneDayTimeInterval];
    return nowTimeInterval - ((NSInteger)nowTimeInterval) % oneDaySeconds - 8 * [self oneHourTimeInterval];
}

//日期相同就是同一天 日期差一天就是差一天，与是否满24小时无关
+ (NSInteger)daysBetweenWith:(NSDate *)fromDate otherDate:(NSDate *)toDate {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                 fromDate:fromDate
                                                                   toDate:toDate
                                                                  options:NSCalendarWrapComponents];
    return components.day;
}

/// 两个日期相差秒数
+ (NSInteger)timeIntervalBetweenWith:(NSDate *)fromDate otherDate:(NSDate *)toDate {
    return [fromDate timeIntervalSinceDate:toDate];
}
#pragma mark - other
/// 判断日期是否今天
+ (BOOL)dateStringIsToday:(NSString *)dateString {
    if (dateString.length < 10) {
        return nil;
    }
    NSString *temDateStr = [dateString substringToIndex:10];
    NSDate *date = [self defaultDataFromDataString:temDateStr];
    return [[NSCalendar currentCalendar]isDateInToday:date];
}

/// 根据生日计算年龄
+ (CGFloat)ageForBirthday:(NSDate *)birthdayDate {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval time = [currentDate timeIntervalSinceDate:birthdayDate];
    CGFloat age = ((CGFloat)time)/[self oneYearTimeInterval];
    return age;
}

/// 获取从今天开始的一周日期时间
+ (NSArray *)oneWeekDateStringAroundNow:(NSString *)dateFormat direction:(BOOL)forward {
    NSDateFormatter *format = [self dateFormatter];
    format.dateFormat = dateFormat;
    NSMutableArray *dateArr = [NSMutableArray array];
    NSTimeInterval oneDayTimeInterval = [self oneDayTimeInterval];
    for (int idx = (forward ? 0 : 6); (forward ? idx <= 6 : idx >= 0); (forward ? idx++ : idx--)) {
        NSTimeInterval temTimeInterval = oneDayTimeInterval * idx;
        NSDate *temDate = [NSDate dateWithTimeIntervalSinceNow:(forward ? temTimeInterval : -temTimeInterval)];
        [dateArr addObject:[format stringFromDate:temDate]];
    }
    return dateArr;
}

+ (NSInteger)daysInMonthFromDate:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days  = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return days.length;
}

#pragma mark -
/// 时间格式单例
+ (NSDateFormatter *)dateFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_XMFormat = [[NSDateFormatter alloc]init];
//        g_format.timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"]; /// 东八区时间，即北京时区
    });
    return g_XMFormat;
}

#pragma mark - const
///  一小时的秒数
+ (NSTimeInterval)oneHourTimeInterval {
    return 86400.0f; // 24 * 60
}

///  一天的秒数
+ (NSTimeInterval)oneDayTimeInterval {
    return 86400.0f; // 24 * 60 * 60
}

///  一年的秒数
+ (NSTimeInterval)oneYearTimeInterval {
    return 31536000.0f; // 3600 * 24 * 365
}

+ (NSArray *)oneWeekDayString {
    return @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
}
@end
