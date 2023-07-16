extension RestService {
    func getAutocomplite(from text: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        let parameters = GetAutocompleteParameters(q: text, language: "pl")
        let request = GetAutocompleteRequest(parameters: parameters)
        performRequest(apiRequest: request, completion: completion)
    }
}
