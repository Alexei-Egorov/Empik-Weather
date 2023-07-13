import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchHistoryLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private var viewModel: HomeViewModel!
    
    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        setupNamings()
    }

    private func setupNamings() {
        titleLabel.text = R.string.localizable.empikWeather()
        searchBar.placeholder = R.string.localizable.provideCityName()
        searchHistoryLabel.text = R.string.localizable.searchHistory()
    }

    @IBAction func makeRequestTapped(_ sender: UIButton) {
        viewModel.getAutocomplete(from: "Biał")
    }
}
