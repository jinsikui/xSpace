

#import "PortalBaseController.h"

@interface PortalBaseController ()

@end

@implementation PortalBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(0xFFFFFF);
}

- (void)actionBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
