class ForecastRepository {
    private let remoteService: RestService
    
    init(remoteService: RestService) {
        self.remoteService = remoteService
    }
    
    public func getTodaysForecast(forCityKey cityKey: String, completion: @escaping (Result<TodaysForecast, Error>) -> Void) {
        remoteService.getTodaysForecast(forCityKey: cityKey) { (result: Result<ForecastRemote, Error>) in
            switch result {
            case .success(let result):
                guard let todaysForecast = result.todaysForecast.first else {
                    fatalError("Could not find daily forecast in the result of request")
                }
                let forecast = TodaysForecast(minimumTemp: todaysForecast.temperature.minimum.value,
                                              maximumTemp: todaysForecast.temperature.maximum.value)
                return completion(.success(forecast))
            case .failure(let failure):
                return completion(.failure(failure))
            }
        }
    }
}
