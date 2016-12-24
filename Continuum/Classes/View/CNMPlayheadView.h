#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 @brief  Player's playhead view for progress presentation.
 
 @author Sergey Mamontov
 @since 1.0
 @copyright © 2015 Continuum LLC.
 */
@interface CNMPlayheadView : UISlider


///------------------------------------------------
/// @name Information
///------------------------------------------------

/**
 @brief  Retrieve value which is shown currently on playhead.
 
 @return Converted from slider value space to video seconds.
 */
- (NSTimeInterval)playheadValue;


///------------------------------------------------
/// @name Configuration
///------------------------------------------------

/**
 @brief  Specify video duration information which will be used during valu calulation.
 
 @param duration Total video duration in seconds.
 */
- (void)setVideoDuration:(NSTimeInterval)duration;

/**
 @brief  Update time shown by playhed view.
 
 @param time Number of seconds from video start.
 */
- (void)setTime:(NSTimeInterval)time;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
