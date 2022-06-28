//
//  ContentView.swift
//  P14_BucketList
//
//  Created by Jae Cho on 6/27/22.
//

import SwiftUI
import MapKit
import LocalAuthentication


struct Location: Identifiable{
	let id = UUID()
	let name: String
	let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
	
	@State private var mapRegion = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12),
		span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
	
	@State private var isUnlocked = false
	
	let locations = [
		Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
		Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
	]
	
	
    var body: some View {
		 VStack{
			 if isUnlocked {
				 Text("Unlocked")
			 }else{
				 Text("Locked")
			 }
		 }
		 .onAppear(perform: authenticate)
    }
	
	func getDocumentsDirectory() -> URL {
		//find all possible documents directoires for this user
		let paths = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)
		//Just send back the first one, which ought to be the only one
		return paths[0]
	}
	
	func authenticate(){
		let context = LAContext()
		var error : NSError?
		
		//Check whether biometric authentication is possible
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			//it's possible, so go ahead and use it.
			let reason = "We need to unlock your data."
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
				// authentication has now completed
				if success{
					//authenticated successfully
					isUnlocked = true
				}else {
					//there was a problem
				}
			}
		}else {
			//no biomentrics
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
