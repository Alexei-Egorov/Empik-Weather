import Foundation

class ForecastRepository {
    private let remoteService: RestService
    
    init(remoteService: RestService) {
        self.remoteService = remoteService
    }
    
    public func getTodaysForecast(forCityKey cityKey: String, completion: @escaping (Result<[DailyForecast], Error>) -> Void) {
        remoteService.getTodaysForecast(forCityKey: cityKey) { (result: Result<ForecastRemote, Error>) in
            switch result {
            case .success(let result):
                let forecasts = result.dailyForecasts.map { dailyForecast in
                    guard let date = DateFormatter.serverDateFormatter.date(from: dailyForecast.date) else {
                        fatalError("Could not convert date using server date formatter")
                    }
                    return DailyForecast(date: date,
                                  minimumTemp: dailyForecast.temperature.minimum.value,
                                  maximumTemp: dailyForecast.temperature.maximum.value,
                                  dayIcon: dailyForecast.day.icon,
                                  nightIcon: dailyForecast.night.icon)
                }
                return completion(.success(forecasts))
            case .failure(let failure):
                return completion(.failure(failure))
            }
        }
    }
}
