import UIKit

protocol AutocompletePopupDelegate: AnyObject {
    func didSelectLocation(_ location: Location)
}

class AutocompletePopupView: UIView, NibLoadable {

    var nibName: String = "AutocompletePopupView"
    
    @IBOutlet var tableView: UITableView!
    
    private var data: [Location]?
    public weak var delegate: AutocompletePopupDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    convenience init(frame: CGRect, data: [Location]) {
        self.init(frame: frame)
        self.data = data
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        tableView.register(UINib(nibName: R.nib.autocompleteCell.name, bundle: nil), forCellReuseIdentifier: R.nib.autocompleteCell.name)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func updateView(with data: [Location]) {
        self.data = data
        tableView.reloadData()
    }
    

}

extension AutocompletePopupView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data {
            return data.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.autocompleteCell.name) as! AutocompleteCell
        cell.titleLabel.text = data![indexPath.row].cityName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = data![indexPath.row]
        delegate.didSelectLocation(selectedLocation)
        self.removeFromSuperview()
    }
}
