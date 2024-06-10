//
//  ImageDetailsViewModel.swift
//  ImagesFeed
//
//  Created by Илья Бочков on 10.06.24.
//

import Combine

final class ImageDetailsViewModel: ObservableObject {
    let imageModel: CuratedPhoto
    
    init(imageModel: CuratedPhoto) {
        self.imageModel = imageModel
    }
}
