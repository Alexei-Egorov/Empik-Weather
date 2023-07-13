class GetAutocompleteRequest: APIRequest {
    var method: HTTPMethod = .get
    var path: String = "https://dataservice.accuweather.com/locations/v1/cities/autocomplete"
    var parameters: [String : Any] = [String: Any]()
    var authorizationRequired: Bool = false
    var version: String = "1.0"
    
    init(parameters: GetAutocompleteParameters) {
        self.path += "?q=" + parameters.q + "&language=" + parameters.language + "&apikey=" + APIKey.apiKey
    }
}
