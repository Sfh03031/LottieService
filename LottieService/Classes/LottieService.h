//
//  LottieService.h
//  SparkBase
//
//  Created by sfh on 2023/3/21.
//  Copyright © 2023 Spark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Lottie/Lottie.h>

NS_ASSUME_NONNULL_BEGIN

@interface LottieService : NSObject

//下载.zip动效文件到沙盒，解压后的数据去生成一个LOTComposition对象并返回
+ (void)requestLottieModelWithURL:(NSURL *)url completion:(void(^)(LOTComposition * _Nullable sceneModel, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
