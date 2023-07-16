import UIKit

class WeatherDetailsViewController: UIViewController {
  
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    private var viewModel: WeatherDetailsViewModel!
    
    private lazy var todaysDetailsCellWidth: CGFloat = {
        let inset: CGFloat = 32
        let spaceBetween: CGFloat = 30
        let width = (self.view.frame.width - inset * 2 - spaceBetween) / 2
        return width
    }()
    
    private lazy var forecastCellWidth: CGFloat = {
        let inset: CGFloat = 32
        let width = self.view.frame.width - inset * 2
        return width
    }()
    
    convenience init(viewModel: WeatherDetailsViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: R.nib.todaysDetailsCell.name, bundle: nil), forCellWithReuseIdentifier: R.nib.todaysDetailsCell.name)
        collectionView.register(UINib(nibName: R.nib.dailyForecastsCell.name, bundle: nil), forCellWithReuseIdentifier: R.nib.dailyForecastsCell.name)
        
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let titleLabel = UILabel()
        titleLabel.text = viewModel.weatherDetails.cityName
        titleLabel.font = R.font.sfProTextBold(size: 22)
        titleLabel.textColor = R.color.primary()
        navigationItem.titleView = titleLabel
    }

    private func setupView() {
        setupCollectionView()
        
        let conditions = viewModel.conditions
        tempLabel.text = "\(conditions.temperature)°C"
        tempLabel.textColor = TemperatureColor.getColor(forTemp: conditions.temperature)
        weatherImageView.image = UIImage(named: "icon\(conditions.weatherIcon)")
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 30
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 32, bottom: 5, right: 32)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
}


extension WeatherDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row <= 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.todaysDetailsCell.name, for: indexPath) as! TodaysDetailsCell
            guard let todaysForecast = viewModel.forecasts.first else {
                fatalError("Could not find forecast for 1st day")
            }
            if indexPath.row == 0 {
                cell.setupCell(temp: todaysForecast.minimumTemp, iconNumber: todaysForecast.nightIcon)
                cell.daytimeLabel.text = R.string.localizable.night()
            } else {
                cell.setupCell(temp: todaysForecast.maximumTemp, iconNumber: todaysForecast.dayIcon)
                cell.daytimeLabel.text = R.string.localizable.day()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.dailyForecastsCell.name, for: indexPath) as! DailyForecastsCell
            cell.setupCell(with: viewModel.forecasts)
            return cell
        }
    }
}


extension WeatherDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row <= 1 {
            return CGSize(width: todaysDetailsCellWidth, height: todaysDetailsCellWidth)
        } else {
            return CGSize(width: forecastCellWidth, height: todaysDetailsCellWidth)
        }
    }
}
