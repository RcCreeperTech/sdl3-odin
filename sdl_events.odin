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


// # CategoryEvents
//
// Event queue management.


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

/* General keyboard/mouse/pen state definitions */


// The types of events that can be delivered.
//
// \since This enum is available since SDL 3.0.0.

EventType :: enum c.int {
	FIRST = 0, /**< Unused (do not remove) */

	/* Application events */
	QUIT = 0x100, /**< User-requested quit */

	/* These application events have special meaning on iOS and Android, see README-ios.md and README-android.md for details */
	TERMINATING, /**< The application is being terminated by the OS. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationWillTerminate()
                                     Called on Android in onDestroy()
                                */
	LOW_MEMORY, /**< The application is low on memory, free memory if possible. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationDidReceiveMemoryWarning()
                                     Called on Android in onTrimMemory()
                                */
	WILL_ENTER_BACKGROUND, /**< The application is about to enter the background. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationWillResignActive()
                                     Called on Android in onPause()
                                */
	DID_ENTER_BACKGROUND, /**< The application did enter the background and may not get CPU for some time. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationDidEnterBackground()
                                     Called on Android in onPause()
                                */
	WILL_ENTER_FOREGROUND, /**< The application is about to enter the foreground. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationWillEnterForeground()
                                     Called on Android in onResume()
                                */
	DID_ENTER_FOREGROUND, /**< The application is now interactive. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationDidBecomeActive()
                                     Called on Android in onResume()
                                */
	LOCALE_CHANGED, /**< The user's locale preferences have changed. */
	SYSTEM_THEME_CHANGED, /**< The system theme changed */

	/* Display events */
	/* 0x150 was SDL_DISPLAYEVENT, reserve the number for sdl2-compat */
	DISPLAY_ORIENTATION = 0x151, /**< Display orientation has changed to data1 */
	DISPLAY_ADDED, /**< Display has been added to the system */
	DISPLAY_REMOVED, /**< Display has been removed from the system */
	DISPLAY_MOVED, /**< Display has changed position */
	DISPLAY_DESKTOP_MODE_CHANGED, /**< Display has changed desktop mode */
	DISPLAY_CURRENT_MODE_CHANGED, /**< Display has changed current mode */
	DISPLAY_CONTENT_SCALE_CHANGED, /**< Display has changed content scale */
	DISPLAY_FIRST = DISPLAY_ORIENTATION,
	DISPLAY_LAST = DISPLAY_CONTENT_SCALE_CHANGED,

	/* Window events */
	/* 0x200 was SDL_WINDOWEVENT, reserve the number for sdl2-compat */
	/* 0x201 was SYSWM, reserve the number for sdl2-compat */
	WINDOW_SHOWN = 0x202, /**< Window has been shown */
	WINDOW_HIDDEN, /**< Window has been hidden */
	WINDOW_EXPOSED, /**< Window has been exposed and should be redrawn, and can be redrawn directly from event watchers for this event */
	WINDOW_MOVED, /**< Window has been moved to data1, data2 */
	WINDOW_RESIZED, /**< Window has been resized to data1xdata2 */
	WINDOW_PIXEL_SIZE_CHANGED, /**< The pixel size of the window has changed to data1xdata2 */
	WINDOW_METAL_VIEW_RESIZED, /**< The pixel size of a Metal view associated with the window has changed */
	WINDOW_MINIMIZED, /**< Window has been minimized */
	WINDOW_MAXIMIZED, /**< Window has been maximized */
	WINDOW_RESTORED, /**< Window has been restored to normal size and position */
	WINDOW_MOUSE_ENTER, /**< Window has gained mouse focus */
	WINDOW_MOUSE_LEAVE, /**< Window has lost mouse focus */
	WINDOW_FOCUS_GAINED, /**< Window has gained keyboard focus */
	WINDOW_FOCUS_LOST, /**< Window has lost keyboard focus */
	WINDOW_CLOSE_REQUESTED, /**< The window manager requests that the window be closed */
	WINDOW_HIT_TEST, /**< Window had a hit test that wasn't SDL_HITTEST_NORMAL */
	WINDOW_ICCPROF_CHANGED, /**< The ICC profile of the window's display has changed */
	WINDOW_DISPLAY_CHANGED, /**< Window has been moved to display data1 */
	WINDOW_DISPLAY_SCALE_CHANGED, /**< Window display scale has been changed */
	WINDOW_SAFE_AREA_CHANGED, /**< The window safe area has been changed */
	WINDOW_OCCLUDED, /**< The window has been occluded */
	WINDOW_ENTER_FULLSCREEN, /**< The window has entered fullscreen mode */
	WINDOW_LEAVE_FULLSCREEN, /**< The window has left fullscreen mode */
	WINDOW_DESTROYED, /**< The window with the associated ID is being or has been destroyed. If this message is being handled
                                             in an event watcher, the window handle is still valid and can still be used to retrieve any userdata
                                             associated with the window. Otherwise, the handle has already been destroyed and all resources
                                             associated with it are invalid */
	WINDOW_HDR_STATE_CHANGED, /**< Window HDR properties have changed */
	WINDOW_FIRST = WINDOW_SHOWN,
	WINDOW_LAST = WINDOW_HDR_STATE_CHANGED,

	/* Keyboard events */
	KEY_DOWN = 0x300, /**< Key pressed */
	KEY_UP, /**< Key released */
	TEXT_EDITING, /**< Keyboard text editing (composition) */
	TEXT_INPUT, /**< Keyboard text input */
	KEYMAP_CHANGED, /**< Keymap changed due to a system event such as an
                                            input language or keyboard layout change. */
	KEYBOARD_ADDED, /**< A new keyboard has been inserted into the system */
	KEYBOARD_REMOVED, /**< A keyboard has been removed */
	TEXT_EDITING_CANDIDATES, /**< Keyboard text editing candidates */

	/* Mouse events */
	MOUSE_MOTION = 0x400, /**< Mouse moved */
	MOUSE_BUTTON_DOWN, /**< Mouse button pressed */
	MOUSE_BUTTON_UP, /**< Mouse button released */
	MOUSE_WHEEL, /**< Mouse wheel motion */
	MOUSE_ADDED, /**< A new mouse has been inserted into the system */
	MOUSE_REMOVED, /**< A mouse has been removed */

	/* Joystick events */
	JOYSTICK_AXIS_MOTION = 0x600, /**< Joystick axis motion */
	JOYSTICK_BALL_MOTION, /**< Joystick trackball motion */
	JOYSTICK_HAT_MOTION, /**< Joystick hat position change */
	JOYSTICK_BUTTON_DOWN, /**< Joystick button pressed */
	JOYSTICK_BUTTON_UP, /**< Joystick button released */
	JOYSTICK_ADDED, /**< A new joystick has been inserted into the system */
	JOYSTICK_REMOVED, /**< An opened joystick has been removed */
	JOYSTICK_BATTERY_UPDATED, /**< Joystick battery level change */
	JOYSTICK_UPDATE_COMPLETE, /**< Joystick update is complete */

	/* Gamepad events */
	GAMEPAD_AXIS_MOTION = 0x650, /**< Gamepad axis motion */
	GAMEPAD_BUTTON_DOWN, /**< Gamepad button pressed */
	GAMEPAD_BUTTON_UP, /**< Gamepad button released */
	GAMEPAD_ADDED, /**< A new gamepad has been inserted into the system */
	GAMEPAD_REMOVED, /**< A gamepad has been removed */
	GAMEPAD_REMAPPED, /**< The gamepad mapping was updated */
	GAMEPAD_TOUCHPAD_DOWN, /**< Gamepad touchpad was touched */
	GAMEPAD_TOUCHPAD_MOTION, /**< Gamepad touchpad finger was moved */
	GAMEPAD_TOUCHPAD_UP, /**< Gamepad touchpad finger was lifted */
	GAMEPAD_SENSOR_UPDATE, /**< Gamepad sensor was updated */
	GAMEPAD_UPDATE_COMPLETE, /**< Gamepad update is complete */
	GAMEPAD_STEAM_HANDLE_UPDATED, /**< Gamepad Steam handle has changed */

	/* Touch events */
	FINGER_DOWN = 0x700,
	FINGER_UP,
	FINGER_MOTION,

	/* 0x800, 0x801, and 0x802 were the Gesture events from SDL2. Do not reuse these values! sdl2-compat needs them! */

	/* Clipboard events */
	CLIPBOARD_UPDATE = 0x900, /**< The clipboard or primary selection changed */

	/* Drag and drop events */
	DROP_FILE = 0x1000, /**< The system requests a file open */
	DROP_TEXT, /**< text/plain drag-and-drop event */
	DROP_BEGIN, /**< A new set of drops is beginning (NULL filename) */
	DROP_COMPLETE, /**< Current set of drops is now complete (NULL filename) */
	DROP_POSITION, /**< Position while moving over the window */

	/* Audio hotplug events */
	AUDIO_DEVICE_ADDED = 0x1100, /**< A new audio device is available */
	AUDIO_DEVICE_REMOVED, /**< An audio device has been removed. */
	AUDIO_DEVICE_FORMAT_CHANGED, /**< An audio device's format has been changed by the system. */

	/* Sensor events */
	SENSOR_UPDATE = 0x1200, /**< A sensor was updated */

	/* Pressure-sensitive pen events */
	PEN_PROXIMITY_IN = 0x1300, /**< Pressure-sensitive pen has become available */
	PEN_PROXIMITY_OUT, /**< Pressure-sensitive pen has become unavailable */
	PEN_DOWN, /**< Pressure-sensitive pen touched drawing surface */
	PEN_UP, /**< Pressure-sensitive pen stopped touching drawing surface */
	PEN_BUTTON_DOWN, /**< Pressure-sensitive pen button pressed */
	PEN_BUTTON_UP, /**< Pressure-sensitive pen button released */
	PEN_MOTION, /**< Pressure-sensitive pen is moving on the tablet */
	PEN_AXIS, /**< Pressure-sensitive pen angle/pressure/etc changed */

	/* Camera hotplug events */
	CAMERA_DEVICE_ADDED = 0x1400, /**< A new camera device is available */
	CAMERA_DEVICE_REMOVED, /**< A camera device has been removed. */
	CAMERA_DEVICE_APPROVED, /**< A camera device has been approved for use by the user. */
	CAMERA_DEVICE_DENIED, /**< A camera device has been denied for use by the user. */

	/* Render events */
	RENDER_TARGETS_RESET = 0x2000, /**< The render targets have been reset and their contents need to be updated */
	RENDER_DEVICE_RESET, /**< The device has been reset and all textures need to be recreated */

	/* Internal events */
	POLL_SENTINEL = 0x7F00, /**< Signals the end of an event poll cycle */

	/** Events USER through SDL_EVENT_LAST are for your use,
     *  and should be allocated with SDL_RegisterEvents()
     */
	USER = 0x8000,

	/**
     *  This last event is only for bounding internal arrays
     */
	LAST = 0xFFFF,

	/* This just makes sure the enum is the size of Uint32 */
	ENUM_PADDING = 0x7FFFFFFF,
}


