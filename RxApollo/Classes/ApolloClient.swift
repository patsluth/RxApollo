//
//  ApolloClient.swift
//  RxApollo
//
//  Created by Pat Sluth on 2019-06-28.
//  Copyright © 2019 Pat Sluth. All rights reserved.
//

import UIKit

import Apollo
import RxSwift
import PromiseKit
import CancelForPromiseKit





public extension ApolloClient
{
	func fetch<Q>(query: () -> Q,
				  cachePolicy: CachePolicy = .returnCacheDataElseFetch,
				  context: UnsafeMutableRawPointer? = nil,
				  queue: DispatchQueue = DispatchQueue.main) -> CancellablePromise<Q.Data>
		where Q: GraphQLQuery
	{
		return self.fetch(query(), cachePolicy: cachePolicy, context: context, queue: queue)
	}
	
	func fetch<Q>(_ query: Q,
				  cachePolicy: CachePolicy = .returnCacheDataElseFetch,
				  context: UnsafeMutableRawPointer? = nil,
				  queue: DispatchQueue = DispatchQueue.main) -> CancellablePromise<Q.Data>
		where Q: GraphQLQuery
	{
		let (promise, resolver) = CancellablePromise<Q.Data>.pending()
		
		let cancellable = self.fetch(query: query,
									 cachePolicy: cachePolicy,
									 context: context,
									 queue: queue,
									 resultHandler: query.makeResultHandler({
										do {
											resolver.fulfill(try $0.get())
										} catch {
											resolver.reject(error)
										}
									}))
		
		promise.appendCancellableTask(task: CancellableFunction(cancellable.cancel),
									  reject: nil)
		
		return promise
	}
	
	func perform<M>(mutation: () -> M,
					context: UnsafeMutableRawPointer? = nil,
					queue: DispatchQueue = DispatchQueue.main) -> CancellablePromise<M.Data>
		where M: GraphQLMutation
	{
		return self.perform(mutation(), context: context, queue: queue)
	}
	
	func perform<M>(_ mutation: M,
					context: UnsafeMutableRawPointer? = nil,
					queue: DispatchQueue = DispatchQueue.main) -> CancellablePromise<M.Data>
		where M: GraphQLMutation
	{
		let (promise, resolver) = CancellablePromise<M.Data>.pending()
		
		let cancellable = self.perform(mutation: mutation,
									   context: context,
									   queue: queue,
									   resultHandler: mutation.makeResultHandler({
										do {
											resolver.fulfill(try $0.get())
										} catch {
											resolver.reject(error)
										}
									}))
		
		promise.appendCancellableTask(task: CancellableFunction(cancellable.cancel),
									  reject: nil)
		
		return promise
	}
	
	func watch<Q>(query: () -> Q,
				  cachePolicy: CachePolicy = .returnCacheDataElseFetch,
				  queue: DispatchQueue = DispatchQueue.main) -> ApolloWatcherObservable<Q>
		where Q: GraphQLQuery
	{
		return self.watch(query(), cachePolicy: cachePolicy, queue: queue)
	}
	
	func watch<Q>(_ query: Q,
				  cachePolicy: CachePolicy = .returnCacheDataElseFetch,
				  queue: DispatchQueue = DispatchQueue.main) -> ApolloWatcherObservable<Q>
		where Q: GraphQLQuery
	{
		return ApolloWatcherObservable(apollo: self,
									   query: query,
									   cachePolicy: cachePolicy,
									   queue: queue)
	}
	
	func subscribe<S>(subscription: () -> S,
					  queue: DispatchQueue = DispatchQueue.main) -> Observable<Swift.Result<S.Data, Error>>
		where S: GraphQLSubscription
	{
		return self.subscribe(subscription(), queue: queue)
	}
	
	func subscribe<S>(_ subscription: S,
					  queue: DispatchQueue = DispatchQueue.main) -> Observable<S.ResultType>
		where S: GraphQLSubscription
	{
		let observable = Observable<S.ResultType>.create({ [unowned self] observable in
			let cancellable = self.subscribe(subscription: subscription,
											 queue: queue,
											 resultHandler: subscription.makeResultHandler({
												observable.onNext($0)
											}))
			
			return Disposables.create(with: {
				cancellable.cancel()
			})
		})
		
		return observable
			.map({
				if case let .failure(error) = $0, error.isCancelled {
					throw error
				} else {
					return $0
				}
			}).catchError({ error in
				if error.isCancelled {
					return .empty()
				}
				throw error
			})
	}
}




