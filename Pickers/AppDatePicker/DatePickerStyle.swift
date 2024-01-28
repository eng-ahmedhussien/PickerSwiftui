//
//  DatePickerStyle.swift
//
//  Created by ahmed hussien on 06/11/2022.
//

import Foundation

enum DatePickerStyle {
    case `default`
    case custom(config: PickerStyleConfig)
}


extension DatePickerStyle {
    var styleConfig: PickerStyleConfig {
        switch self {
        case .default:
            
            return PickerStyleConfig(selectionColor: .theme.txtInput, placeholderColor: .theme.txtPlaceholder, backgroundColor: .theme.bgInput, errorBackgroundColor: .theme.bgError, cornerStyle: .ellipse, borderColor: .clear, borderWidth: 1, disabledForegroundColor: .theme.txtDisabled, disabledBackgroundColor: .theme.bgDisabled, disabledBorderColor: .clear)
            
        case .custom(let config):
            return config
        }
    }
}
