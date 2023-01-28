import Foundation

struct RawWeatherData {
    var dateTime: Date
    var sunrise: Date? = nil
    var sunset: Date? = nil
    
    var rain: Double
    var shower: Double
    var snowfall: Double
    
    /// This is a World Meteorological Organization Code.
    /// | Code        |  Description                                                         |
    /// |-------------|-------------------------------------------------------|
    /// | 0               | Clear sky                                                             |
    /// | 1, 2, 3       | Mainly clear, partly cloudy, and overcast            |
    /// | 45, 48       | Fog and depositing rime fog                               |
    /// | 51, 53, 55 | Drizzle: Light, moderate, and dense intensity     |
    /// | 56, 57       | Freezing Drizzle: Light and dense intensity         |
    /// | 61, 63, 65 | Rain: Slight, moderate and heavy intensity         |
    /// | 66, 67       | Freezing Rain: Light and heavy intensity             |
    /// | 71, 73, 75 | Snow fall: Slight, moderate, and heavy intensity |
    /// | 77             | Snow grains                                                         |
    /// | 80, 81, 82 | Rain showers: Slight, moderate, and violent       |
    /// | 85, 86       | Snow showers slight and heavy                          |
    /// | 95             | Thunderstorm: Slight or moderate                      |
    /// | 96, 99       | Thunderstorm with slight and heavy hail             |
    var weathercode: Int
    var cloudcover: Int? = nil
    var windspeed: Double
}

class WeatherCodeAnalyzer {
    func analyze(from: RawWeatherData) -> WeatherCategory {
        let rain = from.rain + from.shower
        let snowfall = from.snowfall
        let weathercode = from.weathercode
        let cloudcover = from.cloudcover
        let windspeed = from.windspeed
        
        let precipitation = rain + snowfall
        
        var category: WeatherCategory
        if (rain <= 15 && snowfall == 0) {
            category = .rainy
        } else if (rain > 15 && snowfall == 0) {
            category = .heavyRainy
        } else if (snowfall != 0 && rain == 0) {
            category = .snowy
        } else if (snowfall != 0 && rain != 0) {
            category = .sleety
        } else {
            category = .unknown
        }
        
        // There are now some special cases, that might override previously
        // assigned categories.
        
        if (cloudcover != nil && precipitation == 0) {
            if (cloudcover! <= 10) {
                category = .sunny
                            
                if (from.sunrise != nil && from.sunset != nil) {
                    // If current time between sunset and sunrise: show sparkles in UI
                    if (from.dateTime > from.sunset! && from.dateTime < from.sunrise!) {
                        category = .clearNight
                    }
                }
            } else if (cloudcover! > 50) {
                category = .cloudy
            } else if (cloudcover! > 10 || cloudcover! <= 50) {
                category = .sunnyCloudy
            }
        } else if (precipitation == 0) {
            if (weathercode == 0) {
                category = .sunny
            } else if ([1, 2].contains(weathercode)) {
                category = .sunnyCloudy
            } else if (weathercode == 3) {
                category = .cloudy
            }
        }
        
        if (weathercode == 45 || weathercode == 48) {
            category = .foggy
        } else if (weathercode == 95 || weathercode == 96 || weathercode == 99) {
            category = .thundery
        } else if (windspeed >= 75) {
            category = .windy
        }
        
        return category
    }
}
