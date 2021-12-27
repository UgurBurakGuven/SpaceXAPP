//
//  SpaceXModel.swift
//  SpaceX-APP
//
//  Created by MacBook Air on 21.12.2021.
//

import Foundation

struct spaceXList: Decodable {
    let rocket : (spaceX)
    let links : (spaceXLinks)
    let flight_number : Int?
    let mission_name : String?
    var launch_year : String?
   
}

struct spaceXLinks : Decodable {
    let mission_patch : String?
    let mission_patch_small : String?
}

struct spaceX: Decodable {
    let rocket_name : String?
    let rocket_type : String?
}
