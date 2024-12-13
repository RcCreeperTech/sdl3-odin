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

// # CategoryProcess
//
// Process control support.
//
// These functions provide a cross-platform way to spawn and manage OS-level
// processes.
//
// You can create a new subprocess with CreateProcess() and optionally
// read and write to it using ReadProcess() or GetProcessInput() and
// GetProcessOutput(). If more advanced functionality like chaining input
// between processes is necessary, you can use
// CreateProcessWithProperties().
//
// You can get the status of a created process with WaitProcess(), or
// terminate the process with KillProcess().
//
// Don't forget to call DestroyProcess() to clean up, whether the process
// process was killed, terminated on its own, or is still running!


Process :: distinct struct {}

// Description of where standard I/O should be directed when creating a
// process.
//
// If a standard I/O stream is set to PROCESS_STDIO_INHERIT, it will go to
// the same place as the application's I/O stream. This is the default for
// standard output and standard error.
//
// If a standard I/O stream is set to PROCESS_STDIO_NULL, it is connected
// to `NUL:` on Windows and `/dev/null` on POSIX systems. This is the default
// for standard input.
//
// If a standard I/O stream is set to PROCESS_STDIO_APP, it is connected
// to a new IOStream that is available to the application. Standard input
// will be available as `PROP_PROCESS_STDIN_POINTER` and allows
// GetProcessInput(), standard output will be available as
// `PROP_PROCESS_STDOUT_POINTER` and allows ReadProcess() and
// GetProcessOutput(), and standard error will be available as
// `PROP_PROCESS_STDERR_POINTER` in the properties for the created
// process.
//
// If a standard I/O stream is set to PROCESS_STDIO_REDIRECT, it is
// connected to an existing IOStream provided by the application. Standard
// input is provided using `PROP_PROCESS_CREATE_STDIN_POINTER`, standard
// output is provided using `PROP_PROCESS_CREATE_STDOUT_POINTER`, and
// standard error is provided using `PROP_PROCESS_CREATE_STDERR_POINTER`
// in the creation properties. These existing streams should be closed by the
// application once the new process is created.
//
// In order to use an IOStream with PROCESS_STDIO_REDIRECT, it must
// have `PROP_IOSTREAM_WINDOWS_HANDLE_POINTER` or
// `PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER` set. This is true for streams
// representing files and process I/O.
//
// \since This enum is available since SDL 3.0.0.
//
// \sa CreateProcessWithProperties
// \sa GetProcessProperties
// \sa ReadProcess
// \sa GetProcessInput
// \sa GetProcessOutput

ProcessIO :: enum c.int {
	INHERITED, /**< The I/O stream is inherited from the application. */
	NULL, /**< The I/O stream is ignored. */
	APP, /**< The I/O stream is connected to a new IOStream that the application can read or write */
	REDIRECT, /**< The I/O stream is redirected to an existing IOStream. */
}

PROP_PROCESS_CREATE_ARGS_POINTER :: "SDL.process.create.args"
PROP_PROCESS_CREATE_ENVIRONMENT_POINTER :: "SDL.process.create.environment"
PROP_PROCESS_CREATE_STDIN_NUMBER :: "SDL.process.create.stdin_option"
PROP_PROCESS_CREATE_STDIN_POINTER :: "SDL.process.create.stdin_source"
PROP_PROCESS_CREATE_STDOUT_NUMBER :: "SDL.process.create.stdout_option"
PROP_PROCESS_CREATE_STDOUT_POINTER :: "SDL.process.create.stdout_source"
PROP_PROCESS_CREATE_STDERR_NUMBER :: "SDL.process.create.stderr_option"
PROP_PROCESS_CREATE_STDERR_POINTER :: "SDL.process.create.stderr_source"
PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN :: "SDL.process.create.stderr_to_stdout"
PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN :: "SDL.process.create.background"

