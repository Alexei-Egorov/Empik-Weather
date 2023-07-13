class LocationRepository {
    private let remoteService: RestService
    
    init(remoteService: RestService) {
        self.remoteService = remoteService
    }
    
    public func getAutocomplite(from text: String, completion: @escaping (Result<[Location], Error>) -> Void) {
        remoteService.getAutocomplite(from: text, completion: completion)
    }
}
