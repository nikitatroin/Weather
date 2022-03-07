//
//  MyCityesController.swift
//  Weather
//
//  Created by Евгений Елчев on 20.09.17.
//  Copyright © 2017 JonFir. All rights reserved.
//

import UIKit
import RealmSwift

final class MyCityesController: UITableViewController {
    
    private var cities: Results<RLMCity>?
    private var token: NotificationToken?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        pairTableAndRealm()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherViewController", let cell = sender as? UITableViewCell {
            let ctrl = segue.destination as! WeatherViewController
            if let indexPath = tableView.indexPath(for: cell),
                let cityName = cities?[indexPath.row].name  {
                ctrl.cityName = cityName
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        showAddCityForm()
    }
    
    // MARK: - Private
    
    private func configureUI() {
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.tintColor = .brandOrange
        self.navigationController?.navigationBar.backgroundColor = .brandWhite
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        cities = realm.objects(RLMCity.self)
        token = cities?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    private func showAddCityForm() {
        let alertController = UIAlertController(title: "Введите город", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let confirmAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] action in
            guard let name = alertController.textFields?[0].text else { return }
            self?.addCity(name: name)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func addCity(name: String) {
        let newCity = RLMCity()
        newCity.name = name
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(newCity, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    private func deleteCity(at indexPath: IndexPath) {
        guard let city = cities?[indexPath.row] else { return }
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(city.weathers)
            realm.delete(city)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCityesCell", for: indexPath)
        guard let city = cities?[indexPath.row] else {
            cell.textLabel?.text = nil
            return cell
        }
        cell.textLabel?.text = city.name
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.deleteCity(at: indexPath)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "toWeatherViewController", sender: cell)
    }
}
