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
        let countries = Config.countries

        let countriesSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
        let searchAction = UIAlertAction(title: "Search", style: .destructive) { [weak self] _ in
            
            let vc = UIAlertController(title: "Search Country", message: nil, preferredStyle: .alert)
            vc.addTextField()
            
            let search = UIAlertAction(title: "Done", style: .default) { [weak vc, weak self] _ in
                guard let self = self else { return }
                let filteredSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                var filteredArr = [String]()
                if let text = vc?.textFields?[0].text {
                    for i in 0..<countries.count {
                        
                        let country = countries[i]
                        if country.lowercased().contains(text.lowercased()) {
                            filteredArr.append(country)
                        }
                    }
                }

                
                
                self.callActionSheet(by: viewController, in: sourceView, alertController: filteredSheet, countries: filteredArr)

//                viewController.present(countriesSheet, animated: true)
            }
            
            vc.addAction(search)
            vc..addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            viewController.present(vc, animated: true)
        }
        countriesSheet.addAction(searchAction)
        
        callActionSheet(by: viewController, in: sourceView, alertController: countriesSheet, countries: countries)
        
        
    }
    
    
    
    func callActionSheet(by viewController: UIViewController, in sourceView: UIView, alertController: UIAlertController, countries: [String]) {
        for country in countries {
            let countryTitle = country

            let action = UIAlertAction(title: countryTitle, style: .default) { [weak self] _ in
                guard let self = self else { return }
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                for ratio in self.ratios {
                    let title = (self.type == .horizontal) ? ratio.nameH : ratio.nameV
                    
                    
                    if title.contains(countryTitle) {
                        let actionTitleArray = title.components(separatedBy: countryTitle)
                        let actionTitle = actionTitleArray[1]
                        
                        let action = UIAlertAction(title: actionTitle, style: .default) {[weak self] _ in
                            guard let self = self else { return }
                            let ratioValue = (self.type == .horizontal) ? ratio.ratioH : ratio.ratioV
                            self.didGetRatio(ratioValue)
                        }
                        actionSheet.addAction(action)
                    }else if countryTitle == "United States" && title.contains("US") {
                        let action = UIAlertAction(title: title, style: .default) {[weak self] _ in
                            guard let self = self else { return }
                            let ratioValue = (self.type == .horizontal) ? ratio.ratioH : ratio.ratioV
                            self.didGetRatio(ratioValue)
                        }
                        actionSheet.addAction(action)
                    }else if countryTitle == "United Kingdom" && title.contains("UK") {
                        let action = UIAlertAction(title: title, style: .default) {[weak self] _ in
                            guard let self = self else { return }
                            let ratioValue = (self.type == .horizontal) ? ratio.ratioH : ratio.ratioV
                            self.didGetRatio(ratioValue)
                        }
                        actionSheet.addAction(action)
                    }else if countryTitle == "United Arab Emirates" && title.contains("UK") {
                        let action = UIAlertAction(title: title, style: .default) {[weak self] _ in
                            guard let self = self else { return }
                            let ratioValue = (self.type == .horizontal) ? ratio.ratioH : ratio.ratioV
                            self.didGetRatio(ratioValue)
                        }
                        actionSheet.addAction(action)
                    }
                    
                    
                }
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                viewController.present(actionSheet, animated: true)
                
            }
            alertController.addAction(action)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            // https://stackoverflow.com/a/27823616/288724
            alertController.popoverPresentationController?.permittedArrowDirections = .any
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
        }
        
        let cancelText = LocalizedHelper.getString("Cancel")
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true)
    }
}
