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
		return { result, error in
			if let data = result?.data {
				block(.success(data))
			} else if let errors = GraphQLErrors(result?.errors) {
				block(.failure(errors))
			} else {
				block(.failure(error ?? PMKError.cancelled))
			}
		}
	}
}




