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
        
        self.resultStrings = [NSMutableArray array];
        [self saveOriginalImage:assets currentIdx:0 originalPathArray:self.resultStrings completion:^(NSMutableArray *paths) {
            
            NSLog(@"All finished.");
            
            NSDictionary* result = @{@"images": paths, @"isOrigin": @(YES)};
            NSLog(@"====%@",result);
//            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
            
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            
        }];
        
//        for (int i = 0; i < photos.count; i++) {
//            UIImage *img = photos[i];
//            NSData *data = UIImageJPEGRepresentation(photos, 0.5);
//
//        }
//
//        CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:assets];
//
//        [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];

//        photosArr(photos, assets);
    }];
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];

}

- (void)saveOriginalImage:(NSArray *)assets currentIdx:(NSInteger)idx  originalPathArray:(NSMutableArray *)originalPaths completion:(void (^)(NSMutableArray *photos))completion {
    if([assets count] - 1 >= idx) {
        id asset = assets[idx];
        
        __block NSInteger index = idx;
        
        
        [[TZImageManager manager] getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
            
            __block NSString *fileName = [self getFileNameForAsset:asset];
            if ([info valueForKey:@"PHImageExtension"] != nil) {
                NSString *newExtension = [info valueForKey:@"PHImageExtension"];
                fileName = [fileName stringByAppendingString:newExtension];
            }
            NSString *path = [self saveNSDataToFile:data withName:fileName];
            NSDictionary* fileObj = @{
                                      @"path": path,
                                      @"width": @([asset pixelWidth]),
                                      @"height": @([asset pixelHeight]),
                                      @"size": @([data length])
                                      };
            [originalPaths addObject:fileObj];
            
            index += 1;
            [self saveOriginalImage:assets currentIdx:index originalPathArray:originalPaths completion:completion];
        }];
    }
    else {
        if (completion) {
            completion(originalPaths);
        }
    }
}
//获取原始文件名
- (NSString *)getFileNameForAsset:(id)asset {
    
    NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
    NSString *fileName = ((PHAssetResource*)resources[0]).originalFilename;
    return fileName;
}

//保存原始图片
- (NSString *)saveNSDataToFile:(NSData *)imageData withName:(NSString*)imageName{
    // 获取沙盒临时路径
    NSString *fullPath = [[self ensureSaveDirectory] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
    return fullPath;
    
}

// 创建临时保存目录
- (NSString *)ensureSaveDirectory {
    //NSString *storeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *storeDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ImagePicker"];
    
    BOOL isDir = TRUE;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:storeDir isDirectory:&isDir];
    
    if(!exists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:storeDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return storeDir;
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
