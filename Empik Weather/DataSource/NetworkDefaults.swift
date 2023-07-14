struct NetworkDefaults {
    static func apiURLString(for apiPath: String) -> String {
        let apiServerURL = "https://dataservice.accuweather.com/"
        return "\(apiServerURL)\(apiPath)"
    }
}
