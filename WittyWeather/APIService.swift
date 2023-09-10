//
//  APIService.swift
//  WittyWeather
//
//  Created by Felipe Lara on 07/09/2023.
//

import Foundation
import UIKit

enum ServiceError: Error {

    case noToken
    case invalidUrl
    case genericError
    case badImageFromDataConversion
}

protocol APIServiceType {

    func getForecast(city: City) async throws -> ForecastResponse
    func getCity(cityName: String) async throws -> [City]
    func getIcon(iconDesc: String) async throws -> UIImage
}

class APIService: APIServiceType {

    let apiKey = "7e54064d8356179a0eeeb730c642071b"


    func getForecast(city: City) async throws -> ForecastResponse {

        // Request

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)") else {

            throw ServiceError.invalidUrl
        }

        let request = URLRequest(url: url)

        do {

            let (data, _) = try await URLSession.shared.data(for: request)
            let model = try JSONDecoder().decode(ForecastResponse.self, from: data)
            return model

        } catch {

            throw error
        }
    }

    func getCity(cityName: String) async throws -> [City] {

        print("https://api.openweathermap.org/geo/1.0/direct?q=\(cityName.encodeStringForURL())&limit=5&appid=\(apiKey)")
        // Request
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName.encodeStringForURL())&limit=5&appid=\(apiKey)") else {

            throw ServiceError.invalidUrl
        }

        let request = URLRequest(url: url)

        do {

            let (data, _) = try await URLSession.shared.data(for: request)
            let model = try JSONDecoder().decode([City].self, from: data)
            return model

        } catch {

            throw error
        }
    }

    func getIcon(iconDesc: String) async throws -> UIImage {

        // Request
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(iconDesc)@2x.png") else {

            throw ServiceError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad // This is enough to ensure image caching

        do {

            let (data, _) = try await URLSession.shared.data(for: request)

            guard let image = UIImage(data: data) else {

                throw ServiceError.badImageFromDataConversion
            }

            return image

        } catch {

            throw error
        }
    }
}

extension String {

    func encodeStringForURL() -> String {

        let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~%")
        return self.replacingOccurrences(of: " ", with: "%20").addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
    }
}
