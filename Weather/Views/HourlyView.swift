import SwiftUI

struct HourlyView: View {
    private let timeFormatter = DateFormatter()
    private let iconResolver = ForecastIconResolver()
    
    @ObservedObject private var hourlyHolder: HourlyWeatherDataHolder
    
    init(hourlyHolder: HourlyWeatherDataHolder) {
        self.hourlyHolder = hourlyHolder
        timeFormatter.dateFormat = "HH:mm"
    }

    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
             HStack {
                 ForEach(hourlyHolder.data) { forecast in
                     let icon = iconResolver.resolve(
                        category: forecast.category,
                        isRaining: forecast.rain != 0)
                     
                     VStack {
                         Text(timeFormatter.string(from: forecast.time))
                             .foregroundColor(.white)
                         Image(systemName: icon.systemName)
                             .imageScale(.large)
                             .foregroundColor(icon.color)
                             .padding(3)
                         
                         if (forecast.category == .rainy) {
                             Text("\(String(forecast.rain!))mm")
                                 .foregroundColor(.white)
                         }
                         
                         if (forecast.category == .snowy) {
                             Text("\(String(forecast.snowfall!))mm")
                                 .foregroundColor(.white)
                         }
                         
                         if (forecast.category != .sunrise && forecast.category != .sunset) {
                             Text("\(String(forecast.temperature))°")
                                 .foregroundColor(.white)
                         }
                         
                         if (forecast.category == .sunrise) {
                             Text("sunrise").foregroundColor(.white)
                         } else if (forecast.category == .sunset) {
                             Text("sunset").foregroundColor(.white)
                         }
                     }.padding()
                 }
             }
        }
    }
}
