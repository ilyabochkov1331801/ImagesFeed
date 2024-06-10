//
//  ImagesFeedViewModel.swift
//  ImagesFeed
//
//  Created by Илья Бочков on 10.06.24.
//

import Foundation
import Combine

final class ImagesFeedViewModel: ObservableObject {
    enum State: Equatable {
        case loadingFirstPage
        case displayingImagesPage
        case loadingNextImagesPage
        case displayingLastPage
    }
    
    @Published var state: State = .loadingFirstPage
    @Published var isErrorAlertDisplaying = false
    
    private(set) var images: [CuratedPhoto] = []
    private(set) var apiServiceAlertError: ImagesFeedAPIServiceError?

    private var nextPage = 1
    private let apiService: ImagesFeedAPIService
    private var cancelBag: Set<AnyCancellable> = []
    
    init(apiService: ImagesFeedAPIService) {
        self.apiService = apiService
        loadNextImagesPage()
    }
    
    func loadNextImagesPageIfNeeded() {
        switch state {
        case .loadingNextImagesPage, .loadingFirstPage, .displayingLastPage:
            break
        default:
            state = .loadingNextImagesPage
            loadNextImagesPage()
        }
    }
    
    func reloadImagesFeed() {
        state = .loadingNextImagesPage
        loadNextImagesPage()
    }
    
    func refreshImages() {
        nextPage = 1
        loadNextImagesPage(replaceData: true)
    }
}

private extension ImagesFeedViewModel {
    func loadNextImagesPage(replaceData: Bool = false) {
        apiService.loadNextImagesPage(page: nextPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self?.apiServiceAlertError = error
                    self?.isErrorAlertDisplaying = true
                }
            } receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.nextPage = value.page + 1
                if replaceData {
                    self.images = value.photos
                } else {
                    self.images.append(contentsOf: value.photos)
                }
                self.state = value.isLastPage ? .displayingLastPage : .displayingImagesPage
            }
            .store(in: &cancelBag)
    }
}
