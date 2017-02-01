# IngressModelExport
该代码用于导出ingress中的模型

起因是我想做一个短片，使用Ae合成手拿INGRESS道具的效果。
第一反映就是去游戏中提取，没想到看似obj拓展名的文件实际上file结果为『Java serialization data, version 5』
反编译之，最终找到相关解析代码，阅读后重新写出此项目，用于将INGRESS模型导出为OBJ模型。
（对Java一窍不通，昨天才看的书入门，代码各种问题请指正~）

ps：本来想写Makefile的……（逃）

##编译：
javac Main.java

##运行：
java Main ingress_obj/1.112.0_android_apk/scanner/interestCapsuleResource.obj > a.obj

##效果图：
![](https://github.com/YJBeetle/ingress_obj_reader/raw/master/img/E948CD1C-4024-4F32-AB03-137156229EB5.png)
![](https://github.com/YJBeetle/ingress_obj_reader/raw/master/img/F1DA3AB1-2EEB-420C-BAFB-03A8A5EF653C.png)

##某渲染出：
（让我先push然后拷贝地址吧。。。）