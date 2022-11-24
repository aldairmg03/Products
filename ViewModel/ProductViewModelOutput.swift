//
//  ProductViewModelOutput.swift
//  Products
//
//  Created by Aldair Martínez on 24/11/22.
//

import Foundation
import Combine

struct ProductViewModelOutput {
    let showLoadingPublisher = PassthroughSubject<Void, Never>()
    let dismissLoadingPublisher = PassthroughSubject<Void, Never>()
    let itemsPublisher = PassthroughSubject<[Items], Never>()
}
