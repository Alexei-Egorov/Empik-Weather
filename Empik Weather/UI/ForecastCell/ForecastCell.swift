import UIKit

class ForecastCell: UICollectionViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dayImageView: UIImageView!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var nightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setupCell(with forecast: DailyForecast) {
        dateLabel.text = forecast.date.getDayAndMonth()
        dayImageView.image = UIImage(named: "icon\(forecast.dayIcon)")
        maxTempLabel.text = "\(forecast.maximumTemp)°C"
        maxTempLabel.textColor = TemperatureColor.getColor(forTemp: forecast.maximumTemp)
        minTempLabel.text = "\(forecast.minimumTemp)°C"
        minTempLabel.textColor = TemperatureColor.getColor(forTemp: forecast.minimumTemp)
        nightImageView.image = UIImage(named: "icon\(forecast.nightIcon)")
    }

}
