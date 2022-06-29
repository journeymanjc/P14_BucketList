//
//  ContentView-ViewModel.swift
//  P14_BucketList
//
//  Created by Jae Cho on 6/28/22.
//

import Foundation
import MapKit
import LocalAuthentication


extension ContentView {
	@MainActor class ViewModel : ObservableObject {
		@Published var selectedPlace: Location?
		
		@Published var mapRegion = MKCoordinateRegion(
			center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0),
			span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
		
		@Published var isUnlocked = false
		
		@Published private(set) var locations : [Location]
		
		let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
		init(){
			do {
				let data = try Data(contentsOf: savePath)
				locations = try JSONDecoder().decode([Location].self, from: data)
			} catch {
				locations = []
			}
		}
		
		func save(){
			do {
				let data = try JSONEncoder().encode(locations)
				try data.write(to: savePath, options: [.atomic,.completeFileProtection])
			} catch {
				print("Unable to save data.")
			}
		}
		
		func addLocation() {
			let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
			locations.append(newLocation)
			save()
		}
		
		func updateLocation(location: Location) {
			guard let selectedPlace = selectedPlace else {
				return
			}
			if let index = locations.firstIndex(of: selectedPlace) {
				locations[index] = location
			}
			save()
		}
		
		
		func authenticate(){
			let context = LAContext()
			var error : NSError?
			
			//Check whether biometric authentication is possible
			if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
				//it's possible, so go ahead and use it.
				let reason = "Please authenticate yourself to unlock your places."
				context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
					// authentication has now completed
					if success{
						//authenticated successfully
						Task{ @MainActor in
							//await MainActor.run {
								self.isUnlocked = true
							//}
						}
					}else {
						//there was a problem
					}
				}
			}else {
				//no biomentrics
			}
		}
		
	}	
}
