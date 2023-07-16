class GetCurrentConditionsRequest: APIRequest {
    var method: HTTPMethod = .get
    var path: String = "currentconditions/v1/"
    var parameters: [String : Any] = [String: Any]()
    var authorizationRequired: Bool = false
    var version: String = "1.0"
    
    init(parameters: GetCurrentConditionsParameters) {
        self.path += "\(parameters.cityKey)/?language=\(parameters.language)&details=\(parameters.details)"
    }
}
