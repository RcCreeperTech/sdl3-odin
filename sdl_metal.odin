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


// # CategoryMetal
//
// Functions to creating Metal layers and views on SDL windows.


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


// A handle to a CAMetalLayer-backed NSView (macOS) or UIView (iOS/tvOS).
//
// \since This datatype is available since SDL 3.0.0.

MetalView :: distinct rawptr


//  \name Metal support functions

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Create a CAMetalLayer-backed NSView/UIView and attach it to the specified
	// window.
	//
	// On macOS, this does *not* associate a MTLDevice with the CAMetalLayer on
	// its own. It is up to user code to do that.
	//
	// The returned handle can be casted directly to a NSView or UIView. To access
	// the backing CAMetalLayer, call SDL_Metal_GetLayer().
	//
	// \param window the window.
	// \returns handle NSView or UIView.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_Metal_DestroyView
	// \sa SDL_Metal_GetLayer

	Metal_CreateView :: proc(window: ^Window) -> MetalView ---

	// Destroy an existing SDL_MetalView object.
	//
	// This should be called before SDL_DestroyWindow, if SDL_Metal_CreateView was
	// called after SDL_CreateWindow.
	//
	// \param view the SDL_MetalView object.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_Metal_CreateView

	Metal_DestroyView :: proc(view: MetalView) ---

	// Get a pointer to the backing CAMetalLayer for the given view.
	//
	// \param view the SDL_MetalView object.
	// \returns a pointer.
	//
	// \since This function is available since SDL 3.0.0.

	Metal_GetLayer :: proc(view: MetalView) -> rawptr ---
}
