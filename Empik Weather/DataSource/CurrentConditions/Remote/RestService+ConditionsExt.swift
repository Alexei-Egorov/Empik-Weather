extension RestService {
    func getCurrentConditions(forCityKey cityKey: String, completion: @escaping (Result<[CurrentConditionsRemote], Error>) -> Void) {
        let parameters = GetCurrentConditionsParameters(cityKey: cityKey, language: "en", details: "false")
        let request = GetCurrentConditionsRequest(parameters: parameters)
        performRequest(apiRequest: request, completion: completion)
    }
}
