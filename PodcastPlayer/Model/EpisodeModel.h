//
//  EpisodeModel.h
//  PodcastPlayer
//
//  Created by roy on 2020/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EpisodeModel : NSObject

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * image;
@property (strong, nonatomic) NSString * pubDate;
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSString * summary;

@end

NS_ASSUME_NONNULL_END
