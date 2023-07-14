import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchHistoryLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private var viewModel: HomeViewModel!
    private var searchTask: DispatchWorkItem?
    
    private lazy var autocompletePopup: AutocompletePopupView = {
        let width: CGFloat = searchBar.frame.width
        let xPos: CGFloat = searchBar.frame.origin.x
        let yPos: CGFloat = searchBar.frame.origin.y + searchBar.frame.height
        let popupRect = CGRect(x: xPos, y: yPos, width: width, height: 300)
        let popup = AutocompletePopupView(frame: popupRect)
        popup.delegate = self
        self.view.addSubview(popup)
        return popup
    }()
    
    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        searchBar.delegate = self
    }
    
    private func setupView() {
        setupNamings()
    }

    private func setupNamings() {
        titleLabel.text = R.string.localizable.empikWeather()
        searchBar.placeholder = R.string.localizable.provideCityName()
        searchHistoryLabel.text = R.string.localizable.searchHistory()
    }
    
    private func requestAutocomplite(from text: String) {
        displayLoadingView()
        viewModel.getAutocomplete(from: text) { [weak self] (result: Result<[Location], Error>) in
            self?.hideLoadingView()
            switch result {
            case .success(let locations):
                DispatchQueue.main.async {
                    self?.autocompletePopup.updateView(with: locations)
                }
            case .failure(let error):
                print("error occured: \(error)")
            }
        }
    }
    
    private func getWeatherDetails(forCityKey cityKey: String) {
        displayLoadingView()
        viewModel.fulfillData(forCityKey: cityKey) { [weak self] (result: Result<WeatherDetails, Error>) in
            switch result {
            case .success(let weather):
                print("got weather: \(weather)")
            case .failure(let failure):
                print("got failure: \(failure)")
            }
        }
    }
    
    private func displayLoadingView() {
        DispatchQueue.main.async {
            self.searchBar.isLoading = true
        }
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.async {
            self.searchBar.isLoading = false
        }
    }

}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchTask?.cancel()
        
        let task = DispatchWorkItem { () in
            DispatchQueue.global(qos: .userInteractive).async { () in
                self.requestAutocomplite(from: searchText)
            }
        }
        self.searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
}


extension HomeViewController: AutocompletePopupDelegate {
    func didSelectLocation(_ location: Location) {
        searchBar.text = location.cityName
        getWeatherDetails(forCityKey: location.key)
    }
}
