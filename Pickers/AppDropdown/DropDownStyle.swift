//
//  DropDownStyle.swift
//
//  Created by ahmed hussien on 13/10/2022.
//

import Foundation
import SwiftUI

enum DropDownStyle {
    case `default`
    case transparent
    case custom(config: PickerStyleConfig)
}

extension DropDownStyle {
    var styleConfig: PickerStyleConfig {
        switch self {
        case .default:
            
            return PickerStyleConfig(selectionColor: .theme.txtInput, placeholderColor: .theme.txtBlack, backgroundColor: .theme.bgDropdown, errorBackgroundColor: .theme.bgError, cornerStyle: .ellipse, borderColor: .clear, borderWidth: 1, disabledForegroundColor: .theme.txtDisabled, disabledBackgroundColor: .theme.bgDisabled, disabledBorderColor: .clear)
            
        case .custom(let config):
            return config
        case .transparent:
            return PickerStyleConfig(selectionColor: .white, placeholderColor:  .white, backgroundColor: .clear, errorBackgroundColor: .theme.bgError, cornerStyle: .ellipse, borderColor: .clear, borderWidth: 1, disabledForegroundColor: .theme.txtDisabled, disabledBackgroundColor: .theme.bgDisabled, disabledBorderColor: .clear)
        }
    }
}