// Fields shared by every event
//
// \since This struct is available since SDL 3.0.0.
CommonEvent :: struct {
	type:      c.uint32_t, /**< Event type, shared with all events, Uint32 to cover user events which are not in the SDL_EventType enumeration */
	reserved:  c.uint32_t,
	timestamp: c.uint64_t, /**< In nanoseconds, populated using SDL_GetTicksNS() */
}


// Display state change event data (event.display.*)
//
// \since This struct is available since SDL 3.0.0.
DisplayEvent :: struct {
	using common: CommonEvent, /**< SDL_DISPLAYEVENT_* */
	displayID:    DisplayID, /**< The associated display */
	data1:        c.int32_t, /**< event dependent data */
	data2:        c.int32_t, /**< event dependent data */
}


// Window state change event data (event.window.*)
//
// \since This struct is available since SDL 3.0.0.

WindowEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_WINDOW_* */
	windowID:     WindowID, /**< The associated window */
	data1:        c.int32_t, /**< event dependent data */
	data2:        c.int32_t, /**< event dependent data */
}


// Keyboard device event structure (event.kdevice.*)
//
// \since This struct is available since SDL 3.0.0.

KeyboardDeviceEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_KEYBOARD_ADDED or SDL_EVENT_KEYBOARD_REMOVED */
	which:        KeyboardID, /**< The keyboard instance id */
}


