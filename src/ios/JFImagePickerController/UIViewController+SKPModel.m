//
//  UIViewController+SKPModel.m
//  NoDepositRenting
//
//  Created by 马春雨 on 2020/10/13.
//

#import "UIViewController+SKPModel.h"
#import <objc/runtime.h>
#define kTransitionDuration 0.8

@implementation UIViewController (SKPModel)

+(void)load{
       Method m1 = class_getInstanceMethod([self class], @selector(presentViewController:animated:completion:));
       Method m2 = class_getInstanceMethod([self class], @selector(skp_presentViewController:animated:completion:));
       method_exchangeImplementations(m1, m2);
}
- (void)skp_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
    viewControllerToPresent.modalPresentationStyle =  UIModalPresentationFullScreen;
    [self skp_presentViewController:viewControllerToPresent animated:flag completion:completion];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
