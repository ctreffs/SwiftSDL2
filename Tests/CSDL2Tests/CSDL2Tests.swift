//
//  CSDL2Tests.swift
//
//
//  Created by Christian Treffs on 03.11.19.
//

import XCTest
import CSDL2

final class CSDL2Tests: XCTestCase {

    func testVersion() {
        var compiled = SDL_version()
        compiled.major = Uint8(SDL_MAJOR_VERSION)
        compiled.minor = Uint8(SDL_MINOR_VERSION)
        compiled.patch = Uint8(SDL_PATCHLEVEL)

        var linked = SDL_version()
        SDL_GetVersion(&linked)

        XCTAssertGreaterThanOrEqual(compiled.major, 2)
        XCTAssertEqual(compiled.major, linked.major)
    }

    func testAPIAvailability() {
        XCTAssertNotNil(SDL_Init.self)
        XCTAssertNotNil(SDL_CreateWindow.self)
        XCTAssertNotNil(SDL_DestroyWindow.self)
        XCTAssertNotNil(SDL_Quit.self)
    }
    
    func testKeyCodeAvailability() {
        XCTAssertNotNil(SDL_KeyCode.self)
    }
}
