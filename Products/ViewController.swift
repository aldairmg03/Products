//
//  ViewController.swift
//  Products
//
//  Created by Aldair Martínez on 24/11/22.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private var items: [Items] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.autocapitalizationType = .none
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    private lazy var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .lightGray
        indicator.startAnimating()
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        return indicator
    }()
    
    private lazy  var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        return blurEffectView
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    private let viewModelInput = ProductViewModelInput()
    private let viewModel: ProductViewModelProtocol
    private var productRequest = ProductRequest(query: "computer", page: 1)
    
    init() {
        viewModel = ProductViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        fetchProducts(productRequest: productRequest)
    }
    
    private func bind() {
        let output = viewModel.bind(input: viewModelInput)
        
        output.showLoadingPublisher.sink { [weak self] in
            self?.displayLoading()
        }.store(in: &subscriptions)

        output.dismissLoadingPublisher.sink { [weak self] in
            self?.dismissLoading()
        }.store(in: &subscriptions)
        
        output.itemsPublisher.sink {[weak self] items in
            self?.loadData(items: items)
        }.store(in: &subscriptions)
    }


    func fetchProducts(productRequest: ProductRequest) {
        viewModelInput.fetchProductPublisher.send(productRequest)
    }
    
}

private extension ViewController {
    
    func setup() {
        view.backgroundColor = .systemBackground
        title = "Products"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        
        loadingActivityIndicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        view.addSubview(loadingActivityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func displayLoading() {
        loadingActivityIndicator.isHidden = false
    }
    
    func dismissLoading() {
        loadingActivityIndicator.isHidden = true
    }
    
    func loadData(items: [Items]) {
        if productRequest.page == 1 {
            self.items = items
        } else {
            self.items.append(contentsOf: items)
        }
        self.tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productCell: ProductCell = tableView.dequeueReusableCell(for: indexPath)
        productCell.configure(item: items[indexPath.row])
        return productCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == items.count {
            productRequest.page += 1
            fetchProducts(productRequest: productRequest)
        }
    }
    
}


extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        productRequest.page = 1
        productRequest.query = query
        fetchProducts(productRequest: productRequest)
    }
    
}
