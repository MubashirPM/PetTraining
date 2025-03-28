//
//  SheetView.swift
//  Petapp
//
//  Created by MUNAVAR PM on 25/03/25.
//

import SwiftUI

struct SheetView: View {
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing:40) {
                    Image("ic-likeRound")
                        .resizable()
                        .frame(width: 128,height: 128)
                    Text("Great Job! Workout Completed")
                        .bold()
                        .font(.system(size: 22))
                    NavigationLink(destination: TrainView()){
                        Text("Training")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 5)
                            .padding(.horizontal, 40)
                            .padding(.top, 15)
                            
            
                    }
                }
            }
        }
    }
}

#Preview {
    SheetView()
}
