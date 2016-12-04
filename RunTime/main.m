//
//  main.m
//  RunTime
//
//  Created by YK- on 2016/12/4.
//  Copyright © 2016年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "MyClass.h"
#import <objc/runtime.h>

//http://www.jianshu.com/p/6b905584f536

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        MyClass *myClass = [[MyClass alloc]init];
        unsigned int outCount = 0;
        
        Class cls =  myClass.class;
        
        /*
         
         // 获取类的类名
         const char * class_getName ( Class cls );
         
         // 获取类的父类
         Class class_getSuperclass ( Class cls );
         
         // 判断给定的Class是否是一个元类
         BOOL class_isMetaClass ( Class cls );
         
         // 获取实例大小
         size_t class_getInstanceSize ( Class cls );
         
         // 获取类中指定名称实例成员变量的信息
         Ivar class_getInstanceVariable ( Class cls, const char *name );
         
         // 获取类成员变量的信息
         Ivar class_getClassVariable ( Class cls, const char *name );
         
         // 添加成员变量
         BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );
         
         // 获取整个成员变量列表
         Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );
         
         
         // 获取指定的属性
         objc_property_t class_getProperty ( Class cls, const char *name );
         
         // 获取属性列表
         objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );
         
         // 为类添加属性
         BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
         
         // 替换类的属性
         void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
         
         
         // 添加方法
         BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );
         
         // 获取实例方法
         Method class_getInstanceMethod ( Class cls, SEL name );
         
         // 获取类方法
         Method class_getClassMethod ( Class cls, SEL name );
         
         // 获取所有方法的数组
         Method * class_copyMethodList ( Class cls, unsigned int *outCount );
         
         // 替代方法的实现
         IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );
         
         // 返回方法的具体实现
         IMP class_getMethodImplementation ( Class cls, SEL name );
         IMP class_getMethodImplementation_stret ( Class cls, SEL name );
         
         // 类实例是否响应指定的selector
         BOOL class_respondsToSelector ( Class cls, SEL
         
         // 添加协议
         BOOL class_addProtocol ( Class cls, Protocol *protocol );
         
         // 返回类是否实现指定的协议
         BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );
         
         // 返回类实现的协议列表
         Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );
         
         class_conformsToProtocol函数可以使用NSObject类的conformsToProtocol:方法来替代。
         
         class_copyProtocolList函数返回的是一个数组，在使用后我们需要使用free()手动释放。
         
         // 获取版本号
         int class_getVersion ( Class cls );
         
         // 设置版本号
         void class_setVersion ( Class cls, int version );
         
         
         */
        //类名
        NSLog(@"myClass:%@ cls:%@",myClass,cls);
        NSLog(@"class name:%s",class_getName(cls));
        NSLog(@"========================================================");
        
        //父类
        NSLog(@"super class name:%s",class_getName(class_getSuperclass(cls)));
        NSLog(@"========================================================");
        
        //是否是元类
        NSLog(@"MyClass is %@ a meta-class",(class_isMetaClass(cls)?@"":@"not"));
        NSLog(@"========================================================");
        
        Class meta_class = objc_getMetaClass(class_getName(cls));
        NSLog(@"%s's meta-class is %s",class_getName(cls),class_getName(meta_class));
        NSLog(@"========================================================");
        
        //变量实例大小
        NSLog(@"instance size:%zu",class_getInstanceSize(cls));
        NSLog(@"========================================================");
        
        //成员变量
        Ivar *ivars = class_copyIvarList(cls, &outCount);
        for(int i = 0;i<outCount;i++){
        
            Ivar ivar = ivars[i];
            NSLog(@"instance variable's name:%s at index:%d",ivar_getName(ivar),i);
        }
        free(ivars);
        
        Ivar string = class_getInstanceVariable(cls, "_string");
        if (string != NULL) {
            NSLog(@"instance variable %s",ivar_getName(string));
        }
        NSLog(@"========================================================");
        
        //属性操作
        objc_property_t *properties = class_copyPropertyList(cls, &outCount);
        for (int i =0 ;i<outCount;i++ ) {
            objc_property_t property = properties[i];
            NSLog(@"property's name:%s",property_getName(property));
        }
        free(properties);
        
        objc_property_t array = class_getProperty(cls, "array");
        if (array!=NULL) {
            NSLog(@"property %s",property_getName(array));
        }
        NSLog(@"========================================================");
        
        //方法操作
        // 获取所有方法的数组
        Method *methods = class_copyMethodList(cls, &outCount);
        for (int i =0; i< outCount; i++) {
            Method method = methods[i];
            NSLog(@"method's signature:%s",method_getName(method));
        }
        free(methods);
        
        Method method1 = class_getInstanceMethod(cls, @selector(method1));
        if (method1 != NULL) {
            NSLog(@"method:%s",method_getName(method1));
        }
        
        Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
        if (classMethod != NULL) {
            NSLog(@"class Method:%s",method_getName(classMethod));
        }
        NSLog(@"MyClass is %@ responsed to selector:method3WithArg1:arg2:",class_respondsToSelector(cls, @selector(method3WithArg1:arg2:))?@"":@"not");
        

        //// 返回方法的具体实现
        IMP imp = class_getMethodImplementation(cls, @selector(method1));
        imp();
        NSLog(@"========================================================");
        
        //协议
        Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
        Protocol *protocol;
        for (int i = 0; i< outCount;i++) {
            protocol = protocols[i];
            NSLog(@"protocol name:%s",protocol_getName(protocol));
        }
        NSLog(@"MyClass is %@ response to protocol %s",class_conformsToProtocol(cls, protocol)?@"":@"not",protocol_getName(protocol));
        NSLog(@"========================================================");
        NSLog(@"========================================================");
        NSLog(@"========================================================");
        NSLog(@"========================================================");
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}














































