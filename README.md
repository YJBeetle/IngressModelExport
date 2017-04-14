# IngressModelExport
该代码用于导出ingress中的模型

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/xmp.png)

起因是我想做一个短片，使用Ae合成手拿INGRESS道具的效果。

第一反映就是去游戏中提取，没想到看似obj拓展名的文件实际上file结果为『Java serialization data, version 5』

反编译之，最终找到相关解析代码，阅读后重新写出此项目，用于将INGRESS模型导出为OBJ模型。

（对Java一窍不通，昨天才看的书入门，代码各种问题请指正~）

ps：本来想写Makefile的……（逃）

## 编译：
javac Main.java

#运行：
java Main ingress_obj/1.112.0_android_apk/scanner/interestCapsuleResource.obj -o a.obj

#效果图：
![](https://github.com/YJBeetle/ingress_obj_reader/raw/master/demo/img/E948CD1C-4024-4F32-AB03-137156229EB5.png)

![](https://github.com/YJBeetle/ingress_obj_reader/raw/master/demo/img/F1DA3AB1-2EEB-420C-BAFB-03A8A5EF653C.png)

#某中间痛苦猜结构过程：
先是吧顶点数据全部塞进去效果如图

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/CA8E10EC-0DAB-4998-9500-33DFB3AF13E6.png)

然后猜测其中有贴图顶点

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/3CDCFE93-D327-4923-BD1C-F9B67A1B4E50.png)

（猜对了）

然后猜面

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/7A1718A1-53CF-4DE4-BE73-BCAA2025150B.png)

变得很奇怪，继续猜

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/F1DA3AB1-2EEB-420C-BAFB-03A8A5EF653C.png)

猜对了

#某无聊的截图：
为何有这么多人好奇脚的模型啥样子……（你们都是脚控么？）

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/5C207686-18BA-4011-8255-BB5143467696.png)

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/ECE710E6-AFFA-470F-883A-193FDA0F51F5.png)

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/2CBD1D88-D207-495D-8B1C-19955D870FEE.png)

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/358A3E7E-8491-4A47-88F0-CF6679B034B3.png)

这算是个对比吧。。

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/58DFF6CF-2716-449E-B0EA-B4D57E583380.png)

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/794563DE17C3C8E8961BDB2D91DA3F00.jpg)

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/3CA56725-4AEF-48F5-B823-3766D5BB9556.png)

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/D4C4829B6796C5E601B470D9CC66BA5F.jpg)

蓝桶（之所以是蓝桶不是红桶……因为红桶还要画贴图）

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/25CF7876-8CE1-48DE-B6BE-F6B8C30D27D5.png)

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/932ADE11-BD38-44A1-9D3E-3A8AFB6B0BF0.png)

![](https://github.com/YJBeetle/IngressModelExport/raw/master/demo/img/CEE64625-A5B0-4734-99C1-D5C601B288A5.png)

#贴图：
研究一晚上，@zhiyb猜想Texture vertices序号和Geometric vertices序号（以及后来才发现有的模型还有的Vertex normals）可能是一样的。然后实验证明正确。所以只需要在surface中写上一样的Texture vertices序号就可以了。

所以现在程序导出的模型是带有正确的uv数据的，所以自己贴图上去吧，scanner的大部分模型贴图应该都是genericModTexture.png，不过Y轴需要翻转一下。

Ingress巧妙的设计，不同模型贴图顶点坐标的巧妙利用，实现不同模型用同一个贴图。

#最后：
某些c4d文件也直接上传了，可以直接编辑。
