//
//  ViewController.swift
//  SpaceX-APP
//
//  Created by MacBook Air on 20.12.2021.
//

import UIKit
class SpaceX: UIViewController{
    private var spaceXViewModel : SpaceXListViewModel?

    @IBOutlet weak var tableView: UITableView!
    var data = Data()
    
    var response : [filteredStruct]? = []
    var filteredData : [filteredStruct]? = []
    var searchBarArrayLaunchYear = [String]()
    
    let webservice = WebService()
    var searchBar : UISearchBar?
    var searchBarController = 0
    var searchBarTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Filter Off", style: UIBarButtonItem.Style.done, target: self, action: #selector(filtered))
        let keyboardGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        keyboardGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(keyboardGestureRecognizer)
        searchBarSetup()
    }
    
    @objc func filtered(){
        if searchBarController == 0 {
            navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "Filter On"
            searchBar?.isHidden = true
            searchBarController += 1
      
            
        } else if searchBarController == 1{
            navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "Filter Off"
            searchBar?.isHidden = false
            searchBarController -= 1
         
        }
        
    }
    
    func searchBarSetup(){
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        searchBar?.showsScopeBar = true
        searchBar?.scopeButtonTitles = ["Filter By Launch Year"]
        searchBar?.delegate = self
        self.tableView.tableHeaderView = searchBar
    }

    func getData() {
            WebService().downloadSpaceX(path: App.listPath) { (rockets) in
                if let rockets = rockets {
                    self.spaceXViewModel = SpaceXListViewModel(SpaceX: rockets)
                    
                    DispatchQueue.main.async {
                        if let SpaceXViewModel = self.spaceXViewModel {
                            for result in 0..<SpaceXViewModel.SpaceX.count{
                                self.searchBarArrayLaunchYear.append(SpaceXViewModel.SpaceX[result].launch_year ?? "")
                                
                                self.response?.append(filteredStruct(flightNumber: SpaceXViewModel.SpaceX[result].flight_number, missionName: SpaceXViewModel.SpaceX[result].mission_name, launchYear: SpaceXViewModel.SpaceX[result].launch_year, missionPatch: SpaceXViewModel.SpaceX[result].links.mission_patch, missionPatchSmall: SpaceXViewModel.SpaceX[result].links.mission_patch_small, rocketName: SpaceXViewModel.SpaceX[result].rocket.rocket_name, rocketType: SpaceXViewModel.SpaceX[result].rocket.rocket_type, test: 0))
                            }
                            self.filteredData = self.response
                            
                        }
                        self.tableView.reloadData()
                    }
                }
            }
    
    }
    
}
// MARK: - UITableViewDelegates and UITableViewDataSource

extension SpaceX : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCell
                
        if let flightNumber = filteredData?[indexPath.row].flightNumber{
                    cell.FlightNumberLabel.text = "Flight Number: \(flightNumber)"
                }
                    
        if let missionName = filteredData?[indexPath.row].missionName {
                    cell.MissionNameLabel.text = "Mission Name: \(missionName)"
                }
                
        if let launchYear = filteredData?[indexPath.row].launchYear {
                    cell.LaunchYearLabel.text = "Launch Year: \(launchYear)"
                }
            
        if let imageUrl = filteredData?[indexPath.row].missionPatchSmall {
                    if let urlString = URL(string: imageUrl){
                        DispatchQueue.global().async {
                            do {
                                self.data = try Data(contentsOf: urlString)
                                DispatchQueue.main.async {
                                    cell.MissionPatchImageView.image = UIImage(data: self.data)
                                }
                            } catch{
                                print("errorGetImage")
                            }
                        }
                    }
                }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        detailVC.detailData = self.filteredData?[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
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
    

}

//MARK: - UISearchBarDelegate
extension SpaceX: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = response
        } else {
            for counter in 0..<response!.count{
                for result in searchBarArrayLaunchYear {
                    if result.lowercased().contains(searchText.lowercased()){
                            if response?[counter].launchYear == result {
                                filteredData?.append(response![counter])
                                break
                            }
                        }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

