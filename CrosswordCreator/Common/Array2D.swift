//
//  Array2D.swift
//  crosswords_generator
//
//  Created by Oleg Samoylov on 8/08/2019.
//  Copyright © 2015 Oleg Samoylov. All rights reserved.
//

final class Array2D<T> {
	
	private var columns: Int
	private var rows: Int
    private var matrix: [T]
	
	init(columns: Int, rows: Int, defaultValue: T) {
		self.columns = columns
		self.rows = rows
		self.matrix = Array(repeating: defaultValue, count: columns * rows)
	}
	
	subscript(columns: Int, rows: Int) -> T {
		get {
			return matrix[columns * rows + columns]
		}
		set {
			matrix[columns * rows + columns] = newValue
		}
	}
}
