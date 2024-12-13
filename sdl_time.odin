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

// # CategoryTime
//
// SDL realtime clock and date/time routines.


Time :: c.int64_t

// A structure holding a calendar date and time broken down into its
// components.
//
// \since This struct is available since SDL 3.0.0.

DateTime :: struct {
	year:        int, /**< Year */
	month:       int, /**< Month [01-12] */
	day:         int, /**< Day of the month [01-31] */
	hour:        int, /**< Hour [0-23] */
	minute:      int, /**< Minute [0-59] */
	second:      int, /**< Seconds [0-60] */
	nanosecond:  int, /**< Nanoseconds [0-999999999] */
	day_of_week: int, /**< Day of the week [0-6] (0 being Sunday) */
	utc_offset:  int, /**< Seconds east of UTC */
}


// The preferred date format of the current system locale.
//
// \since This enum is available since SDL 3.0.0.
//
// \sa GetDateTimeLocalePreferences

DateFormat :: enum c.int {
	YYYYMMDD = 0, /**< Year/Month/Day */
	DDMMYYYY = 1, /**< Day/Month/Year */
	MMDDYYYY = 2, /**< Month/Day/Year */
}


// The preferred time format of the current system locale.
//
// \since This enum is available since SDL 3.0.0.
//
// \sa GetDateTimeLocalePreferences

TimeFormat :: enum c.int {
	_24HR = 0, /**< 24 hour time */
	_12HR = 1, /**< 12 hour time */
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Gets the current preferred date and time format for the system locale.
	//
	// This might be a "slow" call that has to query the operating system. It's
	// best to ask for this once and save the results. However, the preferred
	// formats can change, usually because the user has changed a system
	// preference outside of your program.
	//
	// \param dateFormat a pointer to the DateFormat to hold the returned date
	//                   format, may be NULL.
	// \param timeFormat a pointer to the TimeFormat to hold the returned time
	//                   format, may be NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GetDateTimeLocalePreferences :: proc(dateFormat: ^DateFormat, timeFormat: ^TimeFormat) -> c.bool ---


	// Gets the current value of the system realtime clock in nanoseconds since
	// Jan 1, 1970 in Universal Coordinated Time (UTC).
	//
	// \param ticks the Time to hold the returned tick count.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GetCurrentTime :: proc(ticks: ^Time) -> c.bool ---


	// Converts an Time in nanoseconds since the epoch to a calendar time in
	// the DateTime format.
	//
	// \param ticks the Time to be converted.
	// \param dt the resulting DateTime.
	// \param localTime the resulting DateTime will be expressed in local time
	//                  if true, otherwise it will be in Universal Coordinated
	//                  Time (UTC).
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	TimeToDateTime :: proc(ticks: ^Time, dt: ^DateTime, localTime: c.bool) -> c.bool ---


	// Converts a calendar time to an Time in nanoseconds since the epoch.
	//
	// This function ignores the day_of_week member of the DateTime struct, so
	// it may remain unset.
	//
	// \param dt the source DateTime.
	// \param ticks the resulting Time.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	DateTimeToTime :: proc(dt: DateTime, ticks: ^Time) -> c.bool ---


	// Converts an SDL time into a Windows FILETIME (100-nanosecond intervals
	// since January 1, 1601).
	//
	// This function fills in the two 32-bit values of the FILETIME structure.
	//
	// \param ticks the time to convert.
	// \param dwLowDateTime a pointer filled in with the low portion of the
	//                      Windows FILETIME value.
	// \param dwHighDateTime a pointer filled in with the high portion of the
	//                       Windows FILETIME value.
	//
	// \since This function is available since SDL 3.0.0.

	TimeToWindows :: proc(ticks: ^Time, dwLowDateTime, dwHighDateTime: ^c.uint32_t) ---


	// Converts a Windows FILETIME (100-nanosecond intervals since January 1,
	// 1601) to an SDL time.
	//
	// This function takes the two 32-bit values of the FILETIME structure as
	// parameters.
	//
	// \param dwLowDateTime the low portion of the Windows FILETIME value.
	// \param dwHighDateTime the high portion of the Windows FILETIME value.
	// \returns the converted SDL time.
	//
	// \since This function is available since SDL 3.0.0.

	TimeFromWindows :: proc(dwLowDateTime, dwHighDateTime: c.uint32_t) -> Time ---


	// Get the number of days in a month for a given year.
	//
	// \param year the year.
	// \param month the month [1-12].
	// \returns the number of days in the requested month or -1 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetDaysInMonth :: proc(year, month: c.int) -> c.int ---


	// Get the day of year for a calendar date.
	//
	// \param year the year component of the date.
	// \param month the month component of the date.
	// \param day the day component of the date.
	// \returns the day of year [0-365] if the date is valid or -1 on failure;
	//          call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetDayOfYear :: proc(year, month, day: c.int) -> c.int ---


	// Get the day of week for a calendar date.
	//
	// \param year the year component of the date.
	// \param month the month component of the date.
	// \param day the day component of the date.
	// \returns a value between 0 and 6 (0 being Sunday) if the date is valid or
	//          -1 on failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetDayOfWeek :: proc(year, month, day: c.int) -> c.int ---
}
