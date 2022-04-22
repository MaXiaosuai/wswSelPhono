#import "wswSelPhono.h"
#import "JFImagePickerController.h"

@interface wswSelPhono () <JFImagePickerDelegate>

@property (nonatomic,strong)NSMutableArray *resultStrings;
@end
@implementation wswSelPhono


- (void)selPhoto:(CDVInvokedUrlCommand *)command
{
    NSDictionary *params = [command.arguments objectAtIndex:0];
       if (![params objectForKey:@"max"]) {
           [self failWithCallbackID:command.callbackId withMessage:@"参数格式错误"];
           return ;
       }
    self.resultStrings = [NSMutableArray array];
    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:nil];
    picker.pickerDelegate = self;
    [self.viewController presentViewController:picker animated:YES completion:nil];
}
- (void)selCamera:(CDVInvokedUrlCommand *)command
{
    
}

- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    NSLog(@"%@",picker.assets);
    [self imagePickerDidCancel:picker];
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)successWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}



- (void)failWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}


@end
