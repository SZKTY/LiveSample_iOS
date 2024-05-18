//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import Foundation
import ComposableArchitecture
import CoreLocation
import MapKit
import MapWithCrossStore
import PostEntity
import API
import UserDefaults

struct SharedData: Equatable {
    var center: CLLocationCoordinate2D?
}

public enum SelectedButton {
    case today
    case tomorrow
    case dayAfterDayTomorrow
}

@Reducer
public struct PostStore {
    public struct State: Equatable {
        @PresentationState public var alert: AlertState<Action.Alert>?
        @PresentationState public var destination: Path.State?
        
        public var region: MKCoordinateRegion
        public var dateString: String {
            return self.dateFormatter.string(from: self.date) + "   |   " + self.timeFormatter.string(from: self.startDateTime) + "  ~  " + self.timeFormatter.string(from: self.endDateTime)
        }
        
        @BindingState public var center: CLLocationCoordinate2D
        @BindingState public var date: Date = Date()
        @BindingState public var startDateTime: Date = Date()
        @BindingState public var endDateTime: Date = Date()
        @BindingState public var image: Data = Data()
        @BindingState public var freeText: String = ""
        
        @BindingState public var isShownImagePicker: Bool = false
        @BindingState public var isEnableCreatePostButton: Bool = false
        @BindingState public var selectedButton: SelectedButton = .today
        
        public var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "JST")
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "M/d (EEE)"
            return dateFormatter
        }
        
        public var timeFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "JST")
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter
        }
        
        public init(center: CLLocationCoordinate2D) {
            self.center = center
            
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude),
                latitudinalMeters: 120.0,
                longitudinalMeters: 120.0
            )
        }
    }
    
    public enum Action: BindableAction {
        case mapTapped
        case todayButtonTapped
        case tomorrowButtonTapped
        case dayAfterDayTomorrowButtonTapped
        case imageButtonTapped
        case imageRemoveButtonTapped
        case createPostButtonTapped
        case uploadPictureResponse(Result<UploadPictureResponse, Error>)
        case createPostResponse(Result<CreatePostResponse, Error>)
        case centerDidChange(center: CLLocationCoordinate2D)
        case alert(PresentationAction<Alert>)
        case destination(PresentationAction<Path.Action>)
        case binding(BindingAction<State>)
        
        public enum Alert: Equatable {
            case failToCreatePost
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.uploadPictureClient) var uploadPictureClient
    @Dependency(\.createPostClient) var createPostClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .mapTapped:
                state.destination = .mapWithCross(MapWithCrossStore.State(center: state.center))
                return .none
            case .todayButtonTapped:
                state.selectedButton = .today
                state.date = Date()
                return .none
            case .tomorrowButtonTapped:
                state.date = Date().addingTimeInterval(60*60*24)
                state.selectedButton = .tomorrow
                return .none
            case .dayAfterDayTomorrowButtonTapped:
                state.date = Date().addingTimeInterval(60*60*24*2)
                state.selectedButton = .dayAfterDayTomorrow
                return .none
            case .imageButtonTapped:
                state.isShownImagePicker = true
                return .none
            case .imageRemoveButtonTapped:
                state.image = Data()
                return .none
            case .createPostButtonTapped:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                if state.image == Data() {
                    return .run { send in
                        await send(.uploadPictureResponse(.success(UploadPictureResponse(imagePath: ""))))
                    }
                }
                
                return .run { [data = state.image] send in
                    await send(.uploadPictureResponse(Result {
                        try await uploadPictureClient.upload(sessionId: sessionId, data: data)
                    }))
                }
                
            case let .uploadPictureResponse(.success(response)):
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                let entity: PostEntity = .init(imagePath: response.imagePath,
                                               freeText: state.freeText,
                                               coordinateX: "\(state.center.latitude)",
                                               coordinateY: "\(state.center.longitude)",
                                               startDateTime: "\(state.startDateTime)",
                                               endDateTime: "\(state.endDateTime)")
                
                return .run { send in
                    await send(.createPostResponse(Result {
                        try await createPostClient.send(sessionId: sessionId, entity: entity)
                    }))
                }
                
            case let .uploadPictureResponse(.failure(error)):
                print("check: FAIL uploadPicture")
                state.alert = AlertState(title: TextState("登録失敗"))
                return .none
                
            case let .createPostResponse(.success(response)):
                print("check: SUCCESS")
                return .none
                
            case let .createPostResponse(.failure(error)):
                print("check: FAIL createPost")
                state.alert = AlertState(title: TextState("登録失敗"))
                return .none
                
            case let .centerDidChange(center):
                state.center = center
                state.region.center = center
                return .none
            case .alert:
                return .none
            case .destination:
                return .none
            case .binding:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$destination, action: \.destination)
        
        BindingReducer()
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center == rhs.center
    }
}

extension PostStore {
    @Reducer(state: .equatable)
    public enum Path {
        case mapWithCross(MapWithCrossStore)
    }
}
