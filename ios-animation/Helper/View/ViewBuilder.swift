//  Created by Windy on 29/12/23.

import UIKit

@resultBuilder
public enum ViewBuilder {
    
    public static func buildBlock() -> [UIView] {
        []
    }
    
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        components
    }
    
    public static func buildBlock(_ components: [UIView]...) -> [UIView] {
        components.flatMap { $0 }
    }
}
