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

// # CategoryThread
//
// SDL thread management routines.


// The SDL thread object.
//
// These are opaque data.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa CreateThread
// \sa WaitThread

Thread :: distinct struct {}


// A unique numeric ID that identifies a thread.
//
// These are different from Thread objects, which are generally what an
// application will operate on, but having a way to uniquely identify a thread
// can be useful at times.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa GetThreadID
// \sa GetCurrentThreadID

ThreadID :: c.uint64_t


// Thread local storage ID.
//
// 0 is the invalid ID. An app can create these and then set data for these
// IDs that is unique to each thread.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa GetTLS
// \sa SetTLS

TLSID :: AtomicInt


// The SDL thread priority.
//
// SDL will make system changes as necessary in order to apply the thread
// priority. Code which attempts to control thread state related to priority
// should be aware that calling SetCurrentThreadPriority may alter such
// state. HINT_THREAD_PRIORITY_POLICY can be used to control aspects of
// this behavior.
//
// \since This enum is available since SDL 3.0.0.

ThreadPriority :: enum c.int {
	LOW,
	NORMAL,
	HIGH,
	TIME_CRITICAL,
}


// The callback used to cleanup data passed to SetTLS.
//
// This is called when a thread exits, to allow an app to free any resources.
//
// \param value a pointer previously handed to SetTLS.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa SetTLS

TLSDestructorCallback :: #type proc "c" (value: rawptr)

// The function passed to CreateThread() as the new thread's entry point.
//
// \param data what was passed as `data` to CreateThread().
// \returns a value that can be reported through WaitThread().
//
// \since This datatype is available since SDL 3.0.0.

ThreadFunction :: #type proc "c" (data: rawptr) -> c.int

PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER :: "SDL.thread.create.entry_function"
PROP_THREAD_CREATE_NAME_STRING :: "SDL.thread.create.name"
PROP_THREAD_CREATE_USERDATA_POINTER :: "SDL.thread.create.userdata"
PROP_THREAD_CREATE_STACKSIZE_NUMBER :: "SDL.thread.create.stacksize"


// Note that these aren't the correct function signatures in this block, but
// this is what the API reference manual should look like for all intents and
// purposes.
//
// Technical details, not for the wiki (hello, header readers!)...
//
// On Windows (and maybe other platforms), a program might use a different
// C runtime than its libraries. Or, in SDL's case, it might use a C runtime
// while SDL uses none at all.
//
// C runtimes expect to initialize thread-specific details when a new thread
// is created, but to do this in CreateThread would require SDL to know
// intimate details about the caller's C runtime, which is not possible.
//
// So CreateThread has two extra parameters, which are
// hidden at compile time by macros: the C runtime's `_beginthreadex` and
// `_endthreadex` entry points. If these are not NULL, they are used to spin
// and terminate the new thread; otherwise the standard Win32 `CreateThread`
// function is used. When `CreateThread` is called from a compiler that
// needs this C runtime thread init function, macros insert the appropriate
// function pointers for CreateThread's caller (which might be a different
// compiler with a different runtime in different calls to CreateThread!).
//
// BeginThreadFunction defaults to `_beginthreadex` on Windows (and NULL
// everywhere else), but apps that have extremely specific special needs can
// define this to something else and the SDL headers will use it, passing the
// app-defined value to CreateThread calls. Redefine this with caution!
//
// Platforms that don't need _beginthread stuff (most everything) will fail
// CreateThread with an error if these pointers _aren't_ NULL.
//
// Unless you are doing something extremely complicated, like perhaps a
// language binding, **you should never deal with this directly**. Let SDL's
// macros handle this platform-specific detail transparently!
// NOTE: This seem important for the bindings lol
// I have got no clue how to do this with odin threads...
// /* The real implementation, hidden from the wiki, so it can show this as real functions that don't have macro magic. */
//   if defined(PLATFORM_WINDOWS)
//     ifndef BeginThreadFunction
//       define BeginThreadFunction _beginthreadex
//     endif
//     ifndef EndThreadFunction
//       define EndThreadFunction _endthreadex
//     endif
//   endif


// Create a new thread with a default stack size.
//
// This is a convenience function, equivalent to calling
// CreateThreadWithProperties with the following properties set:
//
// - `PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER`: `fn`
// - `PROP_THREAD_CREATE_NAME_STRING`: `name`
// - `PROP_THREAD_CREATE_USERDATA_POINTER`: `data`
//
// Note that this "function" is actually a macro that calls an internal
// function with two extra parameters not listed here; they are hidden through
// preprocessor macros and are needed to support various C runtimes at the
// point of the function call. Language bindings that aren't using the C
// headers will need to deal with this.
//
// Usually, apps should just call this function the same way on every platform
// and let the macros hide the details.
//
// \param fn the ThreadFunction function to call in the new thread.
// \param name the name of the thread.
// \param data a pointer that is passed to `fn`.
// \returns an opaque pointer to the new thread object on success, NULL if the
//          new thread could not be created; call GetError() for more
//          information.
//
// \since This function is available since SDL 3.0.0.
//
// \sa CreateThreadWithProperties
// \sa WaitThread

