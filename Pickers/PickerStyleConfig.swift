//
//  PickerStyleConfig.swift
//
//  Created by ahmed hussien on 13/10/2022.
//

import Foundation
import SwiftUI

struct PickerStyleConfig {
    public var selectionColor: Color
    public var placeholderColor: Color
    
    public var backgroundColor: Color
    public var errorBackgroundColor: Color
    
    public var cornerStyle: CornerStyle
    
    // Bottom Label
    public var bottomLabelColor: Color = .theme.txtBlack
    public var bottomLabelErrorColor: Color = .theme.error
    
    // Border Style
    public var borderColor: Color
    public var errorBorderColor: Color = .theme.error
    public var borderWidth: CGFloat
    
    // Disable Style
    public var disabledForegroundColor: Color
    public var disabledBackgroundColor: Color
    public var disabledBorderColor: Color
}
