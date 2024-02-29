# LottieService

[![CI Status](https://img.shields.io/travis/Sfh03031/LottieService.svg?style=flat)](https://travis-ci.org/Sfh03031/LottieService)
[![Version](https://img.shields.io/cocoapods/v/LottieService.svg?style=flat)](https://cocoapods.org/pods/LottieService)
[![License](https://img.shields.io/cocoapods/l/LottieService.svg?style=flat)](https://cocoapods.org/pods/LottieService)
[![Platform](https://img.shields.io/cocoapods/p/LottieService.svg?style=flat)](https://cocoapods.org/pods/LottieService)

iOS端Lottie无法加载带图片的远程动效文件（安卓可以，安卓可以直接加载远程带图片的json动效文件，也可直接加载对应的.zip压缩文件），
主要原因是json文件的加载是异步，用url初始化LOTAnimationView的时候该LOTAnimationView的sceneModel为空，所以动效加载不出来。

由于LOTAnimationView的内部没有加载完成的回调，想到的处理思路是监听sceneModel的设置或者生成一个sceneModel赋值给LOTAnimationView，
前者需要改动Lottie源文件不方便pods管理，所以采用动态生成一个sceneModel赋值给LOTAnimationView的方式。

主要思路是先下载.zip动效文件到沙盒，解压后的数据去生成一个LOTComposition对象，最后用LOTAnimationView的sceneModel去加载
具体实现参考LottieService类，入口文件里只关注生成LOTComposition对象后的回调，拿到sceneModel去赋值

注: 
1、项目中使用的Lottie-ios库是OC语言编写的2.5.3版本，解压缩zip使用的是SSZipArchive库
2、新版本的Lottie库已经是swift语言编写的了，如果不支持远程带图片的动效压缩包文件，仍旧可以采取这种思路去处理。


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LottieService is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LottieService'
```

## Author

Sfh03031, sfh894645252@foxmail.com

## License

LottieService is available under the MIT license. See the LICENSE file for more info.
