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

struct DayRemote: Decodable {
    let icon: Int
    
    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.icon = try container.decode(Int.self, forKey: .icon)
    }
}

struct DailyForecastRemote: Decodable {
    let date: String
    let temperature: TemperatureRemote
    let day: DayRemote
    let night: DayRemote
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case temperature = "Temperature"
        case day = "Day"
        case night = "Night"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.temperature = try container.decode(TemperatureRemote.self, forKey: .temperature)
        self.day = try container.decode(DayRemote.self, forKey: .day)
        self.night = try container.decode(DayRemote.self, forKey: .night)
    }
}

struct ForecastRemote: Decodable {
    let dailyForecasts: [DailyForecastRemote]
    
    enum CodingKeys: String, CodingKey {
        case todaysForecast = "DailyForecasts"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dailyForecasts = try container.decode([DailyForecastRemote].self, forKey: .todaysForecast)
    }
}
