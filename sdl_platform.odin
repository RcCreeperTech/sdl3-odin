package sdl3

/*
  Simple DirectMedia Layer
  Copyright (C) 1997-2024 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/


// # CategoryPlatform
//
// SDL provides a means to identify the app's platform, both at compile time
// and runtime.


import "core:c"

when ODIN_OS != .Windows {
	foreign import lib "system:SDL3"
} else when ODIN_ARCH == .amd64 {
	foreign import lib "./lib/x64/SDL3.lib"
} else when ODIN_ARCH == .i386 {
	foreign import lib "./lib/x86/SDL3.lib"
} else when ODIN_ARCH == .amd64 {
	foreign import lib "./lib/arm64/SDL3.lib"
} else do #panic("Unsupported Architecture")


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get the name of the platform.
	//
	// Here are the names returned for some (but not all) supported platforms:
	//
	// - "Windows"
	// - "macOS"
	// - "Linux"
	// - "iOS"
	// - "Android"
	//
	// \returns the name of the platform. If the correct platform name is not
	//          available, returns a string beginning with the text "Unknown".
	//
	// \since This function is available since SDL 3.0.0.

	GetPlatform :: proc() -> cstring ---

}
