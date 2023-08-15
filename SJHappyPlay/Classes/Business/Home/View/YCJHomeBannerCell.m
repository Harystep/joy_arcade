//
//  YCJHomeBannerCell.m
//  SJHappyPlay
//
//  Created by oneStep on 2023/8/14.
//

#import "YCJHomeBannerCell.h"
#import "SDCycleScrollView.h"

@interface YCJHomeBannerCell ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *bannerView;

@end

@implementation YCJHomeBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)homeBannerCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    YCJHomeBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCJHomeBannerCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    self.bannerView = [[SDCycleScrollView alloc] init];
    self.bannerView.delegate = self;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.clipsToBounds = YES;
    [self.contentView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(12);
        make.top.mas_equalTo(self.contentView.mas_top).offset(4);
        make.height.mas_equalTo(135);
    }];
    [self.bannerView setViewCornerRadiu:8];
    
    UIView *funView = [[UIView alloc] init];
    [self.contentView addSubview:funView];
    [funView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(12);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(15);
    }];
    CGFloat width = kSize(50);
    CGFloat marginX = (kScreenWidth - 12*2 - width*5)/4.0;
    NSArray *imageArr = @[@"icon_home_mrqd_en", @"icon_phb_1", @"icon_home_xszd_en", @"icon_home_yqyl_en", @"icon_home_zxkf_en"];
    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        [funView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(funView);
            make.leading.mas_equalTo(funView.mas_leading).offset((width+marginX)*i);
            make.width.mas_equalTo(width);
        }];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

- (void)btnItemClick:(UIButton *)sender {
    NSString *event;
    switch (sender.tag) {
        case 0:
            event = @"sign";
            break;
        case 1:
            event = @"rank";
            break;
        case 2:
            event = @"new";
            break;
        case 3:
            event = @"rechange";
            break;
        case 4:
            event = @"service";
            break;
            
        default:
            break;
    }
    [self routerWithEventName:event userInfo:@{}];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    NSMutableArray *iconArr = [NSMutableArray array];
    for (NSDictionary *dic in dataArr) {
        [iconArr addObject:dic[@"imgUrl"]];
    }
    self.bannerView.imageURLStringsGroup = iconArr;
}

@end
