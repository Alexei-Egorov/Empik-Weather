struct EdgeTemperatureRemote: Decodable {
    let value: Float
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(Float.self, forKey: .value)
    }
}

struct TemperatureRemote: Decodable {
    let minimum: EdgeTemperatureRemote
    let maximum: EdgeTemperatureRemote
    
    enum CodingKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.minimum = try container.decode(EdgeTemperatureRemote.self, forKey: .minimum)
        self.maximum = try container.decode(EdgeTemperatureRemote.self, forKey: .maximum)
    }
}

struct TodaysForecastRemote: Decodable {
    let temperature: TemperatureRemote
    
    enum CodingKeys: String, CodingKey {
        case temperature = "Temperature"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temperature = try container.decode(TemperatureRemote.self, forKey: .temperature)
    }
}

struct ForecastRemote: Decodable {
    let todaysForecast: [TodaysForecastRemote]
    
    enum CodingKeys: String, CodingKey {
        case todaysForecast = "DailyForecasts"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.todaysForecast = try container.decode([TodaysForecastRemote].self, forKey: .todaysForecast)
    }
}
