//
//  Recipe.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 10/12/2020.
//

import XMLMapper

class Recipe: XMLMappable {
    var nodeName: String!
    
    var id: String?
    var imageUrl: String?
    var imageData: NSData?
    var name: String?
    var ingredients: [String]?
    var steps: [String]?
    var type: String?
    
    required init(map: XMLMap) {

    }

    func mapping(map: XMLMap) {
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        imageData <- map["imageData"]
        name <- map["name"]
        ingredients <- map["ingredients"]
        steps <- map["steps"]
        type <- map["type"]
    }
}
