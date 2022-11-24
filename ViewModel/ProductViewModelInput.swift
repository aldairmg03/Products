//
//  ProductViewModelInput.swift
//  Products
//
//  Created by Aldair Martínez on 24/11/22.
//

import Foundation
import Combine

struct ProductViewModelInput {
    let fetchProductPublisher = PassthroughSubject<ProductRequest, Never>()
}
