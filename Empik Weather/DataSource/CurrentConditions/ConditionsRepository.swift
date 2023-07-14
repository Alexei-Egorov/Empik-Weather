class ConditionsRepository {
    private let remoteService: RestService
    
    init(remoteService: RestService) {
        self.remoteService = remoteService
    }
    
    public func getCurrentConditions(forCityKey cityKey: String, completion: @escaping (Result<[CurrentConditions], Error>) -> Void) {
        remoteService.getCurrentConditions(forCityKey: cityKey, completion: completion)
    }
}
