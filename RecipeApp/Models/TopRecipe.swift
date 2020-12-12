//
//  TopRecipe.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 12/12/2020.
//

import ObjectMapper

struct TopRecipe: Mappable {
    var title: String?
    var href: String?
    var ingredients: String?
    var thumbnail: String?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        title <- map["title"]
        href <- map["href"]
        ingredients <- map["ingredients"]
        thumbnail <- map["thumbnail"]
    }
}
