//
//  UITableView+Extension.swift
//  Products
//
//  Created by Aldair Martínez on 24/11/22.
//

import UIKit

public extension UITableView {
    // MARK: - UITableViewCell
    /// Registers a cell that conforms the ReusableView and NibLoadableView protocols
    /// - Parameter _: Class of the cell to be registered
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    /// Register a cell that conforms the ReusableView protocol
    /// - Parameter _: Class of  the cell to be registered
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    /// Dequeue a cell that conforms the ReusableView protocol
    /// - Parameter indexPath: indexPath of the cell
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    // MARK: - UITableViewHeaderFooterView
    /// Registers a header of footer that conforms the ReusableView and NibLoadableView protocols
    /// - Parameter _: Class of the header or footer to be registered
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    /// Register a header of footer that conforms the ReusableView protocol
    /// - Parameter _: Class of the header of footer to be registered
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    /// Dequeue a header or footer that conforms the ReusableView protocol
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: ReusableView {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue header of footer with identifier: \(T.reuseIdentifier)")
        }
        return header
    }
    
}