// Keyboard button event structure (event.key.*)
//
// The `key` is the base SDL_Keycode generated by pressing the `scancode`
// using the current keyboard layout, applying any options specified in
// SDL_HINT_KEYCODE_OPTIONS. You can get the SDL_Keycode corresponding to the
// event scancode and modifiers directly from the keyboard layout, bypassing
// SDL_HINT_KEYCODE_OPTIONS, by calling SDL_GetKeyFromScancode().
//
// \since This struct is available since SDL 3.0.0.
//
// \sa SDL_GetKeyFromScancode
// \sa SDL_HINT_KEYCODE_OPTIONS

KeyboardEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_KEY_DOWN or SDL_EVENT_KEY_UP */
	windowID:     WindowID, /**< The window with keyboard focus, if any */
	which:        KeyboardID, /**< The keyboard instance id, or 0 if unknown or virtual */
	scancode:     Scancode, /**< SDL physical key code */
	key:          Keycode, /**< SDL virtual key code */
	mod:          Keymod, /**< current key modifiers */
	raw:          c.uint16_t, /**< The platform dependent scancode for this event */
	down:         c.bool, /**< true if the key is pressed */
	repeat:       c.bool, /**< true if this is a key repeat */
}


// Keyboard text editing event structure (event.edit.*)
//
// The start cursor is the position, in UTF-8 characters, where new typing
// will be inserted into the editing text. The length is the number of UTF-8
// characters that will be replaced by new typing.
//
// \since This struct is available since SDL 3.0.0.

TextEditingEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_TEXT_EDITING */
	windowID:     WindowID, /**< The window with keyboard focus, if any */
	text:         cstring, /**< The editing text */
	start:        c.int32_t, /**< The start cursor of selected editing text, or -1 if not set */
	length:       c.int32_t, /**< The length of selected editing text, or -1 if not set */
}


// Keyboard IME candidates event structure (event.edit_candidates.*)
//
// \since This struct is available since SDL 3.0.0.

TextEditingCandidatesEvent :: struct {
	using common:                 CommonEvent, /**< SDL_EVENT_TEXT_EDITING_CANDIDATES */
	windowID:                     WindowID, /**< The window with keyboard focus, if any */
	candidates:                   [^]cstring, /**< The list of candidates, or NULL if there are no candidates available */
	num_candidates:               c.int32_t, /**< The number of strings in `candidates` */
	selected_candidate:           c.int32_t, /**< The index of the selected candidate, or -1 if no candidate is selected */
	horizontal:                   c.bool, /**< true if the list is horizontal, false if it's vertical */
	padding1, padding2, padding3: c.uint8_t,
}


// Keyboard text input event structure (event.text.*)
//
// This event will never be delivered unless text input is enabled by calling
// SDL_StartTextInput(). Text input is disabled by default!
//
// \since This struct is available since SDL 3.0.0.
//
// \sa SDL_StartTextInput
// \sa SDL_StopTextInput
TextInputEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_TEXT_INPUT */
	windowID:     WindowID, /**< The window with keyboard focus, if any */
	text:         cstring, /**< The input text, UTF-8 encoded */
}


// Mouse device event structure (event.mdevice.*)
//
// \since This struct is available since SDL 3.0.0.

MouseDeviceEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_MOUSE_ADDED or SDL_EVENT_MOUSE_REMOVED */
	which:        MouseID, /**< The mouse instance id */
}


// Mouse motion event structure (event.motion.*)
//
// \since This struct is available since SDL 3.0.0.

MouseMotionEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_MOUSE_MOTION */
	windowID:     WindowID, /**< The window with mouse focus, if any */
	which:        MouseID, /**< The mouse instance id or SDL_TOUCH_MOUSEID */
	state:        MouseButtonFlags, /**< The current button state */
	x:            c.float, /**< X coordinate, relative to window */
	y:            c.float, /**< Y coordinate, relative to window */
	xrel:         c.float, /**< The relative motion in the X direction */
	yrel:         c.float, /**< The relative motion in the Y direction */
}


// Mouse button event structure (event.button.*)
//
// \since This struct is available since SDL 3.0.0.

MouseButtonEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_MOUSE_BUTTON_DOWN or SDL_EVENT_MOUSE_BUTTON_UP */
	windowID:     WindowID, /**< The window with mouse focus, if any */
	which:        MouseID, /**< The mouse instance id, SDL_TOUCH_MOUSEID */
	button:       c.uint8_t, /**< The mouse button index */
	down:         c.bool, /**< true if the button is pressed */
	clicks:       c.uint8_t, /**< 1 for single-click, 2 for double-click, etc. */
	padding:      c.uint8_t,
	x:            c.float, /**< X coordinate, relative to window */
	y:            c.float, /**< Y coordinate, relative to window */
}


// Mouse wheel event structure (event.wheel.*)
//
// \since This struct is available since SDL 3.0.0.

MouseWheelEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_MOUSE_WHEEL */
	windowID:     WindowID, /**< The window with mouse focus, if any */
	which:        MouseID, /**< The mouse instance id, SDL_TOUCH_MOUSEID */
	x:            c.float, /**< The amount scrolled horizontally, positive to the right and negative to the left */
	y:            c.float, /**< The amount scrolled vertically, positive away from the user and negative toward the user */
	direction:    MouseWheelDirection, /**< Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back */
	mouse_x:      c.float, /**< X coordinate, relative to window */
	mouse_y:      c.float, /**< Y coordinate, relative to window */
}


// Joystick axis motion event structure (event.jaxis.*)
//
// \since This struct is available since SDL 3.0.0.

JoyAxisEvent :: struct {
	using joy:                    JoyDeviceEvent, /**< SDL_EVENT_JOYSTICK_AXIS_MOTION */
	axis:                         c.uint8_t, /**< The joystick axis index */
	padding1, padding2, padding3: c.uint8_t,
	value:                        c.int16_t, /**< The axis value (range: -32768 to 32767) */
	padding4:                     c.uint8_t,
}


// Joystick trackball motion event structure (event.jball.*)
//
// \since This struct is available since SDL 3.0.0.

JoyBallEvent :: struct {
	using joy:                    JoyDeviceEvent, /**< SDL_EVENT_JOYSTICK_BALL_MOTION */
	ball:                         c.uint8_t, /**< The joystick trackball index */
	padding1, padding2, padding3: c.uint8_t,
	xrel:                         c.int16_t, /**< The relative motion in the X direction */
	yrel:                         c.int16_t, /**< The relative motion in the Y direction */
}


