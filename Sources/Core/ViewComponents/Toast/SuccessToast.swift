//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/06/08.
//

import SwiftUI

public struct SuccessToastBanner: View {
    
    private let onAppear: () -> Void
    
    public init(onAppear: @escaping () -> Void) {
        self.onAppear = onAppear
    }
    
    public var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundColor(Color.green)
                    VStack(alignment: .leading) {
                        Text("投稿完了")
                            .font(.custom("RoundedMplus1c-Bold", size: 16))
                            .foregroundColor(Color.black)
                    }
                }
                .padding(.all, 10)
                // PaleGreenっぽいやつ #D0E2BE
                .background(Color(red: 232/255, green: 242/255, blue: 228/255))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
        }
        .padding(.top, 50)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    onAppear()
                }
            }
        }
    }
}