CreateThread :: #force_inline proc "c" (
	fn: ThreadFunction,
	name: cstring,
	data: rawptr,
) -> ^Thread {
	//FIXME: This is incorrect on windows??
	return CreateThreadRuntime(fn, name, data, nil, nil)
}


// Create a new thread with with the specified properties.
//
// These are the supported properties:
//
// - `PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER`: an ThreadFunction
//   value that will be called at the start of the new thread's life.
//   Required.
// - `PROP_THREAD_CREATE_NAME_STRING`: the name of the new thread, which
//   might be available to debuggers. Optional, defaults to NULL.
// - `PROP_THREAD_CREATE_USERDATA_POINTER`: an arbitrary app-defined
//   pointer, which is passed to the entry function on the new thread, as its
//   only parameter. Optional, defaults to NULL.
// - `PROP_THREAD_CREATE_STACKSIZE_NUMBER`: the size, in bytes, of the new
//   thread's stack. Optional, defaults to 0 (system-defined default).
//
// SDL makes an attempt to report `PROP_THREAD_CREATE_NAME_STRING` to the
// system, so that debuggers can display it. Not all platforms support this.
//
// Thread naming is a little complicated: Most systems have very small limits
// for the string length (Haiku has 32 bytes, Linux currently has 16, Visual
// C++ 6.0 has _nine_!), and possibly other arbitrary rules. You'll have to
// see what happens with your system's debugger. The name should be UTF-8 (but
// using the naming limits of C identifiers is a better bet). There are no
// requirements for thread naming conventions, so long as the string is
// null-terminated UTF-8, but these guidelines are helpful in choosing a name:
//
// https://stackoverflow.com/questions/149932/naming-conventions-for-threads
//
// If a system imposes requirements, SDL will try to munge the string for it
// (truncate, etc), but the original string contents will be available from
// GetThreadName().
//
// The size (in bytes) of the new stack can be specified with
// `PROP_THREAD_CREATE_STACKSIZE_NUMBER`. Zero means "use the system
// default" which might be wildly different between platforms. x86 Linux
// generally defaults to eight megabytes, an embedded device might be a few
// kilobytes instead. You generally need to specify a stack that is a multiple
// of the system's page size (in many cases, this is 4 kilobytes, but check
// your system documentation).
//
// Note that this "function" is actually a macro that calls an internal
// function with two extra parameters not listed here; they are hidden through
// preprocessor macros and are needed to support various C runtimes at the
// point of the function call. Language bindings that aren't using the C
// headers will need to deal with this.
//
// The actual symbol in SDL is `CreateThreadWithPropertiesRuntime`, so
// there is no symbol clash, but trying to load an SDL shared library and look
// for "CreateThreadWithProperties" will fail.
//
// Usually, apps should just call this function the same way on every platform
// and let the macros hide the details.
//
// \param props the properties to use.
// \returns an opaque pointer to the new thread object on success, NULL if the
//          new thread could not be created; call GetError() for more
//          information.
//
// \since This function is available since SDL 3.0.0.
//
// \sa CreateThread
// \sa WaitThread

