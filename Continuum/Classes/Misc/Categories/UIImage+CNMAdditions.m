/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum Luxury, LLC.
 */
#import "UIImage+CNMAdditions.h"


#pragma mark Private interface declaration

@interface UIImage (CNMAdditionsPrivate)


#pragma mark - Size manipulation

/**
 @brief  Calculate target image size which will fit into specified
         size.
 
 @param size       Size into which image should be drawn.
 @param shouldCrop Whether image should be cropped or not.
 
 @return Target image drwa size.
 */
- (CGSize)imageSizeWhatFits:(CGSize)size withCrop:(BOOL)shouldCrop;

/**
 @brief  Calculate rect to draw image of specified size in \c size.
 
 @param imageSize Target image size.
 @param size      Size of placeholer in which image should be drawn.
 
 @return Frame which will place image at the center of specified area size.
 */
- (CGRect)rectToDrawImageWithSize:(CGSize)imageSize inSize:(CGSize)size;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation UIImage (CNMAdditions)


#pragma mark - Size manipulation

- (UIImage *)resizedImageToSize:(CGSize)size withCrop:(BOOL)shouldCrop {
    
    // Calculate new image draw frame.
    CGSize imageSize = [self imageSizeWhatFits:size withCrop:shouldCrop];
    CGRect imageRect = [self rectToDrawImageWithSize:imageSize inSize:size];
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setFill];
    CGContextFillRect(context, (CGRect){.size = size});
    [self drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)resizedImageToSize:(CGSize)size withCrop:(BOOL)shouldCrop
                completion:(void(^)(UIImage *image))block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        UIImage *image = [self resizedImageToSize:size withCrop:shouldCrop];
        dispatch_async(dispatch_get_main_queue(), ^{ block(image); });
    });
}

- (CGSize)imageSizeWhatFits:(CGSize)size withCrop:(BOOL)shouldCrop {
    
    CGFloat aspectRatio = self.size.width / self.size.height;
    CGSize imageSize = CGSizeMake(ceilf(size.height * aspectRatio), size.height);
    if (shouldCrop) {
        
        if (self.size.height > self.size.width) {
            
            imageSize.width = size.width;
            imageSize.height = ceilf(size.width / aspectRatio);
        }
        else {
            
            imageSize.height = size.height;
            imageSize.width = ceilf(size.height * aspectRatio);
        }
    }
    
    return imageSize;
}

- (CGRect)rectToDrawImageWithSize:(CGSize)imageSize inSize:(CGSize)size {
    
    CGPoint imagePosition = CGPointMake(ceilf((size.width - imageSize.width) * 0.5f), 
                                        ceilf((size.height - imageSize.height) * 0.5f));
    
    return (CGRect){.origin = imagePosition, .size = imageSize};
}

#pragma mark -


@end
