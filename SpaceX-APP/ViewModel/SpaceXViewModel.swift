//
//  SpaceXViewModel.swift
//  SpaceX-APP
//
//  Created by MacBook Air on 21.12.2021.
//

import Foundation

struct SpaceXListViewModel {
    var SpaceX : [spaceXList]
    
    func numberOfRowsInSection() -> Int {
        return self.SpaceX.count
    }
    func rocketAddIndex(_ index:Int) -> SpaceXViewModel{
        let flightNumber = self.SpaceX[index].flight_number
        let missionName = self.SpaceX[index].mission_name
        let launchYear = self.SpaceX[index].launch_year
        let rocketDetail = self.SpaceX[index].rocket
        let rocketLinks = self.SpaceX[index].links
    
        return SpaceXViewModel(SpaceX: spaceXList(rocket: rocketDetail, links: rocketLinks, flight_number: flightNumber, mission_name: missionName, launch_year: launchYear))
    }
}

struct SpaceXViewModel {
    let SpaceX : spaceXList
    
    var flight_number : Int? {
        return self.SpaceX.flight_number
    }
    var mission_name : String? {
        return self.SpaceX.mission_name
    }
    var launch_year : String? {
        return self.SpaceX.launch_year
    }
    var rocket_name : String? {
        return self.SpaceX.rocket.rocket_name
    }
    var rocket_type : String? {
        return self.SpaceX.rocket.rocket_type
    }
    var mission_patch : String? {
        return self.SpaceX.links.mission_patch
    }
    var mission_patch_small: String? {
        return self.SpaceX.links.mission_patch_small
    }
    
}
