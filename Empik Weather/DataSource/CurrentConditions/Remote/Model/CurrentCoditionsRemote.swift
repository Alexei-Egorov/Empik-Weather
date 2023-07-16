struct MetricValue: Decodable {
    let value: Float
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(Float.self, forKey: .value)
    }
}

struct Metric: Decodable {
    let metric: MetricValue
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.metric = try container.decode(MetricValue.self, forKey: .metric)
    }
}

struct CurrentConditionsRemote: Decodable {    
    let description: String
    let weatherIcon: Int
    let temperature: Metric
    
    enum CodingKeys: String, CodingKey {
        case description = "WeatherText"
        case weatherIcon = "WeatherIcon"
        case temperature = "Temperature"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decode(String.self, forKey: .description)
        self.weatherIcon = try container.decode(Int.self, forKey: .weatherIcon)
        self.temperature = try container.decode(Metric.self, forKey: .temperature)
    }
}
