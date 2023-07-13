#import "PPImageAlertContentView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface PPImageAlertContentView ()
@property (nonatomic, weak) UIImageView * theContentImageView;
@end
@implementation PPImageAlertContentView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView {
    [self theContentImageView];
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.theContentImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
}
- (UIImageView * )theContentImageView{
    if (!_theContentImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        theView.contentMode = UIViewContentModeScaleAspectFit;
        _theContentImageView = theView;
    }
    return _theContentImageView;
}
@end
