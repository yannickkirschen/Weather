import Foundation

/// This is an ``ObservableObject`` holding an array of ``HourlyWeatherData``.
/// Its purpose is to be used as an ``ObservedObject`` in a SwiftUI view.
class HourlyWeatherDataHolder : ObservableObject, Identifiable {
    /// An array of ``HourlyWeatherData`` containing data sorted by date.
    @Published var data: [HourlyWeatherData] = []
}

/// Provides hourly weather data.
protocol HourlyWeatherDataProvider {    
    /// Loads hourly weather data at a specific ``Location`` and saves it in a
    /// ``HourlyWeatherDataHolder``.
    func loadData(at location: Location, into dataHolder: HourlyWeatherDataHolder)
}

/// A data class containing weather data for a specific point of time.
/// This class is observable, so it can be used as state variable in a SwiftUI
/// view.
class HourlyWeatherData : ObservableObject, Identifiable {
    @Published var location: Location
    @Published var time: Date
    @Published var category: WeatherCategory
    @Published var temperature: Double
    @Published var windspeed: Double

    // These are only set if available.
    @Published var rain: Double?
    @Published var snowfall: Double?
    
    init(location: Location,
         time: Date,
         category: WeatherCategory,
         temperature: Double,
         windspeed: Double,
         rain: Double? = nil,
         snowfall: Double? = nil) {
        self.location = location
        self.time = time
        self.category = category
        self.temperature = temperature
        self.rain = rain
        self.snowfall = snowfall
        self.windspeed = windspeed
    }
}
