//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/06.
//

import Foundation
import SwiftUI

struct UICalendarViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = selection
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate {
        private let parent: UICalendarViewRepresentable
        
        init(_ parent: UICalendarViewRepresentable) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        }
    }
}
