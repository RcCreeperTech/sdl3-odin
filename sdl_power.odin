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


// # CategoryPower
//
// SDL power management routines.


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

// The basic state for the system's power supply.
//
// These are results returned by GetPowerInfo().
//
// \since This enum is available since SDL 3.0.0

PowerState :: enum c.int {
	ERROR = -1, /**< error determining power status */
	UNKNOWN, /**< cannot determine power status */
	ON_BATTERY, /**< Not plugged in, running on the battery */
	NO_BATTERY, /**< Plugged in, no battery available */
	CHARGING, /**< Plugged in, charging battery */
	CHARGED, /**< Plugged in, battery charged */
}


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get the current power supply details.
	//
	// You should never take a battery status as absolute truth. Batteries
	// (especially failing batteries) are delicate hardware, and the values
	// reported here are best estimates based on what that hardware reports. It's
	// not uncommon for older batteries to lose stored power much faster than it
	// reports, or completely drain when reporting it has 20 percent left, etc.
	//
	// Battery status can change at any time; if you are concerned with power
	// state, you should call this function frequently, and perhaps ignore changes
	// until they seem to be stable for a few seconds.
	//
	// It's possible a platform can only report battery percentage or time left
	// but not both.
	//
	// \param seconds a pointer filled in with the seconds of battery life left,
	//                or NULL to ignore. This will be filled in with -1 if we
	//                can't determine a value or there is no battery.
	// \param percent a pointer filled in with the percentage of battery life
	//                left, between 0 and 100, or NULL to ignore. This will be
	//                filled in with -1 we can't determine a value or there is no
	//                battery.
	// \returns the current battery state or `POWERSTATE_ERROR` on failure;
	//          call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetPowerInfo :: proc(seconds, percent: ^c.int) -> PowerState ---
}
