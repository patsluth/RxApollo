//
//  ApolloWatcherObservable.swift
//  RxApollo
//
//  Created by Pat Sluth on 2019-06-28.
//  Copyright © 2019 Pat Sluth. All rights reserved.
//

import Foundation

import Apollo
import RxSwift
import RxCocoa
import RxSwiftExt





public class ApolloWatcher<Q>: NSObject, Cancellable, ObservableConvertibleType
	where Q: GraphQLQuery
{
	public typealias Element = Q.ResultType
	
	private let variable = BehaviorRelay<Element?>(value: nil)
	private(set) var watcher: GraphQLQueryWatcher<Q>!
	
	private override init()
	{
		super.init()
	}
	
	internal init(apollo: ApolloClient,
				  query: Q,
				  cachePolicy: CachePolicy = .returnCacheDataElseFetch,
				  queue: DispatchQueue = DispatchQueue.main)
	{
		super.init()
		
		defer {
			self.watcher = apollo.watch(query: query,
										cachePolicy: cachePolicy,
										queue: queue,
										resultHandler: query.makeResultHandler({ [unowned self] in
											self.variable.accept($0)
										}))
		}
	}
	
	public func refetch()
	{
		self.watcher.refetch()
	}
	
	public func cancel()
	{
		self.watcher.cancel()
	}
	
	public func asObservable() -> Observable<Element>
	{
		return self.variable
			.asObservable()
			.takeUntil(self.rx.deallocated)
			.unwrap()
			.catchError({ error in
				if error.isCancelled {
					return Observable.empty()
				}
				throw error
			})
	}
	
	deinit
	{
		self.watcher.cancel()
	}
}




