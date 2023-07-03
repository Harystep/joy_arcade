

#import "JKTools.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

#import "JKKeyChain.h"
#import <sys/utsname.h>

// 添加IpAddress
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@implementation JKTools

+ (NSString *)iphoneModel {
    
    // 需要导入头文件：#import <sys/utsname.h>
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"])     return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])     return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])     return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])     return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])     return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])     return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])     return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])     return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])     return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])     return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])     return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])     return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])     return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])     return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])     return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])     return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])     return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])     return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])     return @"iPhone 7";//国行、日版、港行
    if ([platform isEqualToString:@"iPhone9,2"])     return @"iPhone 7 Plus";//港行、国行
    if ([platform isEqualToString:@"iPhone9,3"])     return @"iPhone 7";//美版、台版
    if ([platform isEqualToString:@"iPhone9,4"])     return @"iPhone 7 Plus";//美版、台版
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";//国行(A1863)、日行(A1906)
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";//美版(Global/A1905)
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";//国行(A1864)、日行(A1898)
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";//美版(Global/A1897)
    if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";//国行(A1865)、日行(A1902)
    if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";//美版(Global/A1901
    if ([platform isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"])    return @"iPhone SE (2nd)";
    if ([platform isEqualToString:@"iPhone13,1"])    return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"])    return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"])    return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"])    return @"iPhone 12 Pro Max";

    
    if ([platform isEqualToString:@"iPod1,1"])       return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])       return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])       return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])       return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])       return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])       return @"iPod Touch 6G";
    if ([platform isEqualToString:@"iPod9,1"])       return @"iPod Touch 7G";
    
    if ([platform isEqualToString:@"iPad1,1"])       return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])       return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])       return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])       return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])       return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])       return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])       return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])       return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])       return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])       return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])       return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])       return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])       return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])       return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])       return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])       return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])       return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"])       return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])       return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad11,3"])       return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad11,4"])       return @"iPad Air 3";
    
    if ([platform isEqualToString:@"iPad13,1"])       return @"iPad Air 4";
    if ([platform isEqualToString:@"iPad13,2"])       return @"iPad Air 4";
    
    
    if ([platform isEqualToString:@"iPad2,5"])       return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,6"])       return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])       return @"iPad Mini";
    
    if ([platform isEqualToString:@"iPad4,4"])       return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])       return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])       return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,7"])       return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,8"])       return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,9"])       return @"iPad Mini 3G";
    
    if ([platform isEqualToString:@"iPad5,1"])       return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,2"])       return @"iPad Mini 4G";
    
    if ([platform isEqualToString:@"iPad11,1"])       return @"iPad Mini 5G";
    if ([platform isEqualToString:@"iPad11,2"])       return @"iPad Mini 5G";
    
    if ([platform isEqualToString:@"iPad6,3"])       return @"iPad Pro (9.7)";
    if ([platform isEqualToString:@"iPad6,4"])       return @"iPad Pro (9.7)";

    if ([platform isEqualToString:@"iPad7,3"])       return @"iPad Pro (10.5)";
    if ([platform isEqualToString:@"iPad7,4"])       return @"iPad Pro (10.5)";
    
    if ([platform isEqualToString:@"iPad8,3"])       return @"iPad Pro (11)";
    if ([platform isEqualToString:@"iPad8,4"])       return @"iPad Pro (11)";
    
    if ([platform isEqualToString:@"iPad8,9"])        return @"iPad Pro (11) (2nd)";
    if ([platform isEqualToString:@"iPad8,10"])       return @"iPad Pro (11) (2nd)";
    
    if ([platform isEqualToString:@"iPad6,7"])       return @"iPad Pro (12.9)";
    if ([platform isEqualToString:@"iPad6,8"])       return @"iPad Pro (12.9)";
    
    if ([platform isEqualToString:@"iPad7,1"])       return @"iPad Pro (12.9) (2nd)";
    if ([platform isEqualToString:@"iPad7,2"])       return @"iPad Pro (12.9) (2nd)";
    
    if ([platform isEqualToString:@"iPad8,7"])       return @"iPad Pro (12.9) (3nd)";
    if ([platform isEqualToString:@"iPad8,8"])       return @"iPad Pro (12.9) (3nd)";
    
    if ([platform isEqualToString:@"iPad8,11"])       return @"iPad Pro (12.9) (4nd)";
    if ([platform isEqualToString:@"iPad8,12"])       return @"iPad Pro (12.9) (4nd)";
    
    if ([platform isEqualToString:@"i386"])          return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])        return @"iPhone Simulator";
    return platform;
}

