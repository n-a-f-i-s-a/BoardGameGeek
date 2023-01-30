//
//  viewModelProtocol.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 30/1/2023.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
  associatedtype ViewModel

  var viewModel: ViewModel! { get set }
}
