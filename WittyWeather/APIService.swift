//
//  APIService.swift
//  WittyWeather
//
//  Created by Felipe Lara on 07/09/2023.
//

import Foundation

enum ServiceError: Error {

    case noToken
    case invalidUrl
    case genericError
}

protocol APIServiceType {

    func getForecast() async throws -> ForecastResponse
}

class APIService: APIServiceType {

    let apiKey = "7e54064d8356179a0eeeb730c642071b"

    var lat: String = "38.7095641817862"
    let lon: String = "-9.138063509914675"
    let dayCount: Int = 5

    func getForecast() async throws -> ForecastResponse {

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else {
            throw ServiceError.invalidUrl
        }

        var request = URLRequest(url: url)

        do {

            let (data, _) = try await URLSession.shared.data(for: request)

            let model = try JSONDecoder().decode(ForecastResponse.self, from: data)
            print(model)
            return model

        } catch {

            print(error)
            throw error
        }
    }
}
