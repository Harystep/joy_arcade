#import "PPBaseTcpData.h"
#import "MJExtension.h"
#import "AppDefineHeader.h"
@implementation PPBaseTcpData
- (instancetype)init{
    return [self initWithVmc_no:nil cmd:nil];
}
- (instancetype)initWithVmc_no:(NSString *)vmc_no
{
    return [self initWithVmc_no:vmc_no cmd:nil];
}
- (instancetype)initWithVmc_no:(NSString *)vmc_no cmd:(NSString *)cmd_s
{
    self = [super init];
    if (self) {
        _vmc_no = vmc_no;
        self.cmd = cmd_s;
    }
    return self;
}
+ (NSArray<NSString *> *)mj_ignoredPropertyNames
{
    NSMutableArray *ignoreArray = [NSMutableArray arrayWithCapacity:0];
    [ignoreArray addObject:@"taskKey"];
    [ignoreArray addObject:@"debugDescription"];
    [ignoreArray addObject:@"description"];
    [ignoreArray addObject:@"hash"];
    [ignoreArray addObject:@"superclass"];
    return ignoreArray;
}
- (NSData * )getSendData
{
    NSString * send_string = [self mj_JSONString];
    DLog(@"will write %@",send_string);
    NSData *data3 = [send_string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *data = [NSMutableData new];
    NSData *data1 = [@"doll" dataUsingEncoding:NSUTF8StringEncoding];
    int i = 4+4+(int)data3.length;
    NSData *data2 = [NSData dataWithBytes: &i length: sizeof(i)];
    data2 = [self dataWithReverse:data2];
    [data appendData:data1];
    [data appendData:data2];
    [data appendData:data3];
    return [data copy];
}
- (NSData *)dataWithReverse:(NSData *)srcData
{
    NSUInteger byteCount = srcData.length;
    NSMutableData *dstData = [[NSMutableData alloc] initWithData:srcData];
    NSUInteger halfLength = byteCount / 2;
    for (NSUInteger i=0; i<halfLength; i++) {
        NSRange begin = NSMakeRange(i, 1);
        NSRange end = NSMakeRange(byteCount - i - 1, 1);
        NSData *beginData = [srcData subdataWithRange:begin];
        NSData *endData = [srcData subdataWithRange:end];
        [dstData replaceBytesInRange:begin withBytes:endData.bytes];
        [dstData replaceBytesInRange:end withBytes:beginData.bytes];
    }
    return dstData;
}
@end
