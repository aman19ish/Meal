//
//  Meals.swift
//  NaviyaLifeCareTest
//
//  Created by Aman gupta on 28/08/18.
//  Copyright © 2018 Aman Gupta. All rights reserved.
//

import Foundation

struct DietData: Codable {
    let weekDietData: Meals?
    let dietDuration: Int?
    
    enum CodingKeys: String, CodingKey {
        case weekDietData = "week_diet_data"
        case dietDuration = "diet_duration"
    }
}

struct Meals: Codable {
    let monday: [MealDetail]?
    let tuesday: [MealDetail]?
    let wednesday: [MealDetail]?
    let thursday: [MealDetail]?
    let friday: [MealDetail]?
    let saturday: [MealDetail]?
    let sunday: [MealDetail]?
    
}

struct MealDetail: Codable {
    let food: String?
    let mealTime: String?
    
    enum CodingKeys: String, CodingKey {
        case food
        case mealTime = "meal_time"
    }
}
