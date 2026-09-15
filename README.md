# EXIF Helper

Also available in English. Click [HERE](/documents/en.md) to view the English version of the README

## 简介

<img src="assets/icon.png" width="100px">

![License](https://img.shields.io/badge/License-MIT-dark_green)

<a href="https://apps.microsoft.com/detail/9p6389wjjj8k?referrer=appbadge&mode=direct">
	<img src="https://get.microsoft.com/images/en-us%20dark.svg" width="200"/>
</a>

这是一个可以编辑/移除照片中的EXIF信息，也可以添加EXIF信息水印的工具  
支持Windows，macOS，~~Android~~和iOS

动态库组件仓库[在这里](https://github.com/Zhoucheng133/EXIF-Helper-Core)

> [!IMPORTANT]
> 不支持HEIC和HEIF文件，如果你想要处理这两种图片文件，你可以使用转换工具（比如[HEIC Converter](https://github.com/Zhoucheng133/HEIC-Converter)，同时支持转换HEIC和HEIF文件）转换至JPEG  

> [!NOTE]
> 经过测试在Android设备上存在兼容性和权限的问题，理论上也可以运行，可以自行构建尝试

## 截图

![demo2](demo/cn1.png)

![demo2](demo/cn2.png)

## 在你的设备上配置EXIF Helper

你需要在你的设备上安装Flutter和Go

### 构建动态/静态库

核心组件在`/core`目录下，使用Go开发，构建方式见[EXIF-Helper-Core](https://github.com/Zhoucheng133/EXIF-Helper-Core)

对于Windows, macOS, Android和iOS平台，本项目包含已经构建好的二进制动态/静态库

- Windows: `/windows/image.dll`
- macOS: `/macos/image.dylib`
- Android: `/android/app/src/main/jniLibs/arm64-v8a/image.so`
- iOS: `/ios/libcore.xcframework`

### 构建App本体

在构建的时候需要你在`lib/components/map/amap_key.dart`文件中添加一个`amapKey`变量作为高德地图的key

本项目使用的Flutter版本为`3.41.6`，不要使用低于`3.38`的Flutter构建

所有平台的构建时，二进制动态/静态库都会拷贝到构建的App中

```bash
# Windows
flutter build windows
# macOS
flutter build macos
# Android
flutter build apk --split-per-abi
```

## 赞助

如果有帮助到了你，欢迎[给我投喂](https://blog.z-server.top/sponsor/)谢谢 🙏