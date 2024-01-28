//
//  AppDatePicker.swift
//
//  Created by ahmed hussien on 31/10/2022.
//

import SwiftUI

struct AppDatePicker: View {
    
    @Binding var data: DatePickerData
    let style: DatePickerStyle
    let placeholderText: String
    let displayedComponents: DatePicker<Text>.Components
    let closedRange: ClosedRange<Date>?
    let partialRangeFrom: PartialRangeFrom<Date>?
    let partialRangeThrough: PartialRangeThrough<Date>?
    
    @State private var isShowingCalendar: Bool = false
    
    //MARK: Intializers
    init(data: Binding<DatePickerData>, style: DatePickerStyle = .default, placeholderText: String, displayedComponents: DatePicker<Text>.Components = [.date]) {
        self._data = data
        self.style = style
        self.placeholderText = placeholderText
        self.displayedComponents = displayedComponents
        self.closedRange = nil
        self.partialRangeFrom = nil
        self.partialRangeThrough = nil
    }
    
    init(data: Binding<DatePickerData>, style: DatePickerStyle = .default, placeholderText: String, displayedComponents: DatePicker<Text>.Components = [.date], dateRange: ClosedRange<Date>?) {
        self._data = data
        self.style = style
        self.placeholderText = placeholderText
        self.displayedComponents = displayedComponents
        self.closedRange = dateRange
        self.partialRangeFrom = nil
        self.partialRangeThrough = nil
    }
    
    init(data: Binding<DatePickerData>, style: DatePickerStyle = .default, placeholderText: String, displayedComponents: DatePicker<Text>.Components = [.date], dateRange: PartialRangeFrom<Date>?) {
        self._data = data
        self.style = style
        self.placeholderText = placeholderText
        self.displayedComponents = displayedComponents
        self.closedRange = nil
        self.partialRangeFrom = dateRange
        self.partialRangeThrough = nil
    }
    
    init(data: Binding<DatePickerData>, style: DatePickerStyle = .default, placeholderText: String, displayedComponents: DatePicker<Text>.Components = [.date], dateRange: PartialRangeThrough<Date>?) {
        self._data = data
        self.style = style
        self.placeholderText = placeholderText
        self.displayedComponents = displayedComponents
        self.closedRange = nil
        self.partialRangeFrom = nil
        self.partialRangeThrough = dateRange
    }
    // Getter Attributes
    private var styleConfig: PickerStyleConfig {
        get {
            style.styleConfig
        }
    }
    
    private var isDisabled: Bool {
        get {
            data.state == .disabled
        }
    }
    
    //MARK: Body
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            
            HStack {
                Text(data.date?.toString() ?? placeholderText)
                    .lineLimit(2)
                
                Spacer()
                
                Image("calendarIcon")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withoutAnimation {
                    isShowingCalendar = true
                }
            }
            .foregroundColor(foregroundColor(isPlaceholder: data.date == nil))
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(backgroundView)
            
