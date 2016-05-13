# KeyboardAdapt
1、键盘自适应，简单两句代码可以自动适应键盘弹出。

2、使用方法:在系统方法application:didFinishLaunchingWithOptions: 添加下列3行代码，不开启对应功能可不添加。
想在某些视图关闭某些功能，在对添加对应设置方法，设置为NO

 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    //开启键盘适应
    [[KeyboardAdapt keyboardAdapt] setFAdaptStartBool:YES];
    
    //开启键盘点击隐藏功能
   [[KeyboardAdapt keyboardAdapt] setFTapHiddenBool:YES];
    
    //开启键盘滚动隐藏功能
    [[KeyboardAdapt keyboardAdapt] setFDraggingHiddenBool:YES];
    
    return YES;

  }
  
  4、有什么需求，或者有什么问题，可联系我。这个是我自己弄出来学习和平常使用的。