// Joystick hat position change event structure (event.jhat.*)
//
// \since This struct is available since SDL 3.0.0.
JoyHatEvent :: struct {
	using joy:          JoyDeviceEvent, /**< SDL_EVENT_JOYSTICK_HAT_MOTION */
	hat:                c.uint8_t, /**< The joystick hat index */
	value:              c.uint8_t, /**< The hat position value.
                         *   \sa SDL_HAT_LEFTUP SDL_HAT_UP SDL_HAT_RIGHTUP
                         *   \sa SDL_HAT_LEFT SDL_HAT_CENTERED SDL_HAT_RIGHT
                         *   \sa SDL_HAT_LEFTDOWN SDL_HAT_DOWN SDL_HAT_RIGHTDOWN
                         *
                         *   Note that zero means the POV is centered.
                         */
	padding1, padding2: c.uint8_t,
}


// Joystick button event structure (event.jbutton.*)
//
// \since This struct is available since SDL 3.0.0.

JoyButtonEvent :: struct {
	using joy:          JoyDeviceEvent, /**< SDL_EVENT_JOYSTICK_BUTTON_DOWN or SDL_EVENT_JOYSTICK_BUTTON_UP */
	button:             c.uint8_t, /**< The joystick button index */
	down:               c.bool, /**< true if the button is pressed */
	padding1, padding2: c.uint8_t,
}


// Joystick device event structure (event.jdevice.*)
//
// \since This struct is available since SDL 3.0.0.

JoyDeviceEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_JOYSTICK_ADDED or SDL_EVENT_JOYSTICK_REMOVED or SDL_EVENT_JOYSTICK_UPDATE_COMPLETE */
	which:        JoystickID, /**< The joystick instance id */
}


// Joysick battery level change event structure (event.jbattery.*)
//
// \since This struct is available since SDL 3.0.0.

JoyBatteryEvent :: struct {
	using joy: JoyDeviceEvent, /**< SDL_EVENT_JOYSTICK_BATTERY_UPDATED */
	state:     PowerState, /**< The joystick battery state */
	percent:   c.int, /**< The joystick battery percent charge remaining */
}


// Gamepad axis motion event structure (event.gaxis.*)
//
// \since This struct is available since SDL 3.0.0.

GamepadAxisEvent :: struct {
	using joy:                    JoyDeviceEvent, /**< SDL_EVENT_GAMEPAD_AXIS_MOTION */
	axis:                         c.uint8_t, /**< The gamepad axis (SDL_GamepadAxis) */
	padding1, padding2, padding3: c.uint8_t,
	value:                        c.int16_t, /**< The axis value (range: -32768 to 32767) */
	padding4:                     c.uint16_t,
}


// Gamepad button event structure (event.gbutton.*)
//
// \since This struct is available since SDL 3.0.0.

GamepadButtonEvent :: struct {
	using joy:          JoyDeviceEvent, /**< SDL_EVENT_GAMEPAD_BUTTON_DOWN or SDL_EVENT_GAMEPAD_BUTTON_UP */
	button:             c.uint8_t, /**< The gamepad button (SDL_GamepadButton) */
	down:               c.bool, /**< true if the button is pressed */
	padding1, padding2: c.uint8_t,
}


// Gamepad device event structure (event.gdevice.*)
//
// \since This struct is available since SDL 3.0.0.

GamepadDeviceEvent :: JoyDeviceEvent
/**< SDL_EVENT_GAMEPAD_ADDED, SDL_EVENT_GAMEPAD_REMOVED, or SDL_EVENT_GAMEPAD_REMAPPED, SDL_EVENT_GAMEPAD_UPDATE_COMPLETE or SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED */


// Gamepad touchpad event structure (event.gtouchpad.*)
//
// \since This struct is available since SDL 3.0.0.

GamepadTouchpadEvent :: struct {
	using joy: JoyDeviceEvent, /**< SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN or SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION or SDL_EVENT_GAMEPAD_TOUCHPAD_UP */
	touchpad:  c.int32_t, /**< The index of the touchpad */
	finger:    c.int32_t, /**< The index of the finger on the touchpad */
	x:         c.float, /**< Normalized in the range 0...1 with 0 being on the left */
	y:         c.float, /**< Normalized in the range 0...1 with 0 being at the top */
	pressure:  c.float, /**< Normalized in the range 0...1 */
}


// Gamepad sensor event structure (event.gsensor.*)
//
// \since This struct is available since SDL 3.0.0.

GamepadSensorEvent :: struct {
	using joy:        JoyDeviceEvent, /**< SDL_EVENT_GAMEPAD_SENSOR_UPDATE */
	sensor:           c.int32_t, /**< The type of the sensor, one of the values of SDL_SensorType */
	data:             [3]c.float, /**< Up to 3 values from the sensor, as defined in SDL_sensor.h */
	sensor_timestamp: c.uint64_t, /**< The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock */
}


// Audio device event structure (event.adevice.*)
//
// \since This struct is available since SDL 3.0.0.

AudioDeviceEvent :: struct {
	using common:                 CommonEvent, /**< SDL_EVENT_AUDIO_DEVICE_ADDED, or SDL_EVENT_AUDIO_DEVICE_REMOVED, or SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED */
	which:                        AudioDeviceID, /**< SDL_AudioDeviceID for the device being added or removed or changing */
	recording:                    c.bool, /**< false if a playback device, true if a recording device. */
	padding1, padding2, padding3: c.uint8_t,
}


// Camera device event structure (event.cdevice.*)
//
// \since This struct is available since SDL 3.0.0.

CameraDeviceEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_CAMERA_DEVICE_ADDED, SDL_EVENT_CAMERA_DEVICE_REMOVED, SDL_EVENT_CAMERA_DEVICE_APPROVED, SDL_EVENT_CAMERA_DEVICE_DENIED */
	which:        CameraID, /**< SDL_CameraID for the device being added or removed or changing */
}


// Touch finger event structure (event.tfinger.*)
//
// \since This struct is available since SDL 3.0.0.

TouchFingerEvent :: struct {
	using commmon: CommonEvent, /**< SDL_EVENT_FINGER_MOTION or SDL_EVENT_FINGER_DOWN or SDL_EVENT_FINGER_UP */
	touchID:       TouchID, /**< The touch device id */
	fingerID:      FingerID,
	x:             c.float, /**< Normalized in the range 0...1 */
	y:             c.float, /**< Normalized in the range 0...1 */
	dx:            c.float, /**< Normalized in the range -1...1 */
	dy:            c.float, /**< Normalized in the range -1...1 */
	pressure:      c.float, /**< Normalized in the range 0...1 */
	windowID:      WindowID, /**< The window underneath the finger, if any */
}


