//
//  AppDropDownPicker.swift
//
//  Created by ahmed hussien on 12/10/2022.
//

import SwiftUI

struct AppDropDownPicker<T: SelectionProtocol>: View {
    
    @Binding var data: DropDownData<T>
    let style: DropDownStyle
    let placeholderText: String
    let hasSpacer:Bool
    
    init(data: Binding<DropDownData<T>>, style: DropDownStyle = .default, placeholderText: String,hasSpacer:Bool = true) {
        self._data = data
        self.style = style
        self.placeholderText = placeholderText
        self.hasSpacer = hasSpacer
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Menu {
                Picker(placeholderText, selection: $data.selection) {
                    ForEach(data.dataArray, id: \.self) { item in
                        HStack {
                            if let imageType = item.imageType, let imageName = item.imageName {
                                imageView(imageType: imageType, imageName: imageName)
                            }
                            
                            Text(item.name ?? "")
                        }
                        .tag(item as T?)
                    }
                }
                .labelsHidden()
                .pickerStyle(InlinePickerStyle())
            } label: {
                HStack {
                    HStack {
                        if let imageType = data.selection?.imageType, let imageName = data.selection?.imageName {
                            imageView(imageType: imageType, imageName: imageName)
                        }
                        Text(data.selection?.name ?? placeholderText)
                            .lineLimit(2)
                    }
                   if hasSpacer {
                        Spacer()
                    }
                    
                    Image(systemName: "chevron.down")
                }
                .foregroundColor(foregroundColor(isPlaceholder: data.selection == nil))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(backgroundView)
            .disabled(isDisabled)
            
            /// Bottom Label
            bottomLabel
        }
        .onChange(of: data.selection, perform: validate)
        
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
    
    //MARK: Validation
    func validate(_ selection: T?) {
        if selection == nil {
            data.state = .error(labelText: "Please select an option")
            data.isValid = false
        } else {
            data.state = .normal
            data.isValid = true
        }
    }
    
    //MARK: Image
    @ViewBuilder private func imageView(imageType: DropDownImageType, imageName: String) -> some View {
        switch imageType {
        case .systemImage:
            Image(systemName: imageName)
            
        case .assetImage:
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
    
}

struct AppDropDownPicker_Previews: PreviewProvider {
    @State static var normalDropDownData = DropDownData(dataArray: [
        TestSelectionModel(id: "1", name: "One"),
        TestSelectionModel(id: "2", name: "Two"),
        TestSelectionModel(id: "3", name: "Three"),
        TestSelectionModel(id: "4", name: "Four"),
    ], state: .normal
    )
    
    @State static var errorDropDownData =
    DropDownData(dataArray: [
        TestSelectionModel(id: "1", name: "One"),
        TestSelectionModel(id: "2", name: "Two"),
        TestSelectionModel(id: "3", name: "Three"),
        TestSelectionModel(id: "4", name: "Four"),
    ], state: .error(labelText: "Error Message")
    )
    
    @State static var disableDropDownData =
    DropDownData(dataArray: [
        TestSelectionModel(id: "1", name: "One"),
        TestSelectionModel(id: "2", name: "Two"),
        TestSelectionModel(id: "3", name: "Three"),
        TestSelectionModel(id: "4", name: "Four"),
    ], state: .disabled
    )
    
    static var previews: some View {
        VStack(spacing: 20) {
            AppDropDownPicker(data: $normalDropDownData, style: .default, placeholderText: "Placeholder")
            
            AppDropDownPicker(data: $errorDropDownData, style: .default, placeholderText: "Placeholder")
            
            AppDropDownPicker(data: $disableDropDownData, style: .default, placeholderText: "Placeholder")
        }
        .padding()
    }
    
    struct TestSelectionModel: SelectionProtocol {
        var id: String?
        var name: String?
    }
}
