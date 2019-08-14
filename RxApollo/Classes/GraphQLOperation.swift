//
//  GraphQLOperation.swift
//  RxApollo
//
//  Created by Pat Sluth on 2019-06-28.
//  Copyright © 2019 Pat Sluth. All rights reserved.
//

import Foundation

import Apollo
import PromiseKit





public extension GraphQLOperation
{
	typealias ResultType = Swift.Result<Self.Data, Error>
	
	internal func makeResultHandler(_ block: @escaping (Self.ResultType) -> Void) -> GraphQLResultHandler<Self.Data>
	{
		return { result in
			do {
				let gqlResult = try result.get()
				
				if let data = gqlResult.data {
					block(.success(data))
				} else {
					throw GraphQLErrors(gqlResult.errors) ?? PMKError.cancelled
				}
			} catch {
				block(.failure(error))
			}
		}
	}
}




