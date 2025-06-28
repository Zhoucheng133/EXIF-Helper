# EXIF Helper

## 简介

<img src="assets/icon.png" width="100px">

![License](https://img.shields.io/badge/License-MIT-dark_green)

支持的Windows系统: Windows10~ & macOS

动态库组件仓库[在这里](https://github.com/Zhoucheng133/EXIF-Helper-Core)

## 截图

![alt text](demo/demo.png)

## 在你的设备上配置EXIF Helper

你需要在你的设备上安装Flutter和Go

1. 前往[动态库组件仓库](https://github.com/Zhoucheng133/EXIF-Helper-Core)中构建dll (Windows)或者dylib (macOS)：

    ```bash
    # 在EXIF-Helper-Core仓库中
    go mod tidy
    # Windows系统
    go build -o build/image.dll -buildmode=c-shared .
    # macOS系统
    go build -o build/image.dylib -buildmode=c-shared .
    ```
2. 构建App本体：
    ```bash
    # Windows系统
    flutter build windows
    # macOS系统
    flutter build macos
    ```
3. 将生成的动态库复制到App目录中<sup>*</sup>

<sup>*</sup> 如果是Windows系统。直接复制到App根目录下，如果是macOS系统，拷贝到`EXIF Helper/Contents/Frameworks`中（本项目会自动拷贝到，你也可以保留项目中的动态库文件）。注意**不要修改动态库名称**