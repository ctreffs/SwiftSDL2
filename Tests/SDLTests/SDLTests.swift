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

        XCTAssertEqual(compiled.major, 2)
        XCTAssertEqual(compiled.major, linked.major)

        XCTAssertGreaterThanOrEqual(compiled.minor, 0)
        XCTAssertEqual(compiled.minor, linked.minor)

        XCTAssertGreaterThanOrEqual(compiled.patch, 0)
        XCTAssertEqual(compiled.patch, linked.patch)
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
