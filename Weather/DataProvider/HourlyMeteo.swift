import Foundation

struct MeteoHourlyResponse : Codable {
    var timezone: String
    var hourly: MeteoHourly
    var daily: MeteoHourlyDaily
}

struct MeteoHourly: Codable {
    var time: [String]
    var temperature: [Double]
    var rain: [Double]
    var showers: [Double]
    var snowfall: [Double]
    var weathercode: [Int]
    var cloudcover: [Int]
    var windspeed: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case rain
        case showers
        case snowfall
        case weathercode
        case cloudcover

        case temperature = "temperature_2m"
        case windspeed = "windspeed_10m"
    }
}

struct MeteoHourlyDaily : Codable {
    var sunrise: [String]
    var sunset: [String]
}

class MeteoWeatherDataProvider : HourlyWeatherDataProvider {
    private var startDateTime: Date?
    private var endDateTime: Date?
    
    private let service = MeteoHttpService()
    
    func loadData(at location: Location, into dataHolder: HourlyWeatherDataHolder) {
        startDateTime = Date.now
        endDateTime = startDateTime!.addingTimeInterval(60 * 60 * 24) // 24 hours in the future
        
        let url = "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&hourly=temperature_2m,rain,showers,snowfall,weathercode,cloudcover,windspeed_10m&models=best_match&timezone=Europe%2FBerlin&start_date=\(startDateTime!.toDateString())&end_date=\(endDateTime!.toDateString())&daily=sunrise,sunset,weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum"

        service.call(url: url, MeteoHourlyResponse.self, execute: { response in
            self.convert(at: location, from: response, to: dataHolder)
        })
    }

    private func convert(at location: Location, from meteoData: MeteoHourlyResponse, to data: HourlyWeatherDataHolder) {
        // Meteo delivers metrics in flat arrays, so we use this trick to
        // iterate over all metrics at the same time.
        var temperatures = meteoData.hourly.temperature.makeIterator()
        var rains = meteoData.hourly.rain.makeIterator()
        var showers = meteoData.hourly.showers.makeIterator()
        var snowfalls = meteoData.hourly.snowfall.makeIterator()
        var weathercodes = meteoData.hourly.weathercode.makeIterator()
        var cloudcovers = meteoData.hourly.cloudcover.makeIterator()
        var windspeeds = meteoData.hourly.windspeed.makeIterator()
        
        let sunrise: Date = getSunrise(options: meteoData.daily.sunrise.map({ $0.toIsoDateTime()! }))
        let sunset: Date = getSunset(options: meteoData.daily.sunset.map({ $0.toIsoDateTime()! }))
        
        data.data.append(HourlyWeatherData(
            location: location,
            time: sunrise,
            category: .sunrise,
            temperature: 0,
            windspeed: 0
        ))
        
        data.data.append(HourlyWeatherData(
            location: location,
            time: sunset,
            category: .sunset,
            temperature: 0,
            windspeed: 0
        ))
        
        for time in meteoData.hourly.time {
            let formattedTime: Date = time.toIsoDateTime()!
            
            // Omitt data sets before start time
            if (formattedTime >= startDateTime!) {
                let temperature = temperatures.next()!
                let rain = rains.next() ?? 0.0
                let shower = showers.next() ?? 0.0
                let snowfall = snowfalls.next() ?? 0.0
                let weathercode = weathercodes.next()!
                let cloudcover = cloudcovers.next() ?? 0
                let windspeed = windspeeds.next() ?? 0
                
                let category = WeatherCodeAnalyzer().analyze(from: RawWeatherData(
                    dateTime: formattedTime,
                    sunrise: sunrise,
                    sunset: sunset,
                    rain: rain,
                    shower: shower,
                    snowfall: snowfall,
                    weathercode: weathercode,
                    cloudcover: cloudcover,
                    windspeed: windspeed
                ))
                
                data.data.append(HourlyWeatherData(
                    location: location,
                    time: formattedTime,
                    category: category,
                    temperature: temperature,
                    windspeed: windspeed,
                    rain: rain + shower,
                    snowfall: snowfall
                ))
            }
        }
        
        data.data = data.data.sorted(by: { $0.time < $1.time })
    }
    
    private func getSunrise(options: [Date]) -> Date {
        if (options.count == 1) {
            return options[0]
        } else {
            if (startDateTime! < options[0] && startDateTime! > options[1]) {
                return options[0]
            } else {
                return options[1]
            }
        }
    }
    
    private func getSunset(options: [Date]) -> Date {
        if (options.count == 1) {
            return options[0]
        } else {
            if (endDateTime! > options[0] && endDateTime! < options[1]) {
                return options[0]
            } else {
                return options[1]
            }
        }
    }
}
