class ForecastRequest: APIRequest {
    var method: HTTPMethod = .get
    var path: String = "forecasts/v1/daily/5day/"
    var parameters: [String : Any] = [String: Any]()
    var authorizationRequired: Bool = false
    var version: String = "1.0"
    
    init(parameters: ForecastParameters) {
        self.path += "\(parameters.cityKey)?language=\(parameters.language)&details=\(parameters.details)&metric=\(parameters.metric)&apikey=\(APIKey.apiKey)"
    }
}
