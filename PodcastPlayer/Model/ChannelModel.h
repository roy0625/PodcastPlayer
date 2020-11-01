//
//  ChannelModel.h
//  PodcastPlayer
//
//  Created by roy on 2020/10/27.
//

#import <Foundation/Foundation.h>
#import "EpisodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChannelModel : NSObject

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * image;
@property (strong, nonatomic) NSArray<EpisodeModel *> * episodes;

@end

NS_ASSUME_NONNULL_END
