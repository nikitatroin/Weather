//
//  WeatherViewController.swift
//  Weather
//
//  Created by Евгений Елчев on 20.09.17.
//  Copyright © 2017 JonFir. All rights reserved.
//

import UIKit
import RealmSwift

final class WeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var weekDayPicker: WeekDayPicker!
    @IBOutlet var collectionView: UICollectionView!
    
    var cityName = ""
    
    private let weatherService = WeatherAdapter()
    private var weathers: [Weather] = []
    private let factory = WeatherViewModelFactory()
    private var viewModels: [WeatherViewModel] = []
    
    private var selectedDay: Day?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherService.getWeathers(inCity: cityName) { [weak self] weathers in
            guard let self = self else { return }
            self.viewModels = self.factory.constructViewModels(from: weathers)
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Actions

    @IBAction func didSelectDay(_ sender: WeekDayPicker) {
        self.selectedDay = sender.selectedDay
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}
