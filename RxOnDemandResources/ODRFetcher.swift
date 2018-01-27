//
//  ODRFetcher.swift
//  RxOnDemandResources
//
//  Created by Maxim Volgin on 28/01/2018.
//  Copyright © 2018 Maxim Volgin. All rights reserved.
//

import os.log
import RxSwift

class ODRFetcher: NSObject {
    
    private static let keyPath = "fractionCompleted"
    
    typealias Observer = AnyObserver<Progress>
    
    private let observer: Observer
    private var request: NSBundleResourceRequest
    private let progressObservingContext = UnsafeMutableRawPointer.init(bitPattern: 0)
    
    init(observer: Observer, tags: Set<String>, bundle: Bundle? = nil) {
        self.observer = observer
        self.request = bundle == nil ? NSBundleResourceRequest(tags: tags) : NSBundleResourceRequest(tags: tags, bundle: bundle!)
        self.request.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
    }
    
    func fetch() {
        request.conditionallyBeginAccessingResources { [unowned self] available in
            os_log("available: %@", log: Log.odr, type: .info, "\(available)")
            guard available else {
                self.kvoSubscribe()
                self.request.beginAccessingResources { [unowned self] error in
                    self.kvoUnsubscribe()
                    guard let error = error else {
                        os_log("downloaded", log: Log.odr, type: .info)
                        self.observer.on(.completed)
                        return
                    }
                    os_log("tags: %@ error: %@", log: Log.odr, type: .error, self.request.tags, error.localizedDescription)
                    self.observer.on(.error(error))
                }
                return
            }
            self.observer.on(.completed)
        }
    }
    
    func dispose() {
        self.request.endAccessingResources()
    }
    
    // MARK:- KVO
    
    private func kvoSubscribe() {
        self.request.progress.addObserver(self, forKeyPath: ODRFetcher.keyPath, options: [.new, .initial], context: progressObservingContext)
    }
    
    private func kvoUnsubscribe() {
        self.request.progress.removeObserver(self, forKeyPath: ODRFetcher.keyPath)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == progressObservingContext && keyPath == ODRFetcher.keyPath {
            let progress = object as! Progress
            self.observer.on(.next(progress))
        }
    }
    
}
