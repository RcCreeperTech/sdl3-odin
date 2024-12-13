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


// # CategoryLog
//
// Simple log messages with priorities and categories. A message's
// LogPriority signifies how important the message is. A message's
// LogCategory signifies from what domain it belongs to. Every category
// has a minimum priority specified: when a message belongs to that category,
// it will only be sent out if it has that minimum priority or higher.
//
// SDL's own logs are sent below the default priority threshold, so they are
// quiet by default.
//
// You can change the log verbosity programmatically using
// SetLogPriority() or with SetHint(HINT_LOGGING, ...), or with
// the "LOGGING" environment variable. This variable is a comma separated
// set of category=level tokens that define the default logging levels for SDL
// applications.
//
// The category can be a numeric category, one of "app", "error", "assert",
// "system", "audio", "video", "render", "input", "test", or `*` for any
// unspecified category.
//
// The level can be a numeric level, one of "verbose", "debug", "info",
// "warn", "error", "critical", or "quiet" to disable that category.
//
// You can omit the category if you want to set the logging level for all
// categories.
//
// If this hint isn't set, the default log levels are equivalent to:
//
// `app=info,assert=warn,test=verbose,*=error`
//
// Here's where the messages go on different platforms:
//
// - Windows: debug output stream
// - Android: log output
// - Others: standard error output (stderr)


// The predefined log categories
//
// By default the application and gpu categories are enabled at the INFO
// level, the assert category is enabled at the WARN level, test is enabled at
// the VERBOSE level and all other categories are enabled at the ERROR level.
//
// \since This enum is available since SDL 3.0.0.

LogCategory :: enum c.int {
	APPLICATION,
	ERROR,
	ASSERT,
	SYSTEM,
	AUDIO,
	VIDEO,
	RENDER,
	INPUT,
	TEST,
	GPU,

	/* Reserved for future SDL library use */
	RESERVED2,
	RESERVED3,
	RESERVED4,
	RESERVED5,
	RESERVED6,
	RESERVED7,
	RESERVED8,
	RESERVED9,
	RESERVED10,

	// Beyond this point is reserved for application use, e.g.
	//  enum {
	//      MYAPP_CATEGORY_AWESOME1 = LOG_CATEGORY_CUSTOM,
	//      MYAPP_CATEGORY_AWESOME2,
	//      MYAPP_CATEGORY_AWESOME3,
	//      ...
	//  };
	CUSTOM,
}


// The predefined log priorities
//
// \since This enum is available since SDL 3.0.0.

LogPriority :: enum c.int {
	INVALID,
	TRACE,
	VERBOSE,
	DEBUG,
	INFO,
	WARN,
	ERROR,
	CRITICAL,
	COUNT,
}


// The prototype for the log output callback function.
//
// This function is called by SDL when there is new text to be logged. A mutex
// is held so that this function is never called by more than one thread at
// once.
//
// \param userdata what was passed as `userdata` to
//                 SetLogOutputFunction().
// \param category the category of the message.
// \param priority the priority of the message.
// \param message the message being output.
//
// \since This datatype is available since SDL 3.0.0.

