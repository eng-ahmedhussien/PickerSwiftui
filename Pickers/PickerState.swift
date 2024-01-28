//
//  PickerState.swift
//
//  Created by ahmed hussien on 13/10/2022.
//

import Foundation

enum PickerState {
    case normal
    case disabled
    case error(labelText: String?)
}

extension PickerState: Equatable {
    
}
