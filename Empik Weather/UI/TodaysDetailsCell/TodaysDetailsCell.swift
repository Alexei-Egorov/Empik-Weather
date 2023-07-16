import UIKit

class TodaysDetailsCell: UICollectionViewCell {

    @IBOutlet var daytimeLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var backgoundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupShadows()
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
    
    public func setupCell(temp: Float, iconNumber: Int) {
        tempLabel.text = "\(temp)°C"
        tempLabel.textColor = TemperatureColor.getColor(forTemp: temp)
        weatherImageView.image = UIImage(named: "icon\(iconNumber)")
    }

}
