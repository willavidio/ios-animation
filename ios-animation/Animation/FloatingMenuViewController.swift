//
//  FloatingMenuViewController.swift
//  ios-animation
//
//  Created by VIDIO on 24/09/24.
//

import UIKit

final class FloatingMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let floatingMenu = FloatingMenu()
            .image(.init(systemName: "hand.thumbsup")!.withTintColor(.black))
            .title("Beri Nilai")
            .parentView(self.view)
            .floatingMenuButtons([
                .init(image: .init(systemName: "star.circle.fill")!, title: "Super Like", action: {}),
                .init(image: .init(systemName: "hand.thumbsup.circle.fill")!, title: "Like", action: {}),
                .init(image: .init(systemName: "hand.thumbsdown.circle.fill")!, title: "Dislike", action: {})
            ])
        view.addSubview(floatingMenu, constraints: .center)
    }
}
