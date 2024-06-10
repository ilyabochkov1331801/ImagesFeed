//
//  ImagesFeedCellView.swift
//  ImagesFeed
//
//  Created by Илья Бочков on 10.06.24.
//

import SwiftUI

struct ImagesFeedCellView: View {
    private let imageModel: CuratedPhoto
    
    init(imageModel: CuratedPhoto) {
        self.imageModel = imageModel
    }
    
    var body: some View {
        AsyncImage(url: imageModel.links.medium) { imageView in
            imageView
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.gray.opacity(0.2)
                .overlay { ProgressView() }
        }
        .frame(height: 200, alignment: .center)
        .overlay(alignment: .bottomTrailing) {
            Text(imageModel.photographerName)
                .font(.title2)
                .foregroundStyle(Color.white)
                .padding()
        }
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 4)
        .padding(.vertical, 5)
    }
}
