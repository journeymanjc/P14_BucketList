//
//  ContentView.swift
//  P14_BucketList
//
//  Created by Jae Cho on 6/27/22.
//

import SwiftUI
import MapKit





struct ContentView: View {
	
	@StateObject private var viewModel = ViewModel()
	
	var body: some View {
		ZStack{
			if viewModel.isUnlocked {
				Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
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
							viewModel.selectedPlace = location
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
							viewModel.addLocation()
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
			} else {
				Button("Unlock Places") {
					viewModel.authenticate()
				}
				.padding()
				.background(.blue)
				.foregroundColor(.white)
				.clipShape(Capsule())
			}
		}
		.sheet(item: $viewModel.selectedPlace) { place in
			Text(place.name)
			EditView(location: place) { location in
				viewModel.updateLocation(location: location)
			}
		}
		
	}
	
	
	
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


