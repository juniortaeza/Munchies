//
//  RestaurantsModel.swift
//  munchies
//
//  Created by junior taeza on 12/3/22.
//

import Foundation

class RestaurantsModel {
    public static let shared = RestaurantsModel()
    let BASE_URL = "https://api.spoonacular.com/food/restaurants/search"
    let API_KEY = "c216dd0932e5474db8ddebf9962b4ba6"
    let CUISINES : [String] = ["African", "American", "British", "Cajun", "Caribbean", "Chinese", "Eastern European", "European", "French", "Greek", "Indian", "Irish", "Italian", "Japanese", "Jewish", "Korean", "Latin American", "Mediterranean",  "Mexican", "Middle Eastern", "Nordic", "Southern", "Spanish", "Thai", "Vietnamese"
    ]
    
    var RESTAURANTS = Restaurants(restaurants: [Restaurant]())
    var RESTAURANT_ARRAY : [Restaurant] = []
    
    func getRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        let PAGE = 1
        let DISTANCE = User.user.distance
        let CUISINE = User.user.selection.lowercased()
        let BUDGET = User.user.budget
        let LAT = User.user.latitude
        let LNG = User.user.longitude
                
        guard let url = URL(string: "\(BASE_URL)?apiKey=\(API_KEY)&lat=\(LAT)&lng=\(LNG)&page=\(PAGE)&cuisine=\(CUISINE)&distance=\(DISTANCE)&budget=\(BUDGET)&is-open=false") else {
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do{
                let decoder = JSONDecoder()
                self.RESTAURANTS = try decoder.decode(Restaurants.self, from: data!)
                if self.RESTAURANTS.restaurants != nil {
                    for res in self.RESTAURANTS.restaurants! {
                        self.RESTAURANT_ARRAY.append(res)
                    }
                    completion(self.RESTAURANT_ARRAY)
                }
            } catch {
                print(error.localizedDescription)
                exit(1)
            }
        }
        task.resume()
    }
}
