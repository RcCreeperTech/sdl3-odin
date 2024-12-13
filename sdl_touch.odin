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


// # CategoryTouch
//
// SDL touch management.


TouchID :: distinct c.uint64_t
FingerID :: distinct c.uint64_t

TouchDeviceType :: enum c.int {
	INVALID = -1,
	DIRECT, /* touch screen with window-relative coordinates */
	INDIRECT_ABSOLUTE, /* trackpad with absolute device coordinates */
	INDIRECT_RELATIVE, /* trackpad with screen cursor-relative coordinates */
}


// Data about a single finger in a multitouch event.
//
// Each touch even is a collection of fingers that are simultaneously in
// contact with the touch device (so a "touch" can be a "multitouch," in
// reality), and this struct reports details of the specific fingers.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa GetTouchFingers

Finger :: struct {
	id:       FingerID, /**< the finger ID */
	x:        c.float, /**< the x-axis location of the touch event, normalized (0...1) */
	y:        c.float, /**< the y-axis location of the touch event, normalized (0...1) */
	pressure: c.float, /**< the quantity of pressure applied, normalized (0...1) */
}

/* Used as the device ID for mouse events simulated with touch input */
TOUCH_MOUSEID :: transmute(MouseID)i32(-1)

/* Used as the TouchID for touch events simulated with mouse input */
MOUSE_TOUCHID :: transmute(TouchID)i64(-1)


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get a list of registered touch devices.
	//
	// On some platforms SDL first sees the touch device if it was actually used.
	// Therefore the returned list might be empty, although devices are available.
	// After using all devices at least once the number will be correct.
	//
	// \param count a pointer filled in with the number of devices returned, may
	//              be NULL.
	// \returns a 0 terminated array of touch device IDs or NULL on failure; call
	//          GetError() for more information. This should be freed with
	//          free() when it is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.

	GetTouchDevices :: proc(count: ^c.int) -> ^TouchID ---


	// Get the touch device name as reported from the driver.
	//
	// \param touchID the touch device instance ID.
	// \returns touch device name, or NULL on failure; call GetError() for
	//          more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetTouchDeviceName :: proc(touchID: TouchID) -> cstring ---


	// Get the type of the given touch device.
	//
	// \param touchID the ID of a touch device.
	// \returns touch device type.
	//
	// \since This function is available since SDL 3.0.0.

	GetTouchDeviceType :: proc(touchID: TouchID) -> TouchDeviceType ---


	// Get a list of active fingers for a given touch device.
	//
	// \param touchID the ID of a touch device.
	// \param count a pointer filled in with the number of fingers returned, can
	//              be NULL.
	// \returns a NULL terminated array of Finger pointers or NULL on failure;
	//          call GetError() for more information. This is a single
	//          allocation that should be freed with free() when it is no
	//          longer needed.
	//
	// \since This function is available since SDL 3.0.0.

	GetTouchFingers :: proc(touchID: TouchID, count: ^c.int) -> [^]^Finger ---
}
