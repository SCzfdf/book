# Class文件

Class文件是JVM能识别**16进制文件**, 由`javac`命令编译而成



## Javac编译过程

[JVM编译器种类](https://blog.csdn.net/qq_45662823/article/details/124949631)

[java前端编译和后端编译理解](https://blog.csdn.net/qq_35207086/article/details/123758442)

将java文件转换为class文件的操作也称之为**前端编译**, 前端指的是在JVM执行之前. 

前端编译仅仅是一个**翻译**的操作, 对代码执行效率几乎没有优化. 可以用于实现一些语法糖(泛型, 内部类等)

翻译过程如下:

![前端编译过程](Class%E6%96%87%E4%BB%B6.assets/6d1814aad3342c64f2ebc17214500891.png)



## 解析Class文件

[官网class format](https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html)

```class
ClassFile {
    u4             magic; // 标明class文件的解析格式, 为产量cafe babe
    u2             minor_version; // 编译器的主要版本
    u2             major_version; // 编译器的次要版本
    u2             constant_pool_count; // 常量池计数
    cp_info        constant_pool[constant_pool_count-1]; // 常量
    u2             access_flags;
    u2             this_class;
    u2             super_class;
    u2             interfaces_count;
    u2             interfaces[interfaces_count];
    u2             fields_count;
    field_info     fields[fields_count];
    u2             methods_count;
    method_info    methods[methods_count];
    u2             attributes_count;
    attribute_info attributes[attributes_count];
}
```

