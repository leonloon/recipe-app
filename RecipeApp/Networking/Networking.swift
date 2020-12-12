//
//  Networking.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 12/12/2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class Networking {
    
    static let shared = Networking()
    typealias params = [String: Any]
    
    func alamofire(_ endpoint: String, method: HTTPMethod, params: params, controller: UIViewController, completion: @escaping (Any) -> Void) {
        
        controller.startLoading()
        
        guard let url = URL(string: "\(host)/\(endpoint)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        AF.request(request).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let value = value as! [String: Any]
                
                print("\n[\(endpoint)] ~~~ ~~~ ~~~ ~~~>\nServer Returned: \(value)\n")
                controller.endLoading()
                
                DispatchQueue.main.async {
                    completion(value["results"] as Any)
                }
                
            case .failure:
                print("--------> Request Failed")
                controller.endLoading()
                return
            }
        }
    }
    
    func getTopRecipe(params: params, controller: UIViewController, completion: @escaping ([TopRecipe]) -> Void) {
        alamofire("api/?i=onions,garlic&q=omelet&p=3", method: .get, params: params, controller: controller) { result in
            
            print("-------> [GET] getTopRecipe: \(result)")
            let topRecipe = Mapper<TopRecipe>().mapArray(JSONObject: result)
            
            DispatchQueue.main.async {
                completion(topRecipe ?? [])
            }
        }
    }
}
