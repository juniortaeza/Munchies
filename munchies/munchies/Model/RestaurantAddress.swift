//
//  RestaurantAddress.swift
//  munchies
//
//  Created by junior taeza on 12/3/22.
//

import Foundation

struct RestaurantAddress : Decodable {
    let street_addr : String?
    let city : String?
    let state : String?
    let zipcode : String?
    let country : String?
    let lat : Double?
    let lon : Double?
}
