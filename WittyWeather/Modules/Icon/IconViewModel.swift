//
//  IconViewModel.swift
//  WittyWeather
//
//  Created by Felipe Lara on 10/09/2023.
//

import Foundation
import UIKit

class IconViewModel: ObservableObject {

    enum ViewState {

        case loading
        case content(UIImage)
        case error
    }

    @Published var state: ViewState = .loading

    private var apiService: APIServiceType

    private var iconDesc: String

    init(apiService: APIServiceType = APIService(),
         iconDesc: String) {

        self.apiService = apiService

        self.state = .loading
        self.iconDesc = iconDesc

        Task {

            await self.getIcon(iconDesc: iconDesc)
        }
    }

    // MARK: - Functions
    func getIcon(iconDesc: String) async {

        do {

            let image = try await apiService.getIcon(iconDesc: iconDesc)

            DispatchQueue.main.async {

                self.state = .content(image)
            }

        } catch {

            self.state = .error
        }
    }
}
