//
//  GraphQLErrors.swift
//  RxApollo
//
//  Created by Pat Sluth on 2019-06-28.
//  Copyright © 2019 Pat Sluth. All rights reserved.
//

import Foundation

import Apollo





public struct GraphQLErrors: Error
{
	let errors: [GraphQLError]
	
	init?(_ errors: [GraphQLError]?)
	{
		guard let errors = errors else { return nil }
		guard !errors.isEmpty else { return nil }
		
		self.errors = errors
	}
}




