import UIKit

protocol NibLoadable {
    var nibName: String { get }
    func loadViewFromNib() -> UIView?
}

extension NibLoadable {
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self) as! AnyClass)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView
    }
}
