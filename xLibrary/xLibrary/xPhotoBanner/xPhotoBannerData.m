
#import "xPhotoBannerData.h"


@implementation xPhotoBannerData

-(instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    if (videoUrl.length > 0) {
        _dataType = xPhotoBannerDataTypeVideo;
    }
}

@end
