import SwiftUI

struct CurrentView: View {
    @ObservedObject private var dailyHolder: DailyWeatherDataHolder
    @ObservedObject private var hourlyHolder: HourlyWeatherDataHolder
    
    init(dailyHolder: DailyWeatherDataHolder, hourlyHolder: HourlyWeatherDataHolder) {
        self.dailyHolder = dailyHolder
        self.hourlyHolder = hourlyHolder
    }
    
    var body: some View {
        if (dailyHolder.data.count > 0 && hourlyHolder.data.count > 0) {
            VStack {
                let data = dailyHolder.data[0]
                
                let location = "\(data.location.text)"
                let temperature = "\(hourlyHolder.data[0].temperature)"
                let highestTemperature = String("\(data.highestTemperature)")
                let lowestTemperature = String("\(data.lowestTemperature)")
                
                Text(location)
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                
                Text(temperature + "°")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text(LocalizedStringKey(data.category.rawValue))
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                
                Text("highest-lowest-temperature \(highestTemperature) \(lowestTemperature)")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }.padding(10)
        }
    }
}
