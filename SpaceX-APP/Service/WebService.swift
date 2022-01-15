//
//  WebService.swift
//  SpaceX-APP
//
//  Created by MacBook Air on 21.12.2021.
//

import Foundation

class WebService {
   
    func downloadSpaceX(path: String, completion: @escaping([spaceXList]?) -> () ){
        guard let apiURL = URL(string: App.baseURL + path) else { return }
        URLSession.shared.dataTask(with: apiURL) { data, response, error  in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let SpaceXList = try? JSONDecoder().decode([spaceXList].self, from: data)
                if let SpaceXList = SpaceXList {
                    completion(SpaceXList)
                } else {
                    print("ErrorDownloadSpaceXData")
                }
            }
        }.resume()
    }
}
