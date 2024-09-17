import UIKit

extension UIViewController {
    
    func addChildViewController(_ viewController: UIViewController?, completion: ((UIViewController?) -> Void)? = nil) {
        guard let viewController else {
            completion?(nil)
            return
        }
        DispatchQueue.main.async {
            self.addChild(viewController)
            viewController.view.frame = self.view.frame
            self.view.addSubview(viewController.view)
            viewController.didMove(toParent: self)
            completion?(viewController)
        }
    }

    func removeChildViewController(_ viewController: UIViewController?, after: Double = 0.5, completion: (() -> Void)? = nil) {
        guard let viewController else {
            completion?()
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
