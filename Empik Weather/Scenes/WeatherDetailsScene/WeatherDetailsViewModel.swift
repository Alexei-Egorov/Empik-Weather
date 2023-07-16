class WeatherDetailsViewModel {
    let weatherDetails: WeatherDetails
    let conditions: CurrentConditions
    let forecasts: [DailyForecast]
    
    init(weatherDetails: WeatherDetails) {
        self.weatherDetails = weatherDetails
        
        self.conditions = weatherDetails.currentCoditions
        self.forecasts = weatherDetails.dailyForecasts
    }
}
