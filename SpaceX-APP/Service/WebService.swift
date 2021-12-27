//
//  WebService.swift
//  SpaceX-APP
//
//  Created by MacBook Air on 21.12.2021.
//

import Foundation

class WebService {
    /*
    func downloadSpaceXAsync(url: URL) async throws ->[spaceXList] {
        let (data, _ ) = try await URLSession.shared.data(from: url)
        let SpaceXList = try? JSONDecoder().decode([spaceXList].self, from: data)
        return SpaceXList ?? []
    }
    */
    func downloadSpaceX(url: URL, completion: @escaping([spaceXList]?) -> () ){
        
        URLSession.shared.dataTask(with: url) { data, response, error  in
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
