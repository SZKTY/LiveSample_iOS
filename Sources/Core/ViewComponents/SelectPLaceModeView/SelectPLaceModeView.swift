//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/06.
//

import Foundation
import SwiftUI
import Assets

public struct SelectPLaceModeView: View {
    /// safeArea上部のみ無視しており、その分中心がズレるのを補正するPadding
    private let scopeTopPadding: CGFloat
    private let action: () -> ()
    private let cancelAction: () -> ()
    
    public init(scopeTopPadding: CGFloat,
                action: @escaping () -> Void,
                cancelAction: @escaping () -> Void) {
        // ピンの先端とScopeの中心を合わせるため、+20ずらす
        self.scopeTopPadding = scopeTopPadding + 20
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
                            .frame(width: 100, height: 36)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        })
                        
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
                    .foregroundColor(Color.mainBaseColor)
                    .font(.system(size: 36))
                    .padding(.top, self.scopeTopPadding)
                
                Spacer()
                
                Button(action: {
                    self.action()
                }, label: {
                    Text("確定")
                        .frame(width: 120.0, height: 60.0)
                        .background(Color.mainBaseColor)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .bold()
                        .cornerRadius(6)
                        .padding(.bottom, 42.0)
                })
            }
        }
    }
}

