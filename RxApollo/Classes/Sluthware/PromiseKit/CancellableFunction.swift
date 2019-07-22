//
//  CancellableFunction.swift
//  Sluthware
//
//  Created by Pat Sluth on 2017-10-08.
//  Copyright © 2017 patsluth. All rights reserved.
//

import CancelForPromiseKit





class CancellableFunction: CancellableTask
{
	private var _function: (() -> Void)? = nil
	
	var isCancelled: Bool {
		return (self._function == nil)
	}
	
	init(_ function: @escaping () -> Void)
	{
		self._function = function
	}
	
	func cancel()
	{
		self._function?()
		self._function = nil
	}
}