PROP_PROCESS_PID_NUMBER :: "SDL.process.pid"
PROP_PROCESS_STDIN_POINTER :: "SDL.process.stdin"
PROP_PROCESS_STDOUT_POINTER :: "SDL.process.stdout"
PROP_PROCESS_STDERR_POINTER :: "SDL.process.stderr"
PROP_PROCESS_BACKGROUND_BOOLEAN :: "SDL.process.background"


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {


	// Create a new process.
	//
	// The path to the executable is supplied in args[0]. args[1..N] are
	// additional arguments passed on the command line of the new process, and the
	// argument list should be terminated with a NULL, e.g.:
	//
	// ```c
	// cstring args[] = { "myprogram", "argument", NULL };
	// ```
	//
	// Setting pipe_stdio to true is equivalent to setting
	// `PROP_PROCESS_CREATE_STDIN_NUMBER` and
	// `PROP_PROCESS_CREATE_STDOUT_NUMBER` to `PROCESS_STDIO_APP`, and
	// will allow the use of ReadProcess() or GetProcessInput() and
	// GetProcessOutput().
	//
	// See CreateProcessWithProperties() for more details.
	//
	// \param args the path and arguments for the new process.
	// \param pipe_stdio true to create pipes to the process's standard input and
	//                   from the process's standard output, false for the process
	//                   to have no input and inherit the application's standard
	//                   output.
	// \returns the newly created and running process, or NULL if the process
	//          couldn't be created.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProcessWithProperties
	// \sa GetProcessProperties
	// \sa ReadProcess
	// \sa GetProcessInput
	// \sa GetProcessOutput
	// \sa KillProcess
	// \sa WaitProcess
	// \sa DestroyProcess

	CreateProcess :: proc(args: [^]cstring, pipe_stdio: c.bool) -> ^Process ---


	// Create a new process with the specified properties.
	//
	// These are the supported properties:
	//
	// - `PROP_PROCESS_CREATE_ARGS_POINTER`: an array of strings containing
	//   the program to run, any arguments, and a NULL pointer, e.g. const char
	//   *args[] = { "myprogram", "argument", NULL }. This is a required property.
	// - `PROP_PROCESS_CREATE_ENVIRONMENT_POINTER`: an Environment
	//   pointer. If this property is set, it will be the entire environment for
	//   the process, otherwise the current environment is used.
	// - `PROP_PROCESS_CREATE_STDIN_NUMBER`: an ProcessIO value describing
	//   where standard input for the process comes from, defaults to
	//   `PROCESS_STDIO_NULL`.
	// - `PROP_PROCESS_CREATE_STDIN_POINTER`: an IOStream pointer used for
	//   standard input when `PROP_PROCESS_CREATE_STDIN_NUMBER` is set to
	//   `PROCESS_STDIO_REDIRECT`.
	// - `PROP_PROCESS_CREATE_STDOUT_NUMBER`: an ProcessIO value
	//   describing where standard output for the process goes go, defaults to
	//   `PROCESS_STDIO_INHERITED`.
	// - `PROP_PROCESS_CREATE_STDOUT_POINTER`: an IOStream pointer used
	//   for standard output when `PROP_PROCESS_CREATE_STDOUT_NUMBER` is set
	//   to `PROCESS_STDIO_REDIRECT`.
	// - `PROP_PROCESS_CREATE_STDERR_NUMBER`: an ProcessIO value
	//   describing where standard error for the process goes go, defaults to
	//   `PROCESS_STDIO_INHERITED`.
	// - `PROP_PROCESS_CREATE_STDERR_POINTER`: an IOStream pointer used
	//   for standard error when `PROP_PROCESS_CREATE_STDERR_NUMBER` is set to
	//   `PROCESS_STDIO_REDIRECT`.
	// - `PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN`: true if the error
	//   output of the process should be redirected into the standard output of
	//   the process. This property has no effect if
	//   `PROP_PROCESS_CREATE_STDERR_NUMBER` is set.
	// - `PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN`: true if the process should
	//   run in the background. In this case the default input and output is
	//   `PROCESS_STDIO_NULL` and the exitcode of the process is not
	//   available, and will always be 0.
	//
	// On POSIX platforms, wait() and waitpid(-1, ...) should not be called, and
	// SIGCHLD should not be ignored or handled because those would prevent SDL
	// from properly tracking the lifetime of the underlying process. You should
	// use WaitProcess() instead.
	//
	// \param props the properties to use.
	// \returns the newly created and running process, or NULL if the process
	//          couldn't be created.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProcess
	// \sa GetProcessProperties
	// \sa ReadProcess
	// \sa GetProcessInput
	// \sa GetProcessOutput
	// \sa KillProcess
	// \sa WaitProcess
	// \sa DestroyProcess

	CreateProcessWithProperties :: proc(props: PropertiesID) -> ^Process ---


	// Get the properties associated with a process.
	//
	// The following read-only properties are provided by SDL:
	//
	// - `PROP_PROCESS_PID_NUMBER`: the process ID of the process.
	// - `PROP_PROCESS_STDIN_POINTER`: an IOStream that can be used to
	//   write input to the process, if it was created with
	//   `PROP_PROCESS_CREATE_STDIN_NUMBER` set to `PROCESS_STDIO_APP`.
	// - `PROP_PROCESS_STDOUT_POINTER`: a non-blocking IOStream that can
	//   be used to read output from the process, if it was created with
	//   `PROP_PROCESS_CREATE_STDOUT_NUMBER` set to `PROCESS_STDIO_APP`.
	// - `PROP_PROCESS_STDERR_POINTER`: a non-blocking IOStream that can
	//   be used to read error output from the process, if it was created with
	//   `PROP_PROCESS_CREATE_STDERR_NUMBER` set to `PROCESS_STDIO_APP`.
	// - `PROP_PROCESS_BACKGROUND_BOOLEAN`: true if the process is running in
	//   the background.
	//
	// \param process the process to query.
	// \returns a valid property ID on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProcess
	// \sa CreateProcessWithProperties

	GetProcessProperties :: proc(process: ^Process) -> PropertiesID ---


	// Read all the output from a process.
	//
	// If a process was created with I/O enabled, you can use this function to
	// read the output. This function blocks until the process is complete,
	// capturing all output, and providing the process exit code.
	//
	// The data is allocated with a zero byte at the end (null terminated) for
	// convenience. This extra byte is not included in the value reported via
	// `datasize`.
	//
	// The data should be freed with free().
	//
	// \param process The process to read.
	// \param datasize a pointer filled in with the number of bytes read, may be
	//                 NULL.
	// \param exitcode a pointer filled in with the process exit code if the
	//                 process has exited, may be NULL.
	// \returns the data or NULL on failure; call GetError() for more
	//          information.
	//
	// \threadsafety This function is not thread safe.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProcess
	// \sa CreateProcessWithProperties
	// \sa DestroyProcess

	ReadProcess :: proc(process: ^Process, datasize: ^c.size_t, exitcode: ^c.int) -> rawptr ---


	// Get the IOStream associated with process standard input.
	//
	// The process must have been created with CreateProcess() and pipe_stdio
	// set to true, or with CreateProcessWithProperties() and
	// `PROP_PROCESS_CREATE_STDIN_NUMBER` set to `PROCESS_STDIO_APP`.
	//
	// Writing to this stream can return less data than expected if the process
	// hasn't read its input. It may be blocked waiting for its output to be read,
	// so if you may need to call GetOutputStream() and read the output in
	// parallel with writing input.
	//
	// \param process The process to get the input stream for.
	// \returns the input stream or NULL on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProcess
	// \sa CreateProcessWithProperties
	// \sa GetProcessOutput

	GetProcessInput :: proc(process: ^Process) -> ^IOStream ---


	// Get the IOStream associated with process standard output.
	//
	// The process must have been created with CreateProcess() and pipe_stdio
	// set to true, or with CreateProcessWithProperties() and
	// `PROP_PROCESS_CREATE_STDOUT_NUMBER` set to `PROCESS_STDIO_APP`.
	//
	// Reading from this stream can return 0 with GetIOStatus() returning
	// IO_STATUS_NOT_READY if no output is available yet.
	//
	// \param process The process to get the output stream for.
	// \returns the output stream or NULL on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProcess
	// \sa CreateProcessWithProperties
	// \sa GetProcessInput

	GetProcessOutput :: proc(process: ^Process) -> ^IOStream ---


	// Stop a process.
	//
	// \param process The process to stop.
	// \param force true to terminate the process immediately, false to try to
	//              stop the process gracefully. In general you should try to stop
	//              the process gracefully first as terminating a process may
	//              leave it with half-written data or in some other unstable
	//              state.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety This function is not thread safe.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProcess
	// \sa CreateProcessWithProperties
	// \sa WaitProcess
	// \sa DestroyProcess

	KillProcess :: proc(process: ^Process, force: c.bool) -> c.bool ---


	// Wait for a process to finish.
	//
	// This can be called multiple times to get the status of a process.
	//
	// The exit code will be the exit code of the process if it terminates
	// normally, a negative signal if it terminated due to a signal, or -255
	// otherwise. It will not be changed if the process is still running.
	//
	// \param process The process to wait for.
	// \param block If true, block until the process finishes; otherwise, report
	//              on the process' status.
	// \param exitcode a pointer filled in with the process exit code if the
	//                 process has exited, may be NULL.
	// \returns true if the process exited, false otherwise.
	//
	// \threadsafety This function is not thread safe.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProcess
	// \sa CreateProcessWithProperties
	// \sa KillProcess
	// \sa DestroyProcess

	WaitProcess :: proc(process: ^Process, block: c.bool, exitcode: ^c.int) -> c.bool ---


	// Destroy a previously created process object.
	//
	// Note that this does not stop the process, just destroys the SDL object used
	// to track it. If you want to stop the process you should use
	// KillProcess().
	//
	// \param process The process object to destroy.
	//
	// \threadsafety This function is not thread safe.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProcess
	// \sa CreateProcessWithProperties
	// \sa KillProcess

	DestroyProcess :: proc(process: ^Process) ---
}
