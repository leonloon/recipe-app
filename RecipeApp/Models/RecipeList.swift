//
//  RecipeList.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 12/12/2020.
//

import XMLMapper

class RecipeList: XMLMappable {
    var nodeName: String!
    
    var name: String?
    var recipes: [Recipe]?
    
    required init(map: XMLMap) {

    }

    func mapping(map: XMLMap) {
        name <- map["name"]
        recipes <- map["recipes"]
    }
}
