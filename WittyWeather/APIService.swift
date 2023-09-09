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

    func getForecast(city: City) async throws -> ForecastResponse
    func getCity(cityName: String) async throws -> [City]
}

class APIService: APIServiceType {

    let apiKey = "7e54064d8356179a0eeeb730c642071b"

    var lat: String = "38.7095641817862"
    let lon: String = "-9.138063509914675"
    let dayCount: Int = 5

    func getForecast(city: City) async throws -> ForecastResponse {

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)") else {

            throw ServiceError.invalidUrl
        }

        let request = URLRequest(url: url)

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

    func getCity(cityName: String) async throws -> [City] {

        //Sanitize

        let sanitizedQuery = cityName.replacingOccurrences(of: " ", with: "%20")

        //HTTP
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(sanitizedQuery)&limit=5&appid=\(apiKey)") else {

            throw ServiceError.invalidUrl
        }

        var request = URLRequest(url: url)

        do {

            let (data, _) = try await URLSession.shared.data(for: request)

            let model = try JSONDecoder().decode([City].self, from: data)
            print(model)
            return model

        } catch {

            print(error)
            throw error
        }
    }
}
