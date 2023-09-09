//
//  Models.swift
//  WittyWeather
//
//  Created by Felipe Lara on 07/09/2023.
//

import Foundation

// MARK: - Welcome
struct ForecastResponse: Codable {

    let cod: String //  Internal parameter
    let message: Int //  Internal parameter
    let cnt: Int // A number of timestamps returned in the API response
    let list: [Forecast]
    let city: City
}

// MARK: - City
struct City: Codable {

    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int // City population
    let timezone: Int // Shift in seconds from UTC
    let sunrise: Int // Sunrise time, Unix, UTC
    let sunset: Int // Sunset time, Unix, UTC
}

// MARK: - Coord
struct Coord: Codable {

    let lat, lon: Double
}

// MARK: - List
struct Forecast: Codable {

    let dt: Int // Time of data forecasted, unix, UTC
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int // Average visibility, metres. The maximum value of the visibility is 10km
    let pop: Double // Probability of precipitation. The values of the parameter vary between 0 and 1, where 0 is equal to 0%, 1 is equal to 100%
    let sys: Sys //  Part of the day (n - night, d - day)
    let dtTxt: String //  Time of data forecasted, ISO, UTC
    let rain: Rain? // Rain volume for last x hours, mm. Please note that only mm as units of measurement are available for this parameter

    enum CodingKeys: String, CodingKey {

        case dt, main, weather, clouds, wind, visibility, pop, sys, rain
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {

    let all: Int // Cloudiness, %
}

// MARK: - MainClass
struct MainClass: Codable {

    let temp: Double // Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
    let feelsLike: Double // This temperature parameter accounts for the human perception of weather. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
    let tempMin: Double // Minimum temperature at the moment of calculation. This is minimal forecasted temperature (within large megalopolises and urban areas), use this parameter optionally. Please find more info here. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
    let tempMax: Double // Maximum temperature at the moment of calculation. This is maximal forecasted temperature (within large megalopolises and urban areas), use this parameter optionally. Please find more info here. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit
    let pressure: Int // Atmospheric pressure on the sea level by default, hPa
    let seaLevel: Int // Atmospheric pressure on the sea level, hPa
    let grndLevel: Int // Atmospheric pressure on the ground level, hPa
    let humidity: Int // Humidity, %
    let tempKf: Double //  Internal parameter

    enum CodingKeys: String, CodingKey {

        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {

    let last3hours: Double // Rain volume for last 3 hours, mm. Please note that only mm as units of measurement are available for this parameter

    enum CodingKeys: String, CodingKey {

        case last3hours = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: PartOfDay
}

enum PartOfDay: String, Codable {

    case day = "d"
    case night = "n"
}

// MARK: - Weather
struct Weather: Codable {

    let id: Int // Weather condition id
    let main: String // Group of weather parameters (Rain, Snow, Clouds etc.)
    let description: String // Weather condition within the group.
    let icon: String // Weather icon id
}


// MARK: - Wind
struct Wind: Codable {

    let speed: Double // Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour
    let deg: Int // Wind direction, degrees (meteorological)
    let gust: Double // Wind gust. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour
}


// MARK: - CityGeoInfo
struct CityGeocoding: Codable, Equatable, Hashable {

    let id = UUID()
    let name: String
    let localNames: [String: String]?
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {

        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }

    public init(name: String, localNames: [String : String]?, lat: Double, lon: Double, country: String, state: String) {
        self.name = name
        self.localNames = localNames
        self.lat = lat
        self.lon = lon
        self.country = country
        self.state = state
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.localNames = try container.decodeIfPresent([String : String].self, forKey: .localNames)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.country = try container.decode(String.self, forKey: .country)
        self.state = try container.decode(String.self, forKey: .state)
    }
}

