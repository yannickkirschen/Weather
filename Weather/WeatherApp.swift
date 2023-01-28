import SwiftUI

@main
struct WeatherApp: App {
    let hourlyProvider: HourlyWeatherDataProvider = MeteoWeatherDataProvider()
    let dailyProvider: DailyWeatherDataProvider = DailyMeteoWeatherDataProvider()
    
    var body: some Scene {
        WindowGroup {
            MainView(
                hourlyProvider: hourlyProvider,
                dailyProvider: dailyProvider
            )
        }
    }
}
