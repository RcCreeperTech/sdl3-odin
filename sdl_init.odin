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


// # CategoryInit
//
// All SDL programs need to initialize the library before starting to work
// with it.
//
// Almost everything can simply call SDL_Init() near startup, with a handful
// of flags to specify subsystems to touch. These are here to make sure SDL
// does not even attempt to touch low-level pieces of the operating system
// that you don't intend to use. For example, you might be using SDL for video
// and input but chose an external library for audio, and in this case you
// would just need to leave off the `SDL_INIT_AUDIO` flag to make sure that
// external library has complete control.
//
// Most apps, when terminating, should call SDL_Quit(). This will clean up
// (nearly) everything that SDL might have allocated, and crucially, it'll
// make sure that the display's resolution is back to what the user expects if
// you had previously changed it for your game.
//
// SDL3 apps are strongly encouraged to call SDL_SetAppMetadata() at startup
// to fill in details about the program. This is completely optional, but it
// helps in small ways (we can provide an About dialog box for the macOS menu,
// we can name the app in the system's audio mixer, etc). Those that want to
// provide a _lot_ of information should look at the more-detailed
// SDL_SetAppMetadataProperty().

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

/* As of version 0.5, SDL is loaded dynamically into the application */


// Initialization flags for SDL_Init and/or SDL_InitSubSystem
//
// These are the flags which may be passed to SDL_Init(). You should specify
// the subsystems which you will be using in your application.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa SDL_Init
// \sa SDL_Quit
// \sa SDL_InitSubSystem
// \sa SDL_QuitSubSystem
// \sa SDL_WasInit
InitFlags :: bit_set[InitFlag]

InitFlag :: enum c.uint32_t {
	AUDIO    = 5, /**< `SDL_INIT_AUDIO` implies `SDL_INIT_EVENTS` */
	VIDEO    = 6, /**< `SDL_INIT_VIDEO` implies `SDL_INIT_EVENTS` */
	JOYSTICK = 10, /**< `SDL_INIT_JOYSTICK` implies `SDL_INIT_EVENTS`, should be initialized on the same thread as SDL_INIT_VIDEO on Windows if you don't set SDL_HINT_JOYSTICK_THREAD */
	HAPTIC   = 13,
	GAMEPAD  = 14, /**< `SDL_INIT_GAMEPAD` implies `SDL_INIT_JOYSTICK` */
	EVENTS   = 15,
	SENSOR   = 16, /**< `SDL_INIT_SENSOR` implies `SDL_INIT_EVENTS` */
	CAMERA   = 17, /**< `SDL_INIT_CAMERA` implies `SDL_INIT_EVENTS` */
}


// Return values for optional main callbacks.
//
// Returning SDL_APP_SUCCESS or SDL_APP_FAILURE from SDL_AppInit,
// SDL_AppEvent, or SDL_AppIterate will terminate the program and report
// success/failure to the operating system. What that means is
// platform-dependent. On Unix, for example, on success, the process error
// code will be zero, and on failure it will be 1. This interface doesn't
// allow you to return specific exit codes, just whether there was an error
// generally or not.
//
// Returning SDL_APP_CONTINUE from these functions will let the app continue
// to run.
//
// See
// [Main callbacks in SDL3](https://wiki.libsdl.org/SDL3/README/main-functions#main-callbacks-in-sdl3)
// for complete details.
//
// \since This enum is available since SDL 3.0.0.

AppResult :: enum c.int {
	CONTINUE, /**< Value that requests that the app continue from the main callbacks. */
	SUCCESS, /**< Value that requests termination with success from the main callbacks. */
	FAILURE, /**< Value that requests termination with error from the main callbacks. */
}

AppInit_func :: #type proc "c" (appstate: ^rawptr, argc: c.int, argv: [^]cstring) -> AppResult
AppIterate_func :: #type proc "c" (appstate: rawptr) -> AppResult
AppEvent_func :: #type proc "c" (appstate: rawptr, event: ^Event) -> AppResult
AppQuit_func :: #type proc "c" (appstate: rawptr, result: AppResult)

