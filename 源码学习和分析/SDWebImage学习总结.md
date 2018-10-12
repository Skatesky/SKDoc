## SDWebImage学习总结

基于`SDWebImage`版本号：4.4.1

```
pod 'SDWebImage', '4.4.1' 
```

首先，从我们常用的方法入手，`UIImageView+WebCache`分类中的方法：    

```
- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                 completed:(nullable SDExternalCompletionBlock)completedBlock;
```
和其他类似方法，最后都是调用的`UIView+WebCache`的方法：   

```
- (void)sd_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(SDWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
                     setImageBlock:(nullable SDSetImageBlock)setImageBlock
                          progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable SDExternalCompletionBlock)completedBlock
                           context:(nullable NSDictionary<NSString *, id> *)context;
```

该方法实现中，首先会`cancell`掉指定`key`的所有请求：

```
NSString *validOperationKey = operationKey ?: NSStringFromClass([self class]);
[self sd_cancelImageLoadOperationWithKey:validOperationKey];
```	


