## 奔溃问题总结

* 1. Invalid parameter not satisfying: URLString

```
异常提示： NSInternalInconsistencyException

异常信息 ：Invalid parameter not satisfying: URLString

原因： 触发断言，NSAsserttionHandler对象抛出的 NSInternalInconsistencyException 异常。具体原因是URL不合法，比如包含了中文等。

解决方案： 对URL进行UTF8编码

urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

```


