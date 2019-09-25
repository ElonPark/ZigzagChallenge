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
        case setFilter(IndexPath)
        case setSelectedFilter(SelectedFilter)
        case setIsSelectComplete(Bool)
    }
    
    struct State {
        var isSelectComplete: Bool = false
        var selectedFilter: SelectedFilter
        var selectedAges: Set<Age> = Set()
        var selectedStyles: Set<Style> = Set()
        var sections: [ShopFilterSection] = []
    }
    
    let initialState: State
    
    init(selectedFilter: SelectedFilter) {
        initialState = State(selectedFilter: selectedFilter,
                             selectedAges: selectedFilter.ages,
                             selectedStyles: selectedFilter.styles)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .reset:
            return .just(.reset)
            
         case .loadFilter:
            let selectedAges = currentState.selectedFilter.ages
            let ageItems = ageSectionItems(selectedAges)
            let ageSection = ShopFilterSection(header: "연령대",
                                               items: ageItems)
            
            let selectedStyles = currentState.selectedFilter.styles
            let styleItems = styleSectionItems(selectedStyles)
            let styleSection = ShopFilterSection(header: "스타일",
                                                 items: styleItems)
            
            return .just(.setLoadFilter([ageSection, styleSection]))
            
         case .selectFilter(let indexPath):
            return .just(.setFilter(indexPath))
            
         case .complete:
            let ages = currentState.selectedAges
            let styles = currentState.selectedStyles
            let item = SelectedFilter(ages: ages, styles: styles)
            
            let mutations: [Observable<Mutation>] = [
                .just(.setSelectedFilter(item)),
                .just(.setIsSelectComplete(true))
            ]
            
            return .concat(mutations)
        }
    }
    
    private func ageSectionItems(_ selectedAges: Set<Age>) -> [ShopFilterSectionItem] {
        var ageItems: [ShopFilterSectionItem] = []
        for age in Age.allCases {
            let isSelected = selectedAges.contains(age)
            let sectionItem = ShopFilterSectionItem(isSelected: isSelected,
                                                    filter: .age(age))
            ageItems.append(sectionItem)
        }
        
        return ageItems
    }
    
    private func styleSectionItems(_ selectedStyles: Set<Style>) -> [ShopFilterSectionItem] {
        var styleItems: [ShopFilterSectionItem] = []
        for style in Style.allCases {
            let isSelected = selectedStyles.contains(style)
            let sectionItem = ShopFilterSectionItem(isSelected: isSelected,
                                                    filter: .style(style))
            styleItems.append(sectionItem)
        }
        
        return styleItems
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoadFilter(let sections):
            newState.sections = sections
            
        case .reset:
            newState.selectedAges = Set()
            newState.selectedStyles = Set()
            newState.sections = newState.sections.map { section in
                var newSection = section
                newSection.items = section.items.map { item in
                    var newItem = item
                    newItem.isSelected = false
                    return newItem
                }
                return newSection
            }
            
        case .setFilter(let indexPath):
            var section = newState.sections[indexPath.section]
            var item = section.items[indexPath.item]
            let filter = item.filter
            switch filter {
            case .age(let age):
                newState.selectedAges = updatedFilterSet(by: newState.selectedAges,
                                                         filter: age)
            case .style(let style):
                newState.selectedStyles = updatedFilterSet(by: newState.selectedStyles,
                                                           filter: style)
            }
            
            item.isSelected.toggle()
            section.items[indexPath.item] = item
            newState.sections[indexPath.section] = section
            
        case .setSelectedFilter(let filter):
            newState.selectedFilter = filter
            
        case .setIsSelectComplete(let isComplete):
            newState.isSelectComplete = isComplete
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
