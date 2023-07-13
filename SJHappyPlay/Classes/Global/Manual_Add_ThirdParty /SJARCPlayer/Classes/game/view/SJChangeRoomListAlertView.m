

#import "SJChangeRoomListAlertView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"
#import "SJChangeRoomItemCell.h"

@interface SJChangeRoomListAlertView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SJChangeRoomListAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSize(304), SCREEH_HEIGHT)];
    [self addSubview:contentView];
    [self setupViewRound:contentView corners:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(152);
    }];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
    [contentView addSubview:bgView];
    [self configureViewColorGradient:bgView width:DSize(304) height:SCREEN_WIDTH one:RGBACOLOR(226, 224, 255, 1) two:RGBACOLOR(137, 174, 255, 1) cornerRadius:0.0];
    
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
}

- (void)setRoomList:(NSArray *)roomList {
    _roomList = roomList;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roomList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJChangeRoomItemCell *cell = [SJChangeRoomItemCell changeRoomItemCellWithTableView:tableView indexPath:indexPath];
    cell.model = self.roomList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SJGameRoomListInfoModel *model = self.roomList[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(disSelectIntoRoom:)]) {
        [self.delegate disSelectIntoRoom:model];
        [self viewDidClick];
    }
}

- (void)viewDidClick {
    if(self.viewClickBlock) {
        self.viewClickBlock();
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //如果是子视图 self.edittingArea ，设置无法接受 父视图_collectionView 的长按事件。
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}


- (void)setupViewRound:(UIView *)targetView corners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:targetView.bounds byRoundingCorners:corners
    cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    // 设置大小
    maskLayer.frame = targetView.bounds;
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    targetView.layer.mask = maskLayer;
    
}

- (void)configureViewColorGradient:(UIView *)view width:(CGFloat)width height:(CGFloat)height one:(UIColor *)oneColor two:(UIColor *)twoColor cornerRadius:(CGFloat)cornerRadius {
    UIColor *colorOne = oneColor;
    UIColor *colorTwo = twoColor;
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, width, height);
    gradient.cornerRadius = cornerRadius;
    [view.layer insertSublayer:gradient atIndex:0];
}

- (void)configureLeftToRightViewColorGradient:(UIView *)view width:(CGFloat)width height:(CGFloat)height one:(UIColor *)oneColor two:(UIColor *)twoColor cornerRadius:(CGFloat)cornerRadius {
    UIColor *colorOne = oneColor;
    UIColor *colorTwo = twoColor;
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, width, height);
    gradient.cornerRadius = cornerRadius;
    [view.layer insertSublayer:gradient atIndex:0];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerClass:[SJChangeRoomItemCell class] forCellReuseIdentifier:@"SJChangeRoomItemCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
