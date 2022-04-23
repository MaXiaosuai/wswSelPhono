#import "wswSelPhono.h"
#import "TZImagePickerController.h"
#import "AppDelegate.h"
#define CDV_PHOTO_PREFIX @"cdv_photo_"
#import <AssetsLibrary/AssetsLibrary.h>

@interface wswSelPhono ()
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

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:2 delegate:nil];
    // 你可以通过block或者代理，来得到用户选择的照片.
    //    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO;
//        imagePickerVc.selectedAssets = [selImgArr mutableCopy]; // 目前已经选中的图片数组

    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        for (int i = 0; i < photos.count; i++) {
            NSData *data = UIImageJPEGRepresentation(photos[i], 0.1);
            NSString * base64Str =  [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
            [self.resultStrings addObject:base64Str];
        }

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:self.resultStrings];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];

}

- (void)selCamera:(CDVInvokedUrlCommand *)command
{
    
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
