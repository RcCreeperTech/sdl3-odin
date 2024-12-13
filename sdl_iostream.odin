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

/* WIKI CATEGORY: IOStream */

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


// # CategoryIOStream
//
// SDL provides an abstract interface for reading and writing data streams. It
// offers implementations for files, memory, etc, and the app can provideo
// their own implementations, too.
//
// IOStream is not related to the standard C++ iostream class, other than
// both are abstract interfaces to read/write data.


// IOStream status, set by a read or write operation.
//
// \since This enum is available since SDL 3.0.0.

IOStatus :: enum c.int {
	READY, /**< Everything is ready (no errors and not EOF). */
	ERROR, /**< Read or write I/O error */
	EOF, /**< End of file */
	NOT_READY, /**< Non blocking I/O, not ready */
	READONLY, /**< Tried to write a read-only buffer */
	WRITEONLY, /**< Tried to read a write-only buffer */
}


// Possible `whence` values for IOStream seeking.
//
// These map to the same "whence" concept that `fseek` or `lseek` use in the
// standard C runtime.
//
// \since This enum is available since SDL 3.0.0.

IOWhence :: enum c.int {
	SET, /**< Seek from the beginning of data */
	CUR, /**< Seek relative to current read point */
	END, /**< Seek relative to the end of data */
}


// The function pointers that drive an IOStream.
//
// Applications can provide this struct to OpenIO() to create their own
// implementation of IOStream. This is not necessarily required, as SDL
// already offers several common types of I/O streams, via functions like
// IOFromFile() and IOFromMem().
//
// This structure should be initialized using INIT_INTERFACE()
//
// \since This struct is available since SDL 3.0.0.
//
// \sa INIT_INTERFACE

IOStreamInterface :: struct {
	/* The version of this interface */
	version: c.uint32_t,


	//  Return the number of bytes in this IOStream
	//
	//  \return the total size of the data stream, or -1 on error.
	size:    #type proc "c" (userdata: rawptr) -> c.int64_t,


	//  Seek to `offset` relative to `whence`, one of stdio's whence values:
	//  IO_SEEK_SET, IO_SEEK_CUR, IO_SEEK_END
	//
	//  \return the final offset in the data stream, or -1 on error.
	seek:    #type proc "c" (userdata: rawptr, offset: c.int64_t, whence: IOWhence) -> c.int64_t,


	//  Read up to `size` bytes from the data stream to the area pointed
	//  at by `ptr`.
	//
	//  On an incomplete read, you should set `*status` to a value from the
	//  IOStatus enum. You do not have to explicitly set this on
	//  a complete, successful read.
	//
	//  \return the number of bytes read
	read:    #type proc "c" (
		userdata: rawptr,
		ptr: rawptr,
		size: c.size_t,
		status: ^IOStatus,
	) -> c.size_t,


	//  Write exactly `size` bytes from the area pointed at by `ptr`
	//  to data stream.
	//
	//  On an incomplete write, you should set `*status` to a value from the
	//  IOStatus enum. You do not have to explicitly set this on
	//  a complete, successful write.
	//
	//  \return the number of bytes written
	write:   #type proc "c" (
		userdata: rawptr,
		ptr: rawptr,
		size: c.size_t,
		status: ^IOStatus,
	) -> c.size_t,


	//  If the stream is buffering, make sure the data is written out.
	//
	//  On failure, you should set `*status` to a value from the
	//  IOStatus enum. You do not have to explicitly set this on
	//  a successful flush.
	//
	//  \return true if successful or false on write error when flushing data.
	flush:   #type proc "c" (userdata: rawptr, status: ^IOStatus) -> c.bool,


	//  Close and free any allocated resources.
	//
	//  This does not guarantee file writes will sync to physical media; they
	//  can be in the system's file cache, waiting to go to disk.
	//
	//  The IOStream is still destroyed even if this fails, so clean up anything
	//  even if flushing buffers, etc, returns an error.
	//
	//  \return true if successful or false on write error when flushing data.
	close:   #type proc "c" (userdata: rawptr) -> c.bool,
}

// Check the size of IOStreamInterface
//
// If this assert fails, either the compiler is padding to an unexpected size,
// or the interface has been updated and this should be updated to match and
// the code using this interface should be updated to handle the old version.

#assert(
	(size_of(rawptr) == 4 && size_of(IOStreamInterface) == 28) ||
	(size_of(rawptr) == 8 && size_of(IOStreamInterface) == 56),
)


