package sandbox

import ".."
import "core:fmt"
import "core:log"
import "core:math"


main :: proc() {
	logger := log.create_console_logger()
	defer log.destroy_console_logger(logger)

	context.logger = logger
	log.info("Running")


	if !sdl3.Init({.VIDEO}) {
		log.errorf("Unable to initialize SDL:\n%s\n", sdl3.GetError())
		return
	}
	defer sdl3.Quit()

	// Window
	window: ^sdl3.Window = nil
	renderer: ^sdl3.Renderer = nil
	if !sdl3.CreateWindowAndRenderer(
		"SDL3 Examples",
		1024,
		960,
		{.RESIZABLE},
		&window,
		&renderer,
	) {
		log.errorf("Unable to create window & renderer:\n%s\n", sdl3.GetError())
		return
	}

	event: sdl3.Event
	main_loop: for {
		if sdl3.PollEvent(&event) {
			// Quit event is clicking on the X on the window
			(event.type != sdl3.EventType.QUIT) or_break main_loop

			if event.type == sdl3.EventType.KEY_DOWN && event.key.key == .SDLK_ESCAPE {
				break main_loop

			}
		}

		now := cast(f64)sdl3.GetTicks() / 1000
		r := f32(0.5 + 0.5 * sdl3.sin(now))
		g := f32(0.5 + 0.5 * sdl3.sin(now + math.PI * 2 / 3))
		b := f32(0.5 + 0.5 * sdl3.sin(now + math.PI * 4 / 3))

		sdl3.SetRenderDrawColorFloat(renderer, r, g, b, 1.0)
		sdl3.RenderClear(renderer)

		sdl3.RenderPresent(renderer)
	}


}
