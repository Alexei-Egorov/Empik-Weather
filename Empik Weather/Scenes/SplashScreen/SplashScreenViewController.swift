import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupView() {
        let homeVC = HomeViewController()
        self.show(homeVC, sender: nil)
    }
    

    private func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
//            let image = R.image.backIcon()?.withRenderingMode(.alwaysOriginal)
//            appearance.setBackIndicatorImage(image, transitionMaskImage: image)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        
    }

}
