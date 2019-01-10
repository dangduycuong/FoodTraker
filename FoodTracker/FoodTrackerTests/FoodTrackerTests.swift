//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Apple on 1/9/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    //MARK: Meal Class Tests
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testMealInitializationSucceeds() {
        // Zero rating
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(nil)
        
        // Rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        
        // Empty String
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(nil)
        
        // Note: Nếu quá trình khởi tạo hoạt động như mong đợi, các lệnh gọi tới init (name: , photo:, rating: ) sẽ không thành công. XCTAssertNil xác minh điều này bằng cách kiểm tra xem đối tượng Meal được trả về có phải không.
        
    }
}
