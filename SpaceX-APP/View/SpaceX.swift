//
//  ViewController.swift
//  SpaceX-APP
//
//  Created by MacBook Air on 20.12.2021.
//

import UIKit
class SpaceX: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private var spaceXViewModel : SpaceXListViewModel?
   

    @IBOutlet weak var TableView: UITableView!
    var data = Data()
    var flightNumberArray = [Int]()
    var imageUrlArray = [URL]()
    var rocketNameArray = [String]()
    var rocketTypeArray = [String]()
    var chosenRocketName : String?
    var chosenRocketType : String?
    var chosenImageUrl : URL?
    
    var searchBarArrayLaunchYear = [String]()
    var searchBarArrayFlightNumber = [Int]()
    var searchBarArrayMissionName = [String]()
    var searchBarArrayMissionPatch = [String]()
    var searchBarArrayMissionPatchSmall = [String]()
    var searchBarArrayRocketName = [String]()
    var searchBarArrayRocketType = [String]()
    var searchBarModel : [SpaceXViewModel]?
    
    var filteredData : [String]?
    var index = 0
    let webservice = WebService()
    var searchBar : UISearchBar?
    var searchBarController = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        TableView.delegate = self
        TableView.dataSource = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItem.Style.done, target: self, action: #selector(filtered))
        let keyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(keyboardGestureRecognizer)
        searchBarSetup()
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    @objc func filtered(){
        if searchBarController == 0 {
            searchBar?.isHidden = true
            searchBarController += 1
        } else if searchBarController == 1{
            searchBar?.isHidden = false
            searchBarController -= 1
        }
    }
    func searchBarSetup(){
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        searchBar?.showsScopeBar = true
        searchBar?.scopeButtonTitles = ["year"]
        searchBar?.delegate = self
        self.TableView.tableHeaderView = searchBar
    }

    func getData() {
        if let url = URL(string: "https://api.spacexdata.com/v2/launches"){
            WebService().downloadSpaceX(url: url) { (rockets) in
                if let rockets = rockets {
                    self.spaceXViewModel = SpaceXListViewModel(SpaceX: rockets)
                   // self.spaceXViewModel?.rocketAddIndex(self.spaceXViewModel?.numberOfRowsInSection() ?? 0 )
                    
                    DispatchQueue.main.async {
                        if let SpaceXViewModel = self.spaceXViewModel {
                            for result in 0..<SpaceXViewModel.SpaceX.count{
                                self.searchBarArrayLaunchYear.append(SpaceXViewModel.SpaceX[result].launch_year ?? "")
                                self.searchBarArrayFlightNumber.append(SpaceXViewModel.SpaceX[result].flight_number ?? 0)
                                self.searchBarArrayMissionName.append(SpaceXViewModel.SpaceX[result].mission_name ?? "")
                                self.searchBarArrayMissionPatch.append(SpaceXViewModel.SpaceX[result].links.mission_patch ?? "")
                                self.searchBarArrayMissionPatchSmall.append(SpaceXViewModel.SpaceX[result].links.mission_patch_small ?? "")
                                self.searchBarArrayRocketName.append(SpaceXViewModel.SpaceX[result].rocket.rocket_name ?? "")
                                self.searchBarArrayRocketType.append(SpaceXViewModel.SpaceX[result].rocket.rocket_type ?? "")
                                
                            }
                            self.filteredData = self.searchBarArrayLaunchYear
                            
                        }
                        self.TableView.reloadData()
                    }
                }
            }
        }
    
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return  spaceXViewModel?.numberOfRowsInSection() ?? 0
        return filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCell
        
        let rocketsViewModel = self.spaceXViewModel?.rocketAddIndex(indexPath.row)
        
        
        if rocketsViewModel?.launch_year == filteredData![indexPath.row]{
 
                if let rocketNumber = rocketsViewModel?.flight_number{
                    cell.FlightNumberLabel.text = "Flight Number: \(rocketNumber)"
                }
                
                if let rocketName = rocketsViewModel?.rocket_name {
                    self.rocketNameArray.append(rocketName)
                }
                
                if let rocketType = rocketsViewModel?.rocket_type {
                    self.rocketTypeArray.append(rocketType)
                }
                    
                
                if let missionName = rocketsViewModel?.mission_name {
                    cell.MissionNameLabel.text = "Mission Name: \(missionName)"
                }
                
               
                if let launchYear = rocketsViewModel?.launch_year {
                    cell.LaunchYearLabel.text = "Launch Year: \(launchYear)"
                }
            
                if let imageUrl = rocketsViewModel?.mission_patch_small {
                    if let urlString = URL(string: imageUrl){
                        DispatchQueue.global().async {
                            do {
                                self.data = try Data(contentsOf: urlString)
                                DispatchQueue.main.async {
                                    cell.MissionPatchImageView.image = UIImage(data: self.data)
                                    self.imageUrlArray.append(urlString)
                                }
                            } catch{
                                print("errorGetImage")
                            }
                        }
                    }
                }
            
        }
     
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.selectedImageUrl = chosenImageUrl
            destinationVC.selectedNameLabel = chosenRocketName
            destinationVC.selectedTypeLabel = chosenRocketType
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenImageUrl = self.imageUrlArray[indexPath.row]
        chosenRocketName = self.rocketNameArray[indexPath.row]
        chosenRocketType = self.rocketTypeArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8.0
        
        cell.alpha = 0.5
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = searchBarArrayLaunchYear
        } else {
            for result in searchBarArrayLaunchYear {
                if result.lowercased().contains(searchText.lowercased()) {
                    filteredData?.append(result)
                }
            }
           
        }
        self.TableView.reloadData()
    }


}

