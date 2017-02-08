//
//  OpenCVWrap.m
//  Pods
//
//  Created by Playground on 08/02/2017.
//
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
using namespace cv;
#endif

#import "OpenCVWrap.h"

@implementation OpenCVWrap

-(void)yolo {
    NSLog(@"yolo");
}

-(UIImage *)gray:(UIImage *)image {
    cv::Mat mat = [self cvMatFromUIImage:image];
    cvtColor(mat, mat, CV_BGRA2GRAY);
    cvtColor(mat, mat, CV_GRAY2BGRA);
    return [self UIImageFromCVMat:mat];

}
-(UIImage *)gauss:(UIImage *)image {
    cv::Mat mat = [self cvMatFromUIImage:image];
    cvtColor(mat, mat, CV_BGRA2GRAY);
    GaussianBlur(mat, mat, cv::Size(3, 3), 3);
    cvtColor(mat, mat, CV_GRAY2BGRA);
    return [self UIImageFromCVMat:mat];
}
-(UIImage *)canny:(UIImage *)image {
    cv::Mat mat = [self cvMatFromUIImage:image];
    cvtColor(mat, mat, CV_BGRA2GRAY);
    Canny(mat, mat, 100, 200);
    cvtColor(mat, mat, CV_GRAY2BGRA);
    return [self UIImageFromCVMat:mat];
}
-(UIImage *)hough:(UIImage *)image {
    cv::Mat mat = [self cvMatFromUIImage:image];
    cvtColor(mat, mat, CV_BGRA2GRAY);

    std::vector<cv::Vec4i> lines;
    HoughLinesP(mat, lines, 1, CV_PI/360, 100, 30,20);
    cvtColor( mat, mat, CV_GRAY2RGB );
    for( size_t i = 0; i < lines.size(); i++ )
    {
        line( mat, cv::Point(lines[i][0], lines[i][1]),
             cv::Point(lines[i][2], lines[i][3]), Scalar(0,0,255), 3, 8 );
    }
    cvtColor(mat, mat, CV_RGB2BGRA);
    return [self UIImageFromCVMat:mat];
}

-(UIImage *)processPb:(UIImage *)image {

    cv::Mat mat = [self cvMatFromUIImage:image];
    //Processing here
    [self processImage:mat];
    return [self UIImageFromCVMat:mat];
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)

    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;

    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );


    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


- (void)processImage:(Mat&)image;
{

    Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2GRAY);
    GaussianBlur(image_copy, image_copy, cv::Size(3, 3), 3);
    Canny(image_copy, image_copy, 100, 200);
    std::vector<cv::Vec4i> lines;
    HoughLinesP(image_copy, lines, 1, CV_PI/360, 100, 30,20);
    cvtColor( image_copy, image_copy, CV_GRAY2RGB );

    for( size_t i = 0; i < lines.size(); i++ )
    {
        line( image_copy, cv::Point(lines[i][0], lines[i][1]),
             cv::Point(lines[i][2], lines[i][3]), Scalar(0,0,255), 3, 8 );
    }
    cvtColor(image_copy, image, CV_RGB2BGRA);
}


@end
