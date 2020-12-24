//
//  RatioPresenter.swift
//  Mantis
//
//  Created by Echo on 11/3/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit

enum RatioType {
    case horizontal
    case vertical
}

class RatioPresenter {
    var didGetRatio: ((Double)->Void) = { _ in }
    private var type: RatioType = .vertical
    private var originalRatioH: Double
    private var ratios: [RatioItemType]
    
    init(type: RatioType, originalRatioH: Double, ratios: [RatioItemType] = []) {
        self.type = type
        self.originalRatioH = originalRatioH
        self.ratios = ratios
    }
    
    func present(by viewController: UIViewController, in sourceView: UIView) {
        let countriesSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let countries = Config.countries
        
        for country in countries {
            let countryTitle = country

            let action = UIAlertAction(title: countryTitle, style: .default) { [weak self] _ in
                guard let self = self else { return }
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                for ratio in self.ratios {
                    let title = (self.type == .horizontal) ? ratio.nameH : ratio.nameV
                    
                    if title.contains(countryTitle) {
                        let action = UIAlertAction(title: title, style: .default) {[weak self] _ in
                            guard let self = self else { return }
                            let ratioValue = (self.type == .horizontal) ? ratio.ratioH : ratio.ratioV
                            self.didGetRatio(ratioValue)
                        }
                        actionSheet.addAction(action)
                    }
                    
                    
                }
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                viewController.present(actionSheet, animated: true)
                
            }
            countriesSheet.addAction(action)
        }
        
       
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // https://stackoverflow.com/a/27823616/288724
            countriesSheet.popoverPresentationController?.permittedArrowDirections = .any
            countriesSheet.popoverPresentationController?.sourceView = sourceView
            countriesSheet.popoverPresentationController?.sourceRect = sourceView.bounds
        }
        
        let cancelText = LocalizedHelper.getString("Cancel")
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel)
        countriesSheet.addAction(cancelAction)
        
        viewController.present(countriesSheet, animated: true)
    }
}
