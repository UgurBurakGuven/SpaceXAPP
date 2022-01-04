//
//  DetailsVC.swift
//  SpaceX-APP
//
//  Created by MacBook Air on 22.12.2021.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var missionPatchImageView: UIImageView!
    @IBOutlet weak var detailsBackgroundImageView: UIImageView!
    @IBOutlet weak var rocketNameLabel: UILabel!
    @IBOutlet weak var rocketTypeLabel: UILabel!
    
    
    var data = Data()
    var selectedImageUrlString : String?
    var selectedNameLabel : String?
    var selectedTypeLabel : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    func getData(){
        if let selectedImageUrlString = selectedImageUrlString {
            if let urlString = URL(string: selectedImageUrlString){
                DispatchQueue.global().async {
                    do {
                        self.data = try Data(contentsOf: urlString)
                        DispatchQueue.main.async {
                            self.missionPatchImageView.image = UIImage(data: self.data)
                        }
                    } catch{
                        print("ErrorDetailsImage")
                    }
                }
            }
          
        }
        if let selectedNameLabel = selectedNameLabel {
            rocketNameLabel.text = "Rocket Name: \(selectedNameLabel)"
            if let selectedTypeLabel = selectedTypeLabel {
                rocketTypeLabel.text = "Rocket Type: \(selectedTypeLabel)"
            }
        }
    }

  
}