// The read/write operation structure.
//
// This operates as an opaque handle. There are several APIs to create various
// types of I/O streams, or an app can supply an IOStreamInterface to
// OpenIO() to provide their own stream implementation behind this
// struct's abstract interface.
//
// \since This struct is available since SDL 3.0.0.

IOStream :: distinct struct {}

PROP_IOSTREAM_WINDOWS_HANDLE_POINTER :: "SDL.iostream.windows.handle"
PROP_IOSTREAM_STDIO_FILE_POINTER :: "SDL.iostream.stdio.file"
PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER :: "SDL.iostream.file_descriptor"
PROP_IOSTREAM_ANDROID_AASSET_POINTER :: "SDL.iostream.android.aasset"
PROP_IOSTREAM_MEMORY_POINTER :: "SDL.iostream.memory.base"
PROP_IOSTREAM_MEMORY_SIZE_NUMBER :: "SDL.iostream.memory.size"
PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER :: "SDL.iostream.dynamic.memory"
PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER :: "SDL.iostream.dynamic.chunksize"


//  \name IOFrom functions
//
//  Functions to create IOStream structures from various data streams.

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Use this function to create a new IOStream structure for reading from
	// and/or writing to a named file.
	//
	// The `mode` string is treated roughly the same as in a call to the C
	// library's fopen(), even if SDL doesn't happen to use fopen() behind the
	// scenes.
	//
	// Available `mode` strings:
	//
	// - "r": Open a file for reading. The file must exist.
	// - "w": Create an empty file for writing. If a file with the same name
	//   already exists its content is erased and the file is treated as a new
	//   empty file.
	// - "a": Append to a file. Writing operations append data at the end of the
	//   file. The file is created if it does not exist.
	// - "r+": Open a file for update both reading and writing. The file must
	//   exist.
	// - "w+": Create an empty file for both reading and writing. If a file with
	//   the same name already exists its content is erased and the file is
	//   treated as a new empty file.
	// - "a+": Open a file for reading and appending. All writing operations are
	//   performed at the end of the file, protecting the previous content to be
	//   overwritten. You can reposition (fseek, rewind) the internal pointer to
	//   anywhere in the file for reading, but writing operations will move it
	//   back to the end of file. The file is created if it does not exist.
	//
	// **NOTE**: In order to open a file as a binary file, a "b" character has to
	// be included in the `mode` string. This additional "b" character can either
	// be appended at the end of the string (thus making the following compound
	// modes: "rb", "wb", "ab", "r+b", "w+b", "a+b") or be inserted between the
	// letter and the "+" sign for the mixed modes ("rb+", "wb+", "ab+").
	// Additional characters may follow the sequence, although they should have no
	// effect. For example, "t" is sometimes appended to make explicit the file is
	// a text file.
	//
	// This function supports Unicode filenames, but they must be encoded in UTF-8
	// format, regardless of the underlying operating system.
	//
	// In Android, IOFromFile() can be used to open content:// URIs. As a
	// fallback, IOFromFile() will transparently open a matching filename in
	// the app's `assets`.
	//
	// Closing the IOStream will close SDL's internal file handle.
	//
	// The following properties may be set at creation time by SDL:
	//
	// - `PROP_IOSTREAM_WINDOWS_HANDLE_POINTER`: a pointer, that can be cast
	//   to a win32 `HANDLE`, that this IOStream is using to access the
	//   filesystem. If the program isn't running on Windows, or SDL used some
	//   other method to access the filesystem, this property will not be set.
	// - `PROP_IOSTREAM_STDIO_FILE_POINTER`: a pointer, that can be cast to a
	//   stdio `FILE *`, that this IOStream is using to access the filesystem.
	//   If SDL used some other method to access the filesystem, this property
	//   will not be set. PLEASE NOTE that if SDL is using a different C runtime
	//   than your app, trying to use this pointer will almost certainly result in
	//   a crash! This is mostly a problem on Windows; make sure you build SDL and
	//   your app with the same compiler and settings to avoid it.
	// - `PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER`: a file descriptor that this
	//   IOStream is using to access the filesystem.
	// - `PROP_IOSTREAM_ANDROID_AASSET_POINTER`: a pointer, that can be cast
	//   to an Android NDK `AAsset *`, that this IOStream is using to access
	//   the filesystem. If SDL used some other method to access the filesystem,
	//   this property will not be set.
	//
	// \param file a UTF-8 string representing the filename to open.
	// \param mode an ASCII string representing the mode to be used for opening
	//             the file.
	// \returns a pointer to the IOStream structure that is created or NULL on
	//          failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseIO
	// \sa FlushIO
	// \sa ReadIO
	// \sa SeekIO
	// \sa TellIO
	// \sa WriteIO

	IOFromFile :: proc(file, mode: cstring) -> ^IOStream ---


	// Use this function to prepare a read-write memory buffer for use with
	// IOStream.
	//
	// This function sets up an IOStream struct based on a memory area of a
	// certain size, for both read and write access.
	//
	// This memory buffer is not copied by the IOStream; the pointer you
	// provide must remain valid until you close the stream. Closing the stream
	// will not free the original buffer.
	//
	// If you need to make sure the IOStream never writes to the memory
	// buffer, you should use IOFromConstMem() with a read-only buffer of
	// memory instead.
	//
	// The following properties will be set at creation time by SDL:
	//
	// - `PROP_IOSTREAM_MEMORY_POINTER`: this will be the `mem` parameter that
	//   was passed to this function.
	// - `PROP_IOSTREAM_MEMORY_SIZE_NUMBER`: this will be the `size` parameter
	//   that was passed to this function.
	//
	// \param mem a pointer to a buffer to feed an IOStream stream.
	// \param size the buffer size, in bytes.
	// \returns a pointer to a new IOStream structure or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa IOFromConstMem
	// \sa CloseIO
	// \sa FlushIO
	// \sa ReadIO
	// \sa SeekIO
	// \sa TellIO
	// \sa WriteIO

	IOFromMem :: proc(mem: rawptr, size: c.size_t) -> ^IOStream ---


	// Use this function to prepare a read-only memory buffer for use with
	// IOStream.
	//
	// This function sets up an IOStream struct based on a memory area of a
	// certain size. It assumes the memory area is not writable.
	//
	// Attempting to write to this IOStream stream will report an error
	// without writing to the memory buffer.
	//
	// This memory buffer is not copied by the IOStream; the pointer you
	// provide must remain valid until you close the stream. Closing the stream
	// will not free the original buffer.
	//
	// If you need to write to a memory buffer, you should use IOFromMem()
	// with a writable buffer of memory instead.
	//
	// The following properties will be set at creation time by SDL:
	//
	// - `PROP_IOSTREAM_MEMORY_POINTER`: this will be the `mem` parameter that
	//   was passed to this function.
	// - `PROP_IOSTREAM_MEMORY_SIZE_NUMBER`: this will be the `size` parameter
	//   that was passed to this function.
	//
	// \param mem a pointer to a read-only buffer to feed an IOStream stream.
	// \param size the buffer size, in bytes.
	// \returns a pointer to a new IOStream structure or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa IOFromMem
	// \sa CloseIO
	// \sa ReadIO
	// \sa SeekIO
	// \sa TellIO

	IOFromConstMem :: proc(mem: rawptr, size: c.size_t) -> ^IOStream ---


	// Use this function to create an IOStream that is backed by dynamically
	// allocated memory.
	//
	// This supports the following properties to provide access to the memory and
	// control over allocations:
	//
	// - `PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER`: a pointer to the internal
	//   memory of the stream. This can be set to NULL to transfer ownership of
	//   the memory to the application, which should free the memory with
	//   free(). If this is done, the next operation on the stream must be
	//   CloseIO().
	// - `PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER`: memory will be allocated in
	//   multiples of this size, defaulting to 1024.
	//
	// \returns a pointer to a new IOStream structure or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseIO
	// \sa ReadIO
	// \sa SeekIO
	// \sa TellIO
	// \sa WriteIO

	IOFromDynamicMem :: proc() -> ^IOStream ---


	// Create a custom IOStream.
	//
	// Applications do not need to use this function unless they are providing
	// their own IOStream implementation. If you just need an IOStream to
	// read/write a common data source, you should use the built-in
	// implementations in SDL, like IOFromFile() or IOFromMem(), etc.
	//
	// This function makes a copy of `iface` and the caller does not need to keep
	// it around after this call.
	//
	// \param iface the interface that implements this IOStream, initialized
	//              using INIT_INTERFACE().
	// \param userdata the pointer that will be passed to the interface functions.
	// \returns a pointer to the allocated memory on success or NULL on failure;
	//          call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseIO
	// \sa INIT_INTERFACE
	// \sa IOFromConstMem
	// \sa IOFromFile
	// \sa IOFromMem

	OpenIO :: proc(iface: ^IOStreamInterface, userdata: rawptr) -> ^IOStream ---


	// Close and free an allocated IOStream structure.
	//
	// CloseIO() closes and cleans up the IOStream stream. It releases any
	// resources used by the stream and frees the IOStream itself. This
	// returns true on success, or false if the stream failed to flush to its
	// output (e.g. to disk).
	//
	// Note that if this fails to flush the stream for any reason, this function
	// reports an error, but the IOStream is still invalid once this function
	// returns.
	//
	// This call flushes any buffered writes to the operating system, but there
	// are no guarantees that those writes have gone to physical media; they might
	// be in the OS's file cache, waiting to go to disk later. If it's absolutely
	// crucial that writes go to disk immediately, so they are definitely stored
	// even if the power fails before the file cache would have caught up, one
	// should call FlushIO() before closing. Note that flushing takes time and
	// makes the system and your app operate less efficiently, so do so sparingly.
	//
	// \param context IOStream structure to close.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa OpenIO

	CloseIO :: proc(ctx: ^IOStream) -> c.bool ---


	// Get the properties associated with an IOStream.
	//
	// \param context a pointer to an IOStream structure.
	// \returns a valid property ID on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetIOProperties :: proc(ctx: ^IOStream) -> PropertiesID ---


	// Query the stream status of an IOStream.
	//
	// This information can be useful to decide if a short read or write was due
	// to an error, an EOF, or a non-blocking operation that isn't yet ready to
	// complete.
	//
	// An IOStream's status is only expected to change after a ReadIO or
	// WriteIO call; don't expect it to change if you just call this query
	// function in a tight loop.
	//
	// \param context the IOStream to query.
	// \returns an IOStatus enum with the current state.
	//
	// \threadsafety This function should not be called at the same time that
	//               another thread is operating on the same IOStream.
	//
	// \since This function is available since SDL 3.0.0.

	GetIOStatus :: proc(ctx: ^IOStream) -> IOStatus ---


	// Use this function to get the size of the data stream in an IOStream.
	//
	// \param context the IOStream to get the size of the data stream from.
	// \returns the size of the data stream in the IOStream on success or a
	//          negative error code on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GetIOSize :: proc(ctx: ^IOStream) -> c.int64_t ---


	// Seek within an IOStream data stream.
	//
	// This function seeks to byte `offset`, relative to `whence`.
	//
	// `whence` may be any of the following values:
	//
	// - `IO_SEEK_SET`: seek from the beginning of data
	// - `IO_SEEK_CUR`: seek relative to current read point
	// - `IO_SEEK_END`: seek relative to the end of data
	//
	// If this stream can not seek, it will return -1.
	//
	// \param context a pointer to an IOStream structure.
	// \param offset an offset in bytes, relative to `whence` location; can be
	//               negative.
	// \param whence any of `IO_SEEK_SET`, `IO_SEEK_CUR`,
	//               `IO_SEEK_END`.
	// \returns the final offset in the data stream after the seek or -1 on
	//          failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa TellIO

	SeekIO :: proc(ctx: ^IOStream, offset: c.int64_t, whence: IOWhence) -> c.int64_t ---


	// Determine the current read/write offset in an IOStream data stream.
	//
	// TellIO is actually a wrapper function that calls the IOStream's
	// `seek` method, with an offset of 0 bytes from `IO_SEEK_CUR`, to
	// simplify application development.
	//
	// \param context an IOStream data stream object from which to get the
	//                current offset.
	// \returns the current offset in the stream, or -1 if the information can not
	//          be determined.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SeekIO

	TellIO :: proc(ctx: ^IOStream) -> c.int64_t ---


	// Read from a data source.
	//
	// This function reads up `size` bytes from the data source to the area
	// pointed at by `ptr`. This function may read less bytes than requested. It
	// will return zero when the data stream is completely read, and
	// GetIOStatus() will return IO_STATUS_EOF, or on error, and
	// GetIOStatus() will return IO_STATUS_ERROR.
	//
	// \param context a pointer to an IOStream structure.
	// \param ptr a pointer to a buffer to read data into.
	// \param size the number of bytes to read from the data source.
	// \returns the number of bytes read, or 0 on end of file or other failure;
	//          call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa WriteIO
	// \sa GetIOStatus

	ReadIO :: proc(ctx: ^IOStream, ptr: rawptr, size: c.size_t) -> c.size_t ---


	// Write to an IOStream data stream.
	//
	// This function writes exactly `size` bytes from the area pointed at by `ptr`
	// to the stream. If this fails for any reason, it'll return less than `size`
	// to demonstrate how far the write progressed. On success, it returns `size`.
	//
	// On error, this function still attempts to write as much as possible, so it
	// might return a positive value less than the requested write size.
	//
	// The caller can use GetIOStatus() to determine if the problem is
	// recoverable, such as a non-blocking write that can simply be retried later,
	// or a fatal error.
	//
	// \param context a pointer to an IOStream structure.
	// \param ptr a pointer to a buffer containing data to write.
	// \param size the number of bytes to write.
	// \returns the number of bytes written, which will be less than `size` on
	//          failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa IOprintf
	// \sa ReadIO
	// \sa SeekIO
	// \sa FlushIO
	// \sa GetIOStatus

	WriteIO :: proc(ctx: ^IOStream, ptr: rawptr, size: c.size_t) -> c.size_t ---


	// Print to an IOStream data stream.
	//
	// This function does formatted printing to the stream.
	//
	// \param context a pointer to an IOStream structure.
	// \param fmt a printf() style format string.
	// \param ... additional parameters matching % tokens in the `fmt` string, if
	//            any.
	// \returns the number of bytes written or 0 on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa IOvprintf
	// \sa WriteIO

	IOprintf :: proc(ctx: ^IOStream, fmt: cstring, #c_vararg args: ..any) -> c.size_t ---


	// Print to an IOStream data stream.
	//
	// This function does formatted printing to the stream.
	//
	// \param context a pointer to an IOStream structure.
	// \param fmt a printf() style format string.
	// \param ap a variable argument list.
	// \returns the number of bytes written or 0 on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa IOprintf
	// \sa WriteIO

	IOvprintf :: proc(ctx: ^IOStream, fmt: cstring, ap: c.va_list) -> c.size_t ---


	// Flush any buffered data in the stream.
	//
	// This function makes sure that any buffered data is written to the stream.
	// Normally this isn't necessary but if the stream is a pipe or socket it
	// guarantees that any pending data is sent.
	//
	// \param context IOStream structure to flush.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa OpenIO
	// \sa WriteIO

	FlushIO :: proc(ctx: ^IOStream) -> c.bool ---


	// Load all the data from an SDL data stream.
	//
	// The data is allocated with a zero byte at the end (null terminated) for
	// convenience. This extra byte is not included in the value reported via
	// `datasize`.
	//
	// The data should be freed with free().
	//
	// \param src the IOStream to read all available data from.
	// \param datasize a pointer filled in with the number of bytes read, may be
	//                 NULL.
	// \param closeio if true, calls CloseIO() on `src` before returning, even
	//                in the case of an error.
	// \returns the data or NULL on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LoadFile

	LoadFile_IO :: proc(src: ^IOStream, datasize: ^c.size_t, closeio: c.bool) -> rawptr ---


	// Load all the data from a file path.
	//
	// The data is allocated with a zero byte at the end (null terminated) for
	// convenience. This extra byte is not included in the value reported via
	// `datasize`.
	//
	// The data should be freed with free().
	//
	// \param file the path to read all available data from.
	// \param datasize if not NULL, will store the number of bytes read.
	// \returns the data or NULL on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LoadFile_IO

	LoadFile :: proc(file: cstring, datasize: ^c.size_t) -> rawptr ---


	//  \name Read endian functions
	//
	//  Read an item of the specified endianness and return in native format.


	// Use this function to read a byte from an IOStream.
	//
	// \param src the IOStream to read from.
	// \param value a pointer filled in with the data read.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadU8 :: proc(src: ^IOStream, value: ^u8) -> c.bool ---


	// Use this function to read a signed byte from an IOStream.
	//
	// \param src the IOStream to read from.
	// \param value a pointer filled in with the data read.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadS8 :: proc(src: ^IOStream, value: ^i8) -> c.bool ---


	// Use this function to read 16 bits of little-endian data from an
	// IOStream and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadU16LE :: proc(src: ^IOStream, value: ^u16le) -> c.bool ---


	// Use this function to read 16 bits of little-endian data from an
	// IOStream and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadS16LE :: proc(src: ^IOStream, value: ^i16le) -> c.bool ---


	// Use this function to read 16 bits of big-endian data from an IOStream
	// and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadU16BE :: proc(src: ^IOStream, value: ^u16be) -> c.bool ---


	// Use this function to read 16 bits of big-endian data from an IOStream
	// and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadS16BE :: proc(src: ^IOStream, value: ^i16be) -> c.bool ---


	// Use this function to read 32 bits of little-endian data from an
	// IOStream and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadU32LE :: proc(src: ^IOStream, value: ^u32le) -> c.bool ---


	// Use this function to read 32 bits of little-endian data from an
	// IOStream and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadS32LE :: proc(src: ^IOStream, value: ^i32le) -> c.bool ---


	// Use this function to read 32 bits of big-endian data from an IOStream
	// and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadU32BE :: proc(src: ^IOStream, value: ^u32be) -> c.bool ---


	// Use this function to read 32 bits of big-endian data from an IOStream
	// and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadS32BE :: proc(src: ^IOStream, value: ^i32be) -> c.bool ---


	// Use this function to read 64 bits of little-endian data from an
	// IOStream and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadU64LE :: proc(src: ^IOStream, value: ^u64le) -> c.bool ---


	// Use this function to read 64 bits of little-endian data from an
	// IOStream and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadS64LE :: proc(src: ^IOStream, value: ^i64le) -> c.bool ---


	// Use this function to read 64 bits of big-endian data from an IOStream
	// and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadU64BE :: proc(src: ^IOStream, value: u64be) -> c.bool ---


	// Use this function to read 64 bits of big-endian data from an IOStream
	// and return in native format.
	//
	// SDL byteswaps the data only if necessary, so the data returned will be in
	// the native byte order.
	//
	// \param src the stream from which to read data.
	// \param value a pointer filled in with the data read.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	ReadS64BE :: proc(src: ^IOStream, value: ^i64be) -> c.bool ---


	//  \name Write endian functions
	//
	//  Write an item of native format to the specified endianness.


	// Use this function to write a byte to an IOStream.
	//
	// \param dst the IOStream to write to.
	// \param value the byte value to write.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteU8 :: proc(dst: ^IOStream, value: u8) -> c.bool ---


	// Use this function to write a signed byte to an IOStream.
	//
	// \param dst the IOStream to write to.
	// \param value the byte value to write.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteS8 :: proc(dst: ^IOStream, value: i8) -> c.bool ---


	// Use this function to write 16 bits in native format to an IOStream as
	// little-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in little-endian
	// format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteU16LE :: proc(dst: ^IOStream, value: u16) -> c.bool ---


	// Use this function to write 16 bits in native format to an IOStream as
	// little-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in little-endian
	// format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteS16LE :: proc(dst: ^IOStream, value: i16) -> c.bool ---


	// Use this function to write 16 bits in native format to an IOStream as
	// big-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in big-endian format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteU16BE :: proc(dst: ^IOStream, value: u16) -> c.bool ---


	// Use this function to write 16 bits in native format to an IOStream as
	// big-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in big-endian format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteS16BE :: proc(dst: ^IOStream, value: i16) -> c.bool ---


	// Use this function to write 32 bits in native format to an IOStream as
	// little-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in little-endian
	// format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteU32LE :: proc(dst: ^IOStream, value: u32) -> c.bool ---


	// Use this function to write 32 bits in native format to an IOStream as
	// little-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in little-endian
	// format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteS32LE :: proc(dst: ^IOStream, value: i32) -> c.bool ---


	// Use this function to write 32 bits in native format to an IOStream as
	// big-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in big-endian format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteU32BE :: proc(dst: ^IOStream, value: u32) -> c.bool ---


	// Use this function to write 32 bits in native format to an IOStream as
	// big-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in big-endian format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteS32BE :: proc(dst: ^IOStream, value: i32) -> c.bool ---


	// Use this function to write 64 bits in native format to an IOStream as
	// little-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in little-endian
	// format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteU64LE :: proc(dst: ^IOStream, value: u64) -> c.bool ---


	// Use this function to write 64 bits in native format to an IOStream as
	// little-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in little-endian
	// format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteS64LE :: proc(dst: ^IOStream, value: i64) -> c.bool ---


	// Use this function to write 64 bits in native format to an IOStream as
	// big-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in big-endian format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteU64BE :: proc(dst: ^IOStream, value: u64) -> c.bool ---


	// Use this function to write 64 bits in native format to an IOStream as
	// big-endian data.
	//
	// SDL byteswaps the data only if necessary, so the application always
	// specifies native format, and the data written will be in big-endian format.
	//
	// \param dst the stream to which data will be written.
	// \param value the data to be written, in native format.
	// \returns true on successful write or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.

	WriteS64BE :: proc(dst: ^IOStream, value: i64) -> c.bool ---
}