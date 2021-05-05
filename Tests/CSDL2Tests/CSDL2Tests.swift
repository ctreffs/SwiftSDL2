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

        XCTAssertEqual(compiled.major, 2)
        XCTAssertEqual(compiled.minor, 0)
        
        XCTAssertEqual(linked.major, 2)
        XCTAssertEqual(linked.minor, 0)
    }
}