+ (NSString *)timeStampToString:(NSString *)timeStamp dateFormat:(NSString *)dateFormat{
    NSTimeInterval interval = [timeStamp doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    return [formatter stringFromDate: date];
}

+ (NSString *)dateStringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = dateFormat;
    NSString *stringDate = [fmt stringFromDate:date];
    return stringDate;
}

+ (NSString *)handelString:(NSString *)string{
    NSString *str = [NSString stringWithFormat:@"%@",string];
    if ([str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"] || str == nil){
        return @"";
    }else{
        return str;
    }
}

+ (NSString *)amountFormatter:(NSString *)amount {
    if(!amount)return @"";
    NSInteger cpValue = amount.integerValue;
    if(cpValue % 100 == 0) return [NSString stringWithFormat:@"%.0f", cpValue/100.0];
    if(cpValue % 10 == 0) return [NSString stringWithFormat:@"%.1f", cpValue/100.0];
    return [NSString stringWithFormat:@"%.2f", cpValue/100.0];
}

+ (NSString *)discountFormatter:(NSString *)discount {
    if(!discount)return @"";
    NSString *discountStr = [NSString stringWithFormat:@"%@", @(discount.doubleValue * 10)];
    return [self amountFormatter:discountStr];
}

+ (NSMutableAttributedString *)attributeWithText:(NSString *)text attrText:(NSString *)attrText attributes:(NSDictionary *)attributes {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:attrText];
    [attStr addAttributes:attributes range:range];
    return attStr;
}

// 获取16位随机字符串
+ (NSString *)getRandomString{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//  对字符串进行MD5加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr,(CC_LONG)strlen(cStr), result); // This is the md5 call
    // X 代表大写，x代表小写
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (BOOL)isEmptyString:(NSString *)string{
    if(string && [string isKindOfClass:[NSNumber class]])return NO;
    if (string == nil || string.length<1 || [string isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}





static NSString *const uuidKey = @"uuidKey";
+ (NSString *)idfv {
    NSString * currentDeviceUUIDStr = [JKKeyChain load:uuidKey];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""]) {
        currentDeviceUUIDStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [JKKeyChain save:uuidKey data:currentDeviceUUIDStr];
    }
    return currentDeviceUUIDStr;
}


+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}



+ (NSAttributedString *)attributedTextArray:(NSArray *)texts
                                 textColors:(NSArray *)colors
                                  textfonts:(NSArray *)fonts
                                lineSpacing:(CGFloat)l_spacing{
    if(texts.count == 0){
        return nil;
    }
    
    NSMutableAttributedString *resultAttributedStr = [[NSMutableAttributedString alloc] init];
    
    for(int i=0; i<texts.count; i++)
    {
        NSString *text = texts[i];
        NSMutableAttributedString *mAttributedStr = [[NSMutableAttributedString alloc] initWithString:text];
        [mAttributedStr addAttribute:NSForegroundColorAttributeName value:colors[i] range:NSMakeRange(0, text.length)];
        [mAttributedStr addAttribute:NSFontAttributeName value:fonts[i] range:NSMakeRange(0, text.length)];
        [resultAttributedStr appendAttributedString:mAttributedStr];
    }
    
    if(l_spacing>0){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = l_spacing;
        [resultAttributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, resultAttributedStr.length)];
    }
    
    return resultAttributedStr;
    
}





+ (NSDictionary *)parametersWithUrl:(NSString *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:[NSURL URLWithString:url] resolvingAgainstBaseURL:NO];
    NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in urlComponents.queryItems) {
        [itemDict setValue:item.value forKey:item.name];
    }
    return [itemDict copy];

}



/**
 *  获取十六进制颜色
 *
 *  @param hexColor 十六进制
 *  @param alpha    透明度
 *
 *  @return color
 */
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    if (hexColor.length > 6) {
         hexColor = [hexColor substringFromIndex:1];
    }else{
         //  设置默认值
         hexColor = @"333333";
    }
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:alpha];
}

