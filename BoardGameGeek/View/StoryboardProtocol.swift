//
//  StoryboardProtocol.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import Foundation
import UIKit

protocol StoryboardProtocol { }

extension StoryboardProtocol where Self: UIViewController {

    static func instantiateFromStoryboard(storyboardName: String) -> Self {
        let storyboardIdentifier = String(describing: self)

        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)

        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No storyboard with this identifier ")
        }
        return viewController
    }

}

extension UIViewController: StoryboardProtocol {}

extension StoryboardProtocol where Self: ViewModelProtocol {

  static func instantiate(storyboardName: String, viewModel: ViewModel) -> Self {
      let storyboardIdentifier = String(describing: self)
      let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)

      guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
          fatalError("No storyboard with this identifier ")
      }
      viewController.viewModel = viewModel
      return viewController
  }

}
