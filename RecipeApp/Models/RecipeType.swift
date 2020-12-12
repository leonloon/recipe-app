//
//  RecipeType.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 11/12/2020.
//

import XMLMapper

class RecipeType: XMLMappable {
    var nodeName: String!
    
    var data: [RecipeList]?
    
    required init(map: XMLMap) {

    }

    func mapping(map: XMLMap) {
        data <- map["data"]
    }
}
