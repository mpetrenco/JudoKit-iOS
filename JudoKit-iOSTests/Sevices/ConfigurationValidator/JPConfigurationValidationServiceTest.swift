//
//  JPConfigurationValidationServiceTest.swift
//  JudoKit-iOSTests
//
//  Copyright (c) 2020 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import XCTest
@testable import JudoKit_iOS

class JPConfigurationValidationServiceTest: XCTestCase {
    var amount: JPAmount!
    var configuration: JPConfiguration!
    let consumerReference = "judoPay-sample-app"
    var configValidation: JPConfigurationValidationService!
    lazy var reference = JPReference(consumerReference: consumerReference)
    
    override func setUp() {
        configValidation = JPConfigurationValidationServiceImp()
        amount = JPAmount("fv", currency: "EUR")
        configuration = JPConfiguration(judoID: "judoId", amount: self.amount, reference: reference)
        configuration.supportedCardNetworks = [.visa, .masterCard, .AMEX]
    }
    
    /*
     * GIVEN: Validate configuration for payment
     *
     * WHEN: amount is invalid
     *
     * THEN: should return error
     */
    func test_ValiadateConfiguration_WhenAmountInvalid_ShouldReturnError() {
        let error = configValidation.validate(configuration, for: .payment)
        XCTAssertNotNil(error, "Error must not be nil when invalid amount is specified")
    }
    
    /*
     * GIVEN: Validate configuration for payment
     *
     * WHEN: configuration currency is empty
     *
     * THEN: should return error
     */
    func test_ValiadateConfiguration_WhenCurrencyIsEmpty_ShouldReturnError() {
        amount = JPAmount("0.1", currency: "")
        configuration.amount = amount
        let error = configValidation.validate(configuration, for: .payment)
        XCTAssertNotNil(error, "Error must not be nil when no curency is specified")
    }
    
    /*
     * GIVEN: Validate configuration for payment
     *
     * WHEN: configuration is nil
     *
     * THEN: should return error
     */
    func test_ValiadateConfiguration_WhenConfigIsNil_ShouldReturnError() {
        configuration = nil
        let error = configValidation.validate(configuration, for: .payment)
        XCTAssertNotNil(error, "Error must not be nil when nil configuration is specified")
    }
    
    /*
     * GIVEN: Validate pbba payment
     *
     * WHEN: amout currency is EUR
     *
     * THEN: should return error with "Unsuported Currency" message
     */
    func test_ValidatePBBAConfiguration_WhenCurrencyEUR_ShouldReturnError() {
        let error = configValidation.validatePBBAConfiguration(configuration)
        XCTAssertNotNil(error, "Unsuported Currency")
    }
    
    /*
     * GIVEN: Validate configuration for payment
     *
     * WHEN: reference ID is less then 40 characters
     *
     * THEN: should return error
     */
    func test_ValiadateConfiguration_WhenReferenceIsLess_ShouldReturnError() {
        let reference40Characters = String(repeating: "J", count: Int(kMaximumLengthForConsumerReference + 1))
        configuration.reference = JPReference(consumerReference: reference40Characters)
        let error = configValidation.validate(configuration, for: .payment)
        XCTAssertNotNil(error, "Error must not be nil when the consumer reference is larger than 40 characters")
    }
    
    /*
     * GIVEN: Validate configuration for payment
     *
     * WHEN: judoID is invalid ("judoId")
     *
     * THEN: should return error
     */
    func test_ValiadateConfiguration_WhenJudoIDInvalid_ShouldReturnError() {
        amount = JPAmount("0.1", currency: "USD")
        configuration.amount = amount
        let error = configValidation.validate(configuration, for: .payment)
        XCTAssertNotNil(error, "Error must not be nil when invalid amount is specified")
    }
    
    /*
     * GIVEN: Validate configuration for payment
     *
     * WHEN: judoID is valid ("12345")
     *
     * THEN: should return error
     */
    func test_ValiadateConfiguration_WhenJudoIDValid_ShoulNotdReturnError() {
        amount = JPAmount("0.1", currency: "USD")
        configuration.amount = amount
        configuration = JPConfiguration(judoID: "12345", amount: self.amount, reference: reference)
        let error = configValidation.validate(configuration, for: .payment)
        XCTAssertNil(error, "Error must  be nil when valid amount is specified")
    }
    
}