// Pressure-sensitive pen proximity event structure (event.pmotion.*)
//
// When a pen becomes visible to the system (it is close enough to a tablet,
// etc), SDL will send an SDL_EVENT_PEN_PROXIMITY_IN event with the new pen's
// ID. This ID is valid until the pen leaves proximity again (has been removed
// from the tablet's area, the tablet has been unplugged, etc). If the same
// pen reenters proximity again, it will be given a new ID.
//
// Note that "proximity" means "close enough for the tablet to know the tool
// is there." The pen touching and lifting off from the tablet while not
// leaving the area are handled by SDL_EVENT_PEN_DOWN and SDL_EVENT_PEN_UP.
//
// \since This struct is available since SDL 3.0.0.

PenProximityEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_PEN_PROXIMITY_IN or SDL_EVENT_PEN_PROXIMITY_OUT */
	windowID:     WindowID, /**< The window with mouse focus, if any */
	which:        PenID, /**< The pen instance id */
}


// Pressure-sensitive pen motion event structure (event.pmotion.*)
//
// Depending on the hardware, you may get motion events when the pen is not
// touching a tablet, for tracking a pen even when it isn't drawing. You
// should listen for SDL_EVENT_PEN_DOWN and SDL_EVENT_PEN_UP events, or check
// `pen_state & SDL_PEN_INPUT_DOWN` to decide if a pen is "drawing" when
// dealing with pen motion.
//
// \since This struct is available since SDL 3.0.0.

PenMotionEvent :: struct {
	using ppe: PenProximityEvent, /**< SDL_EVENT_PEN_MOTION */
	pen_state: PenInputFlags, /**< Complete pen input state at time of event */
	x:         c.float, /**< X coordinate, relative to window */
	y:         c.float, /**< Y coordinate, relative to window */
}


// Pressure-sensitive pen touched event structure (event.ptouch.*)
//
// These events come when a pen touches a surface (a tablet, etc), or lifts
// off from one.
//
// \since This struct is available since SDL 3.0.0.

PenTouchEvent :: struct {
	using ppe: PenProximityEvent, /**< SDL_EVENT_PEN_DOWN or SDL_EVENT_PEN_UP */
	pen_state: PenInputFlags, /**< Complete pen input state at time of event */
	x:         c.float, /**< X coordinate, relative to window */
	y:         c.float, /**< Y coordinate, relative to window */
	eraser:    c.bool, /**< true if eraser end is used (not all pens support this). */
	down:      c.bool, /**< true if the pen is touching or false if the pen is lifted off */
}


// Pressure-sensitive pen button event structure (event.pbutton.*)
//
// This is for buttons on the pen itself that the user might click. The pen
// itself pressing down to draw triggers a SDL_EVENT_PEN_DOWN event instead.
//
// \since This struct is available since SDL 3.0.0.

PenButtonEvent :: struct {
	using ppe: PenProximityEvent, /**< SDL_EVENT_PEN_BUTTON_DOWN or SDL_EVENT_PEN_BUTTON_UP */
	pen_state: PenInputFlags, /**< Complete pen input state at time of event */
	x:         c.float, /**< X coordinate, relative to window */
	y:         c.float, /**< Y coordinate, relative to window */
	button:    c.uint8_t, /**< The pen button index (first button is 1). */
	down:      c.bool, /**< true if the button is pressed */
}


// Pressure-sensitive pen pressure / angle event structure (event.paxis.*)
//
// You might get some of these events even if the pen isn't touching the
// tablet.
//
// \since This struct is available since SDL 3.0.0.

PenAxisEvent :: struct {
	using ppe: PenProximityEvent, /**< SDL_EVENT_PEN_AXIS */
	pen_state: PenInputFlags, /**< Complete pen input state at time of event */
	x:         c.float, /**< X coordinate, relative to window */
	y:         c.float, /**< Y coordinate, relative to window */
	axis:      PenAxis, /**< Axis that has changed */
	value:     c.float, /**< New value of axis */
}


// An event used to drop text or request a file open by the system
// (event.drop.*)
//
// \since This struct is available since SDL 3.0.0.

DropEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_DROP_BEGIN or SDL_EVENT_DROP_FILE or SDL_EVENT_DROP_TEXT or SDL_EVENT_DROP_COMPLETE or SDL_EVENT_DROP_POSITION */
	windowID:     WindowID, /**< The window that was dropped on, if any */
	x:            c.float, /**< X coordinate, relative to window (not on begin) */
	y:            c.float, /**< Y coordinate, relative to window (not on begin) */
	source:       cstring, /**< The source app that sent this drop event, or NULL if that isn't available */
	data:         cstring, /**< The text for SDL_EVENT_DROP_TEXT and the file name for SDL_EVENT_DROP_FILE, NULL for other events */
}


// An event triggered when the clipboard contents have changed
// (event.clipboard.*)
//
// \since This struct is available since SDL 3.0.0.

ClipboardEvent :: CommonEvent /**< SDL_EVENT_CLIPBOARD_UPDATE */

// Sensor event structure (event.sensor.*)
//
// \since This struct is available since SDL 3.0.0.

SensorEvent :: struct {
	using common:     CommonEvent, /**< SDL_EVENT_SENSOR_UPDATE */
	which:            SensorID, /**< The instance ID of the sensor */
	data:             [6]c.float, /**< Up to 6 values from the sensor - additional values can be queried using SDL_GetSensorData() */
	sensor_timestamp: c.uint64_t, /**< The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock */
}


// The "quit requested" event
//
// \since This struct is available since SDL 3.0.0.

QuitEvent :: CommonEvent /**< SDL_EVENT_QUIT */


// A user-defined event type (event.user.*)
//
// This event is unique; it is never created by SDL, but only by the
// application. The event can be pushed onto the event queue using
// SDL_PushEvent(). The contents of the structure members are completely up to
// the programmer; the only requirement is that '''type''' is a value obtained
// from SDL_RegisterEvents().
//
// \since This struct is available since SDL 3.0.0.

UserEvent :: struct {
	using common: CommonEvent, /**< SDL_EVENT_USER through SDL_EVENT_LAST-1, Uint32 because these are not in the SDL_EventType enumeration */
	windowID:     WindowID, /**< The associated window if any */
	code:         c.int32_t, /**< User defined event code */
	data1:        rawptr, /**< User defined data pointer */
	data2:        rawptr, /**< User defined data pointer */
}


