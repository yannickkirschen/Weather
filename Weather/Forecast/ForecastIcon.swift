import SwiftUI

class ForecastIcon : ObservableObject, Identifiable {   
    @Published var systemName: String
    @Published var color: Color
    
    init(with name: String, in color: Color) {
        self.systemName = name
        self.color = color
    }
}

class ForecastIconResolver {
    func resolve(category: WeatherCategory, isRaining: Bool) -> ForecastIcon {
        if (category == .thundery && isRaining) {
            return ForecastIcon(with: "cloud.bolt.rain", in: .white)
        }
        
        switch category {
        case .sunny:
            return ForecastIcon(with: "sun.max", in: .yellow)
        case .cloudy:
            return ForecastIcon(with: "cloud", in: .white)
        case .sunnyCloudy:
            return ForecastIcon(with: "cloud.sun", in: .white)
        case .rainy:
            return ForecastIcon(with: "cloud.rain", in: .white)
        case .heavyRainy:
            return ForecastIcon(with: "cloud.heavyrain", in: .white)
        case .snowy:
            return ForecastIcon(with: "cloud.snow", in: .white)
        case .sleety:
            return ForecastIcon(with: "cloud.sleet", in: .white)
        case .foggy:
            return ForecastIcon(with: "cloud.fog", in: .white)
        case .thundery:
            return ForecastIcon(with: "cloud.bolt", in: .white)
        case .clearNight:
            return ForecastIcon(with: "sparkles", in: .white)
        case .windy:
            return ForecastIcon(with: "wind", in: .white)
        case .sunrise:
            return ForecastIcon(with: "sunrise", in: .white)
        case .sunset:
            return ForecastIcon(with: "sunset", in: .white)
        default:
            return ForecastIcon(with: "questionmark", in: .white)
        }
    }
}
