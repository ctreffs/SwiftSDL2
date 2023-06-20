#if METAL_ENABLED
    import SDL
    #if canImport(Metal)
        import Metal
        import class QuartzCore.CAMetalLayer
    #endif

    SDL_Init(SDL_INIT_VIDEO)
    SDL_SetHint(SDL_HINT_RENDER_DRIVER, "metal")
    SDL_InitSubSystem(SDL_INIT_VIDEO)

    let window = SDL_CreateWindow("SDL2 Metal Demo", 0, 0, 800, 600, SDL_WINDOW_SHOWN.rawValue | SDL_WINDOW_ALLOW_HIGHDPI.rawValue | SDL_WINDOW_METAL.rawValue)

    let renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC.rawValue | SDL_RENDERER_ACCELERATED.rawValue)

    guard let layerPointer = SDL_RenderGetMetalLayer(renderer) else {
        fatalError("could not get metal layer from renderer")
    }

    let layer: CAMetalLayer = unsafeBitCast(layerPointer, to: CAMetalLayer.self)

    guard let device: MTLDevice = layer.device else {
        fatalError("metal device missing")
    }

    guard let queue: MTLCommandQueue = device.makeCommandQueue() else {
        fatalError("could not create command queue")
    }

    var color = MTLClearColorMake(0, 0, 0, 1)

    var quit = false
    var event = SDL_Event()
    while !quit {
        while SDL_PollEvent(&event) != 0 {
            switch SDL_EventType(event.type) {
            case SDL_QUIT,
                 SDL_KEYUP where event.key.keysym.sym == SDLK_ESCAPE.rawValue:
                quit = true

            default:
                break
            }
        }

        guard let surface = layer.nextDrawable() else {
            break
        }

        color.blue = (color.blue > 1.0) ? 0 : color.blue + 0.01

        let pass = MTLRenderPassDescriptor()
        pass.colorAttachments[0].clearColor = color
        pass.colorAttachments[0].loadAction = .clear
        pass.colorAttachments[0].storeAction = .store
        pass.colorAttachments[0].texture = surface.texture

        guard let buffer = queue.makeCommandBuffer() else {
            fatalError("could not create command buffer")
        }

        guard let encoder = buffer.makeRenderCommandEncoder(descriptor: pass) else {
            fatalError("could not create render command encoder")
        }

        encoder.endEncoding()

        buffer.present(surface)
        buffer.commit()
    }

    SDL_DestroyRenderer(renderer)
    SDL_DestroyWindow(window)
    SDL_Quit()

#endif
