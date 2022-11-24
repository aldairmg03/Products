//
//  ProductViewModel.swift
//  Products
//
//  Created by Aldair Martínez on 24/11/22.
//

import Foundation
import Combine

final class ProductViewModel: ProductViewModelProtocol {
    
    let output = ProductViewModelOutput()
    private var subscriptions = Set<AnyCancellable>()
    
    func bind(input: ProductViewModelInput) -> ProductViewModelOutput {
        
        input.fetchProductPublisher.sink(receiveValue: { [weak self] productRequest in
            self?.fetchProducts(productRequest: productRequest)
        }).store(in: &subscriptions)
        
        return output
    }
    
    
    func fetchProducts(productRequest: ProductRequest) {
        self.output.showLoadingPublisher.send()
        guard let query = productRequest.query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let url = URL(string: "https://00672285.us-south.apigw.appdomain.cloud/demo-gapsi/search?&query=\(query)&page=\(productRequest.page)")
        APIManager.shared.fetch(url: url!) { [weak self] (result: Result<ProductResponse, Error>) in
            switch result {
            case .success(let result):
                self?.output.itemsPublisher.send(result.item.props.pageProps.initialData.searchResult.itemStacks[0].items)
                self?.output.dismissLoadingPublisher.send()
            case .failure(let error):
                self?.output.dismissLoadingPublisher.send()
            }
        }
    }
}
