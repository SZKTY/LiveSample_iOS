//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/06.
//

import Foundation
import SwiftUI

public struct SelectPLaceModeView: View {
    public let action: () -> ()
    public let cancelAction: () -> ()
    
    public init(action: @escaping () -> Void,
                cancelAction: @escaping () -> Void) {
        self.action = action
        self.cancelAction = cancelAction
    }
    
    public var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            VStack {
                HStack {
                    HStack {
                        Spacer()
                            .frame(width: 2.0)
                        
                        Button(action: {
                            self.cancelAction()
                        }, label: {
                            HStack(spacing: 4.0) {
                                Image(systemName: "xmark")
                                Text("Cancel")
                            }
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        })
                        .frame(width: 100, height: 36)
                        
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text("開催場所を指定")
                        .font(.system(size: 16))
                        .bold()
                        .lineLimit(1)
                        .layoutPriority(1)
                    
                    HStack {
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 44)
                
                Spacer()
                
                Image(systemName: "scope")
                    .foregroundColor(.black)
                    .font(.system(size: 36))
                
                
                Spacer()
                
                Button(action: {
                    self.action()
                }, label: {
                    Text("確定")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .bold()
                })
                .frame(width: 120.0, height: 60.0)
                .background(.black)
                .cornerRadius(6)
                .padding(.bottom, 42.0)
            }
        }
    }
}

