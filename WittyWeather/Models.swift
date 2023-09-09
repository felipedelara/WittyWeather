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

    let name: String
    let localNames: [String: String]?
    let lat, lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {

        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

struct StringContants {
    
    static let countryEmojiFlags: [String: String] = [
        "AD": "🇦🇩",
        "AE": "🇦🇪",
        "AF": "🇦🇫",
        "AG": "🇦🇬",
        "AI": "🇦🇮",
        "AL": "🇦🇱",
        "AM": "🇦🇲",
        "AO": "🇦🇴",
        "AQ": "🇦🇶",
        "AR": "🇦🇷",
        "AS": "🇦🇸",
        "AT": "🇦🇹",
        "AU": "🇦🇺",
        "AW": "🇦🇼",
        "AX": "🇦🇽",
        "AZ": "🇦🇿",
        "BA": "🇧🇦",
        "BB": "🇧🇧",
        "BD": "🇧🇩",
        "BE": "🇧🇪",
        "BF": "🇧🇫",
        "BG": "🇧🇬",
        "BH": "🇧🇭",
        "BI": "🇧🇮",
        "BJ": "🇧🇯",
        "BL": "🇧🇱",
        "BM": "🇧🇲",
        "BN": "🇧🇳",
        "BO": "🇧🇴",
        "BQ": "🇧🇶",
        "BR": "🇧🇷",
        "BS": "🇧🇸",
        "BT": "🇧🇹",
        "BV": "🇧🇻",
        "BW": "🇧🇼",
        "BY": "🇧🇾",
        "BZ": "🇧🇿",
        "CA": "🇨🇦",
        "CC": "🇨🇨",
        "CD": "🇨🇩",
        "CF": "🇨🇫",
        "CG": "🇨🇬",
        "CH": "🇨🇭",
        "CI": "🇨🇮",
        "CK": "🇨🇰",
        "CL": "🇨🇱",
        "CM": "🇨🇲",
        "CN": "🇨🇳",
        "CO": "🇨🇴",
        "CR": "🇨🇷",
        "CU": "🇨🇺",
        "CV": "🇨🇻",
        "CW": "🇨🇼",
        "CX": "🇨🇽",
        "CY": "🇨🇾",
        "CZ": "🇨🇿",
        "DE": "🇩🇪",
        "DJ": "🇩🇯",
        "DK": "🇩🇰",
        "DM": "🇩🇲",
        "DO": "🇩🇴",
        "DZ": "🇩🇿",
        "EC": "🇪🇨",
        "EE": "🇪🇪",
        "EG": "🇪🇬",
        "EH": "🇪🇭",
        "ER": "🇪🇷",
        "ES": "🇪🇸",
        "ET": "🇪🇹",
        "FI": "🇫🇮",
        "FJ": "🇫🇯",
        "FK": "🇫🇰",
        "FM": "🇫🇲",
        "FO": "🇫🇴",
        "FR": "🇫🇷",
        "GA": "🇬🇦",
        "GB": "🇬🇧",
        "GD": "🇬🇩",
        "GE": "🇬🇪",
        "GF": "🇬🇫",
        "GG": "🇬🇬",
        "GH": "🇬🇭",
        "GI": "🇬🇮",
        "GL": "🇬🇱",
        "GM": "🇬🇲",
        "GN": "🇬🇳",
        "GP": "🇬🇵",
        "GQ": "🇬🇶",
        "GR": "🇬🇷",
        "GS": "🇬🇸",
        "GT": "🇬🇹",
        "GU": "🇬🇺",
        "GW": "🇬🇼",
        "GY": "🇬🇾",
        "HK": "🇭🇰",
        "HM": "🇭🇲",
        "HN": "🇭🇳",
        "HR": "🇭🇷",
        "HT": "🇭🇹",
        "HU": "🇭🇺",
        "ID": "🇮🇩",
        "IE": "🇮🇪",
        "IL": "🇮🇱",
        "IM": "🇮🇲",
        "IN": "🇮🇳",
        "IO": "🇮🇴",
        "IQ": "🇮🇶",
        "IR": "🇮🇷",
        "IS": "🇮🇸",
        "IT": "🇮🇹",
        "JE": "🇯🇪",
        "JM": "🇯🇲",
        "JO": "🇯🇴",
        "JP": "🇯🇵",
        "KE": "🇰🇪",
        "KG": "🇰🇬",
        "KH": "🇰🇭",
        "KI": "🇰🇮",
        "KM": "🇰🇲",
        "KN": "🇰🇳",
        "KP": "🇰🇵",
        "KR": "🇰🇷",
        "KW": "🇰🇼",
        "KY": "🇰🇾",
        "KZ": "🇰🇿",
        "LA": "🇱🇦",
        "LB": "🇱🇧",
        "LC": "🇱🇨",
        "LI": "🇱🇮",
        "LK": "🇱🇰",
        "LR": "🇱🇷",
        "LS": "🇱🇸",
        "LT": "🇱🇹",
        "LU": "🇱🇺",
        "LV": "🇱🇻",
        "LY": "🇱🇾",
        "MA": "🇲🇦",
        "MC": "🇲🇨",
        "MD": "🇲🇩",
        "ME": "🇲🇪",
        "MF": "🇲🇫",
        "MG": "🇲🇬",
        "MH": "🇲🇭",
        "MK": "🇲🇰",
        "ML": "🇲🇱",
        "MM": "🇲🇲",
        "MN": "🇲🇳",
        "MO": "🇲🇴",
        "MP": "🇲🇵",
        "MQ": "🇲🇶",
        "MR": "🇲🇷",
        "MS": "🇲🇸",
        "MT": "🇲🇹",
        "MU": "🇲🇺",
        "MV": "🇲🇻",
        "MW": "🇲🇼",
        "MX": "🇲🇽",
        "MY": "🇲🇾",
        "MZ": "🇲🇿",
        "NA": "🇳🇦",
        "NC": "🇳🇨",
        "NE": "🇳🇪",
        "NF": "🇳🇫",
        "NG": "🇳🇬",
        "NI": "🇳🇮",
        "NL": "🇳🇱",
        "NO": "🇳🇴",
        "NP": "🇳🇵",
        "NR": "🇳🇷",
        "NU": "🇳🇺",
        "NZ": "🇳🇿",
        "OM": "🇴🇲",
        "PA": "🇵🇦",
        "PE": "🇵🇪",
        "PF": "🇵🇫",
        "PG": "🇵🇬",
        "PH": "🇵🇭",
        "PK": "🇵🇰",
        "PL": "🇵🇱",
        "PM": "🇵🇲",
        "PN": "🇵🇳",
        "PR": "🇵🇷",
        "PS": "🇵🇸",
        "PT": "🇵🇹",
        "PW": "🇵🇼",
        "PY": "🇵🇾",
        "QA": "🇶🇦",
        "RE": "🇷🇪",
        "RO": "🇷🇴",
        "RS": "🇷🇸",
        "RU": "🇷🇺",
        "RW": "🇷🇼",
        "SA": "🇸🇦",
        "SB": "🇸🇧",
        "SC": "🇸🇨",
        "SD": "🇸🇩",
        "SE": "🇸🇪",
        "SG": "🇸🇬",
        "SH": "🇸🇭",
        "SI": "🇸🇮",
        "SJ": "🇸🇯",
        "SK": "🇸🇰",
        "SL": "🇸🇱",
        "SM": "🇸🇲",
        "SN": "🇸🇳",
        "SO": "🇸🇴",
        "SR": "🇸🇷",
        "SS": "🇸🇸",
        "ST": "🇸🇹",
        "SV": "🇸🇻",
        "SX": "🇸🇽",
        "SY": "🇸🇾",
        "SZ": "🇸🇿",
        "TC": "🇹🇨",
        "TD": "🇹🇩",
        "TF": "🇹🇫",
        "TG": "🇹🇬",
        "TH": "🇹🇭",
        "TJ": "🇹🇯",
        "TK": "🇹🇰",
        "TL": "🇹🇱",
        "TM": "🇹🇲",
        "TN": "🇹🇳",
        "TO": "🇹🇴",
        "TR": "🇹🇷",
        "TT": "🇹🇹",
        "TV": "🇹🇻",
        "TW": "🇹🇼",
        "TZ": "🇹🇿",
        "UA": "🇺🇦",
        "UG": "🇺🇬",
        "UM": "🇺🇲",
        "US": "🇺🇸",
        "UY": "🇺🇾",
        "UZ": "🇺🇿",
        "VA": "🇻🇦",
        "VC": "🇻🇨",
        "VE": "🇻🇪",
        "VG": "🇻🇬",
        "VI": "🇻🇮",
        "VN": "🇻🇳",
        "VU": "🇻🇺",
        "WF": "🇼🇫",
        "WS": "🇼🇸",
        "YE": "🇾🇪",
        "YT": "🇾🇹",
        "ZA": "🇿🇦",
        "ZM": "🇿🇲",
        "ZW": "🇿🇼"
    ]
}
