//
//  ImagesFeedAPIService.swift
//  ImagesFeed
//
//  Created by Илья Бочков on 10.06.24.
//

import Foundation
import Combine

enum ImagesFeedAPIServiceError: LocalizedError {
    case wrongURL
    case apiError(Error)
}

final class ImagesFeedAPIService {
    func loadNextImagesPage(page: Int) -> AnyPublisher<CuratedPhotosPage, ImagesFeedAPIServiceError> {
        let urlString = "https://api.pexels.com/v1/curated?page=\(page)"
        guard let baseUrl = URL(string: urlString) else {
            return Fail(error: ImagesFeedAPIServiceError.wrongURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: baseUrl)
        request.addValue(Constants.apiKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: CuratedPhotosPage.self, decoder: JSONDecoder())
            .mapError { .apiError($0) }
            .eraseToAnyPublisher()
    }
}

private extension ImagesFeedAPIService {
    enum Constants {
        static let apiKey = "dkLuTFxKzj8clcFSwFuitMK2DNsFdy6MzZSA5HqXrw6N7dbFATqZQ58Q"
    }
}
