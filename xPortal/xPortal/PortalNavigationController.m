

#import "PortalNavigationController.h"

@interface PortalNavigationController ()

@end

@implementation PortalNavigationController

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.viewControllers.lastObject.supportedInterfaceOrientations;
}

@end
