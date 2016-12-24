#import <UIKit/UIKit.h>


/**
 @brief  Useful \b UIImage class extensions for application.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum Luxury, LLC.
 */
@interface UIImage (CNMAdditions)


///------------------------------------------------
/// @name Size manipulation
///------------------------------------------------

/**
 @brief  Resize receiver to specifie \c size. If required ti fully
         fit into specified size it can be cropped (depending 
         from \c shoulCrop).
 
 @param size       Target receiver image size.
 @param shouldCrop Whether resulting image should be cropped to fit
                   into specified size.
 
 @return Cropped image which fit into specified size.
 */
- (UIImage *)resizedImageToSize:(CGSize)size withCrop:(BOOL)shouldCrop;

/**
 @brief  Resize receiver to specifie \c size. If required ti fully
         fit into specified size it can be cropped (depending 
         from \c shoulCrop).
 
 @param size       Target receiver image size.
 @param shouldCrop Whether resulting image should be cropped to fit
                   into specified size.
 @param block      Reference on block which should be called at the
                   end of image resize process. Block will be called
                   on main queue.
 */
- (void)resizedImageToSize:(CGSize)size withCrop:(BOOL)shouldCrop
                completion:(void(^)(UIImage *image))block;

#pragma mark -


@end
