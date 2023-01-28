import SwiftUI

struct MainView: View, UpdateDelegate {
    @ObservedObject private var hourlyHolder: HourlyWeatherDataHolder = HourlyWeatherDataHolder()
    @ObservedObject private var dailyHolder: DailyWeatherDataHolder = DailyWeatherDataHolder()
    
    @ObservedObject private var location: Location = Location()
    
    private let hourlyProvider: HourlyWeatherDataProvider
    private let dailyProvider: DailyWeatherDataProvider
        
    init(hourlyProvider: HourlyWeatherDataProvider, dailyProvider: DailyWeatherDataProvider) {
        self.hourlyProvider = hourlyProvider
        self.dailyProvider = dailyProvider
        
        // LocationProviderGps(location: location, delegate: self).getCurrentLocation()
        LocationProviderMock(location: location, delegate: self).getCurrentLocation()
    }
    
    var body: some View {
        if (!location.isAllowed) {
            LocationNotAllowedView()
        } else {
            LinearGradient(gradient: Gradient(
                colors: [Color(hex: 0x1f93ff), Color(hex: 0x7bbfff)]),
                           startPoint: .top,
                           endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                ScrollView (.vertical, showsIndicators: false) {
                    VStack {
                        CurrentView(dailyHolder: dailyHolder, hourlyHolder: hourlyHolder)
                        
                        HourlyView(hourlyHolder: hourlyHolder)
                            .background(
                                Color(hex: 0x1C84E6)
                                    .opacity(0.5)
                                    .blur(radius: 0)
                            )
                            .cornerRadius(20)
                            .padding(30)
                        
                        DailyView(dailyHolder: dailyHolder)
                            .background(
                                Color(hex: 0x1C84E6)
                                    .opacity(0.5)
                                    .blur(radius: 0)
                            )
                            .cornerRadius(20)
                            .padding(30)
                    }
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading)
                }
            )
        }
    }
    
    func update() {
        hourlyProvider.loadData(at: location, into: hourlyHolder)
        dailyProvider.loadData(at: location, into: dailyHolder)
    }
}
