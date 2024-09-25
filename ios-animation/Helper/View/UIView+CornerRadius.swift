//  Created by Windy on 01/08/23.
//

import UIKit

extension UIView {
    
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        return self
    }
    
}
