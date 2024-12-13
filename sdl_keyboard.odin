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


// # CategoryKeyboard
//
// SDL keyboard management.

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


// This is a unique ID for a keyboard for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// If the keyboard is disconnected and reconnected, it will get a new ID.
//
// The value 0 is an invalid ID.
//
// \since This datatype is available since SDL 3.0.0.

KeyboardID :: distinct c.uint32_t

// Text input type.
//
// These are the valid values for PROP_TEXTINPUT_TYPE_NUMBER. Not every
// value is valid on every platform, but where a value isn't supported, a
// reasonable fallback will be used.
//
// \since This enum is available since SDL 3.0.0.
//
// \sa StartTextInputWithProperties

TextInputType :: enum c.int {
	TEXT, /**< The input is text */
	TEXT_NAME, /**< The input is a person's name */
	TEXT_EMAIL, /**< The input is an e-mail address */
	TEXT_USERNAME, /**< The input is a username */
	TEXT_PASSWORD_HIDDEN, /**< The input is a secure password that is hidden */
	TEXT_PASSWORD_VISIBLE, /**< The input is a secure password that is visible */
	NUMBER, /**< The input is a number */
	NUMBER_PASSWORD_HIDDEN, /**< The input is a secure PIN that is hidden */
	NUMBER_PASSWORD_VISIBLE, /**< The input is a secure PIN that is visible */
}


// Auto capitalization type.
//
// These are the valid values for
// PROP_TEXTINPUT_AUTOCAPITALIZATION_NUMBER. Not every value is valid on
// every platform, but where a value isn't supported, a reasonable fallback
// will be used.
//
// \since This enum is available since SDL 3.0.0.
//
// \sa StartTextInputWithProperties

Capitalization :: enum c.int {
	NONE, /**< No auto-capitalization will be done */
	SENTENCES, /**< The first letter of sentences will be capitalized */
	WORDS, /**< The first letter of words will be capitalized */
	LETTERS, /**< All letters will be capitalized */
}

PROP_TEXTINPUT_TYPE_NUMBER :: "SDL.textinput.type"
PROP_TEXTINPUT_CAPITALIZATION_NUMBER :: "SDL.textinput.capitalization"
PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN :: "SDL.textinput.autocorrect"
PROP_TEXTINPUT_MULTILINE_BOOLEAN :: "SDL.textinput.multiline"
PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER :: "SDL.textinput.android.inputtype"


