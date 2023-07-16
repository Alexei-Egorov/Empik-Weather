import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchHistoryLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private var viewModel: HomeViewModel!
    private var searchTask: DispatchWorkItem?
    private var isShowingPopup: Bool = false
    
    var searchHistoryCities: [String] = []
    
    private lazy var autocompletePopup: AutocompletePopupView = {
        let width: CGFloat = searchBar.frame.width
        let xPos: CGFloat = searchBar.frame.origin.x
        let yPos: CGFloat = searchBar.frame.origin.y + searchBar.frame.height
        let popupRect = CGRect(x: xPos, y: yPos, width: width, height: 0)
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

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: R.nib.searchHistoryCell.name, bundle: nil), forCellReuseIdentifier: R.nib.searchHistoryCell.name)
        
        searchHistoryCities = viewModel.searchHistory.keys.sorted()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = R.color.primary()
        navigationItem.backBarButtonItem?.setTitleTextAttributes([.font: R.font.sfProTextSemibold(size: 20)!], for: .normal)
    }
    
    private func setupView() {
        self.addHidingKeyboardOnTap()
        setupNamings()
    }

    private func setupNamings() {
        titleLabel.text = R.string.localizable.empikWeather()
        searchBar.placeholder = R.string.localizable.provideCityName()
        searchHistoryLabel.text = R.string.localizable.searchHistory()
    }
    
    private func requestAutocomplite(from text: String) {
        viewModel.getAutocomplete(from: text) { [weak self] (result: Result<[Location], Error>) in
            self?.hideLoadingView()
            switch result {
            case .success(let locations):
                DispatchQueue.main.async {
                    if self?.isShowingPopup == false {
                        self?.showPopup()
                    }
                    self?.autocompletePopup.updateView(with: locations)
                }
            case .failure(let error):
                print("error occured: \(error)")
            }
        }
    }
    
    private func getWeatherDetails(cityName: String, cityKey: String) {
        displayLoadingView()
        viewModel.fulfillData(cityName: cityName, cityKey: cityKey) { [weak self] (result: Result<WeatherDetails, Error>) in
            self?.hideLoadingView()
            self?.viewModel.resetRequestChain()
            switch result {
            case .success(let weatherDetails):
                DispatchQueue.main.async {
                    let weatherDetailsVM = WeatherDetailsViewModel(weatherDetails: weatherDetails)
                    let weatherDetailsVC = WeatherDetailsViewController(viewModel: weatherDetailsVM)
                    self?.show(weatherDetailsVC, sender: nil)
                }
            case .failure(let failure):
                print("got failure: \(failure)")
            }
        }
    }
    
    private func showPopup() {
        let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            let origin = self.autocompletePopup.frame.origin
            let width = self.autocompletePopup.frame.width
            self.autocompletePopup.frame = CGRect(origin: origin, size: CGSize(width: width, height: 300))
        }
        animator.startAnimation()
        isShowingPopup = true
    }
    
    private func hidePopup() {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            let origin = self.autocompletePopup.frame.origin
            let width = self.autocompletePopup.frame.width
            self.autocompletePopup.frame = CGRect(origin: origin, size: CGSize(width: width, height: 0))
        }
        animator.startAnimation()
        isShowingPopup = false
    }
    
    private func displayLoadingView() {
        DispatchQueue.main.async {
            self.searchBar.searchTextPositionAdjustment = .init(horizontal: 25, vertical: 0)
            self.searchBar.isLoading = true
            self.searchBar.setImage(UIImage(), for: .search, state: .normal)
        }
    }
    
    private func hideLoadingView() {
        DispatchQueue.main.async {
            self.searchBar.searchTextPositionAdjustment = .init(horizontal: 0, vertical: 0)
            self.searchBar.isLoading = false
            self.searchBar.setImage(nil, for: .search, state: .normal)
        }
    }

}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty && isShowingPopup == true {
            hidePopup()
        }
        searchTask?.cancel()
        if searchText.isEmpty {
            hideLoadingView()
            return
        }
        
        self.displayLoadingView()
        
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
        viewModel.appendToSearchHistory(cityName: location.cityName, cityKey: location.key)
        getWeatherDetails(cityName: location.cityName, cityKey: location.key)
        hidePopup()
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.searchHistoryCell.name) as! SearchHistoryCell
        cell.titleLabel.text = searchHistoryCities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCityName = searchHistoryCities[indexPath.row]
        guard let selectedCityKey = viewModel.searchHistory[selectedCityName] else {
            fatalError("Could not find key for city")
        }
        getWeatherDetails(cityName: selectedCityKey, cityKey: selectedCityKey)
    }
}
