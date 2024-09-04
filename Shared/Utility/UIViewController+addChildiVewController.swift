import UIKit

extension UIViewController {
    
    func addChildiVewController(_ viewController: UIViewController)  {
        DispatchQueue.main.async {
            self.addChild(viewController)
            viewController.view.frame = self.view.frame
            self.view.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }

    func removeChildViewController(_ viewController: UIViewController?, after: Double = 0.5, completion: (() -> Void)? = nil) {
        guard let viewController else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
            completion?()
        }
    }
}
