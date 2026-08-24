# EXIF Helper

## Introduction

<img src="../assets/icon.png" width="100px">

![License](https://img.shields.io/badge/License-MIT-dark_green)

<a href="https://apps.microsoft.com/detail/9p6389wjjj8k?referrer=appbadge&mode=direct">
    <img src="https://get.microsoft.com/images/en-us%20dark.svg" width="200"/>
</a>

This is a tool that can edit/remove EXIF ​​information from photos and also add EXIF ​​watermarks.  
Support Windows, macOS, Android and iOS

The repository for the dynamic library component is located [HERE](https://github.com/Zhoucheng133/EXIF-Helper-Core).

> [!IMPORTANT]
> HEIC and HEIF files are not supported. If you want to process these two types of image files, you can use a conversion tool (such as [HEIC Converter](https://github.com/Zhoucheng133/HEIC-Converter), which supports converting both HEIC and HEIF files) to convert to JPEG.

## Screenshots

![demo2](../demo/en1.png)

![demo2](../demo/en2.png)

<img src="../demo/en3.png" width="500px" />

## Configuring EXIF Helper on Your Device

You need to have Flutter and Go installed on your device.

### Build Dynamic/Static Libraries

The core component is located in the `/core` directory and is developed using Go. For build instructions, refer to [EXIF-Helper-Core](https://github.com/Zhoucheng133/EXIF-Helper-Core).

For Windows, macOS, Android, and iOS platforms, this project includes pre-built binary dynamic/static libraries.

- Windows: `/windows/image.dll`
- macOS: `/macos/image.dylib`
- Android: `/android/app/src/main/jniLibs/arm64-v8a/image.so`
- iOS: `/ios/libcore.xcframework`

### Build the App

This project uses Flutter version `3.41.6`. Do not use Flutter versions lower than `3.38` for building.

When building for any platform, the binary dynamic/static libraries will be copied into the built App automatically.

```bash
# Windows
flutter build windows

# macOS
flutter build macos

# Android
flutter build apk --split-per-abi
```

## Sponsor

If this project was helpful, consider [buying me a coffee](https://blog.z-server.top/sponsor/). Cheers! ☕