// The structure for all events in SDL.
//
// \since This struct is available since SDL 3.0.0.

Event :: struct #raw_union {
	type:            EventType, /**< Event type, shared with all events, Uint32 to cover user events which are not in the SDL_EventType enumeration */
	common:          CommonEvent, /**< Common event data */
	display:         DisplayEvent, /**< Display event data */
	window:          WindowEvent, /**< Window event data */
	kdevice:         KeyboardDeviceEvent, /**< Keyboard device change event data */
	key:             KeyboardEvent, /**< Keyboard event data */
	edit:            TextEditingEvent, /**< Text editing event data */
	edit_candidates: TextEditingCandidatesEvent, /**< Text editing candidates event data */
	text:            TextInputEvent, /**< Text input event data */
	mdevice:         MouseDeviceEvent, /**< Mouse device change event data */
	motion:          MouseMotionEvent, /**< Mouse motion event data */
	button:          MouseButtonEvent, /**< Mouse button event data */
	wheel:           MouseWheelEvent, /**< Mouse wheel event data */
	jdevice:         JoyDeviceEvent, /**< Joystick device change event data */
	jaxis:           JoyAxisEvent, /**< Joystick axis event data */
	jball:           JoyBallEvent, /**< Joystick ball event data */
	jhat:            JoyHatEvent, /**< Joystick hat event data */
	jbutton:         JoyButtonEvent, /**< Joystick button event data */
	jbattery:        JoyBatteryEvent, /**< Joystick battery event data */
	gdevice:         GamepadDeviceEvent, /**< Gamepad device event data */
	gaxis:           GamepadAxisEvent, /**< Gamepad axis event data */
	gbutton:         GamepadButtonEvent, /**< Gamepad button event data */
	gtouchpad:       GamepadTouchpadEvent, /**< Gamepad touchpad event data */
	gsensor:         GamepadSensorEvent, /**< Gamepad sensor event data */
	adevice:         AudioDeviceEvent, /**< Audio device event data */
	cdevice:         CameraDeviceEvent, /**< Camera device event data */
	sensor:          SensorEvent, /**< Sensor event data */
	quit:            QuitEvent, /**< Quit request event data */
	user:            UserEvent, /**< Custom event data */
	tfinger:         TouchFingerEvent, /**< Touch finger event data */
	pproximity:      PenProximityEvent, /**< Pen proximity event data */
	ptouch:          PenTouchEvent, /**< Pen tip touching event data */
	pmotion:         PenMotionEvent, /**< Pen motion event data */
	pbutton:         PenButtonEvent, /**< Pen button event data */
	paxis:           PenAxisEvent, /**< Pen axis event data */
	drop:            DropEvent, /**< Drag and drop event data */
	clipboard:       ClipboardEvent, /**< Clipboard event data */

	/* This is necessary for ABI compatibility between Visual C++ and GCC.
       Visual C++ will respect the push pack pragma and use 52 bytes (size of
       SDL_TextEditingEvent, the largest structure for 32-bit and 64-bit
       architectures) for this union, and GCC will use the alignment of the
       largest datatype within the union, which is 8 bytes on 64-bit
       architectures.

       So... we'll add padding to force the size to be the same for both.

       On architectures where pointers are 16 bytes, this needs rounding up to
       the next multiple of 16, 64, and on architectures where pointers are
       even larger the size of SDL_UserEvent will dominate as being 3 pointers.
    */
	padding:         [128]c.uint8_t,
}

// Make sure we haven't broken binary compatibility
#assert(size_of(Event) == size_of([128]u8))

// The type of action to request from SDL_PeepEvents().
//
// \since This enum is available since SDL 3.0.0.

EventAction :: enum c.int {
	ADDEVENT, /**< Add events to the back of the queue. */
	PEEKEVENT, /**< Check but don't remove events from the queue front. */
	GETEVENT, /**< Retrieve/remove events from the front of the queue. */
}

// A function pointer used for callbacks that watch the event queue.
//
// \param userdata what was passed as `userdata` to SDL_SetEventFilter() or
//                 SDL_AddEventWatch, etc.
// \param event the event that triggered the callback.
// \returns true to permit event to be added to the queue, and false to
//          disallow it. When used with SDL_AddEventWatch, the return value is
//          ignored.
//
// \threadsafety SDL may call this callback at any time from any thread; the
//               application is responsible for locking resources the callback
//               touches that need to be protected.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa SDL_SetEventFilter
// \sa SDL_AddEventWatch

EventFilter :: #type proc "c" (userdata: rawptr, event: ^Event) -> c.bool