PROP_APP_METADATA_NAME_STRING :: "SDL.app.metadata.name"
PROP_APP_METADATA_VERSION_STRING :: "SDL.app.metadata.version"
PROP_APP_METADATA_IDENTIFIER_STRING :: "SDL.app.metadata.identifier"
PROP_APP_METADATA_CREATOR_STRING :: "SDL.app.metadata.creator"
PROP_APP_METADATA_COPYRIGHT_STRING :: "SDL.app.metadata.copyright"
PROP_APP_METADATA_URL_STRING :: "SDL.app.metadata.url"
PROP_APP_METADATA_TYPE_STRING :: "SDL.app.metadata.type"


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	// Initialize the SDL library.
	//
	// Init() simply forwards to calling InitSubSystem(). Therefore, the
	// two may be used interchangeably. Though for readability of your code
	// InitSubSystem() might be preferred.
	//
	// The file I/O (for example: IOFromFile) and threading (CreateThread)
	// subsystems are initialized by default. Message boxes
	// (ShowSimpleMessageBox) also attempt to work without initializing the
	// video subsystem, in hopes of being useful in showing an error dialog when
	// Init fails. You must specifically initialize other subsystems if you
	// use them in your application.
	//
	// Logging (such as Log) works without initialization, too.
	//
	// `flags` may be any of the following OR'd together:
	//
	// - `INIT_AUDIO`: audio subsystem; automatically initializes the events
	//   subsystem
	// - `INIT_VIDEO`: video subsystem; automatically initializes the events
	//   subsystem
	// - `INIT_JOYSTICK`: joystick subsystem; automatically initializes the
	//   events subsystem
	// - `INIT_HAPTIC`: haptic (force feedback) subsystem
	// - `INIT_GAMEPAD`: gamepad subsystem; automatically initializes the
	//   joystick subsystem
	// - `INIT_EVENTS`: events subsystem
	// - `INIT_SENSOR`: sensor subsystem; automatically initializes the events
	//   subsystem
	// - `INIT_CAMERA`: camera subsystem; automatically initializes the events
	//   subsystem
	//
	// Subsystem initialization is ref-counted, you must call QuitSubSystem()
	// for each InitSubSystem() to correctly shutdown a subsystem manually (or
	// call Quit() to force shutdown). If a subsystem is already loaded then
	// this call will increase the ref-count and return.
	//
	// Consider reporting some basic metadata about your application before
	// calling Init, using either SetAppMetadata() or
	// SetAppMetadataProperty().
	//
	// \param flags subsystem initialization flags.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetAppMetadata
	// \sa SetAppMetadataProperty
	// \sa InitSubSystem
	// \sa Quit
	// \sa SetMainReady
	// \sa WasInit

	Init :: proc(flags: InitFlags) -> c.bool ---

	// Compatibility function to initialize the SDL library.
	//
	// This function and Init() are interchangeable.
	//
	// \param flags any of the flags used by Init(); see Init for details.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Init
	// \sa Quit
	// \sa QuitSubSystem

	InitSubSystem :: proc(flags: InitFlags) -> c.bool ---

	// Shut down specific SDL subsystems.
	//
	// You still need to call Quit() even if you close all open subsystems
	// with QuitSubSystem().
	//
	// \param flags any of the flags used by Init(); see Init for details.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa InitSubSystem
	// \sa Quit

	QuitSubSystem :: proc(flags: InitFlags) ---

	// Get a mask of the specified subsystems which are currently initialized.
	//
	// \param flags any of the flags used by Init(); see Init for details.
	// \returns a mask of all initialized subsystems if `flags` is 0, otherwise it
	//          returns the initialization status of the specified subsystems.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Init
	// \sa InitSubSystem

	WasInit :: proc(flags: InitFlags) -> InitFlags ---

	// Clean up all initialized subsystems.
	//
	// You should call this function even if you have already shutdown each
	// initialized subsystem with QuitSubSystem(). It is safe to call this
	// function even in the case of errors in initialization.
	//
	// You can use this function with atexit() to ensure that it is run when your
	// application is shutdown, but it is not wise to do this from a library or
	// other dynamically loaded code.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Init
	// \sa QuitSubSystem

	Quit :: proc() ---

	// Specify basic metadata about your app.
	//
	// You can optionally provide metadata about your app to SDL. This is not
	// required, but strongly encouraged.
	//
	// There are several locations where SDL can make use of metadata (an "About"
	// box in the macOS menu bar, the name of the app can be shown on some audio
	// mixers, etc). Any piece of metadata can be left as NULL, if a specific
	// detail doesn't make sense for the app.
	//
	// This function should be called as early as possible, before Init.
	// Multiple calls to this function are allowed, but various state might not
	// change once it has been set up with a previous call to this function.
	//
	// Passing a NULL removes any previous metadata.
	//
	// This is a simplified interface for the most important information. You can
	// supply significantly more detailed metadata with
	// SetAppMetadataProperty().
	//
	// \param appname The name of the application ("My Game 2: Bad Guy's
	//                Revenge!").
	// \param appversion The version of the application ("1.0.0beta5" or a git
	//                   hash, or whatever makes sense).
	// \param appidentifier A unique string in reverse-domain format that
	//                      identifies this app ("com.example.mygame2").
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetAppMetadataProperty

	SetAppMetadata :: proc(appname, appversion, appidentifier: cstring) -> c.bool ---

	// Specify metadata about your app through a set of properties.
	//
	// You can optionally provide metadata about your app to SDL. This is not
	// required, but strongly encouraged.
	//
	// There are several locations where SDL can make use of metadata (an "About"
	// box in the macOS menu bar, the name of the app can be shown on some audio
	// mixers, etc). Any piece of metadata can be left out, if a specific detail
	// doesn't make sense for the app.
	//
	// This function should be called as early as possible, before Init.
	// Multiple calls to this function are allowed, but various state might not
	// change once it has been set up with a previous call to this function.
	//
	// Once set, this metadata can be read using GetMetadataProperty().
	//
	// These are the supported properties:
	//
	// - `PROP_APP_METADATA_NAME_STRING`: The human-readable name of the
	//   application, like "My Game 2: Bad Guy's Revenge!". This will show up
	//   anywhere the OS shows the name of the application separately from window
	//   titles, such as volume control applets, etc. This defaults to "SDL
	//   Application".
	// - `PROP_APP_METADATA_VERSION_STRING`: The version of the app that is
	//   running; there are no rules on format, so "1.0.3beta2" and "April 22nd,
	//   2024" and a git hash are all valid options. This has no default.
	// - `PROP_APP_METADATA_IDENTIFIER_STRING`: A unique string that
	//   identifies this app. This must be in reverse-domain format, like
	//   "com.example.mygame2". This string is used by desktop compositors to
	//   identify and group windows together, as well as match applications with
	//   associated desktop settings and icons. If you plan to package your
	//   application in a container such as Flatpak, the app ID should match the
	//   name of your Flatpak container as well. This has no default.
	// - `PROP_APP_METADATA_CREATOR_STRING`: The human-readable name of the
	//   creator/developer/maker of this app, like "MojoWorkshop, LLC"
	// - `PROP_APP_METADATA_COPYRIGHT_STRING`: The human-readable copyright
	//   notice, like "Copyright (c) 2024 MojoWorkshop, LLC" or whatnot. Keep this
	//   to one line, don't paste a copy of a whole software license in here. This
	//   has no default.
	// - `PROP_APP_METADATA_URL_STRING`: A URL to the app on the web. Maybe a
	//   product page, or a storefront, or even a GitHub repository, for user's
	//   further information This has no default.
	// - `PROP_APP_METADATA_TYPE_STRING`: The type of application this is.
	//   Currently this string can be "game" for a video game, "mediaplayer" for a
	//   media player, or generically "application" if nothing else applies.
	//   Future versions of SDL might add new types. This defaults to
	//   "application".
	//
	// \param name the name of the metadata property to set.
	// \param value the value of the property, or NULL to remove that property.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetAppMetadataProperty
	// \sa SetAppMetadata

	SetAppMetadataProperty :: proc(name, value: cstring) -> c.bool ---


	// Get metadata about your app.
	//
	// This returns metadata previously set using SetAppMetadata() or
	// SetAppMetadataProperty(). See SetAppMetadataProperty() for the list
	// of available properties and their meanings.
	//
	// \param name the name of the metadata property to get.
	// \returns the current value of the metadata property, or the default if it
	//          is not set, NULL for properties with no default.
	//
	// \threadsafety It is safe to call this function from any thread, although
	//               the string returned is not protected and could potentially be
	//               freed if you call SetAppMetadataProperty() to set that
	//               property from another thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetAppMetadata
	// \sa SetAppMetadataProperty

	GetAppMetadataProperty :: proc(name: cstring) -> cstring ---
}
