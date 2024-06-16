//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/13.
//

import ComposableArchitecture
import MapKit
import PostAnnotation

class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

@Reducer
public struct PostDetail {
    public struct State: Equatable {
        public let annotation: PostAnnotation
        @BindingState public var isShownActionSheet: Bool = false {
            didSet {
                print("check: isShownActionSheet = \(isShownActionSheet)")
            }
        }
        
        public var dateString: String {
            let date = DateUtils.dateFromString(string: annotation.startDatetime, format: "yyyy/MM/dd HH:mm:ss Z")
            let dateString = DateUtils.stringFromDate(date: date, format: "MM/dd（EEE）")
            return dateString
        }
        
        public var startToFinishTimeString: String {
            let startDate = DateUtils.dateFromString(string: annotation.startDatetime, format: "yyyy/MM/dd HH:mm:ss Z")
            let endDate = DateUtils.dateFromString(string: annotation.endDatetime, format: "yyyy/MM/dd HH:mm:ss Z")
            let startTimeString = DateUtils.stringFromDate(date: startDate, format: "HH:mm")
            let endTimeString = DateUtils.stringFromDate(date: endDate, format: "HH:mm")
            return startTimeString + " ~ " + endTimeString
        }
        
        public init(annotation: PostAnnotation) {
            self.annotation = annotation
        }
    }
    
    public enum Action: BindableAction {
        case initialize
        case ellipsisButtonTapped
        case delegate(Delegate)
        case binding(BindingAction<State>)
        
        public enum Delegate: Equatable {
            case move
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .ellipsisButtonTapped:
                state.isShownActionSheet.toggle()
                return .none
                
            case .initialize:
                return .send(.delegate(.move))
                
            case .delegate:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
