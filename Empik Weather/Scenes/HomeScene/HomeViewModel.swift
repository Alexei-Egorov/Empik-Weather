class HomeViewModel {
    private let locationRepository: LocationRepository
    private let conditionsRepository: ConditionsRepository
    private let forecastRepository: ForecastRepository
    private var weatherDetails = WeatherDetails()
    private var requestsChain: [String: Bool] = ["currentConditions": false, "dayForecast": false]
    
    init(locationRepository: LocationRepository, conditionsRepository: ConditionsRepository, forecastRepository: ForecastRepository) {
        self.locationRepository = locationRepository
        self.conditionsRepository = conditionsRepository
        self.forecastRepository = forecastRepository
    }
    
    public func getAutocomplete(from text: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        locationRepository.getAutocomplite(from: text, completion: completion)
    }
    
    private func getCurrentConditions(forCityKey cityKey: String, completion: @escaping (Result<CurrentConditions, Error>) -> Void) {
        conditionsRepository.getCurrentConditions(forCityKey: cityKey, completion: completion)
    }
    
    private func getTodaysForecast(forCityKey cityKey: String, completion: @escaping (Result<[DailyForecast], Error>) -> Void) {
        forecastRepository.getTodaysForecast(forCityKey: cityKey, completion: completion)
    }
    
    public func fulfillData(forCityKey cityKey: String, completion: @escaping (Result<WeatherDetails, Error>) -> Void) {
        getCurrentConditions(forCityKey: cityKey) { [weak self] (result: Result<CurrentConditions, Error>) in
            guard let sSelf = self else { return }
            switch result {
            case .success(let conditions):
                sSelf.weatherDetails.currentCoditions = conditions
                sSelf.requestsChain["currentConditions"] = true
                sSelf.checkForChainCompletion(completion: completion)
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
        getTodaysForecast(forCityKey: cityKey) { [weak self] (result: Result<[DailyForecast], Error>) in
            switch result {
            case .success(let forecasts):
                self?.weatherDetails.dailyForecasts = forecasts
                self?.requestsChain["dayForecast"] = true
                self?.checkForChainCompletion(completion: completion)
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    private func checkForChainCompletion(completion: @escaping (Result<WeatherDetails, Error>) -> Void) {
        if requestsChain.allSatisfy({ $0.value == true }) {
            completion(.success(self.weatherDetails))
        }
    }
}
