//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture
import PostStore
import MapKit
import ViewComponents
import Routing

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

public struct PostView: View {
    @Dependency(\.viewBuildingClient.mapWithCrossView) var mapWithCrossView
    let store: StoreOf<PostStore>
    
    public init(store: StoreOf<PostStore>) {
        self.store = store
    }
    
    private let topPadding: CGFloat = 8.0
    private let bottomPadding: CGFloat = 16.0
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                // MARK: - Map
                VStack {
                    Spacer()
                        .frame(height: self.topPadding)
                    
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
                        .frame(height: self.bottomPadding)
                }
                
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
                        .background(viewStore.selectedButton == .today ? .black : .gray)
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
                        .background(viewStore.selectedButton == .tomorrow ? .black : .gray)
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
                        .background(viewStore.selectedButton == .dayAfterDayTomorrow ? .black : .gray)
                        .cornerRadius(.infinity)
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        WheelTimePickerView(selection: viewStore.$startDateTime)
                            .frame(width: 124, height: 100)
                        
                        Text("~")
                        
                        WheelTimePickerView(selection: viewStore.$endDateTime)
                            .frame(width: 124, height: 100)
                        
                        Spacer()
                    }
                    
                    Text(viewStore.dateString)
                        .frame(width: 256, height: 36, alignment: .center)
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    Spacer()
                        .frame(height: self.bottomPadding)
                }.alignmentGuide(.listRowSeparatorLeading) { _ in  0 }
                
                // MARK: - Image
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: self.topPadding)
                    
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
                        .frame(height: self.bottomPadding)
                }
                
                // MARK: - Message
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: self.topPadding)
                    
                    TextField("一言メッセージ", text: viewStore.$freeText)
                        .padding(.horizontal, self.bottomPadding)
                    
                    Spacer()
                        .frame(height: self.bottomPadding)
                }
                
                // MARK: - Post
                VStack {
                    
                    Button(action: {
                        print("check: Post !!!!")
                    }) {
                        Text("投稿する")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(10)
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
            .navigationTitle("投稿作成")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(
                store: store.scope(state: \.$destination.mapWithCross,
                                   action: \.destination.mapWithCross)
            ) { store in
                mapWithCrossView(store)
            }
            .sheet(isPresented: viewStore.$isShownImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: viewStore.$image)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.didDetermineCenter)) { notification in
                guard let center = notification.userInfo?["center"] as? CLLocationCoordinate2D else { return }
                viewStore.send(.centerDidChange(center: center))
            }
        }
    }
}
