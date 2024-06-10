//
//  ContentView.swift
//  ImagesFeed
//
//  Created by Илья Бочков on 10.06.24.
//

import SwiftUI

struct ImagesFeedView: View {
    @ObservedObject var viewModel: ImagesFeedViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                imagesCollectionView
            }
            .refreshable { viewModel.refreshImages() }
            .overlay(alignment: .center) {
                if viewModel.state == .loadingFirstPage {
                    ProgressView()
                }
            }
            .alert(isPresented: $viewModel.isErrorAlertDisplaying, error: viewModel.apiServiceAlertError) {
                Button("OK") { viewModel.reloadImagesFeed() }
            }
        }.tint(Color.black)
    }
}

private extension ImagesFeedView {
    @ViewBuilder var imagesCollectionView: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            ForEach(viewModel.images) { imageModel in
                NavigationLink {
                    ImageDetailsView(viewModel: ImageDetailsViewModel(imageModel: imageModel))
                } label: {
                    ImagesFeedCellView(imageModel: imageModel)
                }
            }
            
            if viewModel.state != .displayingLastPage && !viewModel.images.isEmpty {
                ProgressView()
                    .onAppear { viewModel.loadNextImagesPageIfNeeded() }
            }
        }
        .padding()
    }
}
