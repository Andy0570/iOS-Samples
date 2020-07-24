//
//  HQLTakePhotoThirdWayViewController.m
//  HQLTakePhotoDemo
//
//  Created by ToninTech on 2017/2/24.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLTakePhotoThirdWayViewController.h"

@interface HQLTakePhotoThirdWayViewController () {
    UIImageView *imageView;
}

@end

@implementation HQLTakePhotoThirdWayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化后显示截取图片后的View
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, 320, 320)];
    imageView.image = [UIImage imageNamed:@"transparencyPattern"];
    [self.view addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -IBAction
//弹出选项列表选择图片来源
- (IBAction)choosePicture:(id)sender {
    UIActionSheet *chooseImageSheet =[ [UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo",@"library", nil];
    [chooseImageSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    
    switch (buttonIndex) {
        case 0:
        {
            BOOL isSourceTypeAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if (isSourceTypeAvailable) {
                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                [self presentViewController:pickerController animated:YES completion:nil];
            }else{
                NSLog(@"模拟器无法打开相机");
            }
            
        }
            break;
        case 1:
        {
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickerController animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    [UIApplication sharedApplication].statusBarHidden = NO;
    NSLog(@"%@",info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        CaptureViewController *captureView = [[CaptureViewController alloc] init];
        captureView.delegate = self;
        captureView.image = image;
        //隐藏UIImagePickerController本身的导航栏
        picker.navigationBar.hidden = YES;
        [picker pushViewController:captureView animated:YES];
        
    }
}

#pragma mark - 图片回传协议方法
-(void)passImage:(UIImage *)image
{
    imageView.image = image;
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
