# iOS中的几种锁

首先，附上ibireme在 [不再安全的 OSSpinLock](https://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/) 文中对几种锁的性能分析表：

![](image/lock_benchmark.png)

>  注： iOS 10.0之后，苹果推出了 `OSSpinLock` 的替代方案 `os_unfair_lock`，其性能同 `OSSpinLock` 基本相同。  

可以看到除了 `OSSpinLock/os_unfair_lock` 外，`dispatch_semaphore` 和 `pthread_mutex` 性能是最高的。因此，在项目开发中，优先考虑这两种锁。

这几个种锁的运用，可以参考 [iOS 开发中的八种锁（Lock）](https://www.jianshu.com/p/8b8a01dd6356)。

参考   
1 [不再安全的 OSSpinLock](https://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/)    
2 [iOS 开发中的八种锁（Lock）](https://www.jianshu.com/p/8b8a01dd6356)
