---
layout: post
title: Install OpenCV3.2 & opencv_contrib(Windows 10 + VS2015 + CMake)
date: 2017-05-16 00:58
---



在OpenCV3.2上面用xfeatures2d着实是很多坑。  
稍微记录下踩过的坑，以后就有经验了，  
不过以后可能没有太多机会接触CV了，还是RL好玩啊。

## 0X00001 事前准备

---

- System: Windows 10
- IDE: Visual Studio 2015
- CMake: [Version 3.8.1][1]
- Download or clone the laster version, both [OpenCV][2] & [opencv_contrib][3] (**It's important that they have the same version! It's very important**)

> git clone https://github.com/opencv/opencv.git    
> git clone https://github.com/opencv/opencv_contrib.git


## 0X00002 使用CMake编译OpenCV和opencv_contrib

---

这里嫌麻烦就直接用CMake-gui来编译

- 首先填写源代码的路径和编译输出的路径，第一编译暂时不要用到opencv_contrib，注意选择合适的compiler(这里我是VS2015).

![][4]

![][5]

- 第二次编译前，加入需要额外编译的opencv_contrib，具体是在``OPENCV_EXTRA_MODULES_PATH``进行设置。
- 然后先点击configure，确认无误之后，再点generate进行二次编译。

![][6]

![][7]

- 点击Open Project，用VS打开这个工程(或者手动找到sln也行)，打开后rebuild solution
    - 注意有debug和release两种模式，别搞错了。 

- 再单独编译INSTALL，编译好之后应该就可以用了。

![][8]



> 另外如果你在compile的过程中遇到任何问题，除去网路问题，最大的可能就是OpenCV的版本和opencv_contrib的版本不统一，请务必保证这件事。

## 0X00003 环境变量以及VS配置

---

- 先将刚才便编译好的opencv加入到path中，位置会在XXXX\install\x64\vc14\bin
- 打开VS2015，新建一个空的项目
- 找到项目->属性->VC++目录 (Project-Propety-VC++ Directories)
    - (1)设置include directories 
        - 加入XXXX\install\include
    - (2)设置library directories
        - 加入XXXX\install\x64\vc14\lib
- 找到项目->属性->链接器->输入 (Project-Propety-Linker-Input)
    - (3)加入额外的lib (直接把XXXX\install\x64\vc14\lib下的lib全加进去好了)
        - 如果是debug模式，lib是这样的命名:opencv_xfeatures2d320d.lib
        - 如果是release模式，lib是这样的命名:opencv_xfeatures2d320.lib
        - 区别就是最后的d(debug)

![][9]

## 0X00004 测试SIFT

---

```
#include <opencv2\opencv.hpp>
#include <opencv2\xfeatures2d.hpp>

int main() {

  cv::Mat img_1 = cv::imread("test.jpg", cv::IMREAD_GRAYSCALE);
  cv::Mat img_2 = img_1.clone();
  if (!img_1.data || !img_2.data) {
    std::cout << "画像がよみこめません" << std::endl; return -1;
  }
  int minHessian = 400;
  cv::Ptr < cv::xfeatures2d::SURF>detectorSURF = cv::xfeatures2d::SURF::create(minHessian);
  cv::Ptr < cv::xfeatures2d::SIFT>detectorSIFT = cv::xfeatures2d::SIFT::create(minHessian);
  std::vector < cv::KeyPoint>keypoints_1, keypoints_2;
  detectorSURF->detect(img_1, keypoints_1);
  detectorSIFT->detect(img_2, keypoints_2);

  cv::Mat img_1_keypoints;
  cv::Mat img_2_keypoints;
  cv::drawKeypoints(img_1, keypoints_1, img_1_keypoints, cv::Scalar::all(-1), cv::DrawMatchesFlags::DEFAULT);
  cv::drawKeypoints(img_2, keypoints_2, img_2_keypoints, cv::Scalar::all(-1), cv::DrawMatchesFlags::DEFAULT);

  cv::imshow("INPUT_IMG", img_1);
  cv::imshow("SURF_IMG", img_1_keypoints);
  cv::imshow("SIFT_IMG", img_2_keypoints);
  cv::waitKey(0);
  return 0;
}
```

![][10]
    
    
> 值得一提的是OpenCV3.x在很多地方code写法和OpenCV2.x很不一样。
    
## 0X00005 非常有用的参考资料

---

因为自己记录，所有只写关键步骤，如果你需要比较详细的说明，参考下面的链接

- [opencv3.2+opencv_contrib+cmake][11]
- [OpenCV学习笔记（八）—— OpenCV 3.1.0 + opencv_contrib编译（Windows）][12]
- [opencv3.2.0+contirb+cmake][13]
- [OpenCV3.1.0でSIFTとかSURFとかBINGを使う][14]
- [Feature Detection][15]
- [OpenCV Github][16]


> 我觉得我真的不适合搞CV...还是我的DL和RL好啊

  [1]: https://cmake.org/download/
  [2]: https://github.com/opencv/opencv
  [3]: https://github.com/opencv/opencv_contrib/blob/master/README.md
  [4]: http://7xi3e9.com1.z0.glb.clouddn.com/CV_1.png
  [5]: http://7xi3e9.com1.z0.glb.clouddn.com/CV_2.png
  [6]: http://7xi3e9.com1.z0.glb.clouddn.com/CV_4.png
  [7]: http://7xi3e9.com1.z0.glb.clouddn.com/CV_3.png
  [8]: http://7xi3e9.com1.z0.glb.clouddn.com/CV_5.png
  [9]: http://7xi3e9.com1.z0.glb.clouddn.com/CV_7.png
  [10]: http://7xi3e9.com1.z0.glb.clouddn.com/CV_6.png
  [11]: http://blog.csdn.net/cosmispower/article/details/60601151
  [12]: http://blog.csdn.net/linshuhe1/article/details/51221015
  [13]: http://blog.csdn.net/hanchan94/article/details/68926534
  [14]: http://qiita.com/yizumi1012xxx/items/762005e4b41cafcf1d434/article/details/68926534
  [15]: http://docs.opencv.org/3.0-beta/doc/tutorials/features2d/feature_detection/feature_detection.htmlp://qiita.com/yizumi1012xxx/items/762005e4b41cafcf1d434/article/details/68926534
  [16]: https://github.com/opencv