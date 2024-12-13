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

// # CategoryTimer
//
// SDL time management routines.


// Definition of the timer ID type.
//
// \since This datatype is available since SDL 3.0.0.

TimerID :: distinct c.uint32_t


// Function prototype for the millisecond timer callback function.
//
// The callback function is passed the current timer interval and returns the
// next timer interval, in milliseconds. If the returned value is the same as
// the one passed in, the periodic alarm continues, otherwise a new alarm is
// scheduled. If the callback returns 0, the periodic alarm is canceled and
// will be removed.
//
// \param userdata an arbitrary pointer provided by the app through
//                 AddTimer, for its own use.
// \param timerID the current timer being processed.
// \param interval the current callback time interval.
// \returns the new callback time interval, or 0 to disable further runs of
//          the callback.
//
// \threadsafety SDL may call this callback at any time from a background
//               thread; the application is responsible for locking resources
//               the callback touches that need to be protected.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa AddTimer

TimerCallback :: #type proc "c" (
	userdata: rawptr,
	timerID: TimerID,
	interval: c.uint32_t,
) -> c.uint32_t


// Function prototype for the nanosecond timer callback function.
//
// The callback function is passed the current timer interval and returns the
// next timer interval, in nanoseconds. If the returned value is the same as
// the one passed in, the periodic alarm continues, otherwise a new alarm is
// scheduled. If the callback returns 0, the periodic alarm is canceled and
// will be removed.
//
// \param userdata an arbitrary pointer provided by the app through
//                 AddTimer, for its own use.
// \param timerID the current timer being processed.
// \param interval the current callback time interval.
// \returns the new callback time interval, or 0 to disable further runs of
//          the callback.
//
// \threadsafety SDL may call this callback at any time from a background
//               thread; the application is responsible for locking resources
//               the callback touches that need to be protected.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa AddTimerNS

NSTimerCallback :: #type proc "c" (
	userdata: rawptr,
	timerID: TimerID,
	interval: c.uint64_t,
) -> c.uint64_t


/* SDL time constants */
MS_PER_SECOND :: 1000
US_PER_SECOND :: 1000000
NS_PER_SECOND :: 1000000000
NS_PER_MS :: 1000000
NS_PER_US :: 1000
SECONDS_TO_NS :: #force_inline proc "c" (S: c.uint64_t) -> c.uint64_t {return S * NS_PER_SECOND}
NS_TO_SECONDS :: #force_inline proc "c" (NS: c.uint64_t) -> c.uint64_t {return NS / NS_PER_SECOND}
MS_TO_NS :: #force_inline proc "c" (MS: c.uint64_t) -> c.uint64_t {return MS * NS_PER_MS}
NS_TO_MS :: #force_inline proc "c" (NS: c.uint64_t) -> c.uint64_t {return NS / NS_PER_MS}
US_TO_NS :: #force_inline proc "c" (US: c.uint64_t) -> c.uint64_t {return US * NS_PER_US}
NS_TO_US :: #force_inline proc "c" (NS: c.uint64_t) -> c.uint64_t {return NS / NS_PER_US}


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get the number of milliseconds since SDL library initialization.
	//
	// \returns an unsigned 64-bit value representing the number of milliseconds
	//          since the SDL library initialized.
	//
	// \since This function is available since SDL 3.0.0.

	GetTicks :: proc() -> c.uint64_t ---


	// Get the number of nanoseconds since SDL library initialization.
	//
	// \returns an unsigned 64-bit value representing the number of nanoseconds
	//          since the SDL library initialized.
	//
	// \since This function is available since SDL 3.0.0.

	GetTicksNS :: proc() -> c.uint64_t ---


	// Get the current value of the high resolution counter.
	//
	// This function is typically used for profiling.
	//
	// The counter values are only meaningful relative to each other. Differences
	// between values can be converted to times by using
	// GetPerformanceFrequency().
	//
	// \returns the current counter value.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPerformanceFrequency

	GetPerformanceCounter :: proc() -> c.uint64_t ---


	// Get the count per second of the high resolution counter.
	//
	// \returns a platform-specific count per second.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPerformanceCounter

	GetPerformanceFrequency :: proc() -> c.uint64_t ---


	// Wait a specified number of milliseconds before returning.
	//
	// This function waits a specified number of milliseconds before returning. It
	// waits at least the specified time, but possibly longer due to OS
	// scheduling.
	//
	// \param ms the number of milliseconds to delay.
	//
	// \since This function is available since SDL 3.0.0.

	Delay :: proc(ms: c.uint32_t) ---


	// Wait a specified number of nanoseconds before returning.
	//
	// This function waits a specified number of nanoseconds before returning. It
	// will attempt to wait as close to the requested time as possible, busy
	// waiting if necessary, but could return later due to OS scheduling.
	//
	// \param ns the number of nanoseconds to delay.
	//
	// \since This function is available since SDL 3.0.0.

	DelayNS :: proc(ns: c.uint64_t) ---


	// Call a callback function at a future time.
	//
	// The callback function is passed the current timer interval and the user
	// supplied parameter from the AddTimer() call and should return the next
	// timer interval. If the value returned from the callback is 0, the timer is
	// canceled and will be removed.
	//
	// The callback is run on a separate thread, and for short timeouts can
	// potentially be called before this function returns.
	//
	// Timers take into account the amount of time it took to execute the
	// callback. For example, if the callback took 250 ms to execute and returned
	// 1000 (ms), the timer would only wait another 750 ms before its next
	// iteration.
	//
	// Timing may be inexact due to OS scheduling. Be sure to note the current
	// time with GetTicksNS() or GetPerformanceCounter() in case your
	// callback needs to adjust for variances.
	//
	// \param interval the timer delay, in milliseconds, passed to `callback`.
	// \param callback the TimerCallback function to call when the specified
	//                 `interval` elapses.
	// \param userdata a pointer that is passed to `callback`.
	// \returns a timer ID or 0 on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa AddTimerNS
	// \sa RemoveTimer

	AddTimer :: proc(interval: c.uint32_t, callback: TimerCallback, userdata: rawptr) -> TimerID ---


	// Call a callback function at a future time.
	//
	// The callback function is passed the current timer interval and the user
	// supplied parameter from the AddTimerNS() call and should return the
	// next timer interval. If the value returned from the callback is 0, the
	// timer is canceled and will be removed.
	//
	// The callback is run on a separate thread, and for short timeouts can
	// potentially be called before this function returns.
	//
	// Timers take into account the amount of time it took to execute the
	// callback. For example, if the callback took 250 ns to execute and returned
	// 1000 (ns), the timer would only wait another 750 ns before its next
	// iteration.
	//
	// Timing may be inexact due to OS scheduling. Be sure to note the current
	// time with GetTicksNS() or GetPerformanceCounter() in case your
	// callback needs to adjust for variances.
	//
	// \param interval the timer delay, in nanoseconds, passed to `callback`.
	// \param callback the TimerCallback function to call when the specified
	//                 `interval` elapses.
	// \param userdata a pointer that is passed to `callback`.
	// \returns a timer ID or 0 on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa AddTimer
	// \sa RemoveTimer

	AddTimerNS :: proc(interval: c.uint64_t, callback: NSTimerCallback, userdata: rawptr) -> TimerID ---


	// Remove a timer created with AddTimer().
	//
	// \param id the ID of the timer to remove.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa AddTimer

	RemoveTimer :: proc(id: TimerID) -> c.bool ---
}
