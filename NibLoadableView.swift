//
//  NibLoadableView.swift
//  Products
//
//  Created by Aldair Martínez on 24/11/22.
//

import UIKit

@available(*, deprecated, message: "The usage of xibs is deprecated and will be rejected in new MRs, please create your views by code")
public protocol NibLoadableView: AnyObject {
    /// Represents the class name of a xib file
    static var nibName: String { get }
}

public extension NibLoadableView where Self: UIView {
    /// Set the nib name to be equal to the class name
    static var nibName: String {
        return String(describing: self)
    }
}

public extension NibLoadableView where Self: UIViewController {
    /// Set the nib name to be equal to the class name
    static var nibName: String {
        return String(describing: self)
    }
}
