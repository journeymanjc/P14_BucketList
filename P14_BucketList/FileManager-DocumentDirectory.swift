//
//  FileManager-DocumentDirectory.swift
//  P14_BucketList
//
//  Created by Jae Cho on 6/28/22.
//

import Foundation

extension FileManager {
	static var documentsDirectory: URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}