/* Function prototypes */

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Return whether a keyboard is currently connected.
	//
	// \returns true if a keyboard is connected, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyboards

	HasKeyboard :: proc() -> c.bool ---


	// Get a list of currently connected keyboards.
	//
	// Note that this will include any device or virtual driver that includes
	// keyboard functionality, including some mice, KVM switches, motherboard
	// power buttons, etc. You should wait for input from a device before you
	// consider it actively in use.
	//
	// \param count a pointer filled in with the number of keyboards returned, may
	//              be NULL.
	// \returns a 0 terminated array of keyboards instance IDs or NULL on failure;
	//          call GetError() for more information. This should be freed
	//          with free() when it is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyboardNameForID
	// \sa HasKeyboard

	GetKeyboards :: proc(count: ^c.int) -> ^KeyboardID ---


	// Get the name of a keyboard.
	//
	// This function returns "" if the keyboard doesn't have a name.
	//
	// \param instance_id the keyboard instance ID.
	// \returns the name of the selected keyboard or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyboards

	GetKeyboardNameForID :: proc(instance_id: KeyboardID) -> cstring ---


	// Query the window which currently has keyboard focus.
	//
	// \returns the window with keyboard focus.
	//
	// \since This function is available since SDL 3.0.0.

	GetKeyboardFocus :: proc() -> ^Window ---


	// Get a snapshot of the current state of the keyboard.
	//
	// The pointer returned is a pointer to an internal SDL array. It will be
	// valid for the whole lifetime of the application and should not be freed by
	// the caller.
	//
	// A array element with a value of true means that the key is pressed and a
	// value of false means that it is not. Indexes into this array are obtained
	// by using Scancode values.
	//
	// Use PumpEvents() to update the state array.
	//
	// This function gives you the current state after all events have been
	// processed, so if a key or button has been pressed and released before you
	// process events, then the pressed state will never show up in the
	// GetKeyboardState() calls.
	//
	// Note: This function doesn't take into account whether shift has been
	// pressed or not.
	//
	// \param numkeys if non-NULL, receives the length of the returned array.
	// \returns a pointer to an array of key states.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa PumpEvents
	// \sa ResetKeyboard

	GetKeyboardState :: proc(numkeys: ^c.int) -> ^c.bool ---


	// Clear the state of the keyboard.
	//
	// This function will generate key up events for all pressed keys.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyboardState

	ResetKeyboard :: proc() ---


	// Get the current key modifier state for the keyboard.
	//
	// \returns an OR'd combination of the modifier keys for the keyboard. See
	//          Keymod for details.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyboardState
	// \sa SetModState

	GetModState :: proc() -> Keymod ---


	// Set the current key modifier state for the keyboard.
	//
	// The inverse of GetModState(), SetModState() allows you to impose
	// modifier key states on your application. Simply pass your desired modifier
	// states into `modstate`. This value may be a bitwise, OR'd combination of
	// Keymod values.
	//
	// This does not change the keyboard state, only the key modifier flags that
	// SDL reports.
	//
	// \param modstate the desired Keymod for the keyboard.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetModState

	SetModState :: proc(modstate: Keymod) ---


	// Get the key code corresponding to the given scancode according to the
	// current keyboard layout.
	//
	// If you want to get the keycode as it would be delivered in key events,
	// including options specified in HINT_KEYCODE_OPTIONS, then you should
	// pass `key_event` as true. Otherwise this function simply translates the
	// scancode based on the given modifier state.
	//
	// \param scancode the desired Scancode to query.
	// \param modstate the modifier state to use when translating the scancode to
	//                 a keycode.
	// \param key_event true if the keycode will be used in key events.
	// \returns the Keycode that corresponds to the given Scancode.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyName
	// \sa GetScancodeFromKey

	GetKeyFromScancode :: proc(scancode: Scancode, modstate: Keymod, key_event: c.bool) -> Keycode ---


	// Get the scancode corresponding to the given key code according to the
	// current keyboard layout.
	//
	// Note that there may be multiple scancode+modifier states that can generate
	// this keycode, this will just return the first one found.
	//
	// \param key the desired Keycode to query.
	// \param modstate a pointer to the modifier state that would be used when the
	//                 scancode generates this key, may be NULL.
	// \returns the Scancode that corresponds to the given Keycode.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyFromScancode
	// \sa GetScancodeName

	GetScancodeFromKey :: proc(key: Keycode, modstate: ^Keymod) -> Scancode ---


	// Set a human-readable name for a scancode.
	//
	// \param scancode the desired Scancode.
	// \param name the name to use for the scancode, encoded as UTF-8. The string
	//             is not copied, so the pointer given to this function must stay
	//             valid while SDL is being used.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetScancodeName

	SetScancodeName :: proc(scancode: Scancode, name: cstring) -> c.bool ---


	// Get a human-readable name for a scancode.
	//
	// **Warning**: The returned name is by design not stable across platforms,
	// e.g. the name for `SCANCODE_LGUI` is "Left GUI" under Linux but "Left
	// Windows" under Microsoft Windows, and some scancodes like
	// `SCANCODE_NONUSBACKSLASH` don't have any name at all. There are even
	// scancodes that share names, e.g. `SCANCODE_RETURN` and
	// `SCANCODE_RETURN2` (both called "Return"). This function is therefore
	// unsuitable for creating a stable cross-platform two-way mapping between
	// strings and scancodes.
	//
	// \param scancode the desired Scancode to query.
	// \returns a pointer to the name for the scancode. If the scancode doesn't
	//          have a name this function returns an empty string ("").
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetScancodeFromKey
	// \sa GetScancodeFromName
	// \sa SetScancodeName

	GetScancodeName :: proc(scancode: Scancode) -> cstring ---


	// Get a scancode from a human-readable name.
	//
	// \param name the human-readable scancode name.
	// \returns the Scancode, or `SCANCODE_UNKNOWN` if the name wasn't
	//          recognized; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyFromName
	// \sa GetScancodeFromKey
	// \sa GetScancodeName

	GetScancodeFromName :: proc(name: cstring) -> Scancode ---


	// Get a human-readable name for a key.
	//
	// If the key doesn't have a name, this function returns an empty string ("").
	//
	// \param key the desired Keycode to query.
	// \returns a UTF-8 encoded string of the key name.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyFromName
	// \sa GetKeyFromScancode
	// \sa GetScancodeFromKey

	GetKeyName :: proc(key: Keycode) -> cstring ---


	// Get a key code from a human-readable name.
	//
	// \param name the human-readable key name.
	// \returns key code, or `SDLK_UNKNOWN` if the name wasn't recognized; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetKeyFromScancode
	// \sa GetKeyName
	// \sa GetScancodeFromName

	GetKeyFromName :: proc(name: cstring) -> Keycode ---


	// Start accepting Unicode text input events in a window.
	//
	// This function will enable text input (EVENT_TEXT_INPUT and
	// EVENT_TEXT_EDITING events) in the specified window. Please use this
	// function paired with StopTextInput().
	//
	// Text input events are not received by default.
	//
	// On some platforms using this function shows the screen keyboard.
	//
	// \param window the window to enable text input.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetTextInputArea
	// \sa StartTextInputWithProperties
	// \sa StopTextInput
	// \sa TextInputActive

	StartTextInput :: proc(window: ^Window) -> c.bool ---


	// Start accepting Unicode text input events in a window, with properties
	// describing the input.
	//
	// This function will enable text input (EVENT_TEXT_INPUT and
	// EVENT_TEXT_EDITING events) in the specified window. Please use this
	// function paired with StopTextInput().
	//
	// Text input events are not received by default.
	//
	// On some platforms using this function shows the screen keyboard.
	//
	// These are the supported properties:
	//
	// - `PROP_TEXTINPUT_TYPE_NUMBER` - an TextInputType value that
	//   describes text being input, defaults to TEXTINPUT_TYPE_TEXT.
	// - `PROP_TEXTINPUT_CAPITALIZATION_NUMBER` - an Capitalization value
	//   that describes how text should be capitalized, defaults to
	//   CAPITALIZE_SENTENCES for normal text entry, CAPITALIZE_WORDS for
	//   TEXTINPUT_TYPE_TEXT_NAME, and CAPITALIZE_NONE for e-mail
	//   addresses, usernames, and passwords.
	// - `PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN` - true to enable auto completion
	//   and auto correction, defaults to true.
	// - `PROP_TEXTINPUT_MULTILINE_BOOLEAN` - true if multiple lines of text
	//   are allowed. This defaults to true if HINT_RETURN_KEY_HIDES_IME is
	//   "0" or is not set, and defaults to false if HINT_RETURN_KEY_HIDES_IME
	//   is "1".
	//
	// On Android you can directly specify the input type:
	//
	// - `PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER` - the text input type to
	//   use, overriding other properties. This is documented at
	//   https://developer.android.com/reference/android/text/InputType
	//
	// \param window the window to enable text input.
	// \param props the properties to use.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetTextInputArea
	// \sa StartTextInput
	// \sa StopTextInput
	// \sa TextInputActive

	StartTextInputWithProperties :: proc(window: ^Window, props: PropertiesID) -> c.bool ---


	// Check whether or not Unicode text input events are enabled for a window.
	//
	// \param window the window to check.
	// \returns true if text input events are enabled else false.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StartTextInput

	TextInputActive :: proc(window: ^Window) -> c.bool ---


	// Stop receiving any text input events in a window.
	//
	// If StartTextInput() showed the screen keyboard, this function will hide
	// it.
	//
	// \param window the window to disable text input.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StartTextInput

	StopTextInput :: proc(window: ^Window) -> c.bool ---


	// Dismiss the composition window/IME without disabling the subsystem.
	//
	// \param window the window to affect.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StartTextInput
	// \sa StopTextInput

	ClearComposition :: proc(window: ^Window) -> c.bool ---


	// Set the area used to type Unicode text input.
	//
	// Native input methods may place a window with word suggestions near the
	// cursor, without covering the text being entered.
	//
	// \param window the window for which to set the text input area.
	// \param rect the Rect representing the text input area, in window
	//             coordinates, or NULL to clear it.
	// \param cursor the offset of the current cursor location relative to
	//               `rect->x`, in window coordinates.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextInputArea
	// \sa StartTextInput

	SetTextInputArea :: proc(window: ^Window, rect: ^Rect, cursor: c.int) -> c.bool ---


	// Get the area used to type Unicode text input.
	//
	// This returns the values previously set by SetTextInputArea().
	//
	// \param window the window for which to query the text input area.
	// \param rect a pointer to an Rect filled in with the text input area,
	//             may be NULL.
	// \param cursor a pointer to the offset of the current cursor location
	//               relative to `rect->x`, may be NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetTextInputArea

	GetTextInputArea :: proc(window: ^Window, rect: ^Rect, cursor: ^c.int) -> c.bool ---


	// Check whether the platform has screen keyboard support.
	//
	// \returns true if the platform has some screen keyboard support or false if
	//          not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StartTextInput
	// \sa ScreenKeyboardShown

	HasScreenKeyboardSupport :: proc() -> c.bool ---


	// Check whether the screen keyboard is shown for given window.
	//
	// \param window the window for which screen keyboard should be queried.
	// \returns true if screen keyboard is shown or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa HasScreenKeyboardSupport

	ScreenKeyboardShown :: proc(window: ^Window) -> c.bool ---
}
