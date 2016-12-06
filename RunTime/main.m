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
        
        
        //动态创建类
        // 创建一个新类和元类
        Class objc_allocateClassPair ( Class superclass, const char *name, size_t extraBytes );
        
        // 销毁一个类及其相关联的类
        void objc_disposeClassPair ( Class cls );
        
        // 在应用中注册由objc_allocateClassPair创建的类
        void objc_registerClassPair ( Class cls );
        //为了创建一个新类，我们需要调用objc_allocateClassPair。然后使用诸如class_addMethod，class_addIvar等函数来为新创建的类添加方法、实例变量和属性等。完成这些后，我们需要调用objc_registerClassPair函数来注册类，之后这个新类就可以在程序中使用了。
        
        //实例方法和实例变量应该添加到类自身上，而类方法应该添加到类的元类上
        
//        Class cls1 = objc_allocateClassPair(MyClass.class, "MySubClass", 0);
//        class_addMethod(cls1, @selector(submethod1), (IMP)imp_submethod1, "v@:");
//        class_replaceMethod(cls1, @selector(method1), (IMP)imp_submethod1, "v@:");
//        class_addIvar(cls1, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
//
//        objc_property_attribute_t type = {"T", "@\"NSString\""};
//        objc_property_attribute_t ownership = { "C", "" };
//        objc_property_attribute_t backingivar = { "V", "_ivar1"};
//        objc_property_attribute_t attrs[] = {type, ownership, backingivar};
//        
//        class_addProperty(cls1, "property2", attrs, 3);
//        objc_registerClassPair(cls1);
//        
//        id instance = [[cls1 alloc] init];
//        [instance performSelector:@selector(submethod1)];
//        [instance performSelector:@selector(method1)];
        
   
        //动态创建对象
        // 创建类实例
        id class_createInstance ( Class cls, size_t extraBytes );
        
        // 在指定位置创建类实例
        id objc_constructInstance ( Class cls, void *bytes );
        
        // 销毁类实例
        void * objc_destructInstance ( id obj );
        
        id theObject = class_createInstance(NSString.class,sizeof(unsigned));//该函数在ARC环境下无法使用
        id str1 = [theObject init];
        NSLog(@"str1 class:%@",[str1 class]);
        
        id str2 = [[NSString alloc]initWithString:@"test"];
        NSLog(@"str2 class:%@",[str2 class]);
        
        //1.针对整个对象进行操作的函数，这类函数包含
        // 返回指定对象的一份拷贝
        id object_copy ( id obj, size_t size );
        
        // 释放指定对象占用的内存
        id object_dispose ( id obj );
        //有这样一种场景，假设我们有类A和类B，且类B是类A的子类。类B通过添加一些额外的属性来扩展类A。现在我们创建了一个A类的实例对象，并希望在运行时将这个对象转换为B类的实例对象，这样可以添加数据到B类的属性中。这种情况下，我们没有办法直接转换，因为B类的实例会比A类的实例更大，没有足够的空间来放置对象。此时，我们就要以使用以上几个函数来处理这种情况，
        
        NSObject *a = [[NSObject alloc] init];
        id newB = object_copy(a, class_getInstanceSize(MyClass.class));
        object_setClass(newB, MyClass.class);
        object_dispose(a);
        
        //2.针对对象实例变量进行操作的函数
        // 修改类实例的实例变量的值
        Ivar object_setInstanceVariable ( id obj, const char *name, void *value );
        
        // 获取对象实例变量的值
        Ivar object_getInstanceVariable ( id obj, const char *name, void **outValue );
        
        // 返回指向给定对象分配的任何额外字节的指针
        void * object_getIndexedIvars ( id obj );
        
        // 返回对象中实例变量的值
        id object_getIvar ( id obj, Ivar ivar );
        
        // 设置对象中实例变量的值
        void object_setIvar ( id obj, Ivar ivar, id value );
        
        //3.针对对象的类进行操作的函数，这类函数包含：
        // 返回给定对象的类名
        const char * object_getClassName ( id obj );
        
        // 返回对象的类
        Class object_getClass ( id obj );
        
        // 设置对象的类
        Class object_setClass ( id obj, Class cls );
        
        //获取类定义
        // 获取已注册的类定义的列表
        int objc_getClassList ( Class *buffer, int bufferCount );
        
        // 创建并返回一个指向所有已注册类的指针列表
        Class * objc_copyClassList ( unsigned int *outCount );
        
        // 返回指定类的类定义
        Class objc_lookUpClass ( const char *name );
        Class objc_getClass ( const char *name );
        Class objc_getRequiredClass ( const char *name );
        /*
         获取类定义的方法有三个：objc_lookUpClass, objc_getClass和objc_getRequiredClass。如果类在运行时未注册，则objc_lookUpClass会返回nil，而objc_getClass会调用类处理回调，并再次确认类是否注册，如果确认未注册，再返回nil。而objc_getRequiredClass函数的操作与objc_getClass相同，只不过如果没有找到类，则会杀死进程。
        */
        
        // 返回指定类的元类
        Class objc_getMetaClass ( const char *name );
        
        /*
         objc_getMetaClass函数：如果指定的类没有注册，则该函数会调用类处理回调，并再次确认类是否注册，如果确认未注册，再返回nil。不过，每个类定义都必须有一个有效的元类定义，所以这个函数总是会返回一个元类定义，不管它是否有效
         */
        
        //objc_getClassList函数：获取已注册的类定义的列表。我们不能假设从该函数中获取的类对象是继承自NSObject体系的，所以在这些类上调用方法是，都应该先检测一下这个方法是否在这个类中实现。
        int numClasses;
        Class *classes = NULL;
        numClasses = objc_getClassList(NULL, 0);
        if (numClasses>0) {
            classes = malloc(sizeof(Class)*numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            NSLog(@"number of classes:%d",numClasses);
            
            for(int i = 0 ;i<numClasses;i++){
            
                Class cls = classes[i];
                NSLog(@"class name:%s",class_getName(cls));
            }
            free(classes);
        }
        
        //类型编码(Type Encoding)
        //作为对Runtime的补充，编译器将每个方法的返回值和参数类型编码为一个字符串，并将其与方法的selector关联在一起。这种编码方案在其它情况下也是非常有用的，因此我们可以使用@encode编译器指令来获取它。当给定一个类型时，@encode返回这个类型的字符串编码。这些类型可以是诸如int、指针这样的基本类型，也可以是结构体、类等类型。事实上，任何可以作为sizeof()操作参数的类型都可以用于@encode()。
        
        //Objective-C不支持long double类型。@encode(long double)返回d，与double是一样的。
        float a1[] = {1.0, 2.0, 3.0};
        NSLog(@"array encoding type: %s", @encode(typeof(a1)));
        //2014-10-28 11:44:54.731 RuntimeTest[942:50791] array encoding type: [3f]
        
        
        //成员变量、属性
        
        //基础数据类型 Ivar
        //Ivar是表示实例变量的类型，其实际是一个指向objc_ivar结构体的指针
        typedef struct objc_ivar *Ivar;
        
        struct objc_ivar {
            char *ivar_name                 OBJC2_UNAVAILABLE;  // 变量名
            char *ivar_type                 OBJC2_UNAVAILABLE;  // 变量类型
            int ivar_offset                 OBJC2_UNAVAILABLE;  // 基地址偏移字节
            #ifdef __LP64__
            int space                       OBJC2_UNAVAILABLE;
            #endif
            };
        
         //objc_property_t
        //objc_property_t是表示Objective-C声明的属性的类型，其实际是指向objc_property结构体的指针，其定义如下
        typedef struct objc_property *objc_property_t;
        
        //objc_property_attribute_t  objc_property_attribute_t定义了属性的特性(attribute)，它是一个结构体
        
        typedef struct {
            const char *name;           // 特性名
            const char *value;          // 特性值
        } objc_property_attribute_t;
        
        //关联对象(Associated Object)
        //我们可以把关联对象想象成一个Objective-C对象(如字典)，这个对象通过给定的key连接到类的一个实例上。不过由于使用的是C接口，所以key是一个void指针(const void *)。我们还需要指定一个内存管理策略，以告诉Runtime如何管理这个对象的内存。这个内存管理的策略可以由以下值指定
        //OBJC_ASSOCIATION_ASSIGN
        //OBJC_ASSOCIATION_RETAIN_NONATOMIC
        //OBJC_ASSOCIATION_COPY_NONATOMIC
        //OBJC_ASSOCIATION_RETAIN
        //OBJC_ASSOCIATION_COPY
        //当宿主对象被释放时，会根据指定的内存管理策略来处理关联对象。如果指定的策略是assign，则宿主释放时，关联对象不会被释放；而如果指定的是retain或者是copy，则宿主释放时，关联对象会被释放。我们甚至可以选择是否是自动retain/copy。
        
        //成员变量、属性的操作方法
        
        //成员变量  成员变量操作包含以下函数：
        // 获取成员变量名
        const char * ivar_getName ( Ivar v );
        
        // 获取成员变量类型编码
        const char * ivar_getTypeEncoding ( Ivar v );
        
        // 获取成员变量的偏移量
        ptrdiff_t ivar_getOffset ( Ivar v );
        
        //关联对象
        // 设置关联对象
        void objc_setAssociatedObject ( id object, const void *key, id value, objc_AssociationPolicy policy );
        
        // 获取关联对象
        id objc_getAssociatedObject ( id object, const void *key );
        
        // 移除关联对象
        void objc_removeAssociatedObjects ( id object );
        //关联对象及相关实例已经在前面讨论过了，在此不再重复。
        
        //属性
        // 获取属性名
        const char * property_getName ( objc_property_t property );
        
        // 获取属性特性描述字符串
        const char * property_getAttributes ( objc_property_t property );
        
        // 获取属性中指定的特性
        char * property_copyAttributeValue ( objc_property_t property, const char *attributeName );
        //property_copyAttributeValue函数，返回的char *在使用完后需要调用free()释放。
        
        // 获取属性的特性列表
        objc_property_attribute_t * property_copyAttributeList1 ( objc_property_t property, unsigned int *outCount );
        //property_copyAttributeList函数，返回值在使用完后需要调用free()释放。
        
        
        //方法和消息
        //SEL又叫选择器，是表示一个方法的selector的指针，其定义如下:
        typedef struct objc_selector *SEL;
        
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}














































