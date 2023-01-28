import SwiftUI

struct DailyView: View {
    private let iconResolver = ForecastIconResolver()
    
    @ObservedObject private var dailyHolder: DailyWeatherDataHolder
    
    init(dailyHolder: DailyWeatherDataHolder) {
        self.dailyHolder = dailyHolder
    }

    var body: some View {
         VStack {
             HStack {
                 Image(systemName: "calendar")
                     .imageScale(.medium)
                     .foregroundColor(Color(hex: 0xC7EAFE))
                 Text("10-day-forecast")
                     .foregroundColor(Color(hex: 0xC7EAFE))
             }
             
             Divider()
             
             ForEach(dailyHolder.data) { forecast in
                 let icon = iconResolver.resolve(
                    category: forecast.category,
                    isRaining: forecast.rain != 0)
                 
                 HStack {
                     Text(DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: forecast.date) - 1])
                         .foregroundColor(.white)
                                              
                     Image(systemName: icon.systemName)
                         .imageScale(.large)
                         .foregroundColor(icon.color)
                         .padding(3)
                     
                     Text("lowest-temperature \(String(forecast.lowestTemperature))")
                         .foregroundColor(.white)
                     
                     Text("highest-temperature \(String(forecast.highestTemperature))")
                         .foregroundColor(.white)
                 }.padding()
                 
                 Divider()
             }
         }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .topLeading
         ).padding()
    }
}
