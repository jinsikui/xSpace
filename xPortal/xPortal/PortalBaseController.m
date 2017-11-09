

#import "PortalBaseController.h"

@interface PortalBaseController ()

@end

@implementation PortalBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_FFFFFF;
}

- (void)actionBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
