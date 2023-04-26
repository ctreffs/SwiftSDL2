import SDL2

// Initialize SDL video systems
guard SDL_Init(SDL_INIT_VIDEO) == 0 else {
    fatalError("SDL could not initialize! SDL_Error: \(String(cString: SDL_GetError()))")
}

// Create a window at the center of the screen with 800x600 pixel resolution
let window = SDL_CreateWindow(
    "SDL2 Minimal Demo",
    Int32(SDL_WINDOWPOS_CENTERED_MASK), Int32(SDL_WINDOWPOS_CENTERED_MASK),
    800, 600,
    SDL_Flag(SDL_WINDOW_SHOWN))

var quit = false
var event = SDL_Event()

// Run until app is quit
while !quit {
    // Poll for (input) events
    while SDL_PollEvent(&event) > 0 {
        // if the quit event is triggered ...
        if event.type == SDL_QUIT.rawValue {
            // ... quit the run loop
            quit = true
        }
    }

    // wait 100 ms
    SDL_Delay(100)
}

// Destroy the window
SDL_DestroyWindow(window)

// Quit all SDL systems
SDL_Quit()
