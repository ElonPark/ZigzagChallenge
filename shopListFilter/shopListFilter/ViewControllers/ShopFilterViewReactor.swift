//
//  ShopFilterViewReactor.swift
//  shopListFilter
//
//  Created by Elon on 22/09/2019.
//  Copyright © 2019 ElonPark. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class ShopFilterViewReactor: Reactor {
    
    enum Action {
        case reset
        case loadFilter
        case selectFilter(IndexPath)
        case complete
    }
    
    enum Mutation {
        case reset
        case setLoadFilter([ShopFilterSection])
        case setFilter(Filter)
        case setSelectedFilters((age: [Age], style: [Style]))
    }
    
    struct State {
        var sections: [ShopFilterSection] = []
        var selectedAges: Set<Age> = Set()
        var selectedStyles: Set<Style> = Set()
        var selectedFilters = (age: [Age](), style: [Style]())
    }
    
    let initialState: State
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .reset:
            return .just(.setLoadFilter(currentState.sections))
            
         case .loadFilter:
            let ageItems = Age.allCases.map { Filter.age($0) }
            let ageSection = ShopFilterSection(header: "연령대", items: ageItems)
            
            let styleItems = Style.allCases.map { Filter.style($0) }
            let styleSection = ShopFilterSection(header: "스타일", items: styleItems)
            
            return .just(.setLoadFilter([ageSection, styleSection]))
            
         case .selectFilter(let indexPath):
            let filter = currentState.sections[indexPath.section].items[indexPath.item]
            return .just(.setFilter(filter))
            
         case .complete:
            let ages = Array(currentState.selectedAges)
            let styles = Array(currentState.selectedStyles)
            
            return .just(.setSelectedFilters((ages, styles)))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoadFilter(let sections):
            newState.sections = sections
            
        case .reset:
            newState.selectedAges = Set()
            newState.selectedStyles = Set()
            
        case .setFilter(let filterType):
            newState = updateFilter(with: newState, filter: filterType)
            
        case .setSelectedFilters(let filters):
            newState.selectedFilters = filters
        }
        
        return newState
    }
    
    private func updateFilter(with state: State, filter: Filter) -> State {
        var newState = state
        switch filter {
        case .age(let age):
            newState.selectedAges = updatedFilterSet(by: newState.selectedAges,
                                                     filter: age)
        case .style(let style):
            newState.selectedStyles = updatedFilterSet(by: newState.selectedStyles,
                                                       filter: style)
        }
        
        return newState
    }
    
    private func updatedFilterSet<T: FilterType>(by filterSet: Set<T>, filter: T) -> Set<T> {
        var newFilterSet = filterSet
        if filterSet.contains(filter) {
            newFilterSet.remove(filter)
        } else {
            newFilterSet.insert(filter)
        }
        
        return newFilterSet
    }
    
}
