//
//  NavigationController.swift
//  Notes
//
//  Created by Guillaume Bellut on 07/10/2020.
//

import SwiftUI

struct NavigationController: UIViewControllerRepresentable {
    
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationController>) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ viewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationController>) {
        if let navigationController = viewController.navigationController {
            self.configure(navigationController)
        }
    }
}
