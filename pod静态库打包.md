## 使用CocoaPods开发并打包静态库
摘自：[使用CocoaPods开发并打包静态库](http://www.cnblogs.com/brycezhang/p/4117180.html)
     
`Cocoapods`作为OS X和iOS开发平台的类库管理工具，已经非常完善和强大。通常我们用pod来管理第三方开源类库，但我们也极有可能会开发一个用pod管理依赖关系的静态类库给其他人使用，而又不愿意公开源代码，比如一些SDK，那么就需要打包成`.a`文件。本文将以一个依赖于`ASIHTTPRequest`的静态类库，来演示如何创建使用了`CocoaPods`的静态类库以及打包的过程。
## 开发静态库（Static Library）

创建静态库，有2种方法。
### 不基于pod手动创建(deprecated)

过程比较繁琐，纯体力活不推荐，大体步骤说下

    在Xcode中创建一个Cocoa Touch Static Library；
    创建Podfile文件；
    执行pod install完成整个项目的搭建；
    如果需要demo，手动创建示例程序，使用pod添加对私有静态库的依赖，重复执行pod install完成示例项目的搭建。

### 基于pod自动创建

只需要输入pod的`lib`命令即可完成初始项目的搭建，下面详细说明具体步骤，以`BZLib`作为项目名演示。
#### 1.执行命令pod lib create BZLib
在此期间需要确认下面4个问题。

```
Would you like to provide a demo application with your library? [ Yes / No ]
yes
Which testing frameworks will you use? [ Specta / Kiwi / None ]
Kiwi
Would you like to do view based testing? [ Yes / No ]
No
What is your class prefix?
BZ
```

第一个问题询问是否提供一个demo项目，通常选择`Yes`，其他的可以根据需要选择。命令执行完后，就会创建好一个通过cocoapods管理依赖关系的基本类库框架。    

#### 2.打开BZLib.podspec文件，修改类库配置信息

```
Pod::Spec.new do |s|
  s.name             = "BZLib"
  s.version          = "0.1.0"
  s.summary          = "A short description of BZLib."
  s.description      = <<-DESC
                       An optional longer description of BZLib

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/BZLib"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "brycezhang" => "brycezhang.cn@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/BZLib.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.{h,m}'
  s.resource_bundles = {
    'BZLib' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'MobileCoreServices', 'CFNetwork', 'CoreGraphics'
  s.libraries  = 'z.1'
  s.dependency 'YSASIHTTPRequest', '~> 2.0.1'
end
```
按照默认配置，类库的源文件将位于`Pod/Classes`文件夹下，资源文件位于`Pod/Assets`文件夹下，可以修改`s.source_files`和`s.resource_bundles`来更换存放目录。`s.public_header_files`用来指定头文件的搜索位置。    

`s.frameworks`和`s.libraries`指定依赖的SDK中的framework和类库，需要注意，依赖项不仅要包含你自己类库的依赖，还要包括所有第三方类库的依赖，只有这样当你的类库打包成`.a`或`.framework`时才能让其他项目正常使用。示例中`s.frameworks`和`s.libraries`都是`ASIHTTPRequest`的依赖项。
`podspec`文件的详细说明可以看`Podspec Syntax Reference`。   

#### 3.进入`Example`文件夹，执行`pod install`，让demo项目安装依赖项并更新配置。

```
localhost:Example bryce$ pod install --no-repo-update
Analyzing dependencies
Fetching podspec for `BZLib` from `../`
Downloading dependencies
Installing BZLib 0.1.0 (was 0.1.0)
Using Kiwi (2.3.1)
Installing Reachability (3.2)
Installing YSASIHTTPRequest (2.0.1)
Generating Pods project
Integrating client project
```

#### 4.添加代码。因为是示例，只简单封装一下GET请求。

添加`BZHttphelper`类，注意文件存放的位置在`Pod/Classes`目录下，跟podspec配置要一致。   
运行`Pod install`，让demo程序加载新建的类。也许你已经发现了，只要新增加类/资源文件或依赖的三方库都需要重新运行`Pod install`来应用更新。
编写代码。示例代码很简单，创建了一个GET请求的包装方法。

```
#import "BZHttphelper.h"
#import <YSASIHTTPRequest/ASIHTTPRequest.h>

@implementation BZHttphelper

- (void)getWithUrl:(NSString *)url withCompletion:(void (^)(id responseObject))completion failed:(void (^)(NSError *error))failed
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest *weakrequest = request;
    [request setCompletionBlock:^{
         NSString *responseString = [weakrequest responseString];
         completion(responseString);
     }];

    [request setFailedBlock:^{
         NSError *error = [weakrequest error];
         failed(error);
     }];
    [request start];
}

@end

demo项目中调用测试。

#import "BZViewController.h"
#import <BZLib/BZHttphelper.h>

@interface BZViewController ()
{
    BZHttphelper *_httpHelper;
}
@end

@implementation BZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _httpHelper = [BZHttphelper new];
    [_httpHelper getWithUrl:@"http://wcf.open.cnblogs.com/blog/u/brycezhang/posts/1/5" withCompletion:^(id responseObject) {
         NSLog(@"[Completion]:%@", responseObject);
     } failed:^(NSError *error) {
         NSLog(@"[Failed]:%@", error);
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

成功打印，调用成功！

2014-11-23 16:52:23.946 BZLib[6329:96133] [Completion]:<?xml version="1.0" encoding="utf-8"?><feed xmlns="http://www.w3.org/2005/Atom"><title type="text">博客园
...
```
提交本地代码库    
1.修改s.source。根据你的实际路径修改。

	s.source = { :git => "/Users/name/workspace/BZLib", :tag => '0.1.0' }

2.提交源码，并打tag。   

```
git add .
git commit -a -m 'v0.1.0'
git tag -a 0.1.0 -m 'v0.1.0'
```
验证类库

开发完成静态类库之后，需要运行`pod lib lint`验证一下类库是否符合pod的要求。可以通过添加`--only-errors`忽略一些警告。

```
pod lib lint BZLib.podspec --only-errors --verbose
...
BZLib passed validation.
```

打包类库

需要使用一个cocoapods的插件`cocoapods-packager`来完成类库的打包。当然也可以手动编译打包，但是过程会相当繁琐。

    安装打包插件
    终端执行以下命令

    sudo gem install cocoapods-packager

    打包
    命令很简单，执行

    pod package BZLib.podspec --library --force

    其中--library指定打包成.a文件，如果不带上将会打包成.framework文件。--force是指强制覆盖。最终的目录结构如下

    |____BZLib.podspec
    |____ios
    | |____libBZLib.a

需要特别强调的是，该插件通过对引用的三方库进行重命名很好的解决了类库命名冲突的问题。

文中的示例代码下载
BZLib

本文是通过pod及其插件实现了创建和打包的功能，如果对具体实现细节感兴趣可以查看相关源码，或者查看文末的扩展阅读进一步了解。
扩展阅读

    Developing private static library for iOS with CocoaPods
    Automatic build of static library for iOS and many architectures
    Avoiding dependency collisions in iOS static library managed by CocoaPods

