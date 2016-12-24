/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVideoPreset+Private.h"
#import "CNMVideo.h"


#pragma mark Structures

/**
 @brief  Structure describes video preset representation structure.
 */
struct CNMVideoPresetDataStructure {
    
    /**
     @brief  Stores key under which video file width is stored.
     */
    __unsafe_unretained NSString *width;
    
    /**
     @brief  Stores key under which video file height is stored.
     */
    __unsafe_unretained NSString *height;
    
    /**
     @brief  Stores key under which video file size is stored.
     */
    __unsafe_unretained NSString *size;
    
    /**
     @brief  Stores key under which video file URL is stored.
     */
    __unsafe_unretained NSString *url;
    
    /**
     @brief  Stores key-path under which video file quality is stored.
     */
    __unsafe_unretained NSString *quality;
} CNMVideoPresetData = {
    
    .width = @"width",
    .height = @"height",
    .size = @"size",
    .url = @"link_secure",
    .quality = @"quality"
};


#pragma mark - Interface implementation

@implementation CNMVideoPreset


#pragma mark - Data mapping

- (void)mapDataFromDictionary:(NSDictionary *)information {
    
    self.width = information[CNMVideoPresetData.width];
    self.height = information[CNMVideoPresetData.height];
    self.size = information[CNMVideoPresetData.size];
    self.url = information[CNMVideoPresetData.url];
    self.quality = information[CNMVideoPresetData.quality];
}

#pragma mark -


@end