/*
 control 是要设置渐变字体的控件   bgVIew是control的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientControl:(UIControl *)control bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{

    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = control.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = control.layer;
    control.frame = gradientLayer1.bounds;
}

/// 写入文件 数组的形式
+ (void)writeToFileWithDataArr:(NSArray *)dataArr fileName:(NSString *)fileName{
    if (fileName.length < 0 || fileName == nil) {
        return;
    }
//    NSString *filePath = [XMUserDefaultsMannage shareInstance].userId?[XMUserDefaultsMannage shareInstance].userId:[self getAdvertisingIdentifier];
    NSString *filePath  = @"matchid001";
    filePath = [NSString stringWithFormat:@"/%@_%@",filePath,fileName];
    NSString *documentPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingString:filePath];
    if (dataArr.count > 0) {
        [dataArr writeToFile:documentPath atomically:YES];
    } else {
        if ([[NSFileManager defaultManager]fileExistsAtPath:documentPath]) {
            [[NSFileManager defaultManager]removeItemAtPath:documentPath error:nil];
        }
    }
}
/// 根据文件名取出文件 返回数组
+ (NSArray *)readDataArrFromFileName:(NSString *)fileName{
    //读取数组
    NSArray *tempArr = [NSArray array];
    if (fileName.length < 0 || fileName == nil) {
        
        return tempArr;
    }
//    NSString *filePath = [XMUserDefaultsMannage shareInstance].userId?[XMUserDefaultsMannage shareInstance].userId:[self getAdvertisingIdentifier];
    NSString *filePath  = @"matchid001";
    filePath = [NSString stringWithFormat:@"/%@_%@",filePath,fileName];
    NSString *documentPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingString:filePath];
    //判断该文件夹是否存在
    if ([[NSFileManager defaultManager]fileExistsAtPath:documentPath]) {
        tempArr = [NSArray arrayWithContentsOfFile:documentPath];
    }
    return tempArr;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
        {
        NSLog(@"json解析失败：%@",err);
        return nil;
        }
    return dic;
}





+ (NSString *)getBaseUrl{
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] valueForKey:JKBaseApiURLKey];
    baseUrl = [JKTools handelString:baseUrl];
    if ([baseUrl isEqualToString:@""]) {
        baseUrl = JKDefaultBaseApiURL;
    }
    return baseUrl;
}
+ (NSString *)getWebUrl{
    NSString *webUrl = [[NSUserDefaults standardUserDefaults] valueForKey:JKWebURLKey];
    webUrl = [JKTools handelString:webUrl];
    return webUrl;
}


+ (UIViewController *)topViewController {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *resultVC = [self topViewController: window.rootViewController];
    while (resultVC.presentedViewController) {
        resultVC = [self topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

// 判断是否是纯数字
+ (BOOL)checkIsNumText:(NSString *)str{
    if (!str) {
        return NO;
    }
    NSScanner *scan = [NSScanner scannerWithString:str];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//加密
+ (NSString *)encryptByDES:(NSString *)textStr key:(NSString *)key; {
    // 密文
    NSString *ciphertext = nil;
    
    // 加密后的数据
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMove = 0;
    
    dataOutAvailable = (textStr.length + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
    // 将已开辟内存空间buffer的首1个字节的值设为0
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, // 操作名称：加密
                                          kCCAlgorithmDES, // 加密算法
                                          kCCOptionPKCS7Padding | kCCOptionECBMode, // 填充模式，ECB模式
                                          key.UTF8String, // 加密秘钥
                                          kCCKeySizeDES, // 秘钥大小，和加密算法一致
                                          NULL, // 初始向量：ECB模式为空
                                          textStr.UTF8String, // 加密的明文
                                          (size_t)textStr.length, // 加密明文的大小
                                          dataOut, // 密文的接受者
                                          dataOutAvailable, // 预计密文的大小
                                          &dataOutMove); // 加密后密文的实际大小
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:dataOut length:(NSUInteger)dataOutMove];
        // 将data转为16进制字符串
        ciphertext = [self convertDataToHexStr:data];
    }
    return ciphertext;
}


//解密
+ (NSString *)decryptByDES:(NSString *)textStr key:(NSString *)key{
    // 将16进制转为data
//    NSData* cipherData =[self convertHexStrToData:cipherText];
    // base 64 编码
    NSData *cipherData = [[NSData alloc]initWithBase64EncodedString:textStr options:0];
    // 解密后的数据
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMove = 0;
    
    dataOutAvailable = (cipherData.length + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc(dataOutAvailable * sizeof(uint8_t));
    // 将已开辟内存空间buffer的首1个字节的值设为0
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          key.UTF8String,
                                          kCCKeySizeDES,
                                          NULL,
                                          cipherData.bytes,
                                          (size_t)cipherData.length,
                                          dataOut,
                                          dataOutAvailable,
                                          &dataOutMove);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:dataOut length:(NSUInteger)dataOutMove];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return plainText;
}

//将NSData转成16进制
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%02x", (dataBytes[i]) & 0xff];
            [string appendString:hexStr];
        }
    }];
    return string;
}

//将16进制字符串转成NSData
+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] init];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        // 扫描字符串
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

@end
