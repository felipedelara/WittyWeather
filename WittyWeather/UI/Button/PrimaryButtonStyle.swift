//
//  PrimaryButtonStyle.swift
//  WittyWeather
//
//  Created by Felipe Lara on 10/09/2023.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue)
            .cornerRadius(10)
    }
}

struct PrimaryButtonContent: View {

    var title: String
    var isLoading: Bool

    var body: some View {

        ZStack {

            if isLoading {
                ProgressView()
            } else {
                Text(title)
            }
        }
    }
}

