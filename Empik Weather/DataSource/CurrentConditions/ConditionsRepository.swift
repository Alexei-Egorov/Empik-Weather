class ConditionsRepository {
    private let remoteService: RestService
    
    init(remoteService: RestService) {
        self.remoteService = remoteService
    }
    
    public func getCurrentConditions(forCityKey cityKey: String, completion: @escaping (Result<CurrentConditions, Error>) -> Void) {
        remoteService.getCurrentConditions(forCityKey: cityKey) { (result: Result<[CurrentConditionsRemote], Error>) in
            switch result {
            case .success(let conditionsRemote):
                guard let conditionsRemote = conditionsRemote.first else {
                    fatalError("Could not find conditions in the response")
                }
                let currentConditions = CurrentConditions(description: conditionsRemote.description, weatherIcon: conditionsRemote.weatherIcon, temperature: conditionsRemote.temperature.metric.value)
                completion(.success(currentConditions))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
