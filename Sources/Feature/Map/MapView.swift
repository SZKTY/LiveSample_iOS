//
//  SwiftUIView.swift
//
//
//  Created by toya.suzuki on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture
import PopupView
import MapStore
import MapKit
import Routing
import ViewComponents
import Assets

public struct MapView: View {
    @EnvironmentObject var accountTypeChecker: AccountTypeChecker
    
    @Dependency(\.viewBuildingClient.postView) private var postView
    @Dependency(\.viewBuildingClient.myPageView) private var myPageView
    @Dependency(\.viewBuildingClient.postDetailView) private var postDetailView
    @Dependency(\.viewBuildingClient.editProfileView) private var editProfileView
    
    // State側で管理するとAnimationを付けた際にエラーが出るため、View側で泣く泣く管理する
    @State var isShownRecommendView: Bool = false
    @State var isShownHintView: Bool = false
    
    private let store: StoreOf<MapStore>
    
    public nonisolated init(store: StoreOf<MapStore>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                WithViewStore(self.store, observe: { $0 }) { viewStore in
                    ZStack {
                        // マップ表示
                        MapViewRepresentable(postAnnotations: viewStore.$postAnnotations,
                                             isShownPostDetailSheet: viewStore.isShownPostDetailSheet)
                        .setCallback(didLongPress: {
                            // do nothing
                            print("check: didLongPress")
                        }, didChangeCenterRegion: { region in
                            DispatchQueue.main.async {
                                viewStore.send(.centerRegionChanged(region: region))
                            }
                        }, didTapPin: { annotation in
                            viewStore.send(.annotationTapped(annotation: annotation))
                        })
                        
                        FloatingView(position: .topLeading) {
                            VStack {
                                // マイページボタン
                                FloatingButton(imageName: "line.3.horizontal", isBaseColor: false) {
                                    DispatchQueue.main.async {
                                        viewStore.send(.floatingHomeButtonTapped)
                                    }
                                }
                                
                                // ヒントボタン
                                FloatingButton(imageName: "questionmark.circle", isBaseColor: false, isLarge: false) {
                                    isShownHintView = true
                                }
                                
                                //                                // レコメンド一覧ボタン
                                //                                FloatingButton(imageName: "person.badge.plus", isBaseColor: false, isLarge: false) {
                                //                                        withAnimation(.easeInOut(duration: 0.3)) {
                                //                                            isShownRecommendView = true
                                //                                        }
                                //                                }
                            }
                        }.opacity(viewStore.isSelectPlaceMode ? 0 : 1)
                        
                        
                        FloatingView(position: .bottomTailing) {
                            // 投稿作成ボタン
                            FloatingButton(imageName: "plus") {
                                DispatchQueue.main.async {
                                    viewStore.send(.floatingPlusButtonTapped)
                                }
                            }.opacity(accountTypeChecker.accountType == .artist && !viewStore.isSelectPlaceMode ? 1 : 0)
                        }
                        
                        SideRecommendView(isOpen: $isShownRecommendView)
                        
                        // 場所選択モード
                        SelectPLaceModeView(scopeTopPadding: geometry.safeAreaInsets.top, action: {
                            DispatchQueue.main.async {
                                viewStore.send(.confirmButtonTappedInSelectPlaceMode)
                            }
                        }, cancelAction: {
                            DispatchQueue.main.async {
                                viewStore.send(.cancelButtonTappedInSelectPlaceMode)
                            }
                        })
                        .opacity(viewStore.isSelectPlaceMode ? 1 : 0)
                        
                        if isShownHintView {
                            HintView(isOpen: $isShownHintView)
                        }
                    }
                    .popup(isPresented: viewStore.$isShowSuccessToast) {
                        // 投稿作成完了のトーストバナー
                        SuccessToastBanner()
                    } customize: {
                        $0
                            .type(.floater())
                            .position(.top)
                            .animation(.spring)
                            .autohideIn(3)
                        
                    }
                }
            }
            .edgesIgnoringSafeArea(.vertical)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.didSuccessCreatePost)) { notification in
                store.send(.showSuccessToast)
            }
            .task {
                await store.send(.task).finish()
            }
            .alert(
                store: store.scope(state: \.$alert,
                                   action: \.alert)
            )
            .navigationDestination(
                store: store.scope(state: \.$destination.post,
                                   action: \.destination.post)
            ) { store in
                postView(store)
            }
            .navigationDestination(
                store: store.scope(state: \.$destination.editProfile,
                                   action: \.destination.editProfile)
            ) { store in
                editProfileView(store)
            }
            .sheet(
                store: store.scope(state: \.$myPage,
                                   action: \.myPage),
                onDismiss: {
                    store.send(.myPageSheetDismiss)
                }
            ) { store in
                myPageView(store)
            }
            .sheet(
                store: store.scope(state: \.$postDetail,
                                   action: \.postDetail),
                onDismiss: {
                    store.send(.postDetailSheetDismiss)
                }
            ) { store in
                postDetailView(store)
                    .backgroundClearSheet()
                    .presentationDetents([
                        .fraction(0.8)
                    ])
            }
        }
    }
}

