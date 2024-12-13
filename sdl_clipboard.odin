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


// # CategoryClipboard
//
// SDL provides access to the system clipboard, both for reading information
// from other processes and publishing information of its own.
//
// This is not just text! SDL apps can access and publish data by mimetype.

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


// Callback function that will be called when data for the specified mime-type
// is requested by the OS.
//
// The callback function is called with NULL as the mime_type when the
// clipboard is cleared or new data is set. The clipboard is automatically
// cleared in SDL_Quit().
//
// \param userdata a pointer to provided user data.
// \param mime_type the requested mime-type.
// \param size a pointer filled in with the length of the returned data.
// \returns a pointer to the data for the provided mime-type. Returning NULL
//          or setting length to 0 will cause no data to be sent to the
//          "receiver". It is up to the receiver to handle this. Essentially
//          returning no data is more or less undefined behavior and may cause
//          breakage in receiving applications. The returned data will not be
//          freed so it needs to be retained and dealt with internally.
//
// \since This function is available since SDL 3.0.0.
//
// \sa SDL_SetClipboardData
ClipboardDataCallback :: #type proc "c" (
	userdata: rawptr,
	mime_type: cstring,
	size: ^c.size_t,
) -> rawptr


// Callback function that will be called when the clipboard is cleared, or new
// data is set.
//
// \param userdata a pointer to provided user data.
//
// \since This function is available since SDL 3.0.0.
//
// \sa SDL_SetClipboardData
ClipboardCleanupCallback :: #type proc "c" (userdata: rawptr)


/* Function prototypes */
@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Put UTF-8 text into the clipboard.
	//
	// \param text the text to store in the clipboard.
	// \returns true on success or false on failure; call SDL_GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_GetClipboardText
	// \sa SDL_HasClipboardText

	SetClipboardText :: proc(text: cstring) -> c.bool ---


	// Get UTF-8 text from the clipboard.
	//
	// This functions returns empty string if there was not enough memory left for
	// a copy of the clipboard's content.
	//
	// \returns the clipboard text on success or an empty string on failure; call
	//          SDL_GetError() for more information. This should be freed with
	//          SDL_free() when it is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasClipboardText
	// \sa SDL_SetClipboardText

	GetClipboardText :: proc() -> cstring ---


	// Query whether the clipboard exists and contains a non-empty text string.
	//
	// \returns true if the clipboard has text, or false if it does not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_GetClipboardText
	// \sa SDL_SetClipboardText

	HasClipboardText :: proc() -> c.bool ---


	// Put UTF-8 text into the primary selection.
	//
	// \param text the text to store in the primary selection.
	// \returns true on success or false on failure; call SDL_GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_GetPrimarySelectionText
	// \sa SDL_HasPrimarySelectionText

	SetPrimarySelectionText :: proc(text: cstring) -> c.bool ---


	// Get UTF-8 text from the primary selection.
	//
	// This functions returns empty string if there was not enough memory left for
	// a copy of the primary selection's content.
	//
	// \returns the primary selection text on success or an empty string on
	//          failure; call SDL_GetError() for more information. This should be
	//          freed with SDL_free() when it is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasPrimarySelectionText
	// \sa SDL_SetPrimarySelectionText

	GetPrimarySelectionText :: proc() -> cstring ---


	// Query whether the primary selection exists and contains a non-empty text
	// string.
	//
	// \returns true if the primary selection has text, or false if it does not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_GetPrimarySelectionText
	// \sa SDL_SetPrimarySelectionText

	HasPrimarySelectionText :: proc() -> c.bool ---


	// Offer clipboard data to the OS.
	//
	// Tell the operating system that the application is offering clipboard data
	// for each of the proivded mime-types. Once another application requests the
	// data the callback function will be called allowing it to generate and
	// respond with the data for the requested mime-type.
	//
	// The size of text data does not include any terminator, and the text does
	// not need to be null terminated (e.g. you can directly copy a portion of a
	// document)
	//
	// \param callback a function pointer to the function that provides the
	//                 clipboard data.
	// \param cleanup a function pointer to the function that cleans up the
	//                clipboard data.
	// \param userdata an opaque pointer that will be forwarded to the callbacks.
	// \param mime_types a list of mime-types that are being offered.
	// \param num_mime_types the number of mime-types in the mime_types list.
	// \returns true on success or false on failure; call SDL_GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_ClearClipboardData
	// \sa SDL_GetClipboardData
	// \sa SDL_HasClipboardData

	SetClipboardData :: proc(callback: ClipboardDataCallback, cleanup: ClipboardCleanupCallback, userdata: rawptr, mime_types: [^]cstring, num_mime_types: c.size_t) -> c.bool ---


	// Clear the clipboard data.
	//
	// \returns true on success or false on failure; call SDL_GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_SetClipboardData

	ClearClipboardData :: proc() -> c.bool ---


	// Get the data from clipboard for a given mime type.
	//
	// The size of text data does not include the terminator, but the text is
	// guaranteed to be null terminated.
	//
	// \param mime_type the mime type to read from the clipboard.
	// \param size a pointer filled in with the length of the returned data.
	// \returns the retrieved data buffer or NULL on failure; call SDL_GetError()
	//          for more information. This should be freed with SDL_free() when it
	//          is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasClipboardData
	// \sa SDL_SetClipboardData

	GetClipboardData :: proc(mime_type: cstring, size: ^c.size_t) -> rawptr ---


	// Query whether there is data in the clipboard for the provided mime type.
	//
	// \param mime_type the mime type to check for data for.
	// \returns true if there exists data in clipboard for the provided mime type,
	//          false if it does not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_SetClipboardData
	// \sa SDL_GetClipboardData

	HasClipboardData :: proc(mime_type: cstring) -> c.bool ---


	// Retrieve the list of mime types available in the clipboard.
	//
	// \param num_mime_types a pointer filled with the number of mime types, may
	//                       be NULL.
	// \returns a null terminated array of strings with mime types, or NULL on
	//          failure; call SDL_GetError() for more information. This should be
	//          freed with SDL_free() when it is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_SetClipboardData

	GetClipboardMimeTypes :: proc(num_mime_types: ^c.size_t) -> [^]cstring ---
}
