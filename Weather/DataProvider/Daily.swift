import Foundation

/// This is an ``ObservableObject`` holding an array of ``DailyWeatherData``.
/// Its purpose is to be used as an ``ObservedObject`` in a SwiftUI view.
class DailyWeatherDataHolder : ObservableObject, Identifiable {
    /// An array of ``DailyWeatherData`` containing data sorted by date.
    @Published var data: [DailyWeatherData] = []
}

/// Provides daily weather data.
protocol DailyWeatherDataProvider {
    /// Loads daily weather data at a specific ``Location`` and saves it in a
    /// ``DailyWeatherDataHolder``.
    func loadData(at location: Location, into dataHolder: DailyWeatherDataHolder)
}

class DailyWeatherData : ObservableObject, Identifiable {
    @Published var location: Location
    @Published var date: Date
    @Published var category: WeatherCategory
    @Published var rain: Double
    @Published var snowfall: Double
    @Published var highestTemperature: Double
    @Published var lowestTemperature: Double
    
    init(location: Location,
         date: Date,
         category: WeatherCategory,
         rain: Double,
         snowfall: Double,
         highestTemperature: Double,
         lowestTemperature: Double) {
        self.location = location
        self.date = date
        self.category = category
        self.rain = rain
        self.snowfall = snowfall
        self.highestTemperature = highestTemperature
        self.lowestTemperature = lowestTemperature
    }
}
