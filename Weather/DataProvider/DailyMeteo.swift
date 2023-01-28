import Foundation

struct MeteoDailyResponse : Codable {
    var daily: MeteoDaily
}

struct MeteoDaily : Codable {
    var time: [String]
    var weathercode: [Int]
    var maximumTemperature: [Double]
    var minimumTemperature: [Double]
    var rain: [Double]
    var shower: [Double]
    var snowfall: [Double]
    var windspeed: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case weathercode
        
        case maximumTemperature = "temperature_2m_max"
        case minimumTemperature = "temperature_2m_min"
        case rain = "rain_sum"
        case shower = "showers_sum"
        case snowfall = "snowfall_sum"
        case windspeed = "windspeed_10m_max"
    }
}

class DailyMeteoWeatherDataProvider : DailyWeatherDataProvider {   
    private var startDateTime: Date?
    private var endDateTime: Date?
    
    private let service = MeteoHttpService()
    
    func loadData(at location: Location, into dataHolder: DailyWeatherDataHolder) {
        startDateTime = Date.now
        endDateTime = startDateTime!.addingTimeInterval(60 * 60 * 24 * 10) // 10 days in the future
        
        let url = "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&models=best_match&timezone=Europe%2FBerlin&start_date=\(startDateTime!.toDateString())&end_date=\(endDateTime!.toDateString())&daily=rain_sum,showers_sum,snowfall_sum,weathercode,temperature_2m_max,temperature_2m_min,windspeed_10m_max"
        service.call(url: url, MeteoDailyResponse.self, execute: { response in
            self.convert(at: location, from: response, to: dataHolder)
        })
    }
    
    private func convert(at location: Location, from meteoData: MeteoDailyResponse, to data: DailyWeatherDataHolder) {
        // Meteo delivers metrics in flat arrays, so we use this trick to
        // iterate over all metrics at the same time.
        var weathercodes = meteoData.daily.weathercode.makeIterator()
        var maximumTemperatures = meteoData.daily.maximumTemperature.makeIterator()
        var minimumTemperatures = meteoData.daily.minimumTemperature.makeIterator()
        var rains = meteoData.daily.rain.makeIterator()
        var showers = meteoData.daily.shower.makeIterator()
        var snowfalls = meteoData.daily.snowfall.makeIterator()
        var windspeeds = meteoData.daily.windspeed.makeIterator()
        
        for time in meteoData.daily.time {
            let formattedTime: Date = time.toIsoDate()!
            
            // Omitt data sets before start time
            if (formattedTime >= startDateTime!) {
                let weathercode = weathercodes.next() ?? 0
                let maximumTemperature = maximumTemperatures.next() ?? 0.0
                let minimumTemperature = minimumTemperatures.next() ?? 0.0
                let rain = rains.next() ?? 0.0
                let shower = showers.next() ?? 0.0
                let snowfall = snowfalls.next() ?? 0.0
                let windspeed = windspeeds.next() ?? 0.0
                
                let category = WeatherCodeAnalyzer().analyze(from: RawWeatherData(
                    dateTime: formattedTime,
                    rain: rain,
                    shower: shower,
                    snowfall: snowfall,
                    weathercode: weathercode,
                    windspeed: windspeed
                ))
                                
                data.data.append(DailyWeatherData(
                    location: location,
                    date: formattedTime,
                    category: category,
                    rain: rain + shower,
                    snowfall: snowfall,
                    highestTemperature: maximumTemperature,
                    lowestTemperature: minimumTemperature
                ))
            }
        }
    }
}
