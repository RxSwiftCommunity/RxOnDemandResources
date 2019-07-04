//
//  Bundle+Rx.swift
//  RxOnDemandResources
//
//  Created by Maxim Volgin on 28/01/2018.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import os.log
import RxSwift

public extension Reactive where Base: Bundle {
    
    public func demandResources(withTags tags: Set<String>) -> Observable<Progress> {
        return Observable.create { observer in
            let fetcher = ODRFetcher(observer: observer, tags: tags, bundle: self.base)
            fetcher.fetch()
            return Disposables.create {
                os_log("disposed for tags: %@", log: Log.odr, type: .info, tags)
                fetcher.dispose()
            }
        }
    }
    
}