            /// Bottom Label
            bottomLabel
        }
        .disabled(isDisabled)
        .fullScreenCover(isPresented: $isShowingCalendar) {
            presentableCalendarView
        }
        
    }
    
    
    //MARK: Background View
    @ViewBuilder private var backgroundView: some View {
        
        switch styleConfig.cornerStyle {
        case .ellipse:
            Capsule()
                .strokeBorder(borderColor, lineWidth: styleConfig.borderWidth)
                .background(Capsule().fill(backgroundColor))
            
        case .cornerRadius(radius: let radius):
            RoundedRectangle(cornerRadius: radius)
                .strokeBorder(borderColor, lineWidth: styleConfig.borderWidth)
                .background(RoundedRectangle(cornerRadius: radius).fill(backgroundColor))
            
        case .rectangle:
            Rectangle()
                .strokeBorder(borderColor, lineWidth: styleConfig.borderWidth)
                .background(Rectangle().fill(backgroundColor))
        }
    }
    
    //MARK: Bottom Label
    @ViewBuilder private var bottomLabel: some View {
        switch data.state {
        case .normal, .disabled:
            EmptyView()

        case .error(let labelText):
            if let text = labelText {
                bottomLabelText(text)
            }
        }
    }
    
    private func bottomLabelText(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .foregroundColor(bottomLabelColor)
    }
    
    //MARK: Colors
    private func foregroundColor(isPlaceholder: Bool) -> Color {
        switch data.state {
        case .normal, .error:
            return isPlaceholder ? styleConfig.placeholderColor : styleConfig.selectionColor
        case .disabled:
            return styleConfig.disabledForegroundColor
        }
    }
    
    private var borderColor: Color {
        switch data.state {
        case .normal:
            return styleConfig.borderColor
        case .error:
            return styleConfig.errorBorderColor
        case .disabled:
            return styleConfig.disabledBorderColor
        }
    }
    
    private var bottomLabelColor: Color {
        switch data.state {
        case .normal:
            return styleConfig.bottomLabelColor
        case .error:
            return styleConfig.bottomLabelErrorColor
        case .disabled:
            return styleConfig.disabledForegroundColor
        }
    }
    
    private var backgroundColor: Color {
        switch data.state {
        case .normal:
            return styleConfig.backgroundColor
        case .disabled:
            return styleConfig.disabledBackgroundColor
        case .error:
            return styleConfig.errorBackgroundColor
        }
    }
    
    
    //MARK: Action
    private func dismissAction() {
        withoutAnimation {
            isShowingCalendar = false
        }
    }
    
}

//MARK: Calendar View
extension AppDatePicker {
    private var presentableCalendarView: some View {
        ZStack {
            Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    dismissAction()
                }
            
            datePickerView
        }
        .background(TransparentBackground())
    }
    
    private var datePickerView: some View {
        VStack(spacing: 16) {
            
            HStack {
                Spacer()
                
                Button(action: dismissAction) {
                    Image(systemName: "xmark")
                }
                .font(.title3)
                .foregroundColor(.gray)
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            
            configuredDatePicker
                .datePickerStyle(.graphical)
                .environment(\.locale, Language.english.locale)
                .accentColor(Color.theme.primary)
                .padding(.horizontal)
            
            
            AppButton(state: .constant(.normal), style: .stroke(), action: dismissAction) {
                Text("OK")
                    .appFont(.title3)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.theme.bgWhite)
                .shadow(radius: 10)
        )
        .frame(maxWidth: 400)
        .padding()
    }
    
    @ViewBuilder private var configuredDatePicker: some View {
        if let range = closedRange {
            
            DatePicker("", selection: Binding<Date>(get: { data.date ?? Date() }, set: { data.date = $0 }), in: range, displayedComponents: displayedComponents)
            
        } else if let range = partialRangeFrom {
            
            DatePicker("", selection: Binding<Date>(get: { data.date ?? Date() }, set: { data.date = $0 }), in: range, displayedComponents: displayedComponents)
            
        } else if let range = partialRangeThrough {
            
            DatePicker("", selection: Binding<Date>(get: { data.date ?? Date() }, set: { data.date = $0 }), in: range, displayedComponents: displayedComponents)
            
        } else {
            
            DatePicker("", selection: Binding<Date>(get: { data.date ?? Date() }, set: { data.date = $0 }), displayedComponents: displayedComponents)
        }
    }
    
}

struct AppDatePicker_Previews: PreviewProvider {
    
    @State static var normalDatePickerData = DatePickerData(date: Date.now, state: .normal)
    @State static var errorDatePickerData = DatePickerData(date: Date.now, state: .error(labelText: "Please enter a date"))
    @State static var disabledDatePickerData = DatePickerData(date: Date.now, state: .disabled)
    
    static var previews: some View {
        VStack(spacing: 20) {
            AppDatePicker(data: $normalDatePickerData, placeholderText: "Please select a date")
            AppDatePicker(data: $errorDatePickerData, placeholderText: "Please select a date")
            AppDatePicker(data: $disabledDatePickerData, placeholderText: "Please select a date")
        }
        .padding()
    }
}
