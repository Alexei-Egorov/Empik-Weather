class HomeViewModel {
    let locationRepository: LocationRepository
    
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
    
    func getAutocomplete(from text: String) {
        locationRepository.getAutocomplite(from: text) { [weak self] (result: Result<[Location], Error>) in
            switch result {
            case .success(let locations):
                print("got locations: \(locations)")
            case .failure(let error):
                print("got error: \(error)")
            }
        }
    }
}
