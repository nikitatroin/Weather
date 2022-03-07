//
//  WeatherCell.swift
//  Weather
//
//  Created by Евгений Елчев on 20.09.17.
//  Copyright © 2017 JonFir. All rights reserved.
//

import UIKit

final class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            self.shadowView.layer.shadowOffset = .zero
            self.shadowView.layer.shadowOpacity = 0.75
            self.shadowView.layer.shadowRadius = 6
        }
    }
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.clipsToBounds = true
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH.mm"
        return dateFormatter
    }()
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowView.layer.shadowPath = UIBezierPath(ovalIn: self.shadowView.bounds).cgPath
        self.containerView.layer.cornerRadius = self.containerView.frame.width / 2
    }
    
    // MARK: - Methods
    
    func configure(with viewModel: WeatherViewModel) {
        weather.text = viewModel.weatherText
        time.text = viewModel.dateText
        icon.image = viewModel.iconImage
        shadowView.layer.shadowColor = viewModel.shadowColor.cgColor
    }
}
