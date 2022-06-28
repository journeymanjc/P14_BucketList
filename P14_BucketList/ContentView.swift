//
//  ContentView.swift
//  P14_BucketList
//
//  Created by Jae Cho on 6/27/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
			 .onTapGesture {
				 let str = "Test Message"
				 let url = getDocumentsDirectory().appendingPathComponent("message.txt")
				 do {
					 try str.write(to: url, atomically: true, encoding: .utf8)
					 let input = try String(contentsOf: url)
					 print(input)
				 } catch {
					 print(error.localizedDescription)
				 }
			 }
    }
	
	func getDocumentsDirectory() -> URL {
		//find all possible documents directoires for this user
		let paths = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)
		//Just send back the first one, which ought to be the only one
		return paths[0]
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
