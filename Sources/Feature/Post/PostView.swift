//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/04/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import PostStore
import MapKit
import Assets
import ViewComponents
import Routing

public struct PostView: View {
    struct Location: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    enum FocusStates {
        case freeText
    }
    
    @Dependency(\.viewBuildingClient.mapWithCrossView) var mapWithCrossView
    @FocusState private var focusState : FocusStates?
    
    private let store: StoreOf<PostStore>
    private let topPadding: CGFloat = 8.0
    private let bottomPadding: CGFloat = 16.0
    
    public init(store: StoreOf<PostStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                // MARK: - Map
                VStack {
                    Spacer()
                        .frame(height: topPadding)
                    
                    Map(coordinateRegion: .constant(viewStore.region),
                        interactionModes: [],
                        annotationItems: [
                            Location (
                                coordinate: CLLocationCoordinate2D (
                                    latitude: viewStore.center.latitude,
                                    longitude: viewStore.center.longitude
                                )
                            )
                        ]) { location in
                            MapMarker(coordinate: location.coordinate)
                        }
                        .frame(height: 200)
                        .cornerRadius(10)
                        .onTapGesture {
                            viewStore.send(.mapTapped)
                        }
                    
                    Spacer()
                        .frame(height: bottomPadding)
                }
                .listRowBackground(Color.mainSubColor)
                
                // MARK: - Time
                VStack(alignment: .center) {
                    
                    HStack(spacing: 8) {
                        Spacer()
                        
                        Button(action: {
                            viewStore.send(.todayButtonTapped)
                        }) {
                            Text("今日")
                                .frame(width: 80, height: 36)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .background(viewStore.selectedButton == .today ? Color.mainBaseColor : .gray)
                        .cornerRadius(.infinity)
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            viewStore.send(.tomorrowButtonTapped)
                        }) {
                            Text("明日")
                                .frame(width: 80, height: 36)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .background(viewStore.selectedButton == .tomorrow ? Color.mainBaseColor : .gray)
                        .cornerRadius(.infinity)
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            viewStore.send(.dayAfterDayTomorrowButtonTapped)
                        }) {
                            Text("明後日")
                                .frame(width: 80, height: 36)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .background(viewStore.selectedButton == .dayAfterDayTomorrow ? Color.mainBaseColor : .gray)
                        .cornerRadius(.infinity)
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        WheelTimePickerView(selection: viewStore.$startDateTime)
                        
                        Text("~")
                        
                        WheelTimePickerView(selection: viewStore.$endDateTime)
                        
                        Spacer()
                    }
                    .frame(height: 100)
                    
                    VStack {
                        Text(viewStore.dateString)
                            .font(.system(size: 18))
                    }
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .padding(.horizontal, 8)
                    .cornerRadius(10)
                    .background(.white)
                    .foregroundColor(Color.mainBaseColor)
                    .overlay(
                           RoundedRectangle(cornerRadius: 10)
                           .stroke(Color.mainBaseColor, lineWidth: 1.0)
                   )
                    
                    Spacer()
                        .frame(height: bottomPadding)
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                .listRowBackground(Color.mainSubColor)
                
                // MARK: - Image
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: topPadding)
                    
                    HStack {
                        Spacer()
                        
                        if viewStore.image == Data() {
                            NoImageButton(action: {
                                viewStore.send(.imageButtonTapped)
                            })
                        } else {
                            RemovableImageButton(tapAction: {
                                viewStore.send(.imageButtonTapped)
                            }, removeAction: {
                                viewStore.send(.imageRemoveButtonTapped)
                            }, image: viewStore.image)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: bottomPadding)
                }
                .listRowBackground(Color.mainSubColor)
                
                // MARK: - Message
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: topPadding)
                    
                    TextField("一言メッセージ", text: viewStore.$freeText, axis: .vertical)
                        .padding()
                        .foregroundColor(Color.mainBaseColor)
                        .background(.white)
                        .cornerRadius(8)
                        .overlay(
                               RoundedRectangle(cornerRadius: 8)
                               .stroke(Color.mainBaseColor, lineWidth: 1.0)
                       )
                        .focused($focusState, equals: .freeText)
                        .onReceive(Just(viewStore.freeText)) { _ in
                            viewStore.send(.didChangeFreeText)
                        }
                    
                    Spacer()
                        .frame(height: bottomPadding)
                }
                .listRowBackground(Color.mainSubColor)
                
                // MARK: - Post
                VStack {
                    Button(action: {
                        viewStore.send(.createPostButtonTapped)
                    }) {
                        Text("投稿する")
                            .font(.system(size: 15, weight: .medium))
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.mainBaseColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(viewStore.startDateTime > viewStore.endDateTime)
                    
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.mainSubColor)
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
            .background(Color.mainSubColor)
            .navigationTitle("投稿作成")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        
                        Button("閉じる") {
                            focusState = nil
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.didDetermineCenter)) { notification in
                guard let center = notification.userInfo?["center"] as? CLLocationCoordinate2D else { return }
                viewStore.send(.centerDidChange(center: center))
            }
            .sheet(isPresented: viewStore.$isShownImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: viewStore.$image)
            }
            .alert(
                store: store.scope(state: \.$alert,
                                   action: \.alert)
            )
            .navigationDestination(
                store: store.scope(state: \.$destination.mapWithCross,
                                   action: \.destination.mapWithCross)
            ) { store in
                mapWithCrossView(store)
            }
        }
    }
}
