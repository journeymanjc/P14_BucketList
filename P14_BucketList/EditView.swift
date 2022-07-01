//
//  EditView.swift
//  P14_BucketList
//
//  Created by Jae Cho on 6/27/22.
//

import SwiftUI



struct EditView: View {
	@Environment(\.dismiss) var dismiss
	var onSave: (Location) -> Void
	
	@StateObject var viewModel: EditViewModel
	
	var location: Location
	
	init(location: Location, onSave: @escaping (Location) -> Void ){
		self.location = location
		self.onSave = onSave
		
		_viewModel = StateObject(wrappedValue: EditViewModel(location: location))
	}
	
	
    var body: some View {
		 NavigationView{
			 Form{
				 Section {
					 TextField("Place name", text:$viewModel.name)
					 TextField("Description", text:$viewModel.description)
				 }
				 Section("Nearby...") {
					 switch viewModel.loadingState {
					 case .loading:
						 Text("Loading...")
					 case .loaded:
						 ForEach(viewModel.pages, id: \.pageid) { page in
							 Text(page.title)
								 .font(.headline)
							 + Text(": ") +
							 Text(page.description)
								 .italic()
						 }
					 case .failed:
						 Text("Please try again later.")
					 }
				 }
			 }
			 .navigationTitle("Place details")
			 .toolbar {
				 Button("Save") {
					 
					 onSave(viewModel.newLocation)
					 dismiss()
				 }
			 }
			 .task {
				 await viewModel.fetchNearbyPlaces()
			 }
		 }
    }
	
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
		 EditView(location: Location.example) { newLocation in
			 
		 }
    }
}
