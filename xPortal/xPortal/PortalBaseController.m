

#import "PortalBaseController.h"

@interface PortalBaseController ()

@end

@implementation PortalBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)actionBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
