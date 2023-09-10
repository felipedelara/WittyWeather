//
//  IconView.swift
//  WittyWeather
//
//  Created by Felipe Lara on 10/09/2023.
//

import SwiftUI

struct IconView: View {

    @StateObject var viewModel: IconViewModel

    var body: some View {

        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(width: 60.0, height: 60.0)
        case .content(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 60.0, height: 60.0)
        case .error:
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 60.0, height: 60.0)
                .foregroundColor(.gray)
                .opacity(0.2)
        }
    }
}
