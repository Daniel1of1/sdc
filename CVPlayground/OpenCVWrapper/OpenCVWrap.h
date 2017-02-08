#import <Foundation/Foundation.h>

@interface OpenCVWrap : NSObject

-(void)yolo;
-(UIImage *)processPb:(UIImage *)image;
-(UIImage *)gray:(UIImage *)image;
-(UIImage *)gauss:(UIImage *)image;
-(UIImage *)canny:(UIImage *)image;
-(UIImage *)hough:(UIImage *)image;
@end