LogOutputFunction :: #type proc "c" (
	userdata: rawptr,
	category: c.int,
	priority: LogPriority,
	message: cstring,
)


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Set the priority of all log categories.
	//
	// \param priority the LogPriority to assign.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ResetLogPriorities
	// \sa SetLogPriority

	SetLogPriorities :: proc(priority: LogPriority) ---


	// Set the priority of a particular log category.
	//
	// \param category the category to assign a priority to.
	// \param priority the LogPriority to assign.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetLogPriority
	// \sa ResetLogPriorities
	// \sa SetLogPriorities

	SetLogPriority :: proc(category: c.int, priority: LogPriority) ---


	// Get the priority of a particular log category.
	//
	// \param category the category to query.
	// \returns the LogPriority for the requested category.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetLogPriority

	GetLogPriority :: proc(category: c.int) -> LogPriority ---


	// Reset all priorities to default.
	//
	// This is called by Quit().
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetLogPriorities
	// \sa SetLogPriority

	ResetLogPriorities :: proc() ---


	// Set the text prepended to log messages of a given priority.
	//
	// By default LOG_PRIORITY_INFO and below have no prefix, and
	// LOG_PRIORITY_WARN and higher have a prefix showing their priority, e.g.
	// "WARNING: ".
	//
	// \param priority the LogPriority to modify.
	// \param prefix the prefix to use for that log priority, or NULL to use no
	//               prefix.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetLogPriorities
	// \sa SetLogPriority

	SetLogPriorityPrefix :: proc(priority: LogPriority, prefix: cstring) -> c.bool ---


	// Log a message with LOG_CATEGORY_APPLICATION and LOG_PRIORITY_INFO.
	//
	// \param fmt a printf() style message format string.
	// \param ... additional parameters matching % tokens in the `fmt` string, if
	//            any.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LogCritical
	// \sa LogDebug
	// \sa LogError
	// \sa LogInfo
	// \sa LogMessage
	// \sa LogMessageV
	// \sa LogTrace
	// \sa LogVerbose
	// \sa LogWarn

	Log :: proc(fmt: cstring, #c_vararg args: ..any) ---


	// Log a message with LOG_PRIORITY_TRACE.
	//
	// \param category the category of the message.
	// \param fmt a printf() style message format string.
	// \param ... additional parameters matching % tokens in the **fmt** string,
	//            if any.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Log
	// \sa LogCritical
	// \sa LogDebug
	// \sa LogError
	// \sa LogInfo
	// \sa LogMessage
	// \sa LogMessageV
	// \sa LogTrace
	// \sa LogVerbose
	// \sa LogWarn

	LogTrace :: proc(category: c.int, fmt: cstring, #c_vararg args: ..any) ---


	// Log a message with LOG_PRIORITY_VERBOSE.
	//
	// \param category the category of the message.
	// \param fmt a printf() style message format string.
	// \param ... additional parameters matching % tokens in the **fmt** string,
	//            if any.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Log
	// \sa LogCritical
	// \sa LogDebug
	// \sa LogError
	// \sa LogInfo
	// \sa LogMessage
	// \sa LogMessageV
	// \sa LogWarn

	LogVerbose :: proc(category: c.int, fmt: cstring, #c_vararg args: ..any) ---


	// Log a message with LOG_PRIORITY_DEBUG.
	//
	// \param category the category of the message.
	// \param fmt a printf() style message format string.
	// \param ... additional parameters matching % tokens in the **fmt** string,
	//            if any.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Log
	// \sa LogCritical
	// \sa LogError
	// \sa LogInfo
	// \sa LogMessage
	// \sa LogMessageV
	// \sa LogTrace
	// \sa LogVerbose
	// \sa LogWarn

	LogDebug :: proc(category: c.int, fmt: cstring, #c_vararg args: ..any) ---


	// Log a message with LOG_PRIORITY_INFO.
	//
	// \param category the category of the message.
	// \param fmt a printf() style message format string.
	// \param ... additional parameters matching % tokens in the **fmt** string,
	//            if any.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Log
	// \sa LogCritical
	// \sa LogDebug
	// \sa LogError
	// \sa LogMessage
	// \sa LogMessageV
	// \sa LogTrace
	// \sa LogVerbose
	// \sa LogWarn

	LogInfo :: proc(category: c.int, fmt: cstring, #c_vararg args: ..any) ---


	// Log a message with LOG_PRIORITY_WARN.
	//
	// \param category the category of the message.
	// \param fmt a printf() style message format string.
	// \param ... additional parameters matching % tokens in the **fmt** string,
	//            if any.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Log
	// \sa LogCritical
	// \sa LogDebug
	// \sa LogError
	// \sa LogInfo
	// \sa LogMessage
	// \sa LogMessageV
	// \sa LogTrace
	// \sa LogVerbose

	LogWarn :: proc(category: c.int, fmt: cstring, #c_vararg args: ..any) ---


	// Log a message with LOG_PRIORITY_ERROR.
	//
	// \param category the category of the message.
	// \param fmt a printf() style message format string.
	// \param ... additional parameters matching % tokens in the **fmt** string,
	//            if any.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Log
	// \sa LogCritical
	// \sa LogDebug
	// \sa LogInfo
	// \sa LogMessage
	// \sa LogMessageV
	// \sa LogTrace
	// \sa LogVerbose
	// \sa LogWarn

	LogError :: proc(category: c.int, fmt: cstring, #c_vararg args: ..any) ---


	// Log a message with LOG_PRIORITY_CRITICAL.
	//
	// \param category the category of the message.
	// \param fmt a printf() style message format string.
	// \param ... additional parameters matching % tokens in the **fmt** string,
	//            if any.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Log
	// \sa LogDebug
	// \sa LogError
	// \sa LogInfo
	// \sa LogMessage
	// \sa LogMessageV
	// \sa LogTrace
	// \sa LogVerbose
	// \sa LogWarn

	LogCritical :: proc(category: c.int, fmt: cstring, #c_vararg args: ..any) ---


	// Log a message with the specified category and priority.
	//
	// \param category the category of the message.
	// \param priority the priority of the message.
	// \param fmt a printf() style message format string.
	// \param ... additional parameters matching % tokens in the **fmt** string,
	//            if any.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Log
	// \sa LogCritical
	// \sa LogDebug
	// \sa LogError
	// \sa LogInfo
	// \sa LogMessageV
	// \sa LogTrace
	// \sa LogVerbose
	// \sa LogWarn

	LogMessage :: proc(category: c.int, priority: LogPriority, fmt: cstring, #c_vararg args: ..any) ---


	// Log a message with the specified category and priority.
	//
	// \param category the category of the message.
	// \param priority the priority of the message.
	// \param fmt a printf() style message format string.
	// \param ap a variable argument list.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa Log
	// \sa LogCritical
	// \sa LogDebug
	// \sa LogError
	// \sa LogInfo
	// \sa LogMessage
	// \sa LogTrace
	// \sa LogVerbose
	// \sa LogWarn

	LogMessageV :: proc(category: c.int, priority: LogPriority, fmt: cstring, ap: c.va_list) ---


	// Get the current log output function.
	//
	// \param callback an LogOutputFunction filled in with the current log
	//                 callback.
	// \param userdata a pointer filled in with the pointer that is passed to
	//                 `callback`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetLogOutputFunction

	GetLogOutputFunction :: proc(callback: ^LogOutputFunction, userdata: ^rawptr) ---


	// Replace the default log output function with one of your own.
	//
	// \param callback an LogOutputFunction to call instead of the default.
	// \param userdata a pointer that is passed to `callback`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetLogOutputFunction

	SetLogOutputFunction :: proc(callback: LogOutputFunction, userdata: rawptr) ---
}
