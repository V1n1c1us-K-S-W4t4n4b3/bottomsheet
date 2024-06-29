//
//  ContentView.swift
//  bottomsheet
//
//  Created by Usuario on 29/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var offset: CGFloat = 0
    @State var translation: CGSize = CGSize(width: 0, height: 0)
    @State var location: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Color.purple
            VStack {
                Text("\(translation.width) \(translation.height)")
                Text("\(location.x) \(location.y)")
            }
            .frame(maxHeight: .infinity)
            
            GeometryReader { reader in
                
                BottomSheet()
                    .offset(y: reader.frame(in: .global).height - 60)
                    .offset(y: offset)
                    .gesture(DragGesture().onChanged({ (value) in
                        withAnimation{
                            translation = value.translation
                            location  = value.location
                            
                            if value.startLocation.y > reader.frame(in: .global).midX {
                                if value.translation.height < 0 && offset > (-reader.frame(in: .global).height + 60) {
                                    offset = value.translation.height
                                }
                            }
                            
                            if value.startLocation.y < reader.frame(in: .global).midX {
                                if value.translation.height > 0 && offset < 0 {
                                    offset = (-reader.frame(in: .global).height + 60) +
                                    value.translation.height
                                }
                            }
                        }
                    }).onEnded({ (value) in
                        withAnimation{
                            if value.startLocation.y > reader.frame(in: .global).midX {
                                if -value.translation.height > reader.frame(in: .global).midX {
                                    offset = (-reader.frame(in: .global).height + 60)
                                    return
                                }
                                
                                offset = 0
                            }
                            
                            if value.startLocation.y < reader.frame(in: .global).midX {
                                if value.translation.height < reader.frame(in: .global).midX {
                                    offset = (-reader.frame(in: .global).height + 60)
                                    return
                                }
                                offset = 0
                            }
                        }
                    }))
            }
        }
    }
}

struct BottomSheet: View {
    
    @State var text = ""
    
    var body: some View{
        VStack{
            Capsule()
                .fill(Color(white: 0.95))
                .frame(width: 50, height: 5)
            
            TextField("Pesquisar", text: $text)
                .padding()
            
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack(alignment: .leading) {
                    ForEach(1...30, id: \.self){
                        Text("Ola \($0)")
                    }
                }
            })
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 50)
        .padding(.top, 20)
        .background(BlurShape())
    }
}
struct BlurShape: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
