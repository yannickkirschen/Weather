/// This categorizes the weather forecast for easier use. All categories match
/// a certain SF symbol, that is displayed in the UI.
enum WeatherCategory : String {
    /// Sunny means, that the sun shines mostly during a time period. There
    /// must not be any precipitation and cloudcover must be less or equal
    /// to 10%.
    /// The SF symbol `sun.max` will be displayed.
    case sunny = "sunny"
    
    /// Cloudy means, that the sky is mostly cloudy. There must not be any
    /// precipitation and cloudcover is more than 50%.
    /// The SF symbol `cloud` will be displayed.
    case cloudy = "cloudy"
    
    /// Sunny cloudy means, that we have a mixture of sun and clouds. There
    /// must not be any precipitation and cloudcover is between 10% and 50%.
    /// The SF symbol `cliud.sun` will be displayed.
    case sunnyCloudy = "sunny-cloudy"
    
    /// Rainy means, that is is raining but the precipitation is not higher
    /// than 15mm (15l/m^2).
    /// The SF symbol `cloud.rain` will be displayed.
    case rainy = "rainy"
    
    /// Heavy rainy means, that it is raining and the precipitation is higher
    /// than 15mm (15l/m^2). Caution: this is dangerous weather!
    case heavyRainy = "heavy-rainy"
    
    /// Snowy means, that snow is falling.
    /// The SF symbol `cloud.snow` will be displayed.
    case snowy = "snowy"
    
    /// Sleety means, that it is raining and snow is falling.
    /// The SF symbol `cloud.sleet` will be displayed.
    case sleety = "sleety"
    
    /// Foggy means, that the World Meteorological Organization Code
    /// is 45 or 48.
    /// The SF symbol `cloud.fog` will be displayed.
    case foggy = "foggy"
    
    /// Thundery means, that the World Meteorological Organization Code
    /// is 95, 96 or 99.
    /// The SF symbol `cloud.bolt` will be displayed. If it is raining at the
    /// same time, the SF symbol `cloud.bolt.rain` will be displayed.
    case thundery = "thundery"
    
    /// Clear night means, that sun has already set and the sky is clear, so
    /// you can see the stars.
    /// The SF symbol `sparkles` will be displayed.
    case clearNight = "clear-night"
    
    /// Windy means, that the windspeed is equal to or higher than 75 km/h.
    /// This is the speed of a storm.
    /// The SF symbol `wind` will be displayed.
    case windy = "windy"
    
    //
    // The following categories are used in special cases only.
    //
    
    /// This is connected to the excact time of the sunrise in the corresponding
    /// ``WeatherData`` object.
    /// The SF symbol `sunrise` will be displayed.
    case sunrise = "sunrise"
    
    /// This is connected to the excact time of the sunset in the corresponding
    /// ``WeatherData`` object.
    /// The SF symbol `sunset` will be displayed.
    case sunset = "sunset"
    
    /// We have no idea how to categorize the weather.
    case unknown = "unknown"
}
