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


// # CategoryMessagebox
//
// Message box support routines.
// MessageBox flags.

//
// If supported will display warning icon, etc.
//
// \since This datatype is available since SDL 3.0.0.

MessageBoxFlags :: bit_set[MessageBoxFlag]

MessageBoxFlag :: enum c.uint32_t {
	ERROR       = 5, /**< error dialog */
	WARNING     = 6, /**< warning dialog */
	INFORMATION = 7, /**< informational dialog */
}

// MessageBoxButtonData flags.
//
// \since This datatype is available since SDL 3.0.0.

MessageBoxButtonFlags :: bit_set[MessageBoxButtonFlag]

MessageBoxButtonFlag :: enum c.uint32_t {
	BUTTONS_LEFT_TO_RIGHT    = 8, /**< buttons placed left to right */
	BUTTONS_RIGHT_TO_LEFT    = 9, /**< buttons placed right to left */
	BUTTON_RETURNKEY_DEFAULT = 0, /**< Marks the default button when return is hit */
	BUTTON_ESCAPEKEY_DEFAULT = 1, /**< Marks the default button when escape is hit */
}


// Individual button data.
//
// \since This struct is available since SDL 3.0.0.

MessageBoxButtonData :: struct {
	flags:    MessageBoxButtonFlags,
	buttonID: int, /**< User defined button id (value returned via ShowMessageBox) */
	text:     cstring, /**< The UTF-8 button text */
}


// RGB value used in a message box color scheme
//
// \since This struct is available since SDL 3.0.0.

MessageBoxColor :: struct {
	r, g, b: c.uint8_t,
}


// An enumeration of indices inside the colors array of
// MessageBoxColorScheme.

MessageBoxColorType :: enum c.int {
	BACKGROUND,
	TEXT,
	BUTTON_BORDER,
	BUTTON_BACKGROUND,
	BUTTON_SELECTED,
	COUNT, /**< Size of the colors array of MessageBoxColorScheme. */
}


// A set of colors to use for message box dialogs
//
// \since This struct is available since SDL 3.0.0.

MessageBoxColorScheme :: struct {
	colors: [MessageBoxColorType]MessageBoxColor,
}


// MessageBox structure containing title, text, window, etc.
//
// \since This struct is available since SDL 3.0.0.

MessageBoxData :: struct {
	flags:       MessageBoxFlags,
	window:      ^Window, /**< Parent window, can be NULL */
	title:       cstring, /**< UTF-8 title */
	message:     cstring, /**< UTF-8 message text */
	numbuttons:  int,
	buttons:     MessageBoxButtonData,
	colorScheme: MessageBoxColorScheme, /**< MessageBoxColorScheme, can be NULL to use system settings */
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Create a modal message box.
	//
	// If your needs aren't complex, it might be easier to use
	// ShowSimpleMessageBox.
	//
	// This function should be called on the thread that created the parent
	// window, or on the main thread if the messagebox has no parent. It will
	// block execution of that thread until the user clicks a button or closes the
	// messagebox.
	//
	// This function may be called at any time, even before Init(). This makes
	// it useful for reporting errors like a failure to create a renderer or
	// OpenGL context.
	//
	// On X11, SDL rolls its own dialog box with X11 primitives instead of a
	// formal toolkit like GTK+ or Qt.
	//
	// Note that if Init() would fail because there isn't any available video
	// target, this function is likely to fail for the same reasons. If this is a
	// concern, check the return value from this function and fall back to writing
	// to stderr if you can.
	//
	// \param messageboxdata the MessageBoxData structure with title, text and
	//                       other options.
	// \param buttonid the pointer to which user id of hit button should be
	//                 copied.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ShowSimpleMessageBox

	ShowMessageBox :: proc(messageboxdata: ^MessageBoxData, buttonid: ^c.int) -> c.bool ---


	// Display a simple modal message box.
	//
	// If your needs aren't complex, this function is preferred over
	// ShowMessageBox.
	//
	// `flags` may be any of the following:
	//
	// - `MESSAGEBOX_ERROR`: error dialog
	// - `MESSAGEBOX_WARNING`: warning dialog
	// - `MESSAGEBOX_INFORMATION`: informational dialog
	//
	// This function should be called on the thread that created the parent
	// window, or on the main thread if the messagebox has no parent. It will
	// block execution of that thread until the user clicks a button or closes the
	// messagebox.
	//
	// This function may be called at any time, even before Init(). This makes
	// it useful for reporting errors like a failure to create a renderer or
	// OpenGL context.
	//
	// On X11, SDL rolls its own dialog box with X11 primitives instead of a
	// formal toolkit like GTK+ or Qt.
	//
	// Note that if Init() would fail because there isn't any available video
	// target, this function is likely to fail for the same reasons. If this is a
	// concern, check the return value from this function and fall back to writing
	// to stderr if you can.
	//
	// \param flags an MessageBoxFlags value.
	// \param title uTF-8 title text.
	// \param message uTF-8 message text.
	// \param window the parent window, or NULL for no parent.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ShowMessageBox

	ShowSimpleMessageBox :: proc(flags: MessageBoxFlags, title: cstring, message: cstring, window: ^Window) -> c.bool ---
}
