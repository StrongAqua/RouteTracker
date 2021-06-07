//
//  PrivacyProtectionViewController.swift
//  RouteTracker
//
//  Created by aprirez on 6/7/21.
//

import UIKit

class PrivacyProtectionViewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // In my opinion, it looks a bit better to position the label centred in the top two thirds of the screen rather than in the middle
        let labelHeight = view.bounds.height * 0.66
        (privacyLabel.frame, _) = view.bounds.divided(atDistance: labelHeight, from: .minYEdge)
    }
    
    private lazy var privacyLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        
        label.textAlignment = .center
        label.textColor = .gray
        
        label.numberOfLines = 0
        label.text = "Content hidden\nto protect\nyour privacy"
        
        self.view.addSubview(label)
        
        return label
    }()
}

