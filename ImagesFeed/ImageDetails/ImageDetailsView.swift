//
//  ImageDetailsView.swift
//  ImagesFeed
//
//  Created by Илья Бочков on 10.06.24.
//

import SwiftUI

struct ImageDetailsView: View {
    @ObservedObject var viewModel: ImageDetailsViewModel
    
    var body: some View {
        AsyncImage(url: viewModel.imageModel.links.original) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 2)
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .navigationTitle(viewModel.imageModel.photographerName)
    }
}
