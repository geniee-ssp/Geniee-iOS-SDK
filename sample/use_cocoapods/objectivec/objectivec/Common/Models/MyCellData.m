#import "MyCellData.h"

@implementation MyCellData

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *sampleDatas = @[@{@"img_url": @"https://media.gssp.asia/img/bf0/8f2/bf08f28d19c98e2b603a21519a0948f6.png",
                                   @"title": @"title",
                                   @"content": @"description sample : ios",
                                   },
                                 @{@"img_url": @"https://media.gssp.asia/img/bae/bbb/baebbb357d7011d4b1a8fee309dbfe56.jpg",
                                   @"title": @"title",
                                   @"content": @"description sample : android",
                                   },
                                 ];
        NSDictionary *sampleData = sampleDatas[rand() % sampleDatas.count];
        _imgURL = [NSURL URLWithString:sampleData[@"img_url"]];
        _title = sampleData[@"title"];
        _content = sampleData[@"content"];
    }
    return self;
}

@end
