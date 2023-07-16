import UIKit

class DailyForecastsCell: UICollectionViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    private var forecasts: [DailyForecast] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: R.nib.forecastCell.name, bundle: nil), forCellWithReuseIdentifier: R.nib.forecastCell.name)
        
        setupCollectionView()
        setupShadows()
    }
    
    public func setupCell(with forecasts: [DailyForecast]) {
        self.forecasts = forecasts
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 70, height: 157)
        flowLayout.minimumLineSpacing = 8
        flowLayout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
    
    private func setupShadows() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
}


extension DailyForecastsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.forecastCell.name, for: indexPath) as! ForecastCell
        let currentForecast = forecasts[indexPath.row]
        cell.setupCell(with: currentForecast)
        return cell
    }
}
