//
//  ProductViewModelProtocol.swift
//  Products
//
//  Created by Aldair Martínez on 24/11/22.
//

import Foundation

protocol ProductViewModelProtocol: AnyObject {
    var output: ProductViewModelOutput { get }
    func bind(input: ProductViewModelInput) -> ProductViewModelOutput
}
