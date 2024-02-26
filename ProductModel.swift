//
//  ProductModel.swift
//  E-Buy (iOS)
//
//  Created by MacBook on 2/26/24.
//
import Foundation

class Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let image: String
    let category: String
    private(set) var quantity: Int // Making quantity private(set) allows it to be set within the same file but read from any scope

    init(id: Int, title: String, price: Double, description: String, image: String, category: String, quantity: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.image = image
        self.category = category
        self.quantity = quantity
    }
}

