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


// # CategoryLocale
//
// SDL locale services.


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


// A struct to provide locale data.
//
// Locale data is split into a spoken language, like English, and an optional
// country, like Canada. The language will be in ISO-639 format (so English
// would be "en"), and the country, if not NULL, will be an ISO-3166 country
// code (so Canada would be "CA").
//
// \since This function is available since SDL 3.0.0.
//
// \sa GetPreferredLocales

Locale :: struct {
	language: cstring, /**< A language name, like "en" for English. */
	country:  cstring, /**< A country, like "US" for America. Can be NULL. */
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Report the user's preferred locale.
	//
	// Returned language strings are in the format xx, where 'xx' is an ISO-639
	// language specifier (such as "en" for English, "de" for German, etc).
	// Country strings are in the format YY, where "YY" is an ISO-3166 country
	// code (such as "US" for the United States, "CA" for Canada, etc). Country
	// might be NULL if there's no specific guidance on them (so you might get {
	// "en", "US" } for American English, but { "en", NULL } means "English
	// language, generically"). Language strings are never NULL, except to
	// terminate the array.
	//
	// Please note that not all of these strings are 2 characters; some are three
	// or more.
	//
	// The returned list of locales are in the order of the user's preference. For
	// example, a German citizen that is fluent in US English and knows enough
	// Japanese to navigate around Tokyo might have a list like: { "de", "en_US",
	// "jp", NULL }. Someone from England might prefer British English (where
	// "color" is spelled "colour", etc), but will settle for anything like it: {
	// "en_GB", "en", NULL }.
	//
	// This function returns NULL on error, including when the platform does not
	// supply this information at all.
	//
	// This might be a "slow" call that has to query the operating system. It's
	// best to ask for this once and save the results. However, this list can
	// change, usually because the user has changed a system preference outside of
	// your program; SDL will send an EVENT_LOCALE_CHANGED event in this case,
	// if possible, and you can call this function again to get an updated copy of
	// preferred locales.
	//
	// \param count a pointer filled in with the number of locales returned, may
	//              be NULL.
	// \returns a NULL terminated array of locale pointers, or NULL on failure;
	//          call GetError() for more information. This is a single
	//          allocation that should be freed with free() when it is no
	//          longer needed.
	//
	// \since This function is available since SDL 3.0.0.

	GetPreferredLocales :: proc(count: ^c.int) -> [^]^Locale ---
}
