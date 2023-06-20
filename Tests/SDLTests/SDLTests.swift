@testable import SDL
import XCTest

final class SDLTests: XCTestCase {
    func testVersion() {
        var compiled = SDL_version()
        compiled.major = Uint8(SDL_MAJOR_VERSION)
        compiled.minor = Uint8(SDL_MINOR_VERSION)
        compiled.patch = Uint8(SDL_PATCHLEVEL)

        var linked = SDL_version()
        SDL_GetVersion(&linked)

        #if os(Linux)
            XCTAssertEqual(compiled.major, 2)
            XCTAssertEqual(compiled.major, linked.major)
        #else
            XCTAssertEqual(compiled.major, 2)
            XCTAssertEqual(compiled.major, linked.major)

            XCTAssertEqual(compiled.minor, 26)
            XCTAssertEqual(compiled.minor, linked.minor)

            XCTAssertEqual(compiled.patch, 5)
            XCTAssertEqual(compiled.patch, linked.patch)
        #endif
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
