/**
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
#import "CNMVideo+Private.h"
#import "CNMVideoPreset+Private.h"
#import <UIKit/UIKit.h>


#pragma mark Structures

/**
 @brief  Structure describes video representation structure.
 */
struct CNMVideoDataStructure {

    /**
     @brief  Stores key under which stored data from which video identifier can be extracted.
     */
    __unsafe_unretained NSString *identifier;

    /**
     @brief  Stores key-path under which stored list of available images associated with video.
     */
    struct {
        
        /**
         @brief  Stores key under which stored key-path from viedeo data which store pictures set.
         */
        __unsafe_unretained NSString *key;
        
        /**
         @brief  Stores key under which stored video snapshot image width.
         */
        __unsafe_unretained NSString *width;
        
        /**
         @brief  Stores key under which stored video snapshot image height.
         */
        __unsafe_unretained NSString *height;
        
        /**
         @brief  Stores key under which stored video snapshot image url.
         */
        __unsafe_unretained NSString *url;
    } images;
    
    /**
     @brief  Stores key under which video name is stored.
     */
    __unsafe_unretained NSString *name;
    
    /**
     @brief  Stores key under which video file duration is stored.
     */
    __unsafe_unretained NSString *duration;
    
    /**
     @brief  Stores key under which video file upload date is stored.
     */
    __unsafe_unretained NSString *creationDate;
    
    /**
     @brief  Stores key under which video presets is stored.
     */
    __unsafe_unretained NSString *presets;
} CNMVideoData = {
    
    .identifier = @"link",
    .images = {
        .key = @"pictures.sizes",
        .width = @"width",
        .height = @"height",
        .url = @"link"
    },
    .name = @"name",
    .duration = @"duration",
    .creationDate = @"created_time",
    .presets = @"files"
};


#pragma mark - Private interface declaration

@interface CNMVideo (Protected)


#pragma mark - Misc

/**
 @brief  Extract video ientifier from passed \c data object.
 
 @param data Reference on data from which identifier should be
             extracted.
 
 @return Video identifier on remote data provider.
 */
+ (NSString *)identifierFromData:(NSString *)data;

/**
 @brief  Retrieve URL on video image which will best fit to device
         screen size.
 
 @param images List of image presets from which one should be 
               picked basing on device screen size.
 
 @return Suitable image URL string.
 */
- (NSString *)imageURLFromList:(NSArray<NSDictionary *> *)images;

/**
 @brief  Retrieve list of video preset data models from passed data.
 
 @param presets List of video file presets.
 
 @return List of configured and ready to use video preset instances.
 */
- (NSArray<CNMVideoPreset *> *)videoPresetsFromData:(NSDictionary *)data;

/**
 @brief  Retrieve sorting descriptors which can be used for image presets
         sorting from smaller to larger.
 
 @return List of sorting descriptors.
 */
- (NSArray *)imagePresetsSortDescriptors;

#pragma mark -


@end


#pragma mark - Interface implementation

@implementation CNMVideo


#pragma mark - Configuration

- (void)updateCredits:(NSArray<NSDictionary<NSString *, id> *> *)data {
    
    if (data.count == 1) { self.author = data.firstObject[@"name"]; }
    else if (data.count > 1) {
        
        [data enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> *credit, NSUInteger creditIdx, 
                                           BOOL *creditsEnumeratorStop) {
            
            if ([credit[@"role"] isKindOfClass:NSString.class] && 
                [credit[@"role"] isEqualToString:@"Contributor"]) {
                
                self.author = credit[@"name"];
            }
            
            *creditsEnumeratorStop = (self.author.length > 0);
        }];
    }
}

- (void)updateWithVideo:(CNMVideo *)video {
    
    if (video.identifier) {self.identifier = video.identifier; }
    if (video.idx) { self.idx = video.idx; }
    if (video.imagePath) {self.imagePath = video.imagePath; }
    if (video.name) {self.name = video.name; }
    if (video.author) {self.author = video.author; }
    if (video.creationDate) {self.creationDate = video.creationDate; }
    if (video.presets) {self.presets = video.presets; }
}


#pragma mark - Data mapping

- (void)mapDataFromDictionary:(NSDictionary *)information {
    
    self.identifier = [self.class identifierFromData:information[CNMVideoData.identifier]];
    self.imagePath = [self imageURLFromList:[information valueForKeyPath:CNMVideoData.images.key]];
    self.name = information[CNMVideoData.name];
    self.creationDate = information[CNMVideoData.creationDate];
    self.presets = [self videoPresetsFromData:information];
}


#pragma mark - Misc

+ (NSString *)identifierFromData:(NSString *)data {
    
    return [data lastPathComponent];
}

- (NSString *)imageURLFromList:(NSArray<NSDictionary *> *)images {
    
    __block NSString *url = nil;
    if ([images isKindOfClass:NSArray.class]) {
        
        __block CGFloat previousImageHeight = 0.0f;
        NSArray *sortedImages = [images sortedArrayUsingDescriptors:[self imagePresetsSortDescriptors]];
        CGSize screenSize = [UIScreen mainScreen].nativeBounds.size;
        [sortedImages enumerateObjectsUsingBlock:^(NSDictionary *imageDescription, NSUInteger imageDescriptionIdx, 
                                                   BOOL *imagesDescriptionEnumeratorStop) {
            
            CGFloat imageHeight = ((NSNumber *)imageDescription[CNMVideoData.images.height]).doubleValue;
            NSString *imageURL = imageDescription[CNMVideoData.images.url];
            CGFloat heightDiff = screenSize.height - imageHeight;
            if (heightDiff < screenSize.height - previousImageHeight) {
                
                url = imageURL;
                previousImageHeight = imageHeight;
                *imagesDescriptionEnumeratorStop = (heightDiff < 0.0f);
            }
        }];
    }
    
    return url;
}

- (NSArray<CNMVideoPreset *> *)videoPresetsFromData:(NSDictionary *)data {
    
    NSMutableSet *presetSet = [NSMutableSet new];
    NSNumber *duration = data[CNMVideoData.duration];
    NSArray<NSDictionary *> *presets = data[CNMVideoData.presets];
    [presets enumerateObjectsUsingBlock:^(NSDictionary *presetInformation, NSUInteger presetInformationIdx, 
                                          BOOL *presetsInformationEnumeratorStop) {
        
        CNMVideoPreset *preset = [CNMVideoPreset new];
        [preset mapDataFromDictionary:presetInformation];
        preset.video = self.identifier;
        preset.duration = duration;
        [presetSet addObject:preset];
    }];
    
    return presetSet.allObjects;
}

- (NSArray *)imagePresetsSortDescriptors {
    
    static NSArray *_imagePresetsSortDescriptors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSSortDescriptor *descriptor =[[NSSortDescriptor alloc] initWithKey:@"height" ascending:YES];
        _imagePresetsSortDescriptors = @[descriptor];
    });
    
    return _imagePresetsSortDescriptors;
}

#pragma mark -


@end
