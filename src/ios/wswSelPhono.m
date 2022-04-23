#import "wswSelPhono.h"
#import "TZImagePickerController.h"
#import "AppDelegate.h"
#define CDV_PHOTO_PREFIX @"cdv_photo_"
#import <AssetsLibrary/AssetsLibrary.h>

@interface wswSelPhono ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray *resultStrings;
@property (nonatomic, strong) NSString *currentCallbackId;

@end
@implementation wswSelPhono


- (void)selPhoto:(CDVInvokedUrlCommand *)command
{
    self.currentCallbackId = command.callbackId;
    int num = 0;
    NSDictionary *params = [command.arguments objectAtIndex:0];
       if (![params objectForKey:@"max"]) {
           num = 0;
           return ;
       }else{
           num = [params[@"max"] intValue] == 0 ? '1': [params[@"max"] intValue];
       }
    
    self.resultStrings = [NSMutableArray array];

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:num delegate:nil];
    // 你可以通过block或者代理，来得到用户选择的照片.
    //    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO;
    
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
    self.currentCallbackId = command.callbackId;

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 是否显示裁剪框编辑（默认为NO），等于YES的时候，照片拍摄完成可以进行裁剪
    imagePickerController.allowsEditing = YES;
    // 设置照片来源为相机
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 设置进入相机时使用前置或后置摄像头
    //    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    // 展示选取照片控制器
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self.viewController presentViewController:imagePickerController
                       animated:YES
                     completion:^{
        
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    NSString * base64Str =  [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self successWithCallbackID:self.currentCallbackId withMessage:base64Str];

}

// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    [self failWithCallbackID:self.currentCallbackId withMessage:@"取消拍照"];
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
