import Foundation
import XCTest


extension Character {
     var isAlphabet: Bool {
        return range(of: "[^a-zA-Z]", options: .regularExpression) == nil
     }
}

func snakeCase(by originString: String) -> String {
    guard !originString.isEmpty else { return originString }
    var tokenArray: [String] = []
    var tempString: String = ""

    for character in originString {
        character.isAlphabet
    }
    let a = Array(originString)
}

class InflectStringTestCase: XCTestCase {
    
    func testEmptyString() {
        // given
        let empty = ""
        
        // when
        let snake_empty = snakeCase(by: empty)
        
        // Then
        XCTAssertEqual(snake_empty, "", "빈 문자열 변환 실패")
    }
    
    func testSpaceString() {
        // given
        let space = " "
        let space2 = "\t"
        
        // when
        let snake_space = snakeCase(by: space)
        let snake_space2 = snakeCase(by: space2)
        
        // Then
        XCTAssertEqual(snake_space, "", "공백 문자열 변환 실패")
        XCTAssertEqual(snake_space2, "", "공백 문자열 변환 실패")
    }
    
    func testWord() {
        // given
        let product = "Product"
        let shop = "Shop"
        let value = "Value"
        let zigzag = "zigzag"
        
        // when
        let snake_product = snakeCase(by: product)
        let snake_shop = snakeCase(by: shop)
        let snake_value = snakeCase(by: value)
        let snake_zigzag = snakeCase(by: zigzag)
        
        // Then
        XCTAssertEqual(snake_product, "product", "단어 변환 실패")
        XCTAssertEqual(snake_shop, "shop", "단어 변환 실패")
        XCTAssertEqual(snake_value, "value", "단어 변환 실패")
        XCTAssertEqual(snake_zigzag, "zigzag", "단어 변환 실패")
    }
    
    func testPascalCase() {
        // given
        let specialGuest = "SpecialGuest"
        let appleComputer = "AppleComputer"
        
        // when
        let snake_special_guest = snakeCase(by: specialGuest)
        let snak_apple_computer = snakeCase(by: appleComputer)
        
        // Then
        XCTAssertEqual(snake_special_guest, "special_guest", "파스칼 케이스 변환 실패")
        XCTAssertEqual(snak_apple_computer, "apple_computer", "파스칼 케이스 변환 실패")
    }
    
    
    func testNumber() {
        // given
        let intNumber = "a1234b5678"
        let floatNumber = "3.141592pie"
        
        // when
        let snake_int_number = snakeCase(by: intNumber)
        let snake_float_number = snakeCase(by: floatNumber)
        
        // Then
        XCTAssertEqual(snake_int_number, "a_b", "숫자 케이스 변환 실패")
        XCTAssertEqual(snake_float_number, "pie", "숫자 케이스 변환 실패")
    }

    func testSpecialSymbols() {
        // given
        let donaldEKnuth = "donald E. knuth"
        let steveJobs = "steve! & Jobs?"
        let steveWoz = "@Steve ^&&*()'\"Gary #Woz\n@Wozniak!@#$%$"
        
        // when
        let snake_donald_e_knuth = snakeCase(by: donaldEKnuth)
        let snake_steve_jobs = snakeCase(by: steveJobs)
        let snake_steve_woz = snakeCase(by: steveWoz)
        
        // Then
        XCTAssertEqual(snake_donald_e_knuth, "donald_e_knuth", "특수기호 케이스 변환 실패")
        XCTAssertEqual(snake_steve_jobs, "steve_jobs", "특수기호 케이스 변환 실패")
        XCTAssertEqual(snake_steve_woz, "steve_gary_woz_wozniak", "특수기호 케이스 변환 실패")
    }

    func testSpecialCharacters() {
        // given
        let smileEmoji = "this is smile 🤣"
        let cross = "I Love XⓍ𝓧 xx"
        
        // when
        let snake_smile_emoji = snakeCase(by: smileEmoji)
        let snake_cross = snakeCase(by: cross)
        
        // Then
        XCTAssertEqual(snake_smile_emoji, "this_is_smile", "특수문자 케이스 변환 실패")
        XCTAssertEqual(snake_cross, "i_love_xx", "특수문자 케이스 변환 실패")
    }
    
    
}

InflectStringTestCase.defaultTestSuite.run()
