# RxOnDemandResources
RxOnDemandResources (based on RxSwift)

Basic usage.

```swift

Bundle
    .main
    .rx
    .demandResources(withTags: tags) // tags: Set<String>
    .subscribeOn(Scheduler.concurrentUser) // declare your scheduler first
    .observeOn(Scheduler.concurrentMain) // declare your scheduler first
    .subscribe { event in
        switch event {
        case .next(let progress):
            self.showProgress(progress: Float(progress.fractionCompleted)) // declare your handler first
        case .error(let error):
            break // handle appropriately
        case .completed:
            if let url = Bundle.main.url(forResource: file, withExtension: "") {
                os_log("url: %@", log: Log.odr, type: .info, "\(url)")
                // TODO use your resource
            }
        }
    }
    .disposed(by: self.disposeBag)
```

Carthage setup.

```
github "maxvol/RxOnDemandResources" ~> 0.0.2

```
