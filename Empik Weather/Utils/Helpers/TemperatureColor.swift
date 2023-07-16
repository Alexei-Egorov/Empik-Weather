import UIKit

class TemperatureColor {
    private static let colorsArray: [UIColor?] = [R.color.cold(), R.color.fair(), R.color.warm(), R.color.hot(), R.color.extraHot()]
    
    static func getColor(forTemp temp: Float) -> UIColor? {
        if temp < 10 {
            return colorsArray[0]
        } else if temp > 30 {
            return colorsArray[4]
        } else {
            var diff = Int(roundf((temp - 10) / 20 * 5))
            if diff != 0 {
                diff -= 1
            }
            return colorsArray[diff]
        }
    }
}
