//
//  ContentView.swift
//  P14_BucketList
//
//  Created by Jae Cho on 6/27/22.
//

import SwiftUI
import MapKit
import LocalAuthentication




struct ContentView: View {
	@State private var selectedPlace: Location?
	
	@State private var mapRegion = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 51.5, longitude: 0),
		span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
	
	@State private var isUnlocked = false
	
	@State private var locations = [Location]()
	
	
    var body: some View {
		 ZStack{
			 Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
//				 MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
				 MapAnnotation(coordinate: location.coordinate) {
					 VStack{
						 Image(systemName: "star.circle")
							 .resizable()
							 .foregroundColor(.red)
							 .frame(width: 44, height: 44)
							 .background(.white)
							 .clipShape(Circle())
						 Text(location.name)
							 .fixedSize()
					 }
					 .onTapGesture {
						 selectedPlace = location
					 }
				 }
			 }
				 .ignoresSafeArea()
			 Circle()
				 .fill(.blue)
				 .opacity(0.3)
				 .frame(width: 32, height: 32)
			 VStack{
				 Spacer()
				 HStack{
					 Spacer()
					 Button {
						 //Create new location
						 let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
						 locations.append(newLocation)
					 } label: {
						 Image(systemName: "plus")
					 }
					 .padding()
					 .background(.black.opacity(0.75))
					 .foregroundColor(.white)
					 .font(.title)
					 .clipShape(Circle())
					 .padding(.trailing)
				 }
			 }
			 
		 }
		 .sheet(item: $selectedPlace) { place in
			 Text(place.name)
			 EditView(location: place) { newLocation in
				 if let index = locations.firstIndex(of: place) {
					 locations[index] = newLocation
				 }
			 }
		 }
		 
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
