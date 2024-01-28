//
//  DatePickerData.swift
//
//  Created by ahmed hussien on 31/10/2022.
//

import Foundation
import SwiftUI

struct DatePickerData {
    var date: Date?
    var isValid: Bool = false
    var state: PickerState = .normal
}
