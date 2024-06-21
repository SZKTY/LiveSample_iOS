//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/06/08.
//

import SwiftUI
import Assets

public struct SuccessToastBanner: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundColor(Color.mainBaseColor)
                    
                    VStack(alignment: .leading) {
                        Text("投稿完了")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(Color.mainBaseColor)
                    }
                }
                .padding(.all, 10)
                .background(Color.mainSubColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
            }
        }
        .padding(.top, 50)
    }
}