CreateThreadWithProperties :: #force_inline proc(props: PropertiesID) -> ^Thread {
	//FIXME: This is incorrect on windows??
	return CreateThreadWithPropertiesRuntime(props, nil, nil)
}


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	/* These are the actual functions exported from SDL! Don't use them directly! Use the CreateThread and CreateThreadWithProperties macros! */

	// The actual entry point for CreateThread.
	//
	// \param fn the ThreadFunction function to call in the new thread
	// \param name the name of the thread
	// \param data a pointer that is passed to `fn`
	// \param pfnBeginThread the C runtime's _beginthreadex (or whatnot). Can be NULL.
	// \param pfnEndThread the C runtime's _endthreadex (or whatnot). Can be NULL.
	// \returns an opaque pointer to the new thread object on success, NULL if the
	//          new thread could not be created; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	CreateThreadRuntime :: proc(fn: ThreadFunction, name: cstring, data: rawptr, pfnBeginThread, pfnEndThread: FunctionPointer) -> ^Thread ---


	// The actual entry point for CreateThreadWithProperties.
	//
	// \param props the properties to use
	// \param pfnBeginThread the C runtime's _beginthreadex (or whatnot). Can be NULL.
	// \param pfnEndThread the C runtime's _endthreadex (or whatnot). Can be NULL.
	// \returns an opaque pointer to the new thread object on success, NULL if the
	//          new thread could not be created; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	CreateThreadWithPropertiesRuntime :: proc(props: PropertiesID, pfnBeginThread, pfnEndThread: FunctionPointer) -> ^Thread ---


	// Get the thread name as it was specified in CreateThread().
	//
	// \param thread the thread to query.
	// \returns a pointer to a UTF-8 string that names the specified thread, or
	//          NULL if it doesn't have a name.
	//
	// \since This function is available since SDL 3.0.0.

	GetThreadName :: proc(thread: ^Thread) -> cstring ---


	// Get the thread identifier for the current thread.
	//
	// This thread identifier is as reported by the underlying operating system.
	// If SDL is running on a platform that does not support threads the return
	// value will always be zero.
	//
	// This function also returns a valid thread ID when called from the main
	// thread.
	//
	// \returns the ID of the current thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetThreadID

	GetCurrentThreadID :: proc() -> ThreadID ---


	// Get the thread identifier for the specified thread.
	//
	// This thread identifier is as reported by the underlying operating system.
	// If SDL is running on a platform that does not support threads the return
	// value will always be zero.
	//
	// \param thread the thread to query.
	// \returns the ID of the specified thread, or the ID of the current thread if
	//          `thread` is NULL.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetCurrentThreadID

	GetThreadID :: proc(thread: ^Thread) -> ThreadID ---


	// Set the priority for the current thread.
	//
	// Note that some platforms will not let you alter the priority (or at least,
	// promote the thread to a higher priority) at all, and some require you to be
	// an administrator account. Be prepared for this to fail.
	//
	// \param priority the ThreadPriority to set.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	SetCurrentThreadPriority :: proc(priority: ThreadPriority) -> c.bool ---


	// Wait for a thread to finish.
	//
	// Threads that haven't been detached will remain (as a "zombie") until this
	// function cleans them up. Not doing so is a resource leak.
	//
	// Once a thread has been cleaned up through this function, the Thread
	// that references it becomes invalid and should not be referenced again. As
	// such, only one thread may call WaitThread() on another.
	//
	// The return code for the thread function is placed in the area pointed to by
	// `status`, if `status` is not NULL.
	//
	// You may not wait on a thread that has been used in a call to
	// DetachThread(). Use either that function or this one, but not both, or
	// behavior is undefined.
	//
	// It is safe to pass a NULL thread to this function; it is a no-op.
	//
	// Note that the thread pointer is freed by this function and is not valid
	// afterward.
	//
	// \param thread the Thread pointer that was returned from the
	//               CreateThread() call that started this thread.
	// \param status pointer to an integer that will receive the value returned
	//               from the thread function by its 'return', or NULL to not
	//               receive such value back.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateThread
	// \sa DetachThread

	WaitThread :: proc(thread: ^Thread, status: ^c.int) ---


	// Let a thread clean up on exit without intervention.
	//
	// A thread may be "detached" to signify that it should not remain until
	// another thread has called WaitThread() on it. Detaching a thread is
	// useful for long-running threads that nothing needs to synchronize with or
	// further manage. When a detached thread is done, it simply goes away.
	//
	// There is no way to recover the return code of a detached thread. If you
	// need this, don't detach the thread and instead use WaitThread().
	//
	// Once a thread is detached, you should usually assume the Thread isn't
	// safe to reference again, as it will become invalid immediately upon the
	// detached thread's exit, instead of remaining until someone has called
	// WaitThread() to finally clean it up. As such, don't detach the same
	// thread more than once.
	//
	// If a thread has already exited when passed to DetachThread(), it will
	// stop waiting for a call to WaitThread() and clean up immediately. It is
	// not safe to detach a thread that might be used with WaitThread().
	//
	// You may not call WaitThread() on a thread that has been detached. Use
	// either that function or this one, but not both, or behavior is undefined.
	//
	// It is safe to pass NULL to this function; it is a no-op.
	//
	// \param thread the Thread pointer that was returned from the
	//               CreateThread() call that started this thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateThread
	// \sa WaitThread

	DetachThread :: proc(thread: ^Thread) ---


	// Get the current thread's value associated with a thread local storage ID.
	//
	// \param id a pointer to the thread local storage ID, may not be NULL.
	// \returns the value associated with the ID for the current thread or NULL if
	//          no value has been set; call GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetTLS

	GetTLS :: proc(id: ^TLSID) -> rawptr ---


	// Set the current thread's value associated with a thread local storage ID.
	//
	// If the thread local storage ID is not initialized (the value is 0), a new
	// ID will be created in a thread-safe way, so all calls using a pointer to
	// the same ID will refer to the same local storage.
	//
	// Note that replacing a value from a previous call to this function on the
	// same thread does _not_ call the previous value's destructor!
	//
	// `destructor` can be NULL; it is assumed that `value` does not need to be
	// cleaned up if so.
	//
	// \param id a pointer to the thread local storage ID, may not be NULL.
	// \param value the value to associate with the ID for the current thread.
	// \param destructor a function called when the thread exits, to free the
	//                   value, may be NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTLS

	SetTLS :: proc(id: ^TLSID, value: rawptr, destructor: TLSDestructorCallback) -> c.bool ---


	// Cleanup all TLS data for this thread.
	//
	// If you are creating your threads outside of SDL and then calling SDL
	// functions, you should call this function before your thread exits, to
	// properly clean up SDL memory.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	CleanupTLS :: proc() ---
}
