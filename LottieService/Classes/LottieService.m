//
//  LottieService.m
//  SparkBase
//
//  Created by sfh on 2023/3/21.
//  Copyright © 2023 Spark. All rights reserved.
//

#import "LottieService.h"
#import "SSZipArchive.h"

//在Caches目录下新建Lotties文件夹，所有的动效文件都放在此目录下
//每一个新的zip文件生成一个新的目录，目录名即zip文件的名，zip文件和解压后的文件都放在新目录下
static NSString *DocComponent = @"Lotties";

@implementation LottieService

/// 下载.zip动效文件到沙盒，解压后的数据去生成一个LOTComposition对象并返回
/// - Parameters:
///   - url: .zip动效文件地址
///   - completion: 回调
+ (void)requestLottieModelWithURL:(NSURL *)url completion:(void(^)(LOTComposition * _Nullable sceneModel, NSError * _Nullable error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        //截取出.zip的文件名
        NSString *zipName = @"";
        NSArray *arr = [url.absoluteString componentsSeparatedByString:@"/"];
        for (int i = 0; i < arr.count; i++) {
            NSString *alpha = arr[i];
            if ([alpha containsString:@".zip"]) {
                zipName = alpha;
                break;
            }
        }

        //沙盒文件地址
        NSString *filePath = [self DownloadTextFile: url.absoluteString fileName: zipName];
#if DEBUG
        NSLog(@"filepath is : %@", filePath);
#endif
        //解压指定目录
        NSString *name = [zipName stringByReplacingOccurrencesOfString:@".zip" withString:@""];
        NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *documentPath = [cachesDir stringByAppendingPathComponent: [NSString stringWithFormat:@"%@/%@", DocComponent, name]];
#if DEBUG
        NSLog(@"documentPath is : %@", documentPath);
#endif
        //解压.zip动效文件到指定目录
        //~Library/Caches/Lotties/文件名/文件名.zip
        __block NSString *finalPath = @"";
        [SSZipArchive unzipFileAtPath:filePath toDestination:documentPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
#if DEBUG
            NSLog(@"entry is : %@", entry);
            NSLog(@"entryNumber is : ");
            NSLog(@"%ld", entryNumber);
            NSLog(@"total is : ");
            NSLog(@"%ld", total);
#endif
            //包含".json"后缀的就是需要的动效文件
            if ([entry.description containsString:@".json"]) {
                finalPath = entry.description;
            }
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            //这个path是.zip文件的沙盒地址
#if DEBUG
            NSLog(@"path: %@", path);
#endif
            if (succeeded) {
                //~Library/Caches/Lotties/文件名/[finalPath].json
                NSString *final = [documentPath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@", finalPath]];
#if DEBUG
                NSLog(@"json动效文件地址: %@", final);
#endif
                //截取出.json的文件名
                NSString *jsonName = @"";
                NSArray *arr = [finalPath componentsSeparatedByString:@"/"];
                for (int i = 0; i < arr.count; i++) {
                    NSString *alpha = arr[i];
                    if ([alpha containsString:@".json"]) {
                        jsonName = alpha;
                        break;
                    }
                }
                
                NSString *imgDir = [finalPath stringByReplacingOccurrencesOfString:jsonName withString:@""];
                NSString *jsonImgDir = [documentPath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@", imgDir]];
#if DEBUG
                NSLog(@"json动效文件所需图片地址: %@", jsonImgDir);
#endif
                
                NSData *animationData = [NSData dataWithContentsOfFile:final];
                if (!animationData) {
                    return;
                }
                
                NSError *error;
                NSDictionary *animationJSON = [NSJSONSerialization JSONObjectWithData:animationData options:0 error:&error];
                if (error || !animationJSON) {
                    if (completion) {
                        completion(nil, error);
                    }
                    return;
                }
                
                LOTComposition *model = [[LOTComposition alloc] initWithJSON:animationJSON withAssetBundle:[NSBundle mainBundle]];
                model.rootDirectory = jsonImgDir;//指定动效所需图片加载地址
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [[LOTAnimationCache sharedCache] addAnimation:model forKey:url.absoluteString];
                    model.cacheKey = url.absoluteString;
                    if (completion) {
                        completion(model, nil);
                    }
                });
            } else {
#if DEBUG
                NSLog(@"解压失败, error is: %@", error.description);
#endif
            }
        }];
    });
}

/// 获取远程.zip动效文件到沙盒，并返回沙盒地址
/// - Parameters:
///   - fileUrl: .zip文件地址, 示例: "https://ksimg.sparke.cn/images/smartBook/english/2023/7/1852229119376130624.zip"
///   - fileName: 保存到本地的文件名称
+ (NSString *)DownloadTextFile:(NSString*)fileUrl fileName:(NSString*)fileName
{
    //文件名
    NSString *name = [fileName stringByReplacingOccurrencesOfString:@".zip" withString:@""];
    //定位caches目录
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //在caches目录下指定新目录
    NSString *documentPath = [cachesDir stringByAppendingPathComponent: [NSString stringWithFormat:@"%@/%@", DocComponent, name]];
    //指定文件的保存目录
    NSString *FileName = [documentPath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    //判断目录是否存在
    BOOL existed = [fileManager fileExistsAtPath:documentPath isDirectory:&isDir];
    
    if (!(isDir == YES && existed == YES)) {
        //创建文件夹目录
        [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    if ([fileManager fileExistsAtPath:FileName]) {
        return FileName;
    } else {
        NSURL *url = [NSURL URLWithString:fileUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [data writeToFile:FileName atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
    }
    
    return FileName;
}

@end
