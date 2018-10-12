# NSURLSession的线程问题

在`AFNetworking`中，请求的是什么线程，回调便在什么线程。（确定吗？）原以为`NSURLSession`也是如此，然而在实践中却发现并不是。

```

```

--------
### 一.NSURLSession有两种使用方式：
1

```
NSURLSession* session = [NSURLSession sharedSession];
```

此方式，没有设置`NSURLSession`的`delegate`，因此不会走代理接口，所以若要实现有意义的功能，在创建各种`Task`的时候，需要使用带`completionHandler`的接口，如：

```
NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {}];
```


2

```
NSURLSession* session = [NSURLSessionsessionWithConfiguration:[NSURLSessionConfiguration            defaultSessionConfiguration]delegate:selfdelegateQueue:nil];
```

此方式下，已经设置`NSURLSession`的`delegate`，因此期望会对返回的响应及数据走代理方式进行处理。    
但是，需要注意的是，如果在创建`Task`的时候，使用了带有`completionHandler`参数的方式，则响应仍然会在`completionHandler`的`block`中进行处理，并且不会走代理接口。因此，若保证响应走代理接口，则要使用不带`completionHandler`参数的接口，或者将`completionHandler`的`block`置为`nil`。



### 二.响应的执行线程问题

1.对于创建的`task`，如果其响应处理的方式为通过上述`completionHandler`中`block`的方式处理：

  1）若`session`的创建方式为`NSURLSession* session = [NSURLSession sharedSession]`，则不管`session`执行的线程为主线程还是子线程，`block`中的代码执行线程均为任意选择的子线程。

  2）若`session`的创建方式为   

```
NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration            defaultSessionConfiguration] delegate:self delegateQueue:nil]，
```

* 若`delegateQueue = nil`，则不管`session`执行的线程为主线程还是子线程，`block`中的代码执行线程均为任意选择的子线程；

* 若`delegateQueue = [NSOperationQueue mainQueue]`,则不管`session`执行的线程为主线程还是子线程，则`block`中的代码执行线程为主线程中执行；

* 若`delegateQueue = [[NSOperationQueue alloc]init]`，则不管`session`执行的线程为主线程还是子线程，`block`中的代码执行线程均为任意选择的子线程；


2.对于创建的task，如果其响应处理的方式为通过上述`delegate`代理接口的方式处理：     

* 若`delegateQueue = nil`，则不管`session`执行的线程为主线程还是子线程，`block`中的代码执行线程均为任意选择的子线程；

* 若`delegateQueue = [NSOperationQueue mainQueue]`,则不管`session`执行的线程为主线程还是子线程，则`block`中的代码执行线程为主线程中执行；

* 若`delegateQueue = [[NSOperationQueue alloc] init]`，则不管`session`执行的线程为主线程还是子线程，`block`中的代码执行线程均为任意选择的子线程；


### 三.Runloop
对于`NSURLSession`，当其在子线程中开启任务，并通过代理方式进行响应的处理时，此处不需要手动开启此线程的`runloop`，这一点不同于`NSURLConnection`。

本文来自 `_myHonestSunshine_` 的CSDN 博客 ，全文地址请点击：[NSURLSession与线程问题](https://blog.csdn.net/u012361288/article/details/54607551?utm_source=copy)

---------------------


