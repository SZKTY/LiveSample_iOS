//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/06.
//

import Foundation
import SwiftUI

public struct WheelTimePickerView: UIViewRepresentable {
    @Binding private var selection: Date

    public init(selection: Binding<Date>) {
        self._selection = selection
    }

    public func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker(frame: .zero)

        picker.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        picker.minuteInterval = 5
        picker.minimumDate = .init()

        picker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)

        return picker
    }

    public func updateUIView(_ uiDatePicker: UIDatePicker, context: Context) {
        uiDatePicker.date = selection
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    public class Coordinator: NSObject {
        public var wheelTimePickerView: WheelTimePickerView

        public init(_ wheelTimePickerView: WheelTimePickerView) {
            self.wheelTimePickerView = wheelTimePickerView
        }

        @objc public func changed(_ sender: UIDatePicker) {
            self.wheelTimePickerView.selection = sender.date
        }
    }
}
