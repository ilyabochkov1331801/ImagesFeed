//
//  ImagesFeedApp.swift
//  ImagesFeed
//
//  Created by Илья Бочков on 10.06.24.
//

import SwiftUI

@main
struct ImagesFeedApp: App {
    var body: some Scene {
        WindowGroup {
            ImagesFeedView(viewModel: ImagesFeedViewModel(apiService: ImagesFeedAPIService()))
        }
    }
}
