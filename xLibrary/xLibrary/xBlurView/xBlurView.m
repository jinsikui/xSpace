//
//  xBlurView.m
//  xSpace
//
//  Created by JSK on 2017/12/30.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

////////////////////////////////////////////////////////////////////////////////////////

@implementation UIImage (xBlur)
#define BlurViewTag 1000
- (UIImage *)blurredImageWithRadius:(CGFloat)radius
                         iterations:(NSUInteger)iterations
                          tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusDarker);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}

- (UIImage*) imageWithSaturation:(CGFloat)saturation
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciimage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:ciimage forKey:kCIInputImageKey];
    //if (V_IOS_7) {
    [filter setValue:[NSNumber numberWithFloat:saturation] forKey:kCIInputSaturationKey];
    //}
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}


@end

////////////////////////////////////////////////////////////////////////////////////////

@interface xBlurView ()
{
    UIImageView *contentView_;
}

@end

@implementation xBlurView

- (void) setContentImage:(UIImage *)image frame:(CGRect)frame
{
    [self setContentImage:image frame:frame alpha:0.3];
}

- (void) setContentImage:(UIImage *)image frame:(CGRect)frame alpha:(CGFloat)alpha
{
    if (contentView_) {
        contentView_.frame = frame;
        if (image == contentView_.highlightedImage) {
            return;
        }
    } else {
        self.clipsToBounds = YES;
        contentView_ = [[UIImageView alloc] initWithFrame:frame];
        contentView_.clipsToBounds = YES;
        contentView_.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:contentView_];
    }
    contentView_.highlightedImage = image;
    contentView_.image = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *blurImage = [image blurredImageWithRadius:30.f iterations:2 tintColor:[UIColor colorWithWhite:0.0 alpha:alpha]];
        dispatch_async(dispatch_get_main_queue(), ^{
            contentView_.image = blurImage;
        });
    });
    
}

@end