/* Function prototypes */
@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Pump the event loop, gathering events from the input devices.
	//
	// This function updates the event queue and internal input device state.
	//
	// **WARNING**: This should only be run in the thread that initialized the
	// video subsystem, and for extra safety, you should consider only doing those
	// things on the main thread in any case.
	//
	// SDL_PumpEvents() gathers all the pending input information from devices and
	// places it in the event queue. Without calls to SDL_PumpEvents() no events
	// would ever be placed on the queue. Often the need for calls to
	// SDL_PumpEvents() is hidden from the user since SDL_PollEvent() and
	// SDL_WaitEvent() implicitly call SDL_PumpEvents(). However, if you are not
	// polling or waiting for events (e.g. you are filtering them), then you must
	// call SDL_PumpEvents() to force an event queue update.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_PollEvent
	// \sa SDL_WaitEvent

	PumpEvents :: proc() ---


	// Check the event queue for messages and optionally return them.
	//
	// `action` may be any of the following:
	//
	// - `SDL_ADDEVENT`: up to `numevents` events will be added to the back of the
	//   event queue.
	// - `SDL_PEEKEVENT`: `numevents` events at the front of the event queue,
	//   within the specified minimum and maximum type, will be returned to the
	//   caller and will _not_ be removed from the queue. If you pass NULL for
	//   `events`, then `numevents` is ignored and the total number of matching
	//   events will be returned.
	// - `SDL_GETEVENT`: up to `numevents` events at the front of the event queue,
	//   within the specified minimum and maximum type, will be returned to the
	//   caller and will be removed from the queue.
	//
	// You may have to call SDL_PumpEvents() before calling this function.
	// Otherwise, the events may not be ready to be filtered when you call
	// SDL_PeepEvents().
	//
	// This function is thread-safe.
	//
	// \param events destination buffer for the retrieved events, may be NULL to
	//               leave the events in the queue and return the number of events
	//               that would have been stored.
	// \param numevents if action is SDL_ADDEVENT, the number of events to add
	//                  back to the event queue; if action is SDL_PEEKEVENT or
	//                  SDL_GETEVENT, the maximum number of events to retrieve.
	// \param action action to take; see [[#action|Remarks]] for details.
	// \param minType minimum value of the event type to be considered;
	//                SDL_EVENT_FIRST is a safe choice.
	// \param maxType maximum value of the event type to be considered;
	//                SDL_EVENT_LAST is a safe choice.
	// \returns the number of events actually stored or -1 on failure; call
	//          SDL_GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_PollEvent
	// \sa SDL_PumpEvents
	// \sa SDL_PushEvent

	PeepEvents :: proc(events: [^]Event, numevents: c.int, action: EventAction, minType, maxType: c.uint32_t) -> c.int ---


	// Check for the existence of a certain event type in the event queue.
	//
	// If you need to check for a range of event types, use SDL_HasEvents()
	// instead.
	//
	// \param type the type of event to be queried; see SDL_EventType for details.
	// \returns true if events matching `type` are present, or false if events
	//          matching `type` are not present.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasEvents

	HasEvent :: proc(type: c.uint32_t) -> c.bool ---


	// Check for the existence of certain event types in the event queue.
	//
	// If you need to check for a single event type, use SDL_HasEvent() instead.
	//
	// \param minType the low end of event type to be queried, inclusive; see
	//                SDL_EventType for details.
	// \param maxType the high end of event type to be queried, inclusive; see
	//                SDL_EventType for details.
	// \returns true if events with type >= `minType` and <= `maxType` are
	//          present, or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasEvents

	HasEvents :: proc(minType, maxType: c.uint32_t) -> c.bool ---


	// Clear events of a specific type from the event queue.
	//
	// This will unconditionally remove any events from the queue that match
	// `type`. If you need to remove a range of event types, use SDL_FlushEvents()
	// instead.
	//
	// It's also normal to just ignore events you don't care about in your event
	// loop without calling this function.
	//
	// This function only affects currently queued events. If you want to make
	// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
	// on the main thread immediately before the flush call.
	//
	// If you have user events with custom data that needs to be freed, you should
	// use SDL_PeepEvents() to remove and clean up those events before calling
	// this function.
	//
	// \param type the type of event to be cleared; see SDL_EventType for details.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_FlushEvents

	FlushEvent :: proc(type: c.uint32_t) ---


	// Clear events of a range of types from the event queue.
	//
	// This will unconditionally remove any events from the queue that are in the
	// range of `minType` to `maxType`, inclusive. If you need to remove a single
	// event type, use SDL_FlushEvent() instead.
	//
	// It's also normal to just ignore events you don't care about in your event
	// loop without calling this function.
	//
	// This function only affects currently queued events. If you want to make
	// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
	// on the main thread immediately before the flush call.
	//
	// \param minType the low end of event type to be cleared, inclusive; see
	//                SDL_EventType for details.
	// \param maxType the high end of event type to be cleared, inclusive; see
	//                SDL_EventType for details.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_FlushEvent

	FlushEvents :: proc(minType, maxType: c.uint32_t) ---


	// Poll for currently pending events.
	//
	// If `event` is not NULL, the next event is removed from the queue and stored
	// in the SDL_Event structure pointed to by `event`. The 1 returned refers to
	// this event, immediately stored in the SDL Event structure -- not an event
	// to follow.
	//
	// If `event` is NULL, it simply returns 1 if there is an event in the queue,
	// but will not remove it from the queue.
	//
	// As this function may implicitly call SDL_PumpEvents(), you can only call
	// this function in the thread that set the video mode.
	//
	// SDL_PollEvent() is the favored way of receiving system events since it can
	// be done from the main loop and does not suspend the main loop while waiting
	// on an event to be posted.
	//
	// The common practice is to fully process the event queue once every frame,
	// usually as a first step before updating the game's state:
	//
	// ```c
	// while (game_is_still_running) {
	//     SDL_Event event;
	//     while (SDL_PollEvent(&event)) {  // poll until all events are handled!
	//         // decide what to do with this event.
	//     }
	//
	//     // update game state, draw the current frame
	// }
	// ```
	//
	// \param event the SDL_Event structure to be filled with the next event from
	//              the queue, or NULL.
	// \returns true if this got an event or false if there are none available.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_PushEvent
	// \sa SDL_WaitEvent
	// \sa SDL_WaitEventTimeout

	PollEvent :: proc(event: ^Event) -> c.bool ---


	// Wait indefinitely for the next available event.
	//
	// If `event` is not NULL, the next event is removed from the queue and stored
	// in the SDL_Event structure pointed to by `event`.
	//
	// As this function may implicitly call SDL_PumpEvents(), you can only call
	// this function in the thread that initialized the video subsystem.
	//
	// \param event the SDL_Event structure to be filled in with the next event
	//              from the queue, or NULL.
	// \returns true on success or false if there was an error while waiting for
	//          events; call SDL_GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_PollEvent
	// \sa SDL_PushEvent
	// \sa SDL_WaitEventTimeout

	WaitEvent :: proc(event: ^Event) -> c.bool ---


	// Wait until the specified timeout (in milliseconds) for the next available
	// event.
	//
	// If `event` is not NULL, the next event is removed from the queue and stored
	// in the SDL_Event structure pointed to by `event`.
	//
	// As this function may implicitly call SDL_PumpEvents(), you can only call
	// this function in the thread that initialized the video subsystem.
	//
	// The timeout is not guaranteed, the actual wait time could be longer due to
	// system scheduling.
	//
	// \param event the SDL_Event structure to be filled in with the next event
	//              from the queue, or NULL.
	// \param timeoutMS the maximum number of milliseconds to wait for the next
	//                  available event.
	// \returns true if this got an event or false if the timeout elapsed without
	//          any events available.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_PollEvent
	// \sa SDL_PushEvent
	// \sa SDL_WaitEvent

	WaitEventTimeout :: proc(event: ^Event, timeoutMS: c.int32_t) -> c.bool ---


	// Add an event to the event queue.
	//
	// The event queue can actually be used as a two way communication channel.
	// Not only can events be read from the queue, but the user can also push
	// their own events onto it. `event` is a pointer to the event structure you
	// wish to push onto the queue. The event is copied into the queue, and the
	// caller may dispose of the memory pointed to after SDL_PushEvent() returns.
	//
	// Note: Pushing device input events onto the queue doesn't modify the state
	// of the device within SDL.
	//
	// This function is thread-safe, and can be called from other threads safely.
	//
	// Note: Events pushed onto the queue with SDL_PushEvent() get passed through
	// the event filter but events added with SDL_PeepEvents() do not.
	//
	// For pushing application-specific events, please use SDL_RegisterEvents() to
	// get an event type that does not conflict with other code that also wants
	// its own custom event types.
	//
	// \param event the SDL_Event to be added to the queue.
	// \returns true on success, false if the event was filtered or on failure;
	//          call SDL_GetError() for more information. A common reason for
	//          error is the event queue being full.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_PeepEvents
	// \sa SDL_PollEvent
	// \sa SDL_RegisterEvents

	PushEvent :: proc(event: ^Event) -> c.bool ---


	// Set up a filter to process all events before they change internal state and
	// are posted to the internal event queue.
	//
	// If the filter function returns true when called, then the event will be
	// added to the internal queue. If it returns false, then the event will be
	// dropped from the queue, but the internal state will still be updated. This
	// allows selective filtering of dynamically arriving events.
	//
	// **WARNING**: Be very careful of what you do in the event filter function,
	// as it may run in a different thread!
	//
	// On platforms that support it, if the quit event is generated by an
	// interrupt signal (e.g. pressing Ctrl-C), it will be delivered to the
	// application at the next event poll.
	//
	// There is one caveat when dealing with the SDL_QuitEvent event type. The
	// event filter is only called when the window manager desires to close the
	// application window. If the event filter returns 1, then the window will be
	// closed, otherwise the window will remain open if possible.
	//
	// Note: Disabled events never make it to the event filter function; see
	// SDL_SetEventEnabled().
	//
	// Note: If you just want to inspect events without filtering, you should use
	// SDL_AddEventWatch() instead.
	//
	// Note: Events pushed onto the queue with SDL_PushEvent() get passed through
	// the event filter, but events pushed onto the queue with SDL_PeepEvents() do
	// not.
	//
	// \param filter an SDL_EventFilter function to call when an event happens.
	// \param userdata a pointer that is passed to `filter`.
	//
	// \threadsafety SDL may call the filter callback at any time from any thread;
	//               the application is responsible for locking resources the
	//               callback touches that need to be protected.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_AddEventWatch
	// \sa SDL_SetEventEnabled
	// \sa SDL_GetEventFilter
	// \sa SDL_PeepEvents
	// \sa SDL_PushEvent

	SetEventFilter :: proc(filter: EventFilter, userdata: rawptr) ---


	// Query the current event filter.
	//
	// This function can be used to "chain" filters, by saving the existing filter
	// before replacing it with a function that will call that saved filter.
	//
	// \param filter the current callback function will be stored here.
	// \param userdata the pointer that is passed to the current event filter will
	//                 be stored here.
	// \returns true on success or false if there is no event filter set.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_SetEventFilter

	GetEventFilter :: proc(filter: ^EventFilter, userdata: rawptr) -> c.bool ---


	// Add a callback to be triggered when an event is added to the event queue.
	//
	// `filter` will be called when an event happens, and its return value is
	// ignored.
	//
	// **WARNING**: Be very careful of what you do in the event filter function,
	// as it may run in a different thread!
	//
	// If the quit event is generated by a signal (e.g. SIGINT), it will bypass
	// the internal queue and be delivered to the watch callback immediately, and
	// arrive at the next event poll.
	//
	// Note: the callback is called for events posted by the user through
	// SDL_PushEvent(), but not for disabled events, nor for events by a filter
	// callback set with SDL_SetEventFilter(), nor for events posted by the user
	// through SDL_PeepEvents().
	//
	// \param filter an SDL_EventFilter function to call when an event happens.
	// \param userdata a pointer that is passed to `filter`.
	// \returns true on success or false on failure; call SDL_GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_RemoveEventWatch
	// \sa SDL_SetEventFilter

	AddEventWatch :: proc(filter: EventFilter, userdata: rawptr) -> c.bool ---


	// Remove an event watch callback added with SDL_AddEventWatch().
	//
	// This function takes the same input as SDL_AddEventWatch() to identify and
	// delete the corresponding callback.
	//
	// \param filter the function originally passed to SDL_AddEventWatch().
	// \param userdata the pointer originally passed to SDL_AddEventWatch().
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_AddEventWatch

	RemoveEventWatch :: proc(filter: EventFilter, userdata: rawptr) ---


	// Run a specific filter function on the current event queue, removing any
	// events for which the filter returns false.
	//
	// See SDL_SetEventFilter() for more information. Unlike SDL_SetEventFilter(),
	// this function does not change the filter permanently, it only uses the
	// supplied filter until this function returns.
	//
	// \param filter the SDL_EventFilter function to call when an event happens.
	// \param userdata a pointer that is passed to `filter`.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_GetEventFilter
	// \sa SDL_SetEventFilter

	FilterEvents :: proc(filter: EventFilter, userdata: rawptr) ---


	// Set the state of processing events by type.
	//
	// \param type the type of event; see SDL_EventType for details.
	// \param enabled whether to process the event or not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_EventEnabled

	SetEventEnabled :: proc(type: c.uint32_t, enabled: c.bool) ---


	// Query the state of processing events by type.
	//
	// \param type the type of event; see SDL_EventType for details.
	// \returns true if the event is being processed, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_SetEventEnabled

	EventEnabled :: proc(type: c.uint32_t) -> c.bool ---


	// Allocate a set of user-defined events, and return the beginning event
	// number for that set of events.
	//
	// \param numevents the number of events to be allocated.
	// \returns the beginning event number, or 0 if numevents is invalid or if
	//          there are not enough user-defined events left.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_PushEvent

	RegisterEvents :: proc(numevents: c.int) -> c.uint32_t ---


	// Get window associated with an event.
	//
	// \param event an event containing a `windowID`.
	// \returns the associated window on success or NULL if there is none.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_PollEvent
	// \sa SDL_WaitEvent
	// \sa SDL_WaitEventTimeout

	GetWindowFromEvent :: proc(event: ^Event) -> ^Window ---
}
