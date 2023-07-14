extension RestService {
    func getTodaysForecast(forCityKey cityKey: String, completion: @escaping (Result<ForecastRemote, Error>) -> Void) {
        let parameters = ForecastParameters(cityKey: cityKey, language: "en", details: "false", metric: "true")
        let request = ForecastRequest(parameters: parameters)
        performRequest(apiRequest: request, completion: completion)
    }
}
