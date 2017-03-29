//
//  DetailViewController.swift
//  FindPlaces
//
//  Created by Alex on 3/28/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    var imageView = UIImageView()
    var place: Place?
    
    // MARK: - VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = place?.name
        
        loadViews() //loadSubViews + contraints
        
    }
    
    // MARK: - Load Views and contraints
    
    func loadViews(){
        //Initialize Labels
        let titleLabel = UILabel()
        let descriptionLabel = UILabel()
        let vicinityLable = UILabel()
        
        //Autolayout
        for v in [titleLabel,vicinityLable,descriptionLabel,imageView] as [UIView]{
            scrollView.addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let views = ["title":titleLabel,"description":descriptionLabel,"vicinity":vicinityLable,"icon":imageView] as [String : Any]
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[icon]-30-[title]-20-[vicinity]-20-[description]-20-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views))
        scrollView.addConstraints((NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[title]-40-|", options: .alignAllCenterX, metrics: nil, views: views)))
        scrollView.addConstraints((NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[vicinity]-40-|", options: .alignAllCenterX, metrics: nil, views: views)))
        scrollView.addConstraints((NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[description]-25-|", options: .alignAllCenterX, metrics: nil, views: views)))
        self.view.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: -50))
        
        scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 0.2, constant: 0))
        
        if let title = self.place?.name {
            titleLabel.text = title
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightLight)
            titleLabel.minimumScaleFactor = 0.6
            titleLabel.numberOfLines = 2
        }
        
        if let vicinity = self.place?.vicinity {
            vicinityLable.text = vicinity
            vicinityLable.textAlignment = NSTextAlignment.center
            vicinityLable.adjustsFontSizeToFitWidth = true
            vicinityLable.textColor = UIColor.white
            vicinityLable.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightBold)
            vicinityLable.minimumScaleFactor = 0.6
            vicinityLable.numberOfLines = 0
        }
        
        if let description = self.place?.openNow {
            descriptionLabel.text = (description == "0") ? "Closed" : "Open"
            descriptionLabel.textAlignment = .center
            descriptionLabel.adjustsFontSizeToFitWidth = true
            descriptionLabel.textColor = UIColor.white
            descriptionLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightLight)
            descriptionLabel.minimumScaleFactor = 0.6
            descriptionLabel.numberOfLines = 1
        }
        
        
    }

}