public struct HintView: View {
    @Binding private var isOpen: Bool
    private let maxWidth = UIScreen.main.bounds.width
    private let maxHeight = UIScreen.main.bounds.height
    
    public init(isOpen: Binding<Bool>) {
        _isOpen = isOpen
    }
    
    public var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(0.7)
                .onTapGesture {
                    isOpen.toggle()
                }
            
            VStack(spacing: .zero) {
                Text("ヒント")
                    .font(.system(size: 22, weight: .bold))
                
                Spacer()
                    .frame(height: 12)
                
                ScrollView {
                    Spacer()
                        .frame(height: 24)
                    
                    VStack(spacing: 36) {
                        VStack(spacing: 12) {
                            Text("ピンの色表示について")
                                .font(.system(size: 16, weight: .bold))
                            
                            Text("開催までの残り時間によってピンの色が変わります\n気になるライブがあったらチェックしてみましょう")
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                VStack {
                                    Image("RedPin")
                                    Text("開催中")
                                }
                                VStack {
                                    Image("YellowPin")
                                    Text("~1時間")
                                }
                                VStack {
                                    Image("GreenPin")
                                    Text("~12時間")
                                }
                                VStack {
                                    Image("BluePin")
                                    Text("~24時間")
                                }
                                VStack {
                                    Image("GrayPin")
                                    Text("24時間以上")
                                }
                            }
                            .font(.system(size: 8))
                        }
                        
                        VStack(spacing: 12) {
                            Text("行きたいライブがみつかったら")
                                .font(.system(size: 16, weight: .bold))
                            
                            VStack(spacing: 4) {
                                Text("まずはなにより現地で応援してみましょう！\n直接会いにきてくれることは\n必ずアーティストの励みになります。")
                                Text("次にいつ会えるかわからないアーティストもいるので、\n気になったら積極的に現地で応援してみてください！")
                            }
                            .font(.system(size: 10))
                            .multilineTextAlignment(.center)
                        }
                        
                        VStack(spacing: 12) {
                            Text("応援したいアーティストがみつかったら")
                                .font(.system(size: 16, weight: .bold))
                            
                            VStack(spacing: 4) {
                                Text("ぜひ他のSNSや音楽サイトをチェックしてみてください！\nSPREETはアーティストが路上ライブ以外の場でも\n活躍していくことを心より願っています！")
                                Text("みなさんでアーティストの夢を叶えるべく\n応援していきましょう！")
                            }
                            .font(.system(size: 10))
                            .multilineTextAlignment(.center)
                        }
                        
                        HStack(spacing: .zero) {
                            Text("わからないことがあれば")
                            
                            Button(action: {
                                
                            }, label: {
                                Text("ヘルプページ")
                                    .underline()
                            })
                            
                            Text("へ")
                        }
                        .font(.system(size: 12))
                    }
                }.scrollIndicators(.never)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mainSubColor)
            .cornerRadius(40)
            .padding(.horizontal, maxWidth / 12)
            .padding(.vertical, maxHeight / 6)
        }
    }
}


public struct SideRecommendView: View {
    @Binding private var isOpen: Bool
    private let maxWidth = UIScreen.main.bounds.width
    
    private var safeAreaInsets: UIEdgeInsets {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first?.safeAreaInsets ?? .zero
    }
    
    public init(
        isOpen: Binding<Bool>
    ) {
        _isOpen = isOpen
    }
    
    public var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(isOpen ? 0.7 : 0)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isOpen.toggle()
                    }
                }
            
            VStack(spacing: .zero) {
                Text("イチ推しアーティスト")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.vertical, 20)
                
                
                VStack(spacing: 16) {
                    ForEach(0...6, id: \.self) { _ in
                        RecommendCellView()
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mainSubColor)
            .padding(.top, safeAreaInsets.top)
            .cornerRadius(40)
            .clipShape(
                .rect(
                    topLeadingRadius: 40,
                    bottomLeadingRadius: 40,
                    bottomTrailingRadius: .zero,
                    topTrailingRadius: .zero
                )
            )
            .padding(.leading, maxWidth / 4)
            .offset(x: isOpen ? 0 : maxWidth)
        }
    }
}

public struct RecommendCellView: View {
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 12) {
            //            AsyncImage(
            //                url: URL(string: viewStore.annotation.postUserProfileImagePath)
            //            ) { image in
            //                image
            //                    .resizable()
            //                    .scaledToFill()
            //                    .frame(
            //                        width: UIScreen.main.bounds.width*0.15,
            //                        height: UIScreen.main.bounds.width*0.15
            //                    )
            //                    .clipShape(Circle())
            //            } placeholder: {
            Image(uiImage: UIImage(named: "noImage")!)
                .resizable()
                .scaledToFill()
                .frame(
                    width: UIScreen.main.bounds.width*0.15,
                    height: UIScreen.main.bounds.width*0.15
                )
                .clipShape(Circle())
            //            }
            
            VStack(alignment: .leading) {
                Text("HogeHoge")
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .medium))
                
                Text("PiyoPiyoPiyoPiyo")
                    .foregroundColor(.black)
                    .font(.system(size: 12))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func backgroundClearSheet() -> some View {
        background(BackgroundClearView())
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
    }
}
