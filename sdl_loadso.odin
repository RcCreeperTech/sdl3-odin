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

/* WIKI CATEGORY: SharedObject */

import "base:intrinsics"
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


// # CategorySharedObject
//
// System-dependent library loading routines.
//
// Shared objects are code that is programmatically loadable at runtime.
// Windows calls these "DLLs", Linux calls them "shared libraries", etc.
//
// To use them, build such a library, then call LoadObject() on it. Once
// loaded, you can use LoadFunction() on that object to find the address
// of its exported symbols. When done with the object, call UnloadObject()
// to dispose of it.
//
// Some things to keep in mind:
//
// - These functions only work on C function names. Other languages may have
//   name mangling and intrinsic language support that varies from compiler to
//   compiler.
// - Make sure you declare your function pointers with the same calling
//   convention as the actual library function. Your code will crash
//   mysteriously if you do not do this.
// - Avoid namespace collisions. If you load a symbol from the library, it is
//   not defined whether or not it goes into the global symbol namespace for
//   the application. If it does and it conflicts with symbols in your code or
//   other shared libraries, you will not get the results you expect. :)

// An opaque datatype that represents a loaded shared object.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa LoadObject
// \sa LoadFunction
// \sa UnloadObject

SharedObject :: distinct struct {}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Dynamically load a shared object.
	//
	// \param sofile a system-dependent name of the object file.
	// \returns an opaque pointer to the object handle or NULL on failure; call
	//          GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LoadFunction
	// \sa UnloadObject

	LoadObject :: proc(sofile: cstring) -> ^SharedObject ---


	// Look up the address of the named function in a shared object.
	//
	// This function pointer is no longer valid after calling UnloadObject().
	//
	// This function can only look up C function names. Other languages may have
	// name mangling and intrinsic language support that varies from compiler to
	// compiler.
	//
	// Make sure you declare your function pointers with the same calling
	// convention as the actual library function. Your code will crash
	// mysteriously if you do not do this.
	//
	// If the requested function doesn't exist, NULL is returned.
	//
	// \param handle a valid shared object handle returned by LoadObject().
	// \param name the name of the function to look up.
	// \returns a pointer to the function or NULL on failure; call GetError()
	//          for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LoadObject

	LoadFunction :: proc(handle: ^SharedObject, name: cstring) -> FunctionPointer ---


	// Unload a shared object from memory.
	//
	// Note that any pointers from this object looked up through
	// LoadFunction() will no longer be valid.
	//
	// \param handle a valid shared object handle returned by LoadObject().
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LoadObject

	UnloadObject :: proc(handle: ^SharedObject) ---
}
