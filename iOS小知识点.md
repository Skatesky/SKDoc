# iOS小知识点

### 1 滑动返回失效

* 设置导航栏左侧按钮或者隐藏导航栏，会导致系统`滑动返回`失效。

```
UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button_image"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped:)]; 
self.navigationItem.leftBarButtonItem = backButtonItem;

或者

[self.navigationController setNavigationBarHidden:YES animated:NO];


```

这种时候，如果想要启用系统的`滑动返回`功能，可进行如下设置：    

 先遵循代理

```
@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

```
再在`viewDidLoad:`中或`viewWillAppear:`中设置代理

```
self.navigationController.interactivePopGestureRecognizer.delegate = self;
```
我们可以再代理方法中进行更多设置：   

```
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer 
{ 
 // 编辑flag为打开时使滑动返回无效
  if(self.Edit)
   { return NO; } 
   else
   { return YES; }
}

```