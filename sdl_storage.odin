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


// # CategoryStorage
//
// SDL storage container management.


/* !!! FIXME: Don't let this ship without async R/W support!!! */


// Function interface for Storage.
//
// Apps that want to supply a custom implementation of Storage will fill
// in all the functions in this struct, and then pass it to OpenStorage to
// create a custom Storage object.
//
// It is not usually necessary to do this; SDL provides standard
// implementations for many things you might expect to do with an Storage.
//
// This structure should be initialized using INIT_INTERFACE()
//
// \since This struct is available since SDL 3.0.0.
//
// \sa INIT_INTERFACE

StorageInterface :: struct {
	/* The version of this interface */
	version:         c.uint32_t,

	/* Called when the storage is closed */
	close:           #type proc "c" (userdata: rawptr) -> c.bool,

	/* Optional, returns whether the storage is currently ready for access */
	ready:           #type proc "c" (userdata: rawptr) -> c.bool,

	/* Enumerate a directory, optional for write-only storage */
	enumerate:       #type proc "c" (
		userdata: rawptr,
		path: cstring,
		callback: EnumerateDirectoryCallback,
		callback_userdata: rawptr,
	) -> c.bool,

	/* Get path information, optional for write-only storage */
	info:            #type proc "c" (userdata: rawptr, path: cstring, info: ^PathInfo) -> c.bool,

	/* Read a file from storage, optional for write-only storage */
	read_file:       #type proc "c" (
		userdata: rawptr,
		path: cstring,
		destination: rawptr,
		length: c.uint64_t,
	) -> c.bool,

	/* Write a file to storage, optional for read-only storage */
	write_file:      #type proc "c" (
		userdata: rawptr,
		path: cstring,
		source: rawptr,
		length: c.uint64_t,
	) -> c.bool,

	/* Create a directory, optional for read-only storage */
	mkdir:           #type proc "c" (userdata: rawptr, path: cstring) -> c.bool,

	/* Remove a file or empty directory, optional for read-only storage */
	remove:          #type proc "c" (userdata: rawptr, path: cstring) -> c.bool,

	/* Rename a path, optional for read-only storage */
	rename:          #type proc "c" (userdata: rawptr, oldpath, newpath: cstring) -> c.bool,

	/* Copy a file, optional for read-only storage */
	copy:            #type proc "c" (userdata: rawptr, oldpath, newpath: cstring) -> c.bool,

	/* Get the space remaining, optional for read-only storage */
	space_remaining: #type proc "c" (userdata: rawptr) -> c.uint64_t,
}

// Check the size of StorageInterface 
//
// If this assert fails, either the compiler is padding to an unexpected size,
// or the interface has been updated and this should be updated to match and
// the code using this interface should be updated to handle the old version.

#assert(
	(size_of(rawptr) == 4 && size_of(StorageInterface) == 48) ||
	(size_of(rawptr) == 8 && size_of(StorageInterface) == 96),
)


// An abstract interface for filesystem access.
//
// This is an opaque datatype. One can create this object using standard SDL
// functions like OpenTitleStorage or OpenUserStorage, etc, or create
// an object with a custom implementation using OpenStorage.
//
// \since This struct is available since SDL 3.0.0.

Storage :: distinct struct {}


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Opens up a read-only container for the application's filesystem.
	//
	// \param override a path to override the backend's default title root.
	// \param props a property list that may contain backend-specific information.
	// \returns a title storage container on success or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseStorage
	// \sa GetStorageFileSize
	// \sa OpenUserStorage
	// \sa ReadStorageFile

	OpenTitleStorage :: proc(override: cstring, props: PropertiesID) -> ^Storage ---


	// Opens up a container for a user's unique read/write filesystem.
	//
	// While title storage can generally be kept open throughout runtime, user
	// storage should only be opened when the client is ready to read/write files.
	// This allows the backend to properly batch file operations and flush them
	// when the container has been closed; ensuring safe and optimal save I/O.
	//
	// \param org the name of your organization.
	// \param app the name of your application.
	// \param props a property list that may contain backend-specific information.
	// \returns a user storage container on success or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseStorage
	// \sa GetStorageFileSize
	// \sa GetStorageSpaceRemaining
	// \sa OpenTitleStorage
	// \sa ReadStorageFile
	// \sa StorageReady
	// \sa WriteStorageFile

	OpenUserStorage :: proc(org, app: cstring, props: PropertiesID) -> ^Storage ---


	// Opens up a container for local filesystem storage.
	//
	// This is provided for development and tools. Portable applications should
	// use OpenTitleStorage() for access to game data and
	// OpenUserStorage() for access to user data.
	//
	// \param path the base path prepended to all storage paths, or NULL for no
	//             base path.
	// \returns a filesystem storage container on success or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseStorage
	// \sa GetStorageFileSize
	// \sa GetStorageSpaceRemaining
	// \sa OpenTitleStorage
	// \sa OpenUserStorage
	// \sa ReadStorageFile
	// \sa WriteStorageFile

	OpenFileStorage :: proc(path: cstring) -> ^Storage ---


	// Opens up a container using a client-provided storage interface.
	//
	// Applications do not need to use this function unless they are providing
	// their own Storage implementation. If you just need an Storage, you
	// should use the built-in implementations in SDL, like OpenTitleStorage()
	// or OpenUserStorage().
	//
	// This function makes a copy of `iface` and the caller does not need to keep
	// it around after this call.
	//
	// \param iface the interface that implements this storage, initialized using
	//              INIT_INTERFACE().
	// \param userdata the pointer that will be passed to the interface functions.
	// \returns a storage container on success or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseStorage
	// \sa GetStorageFileSize
	// \sa GetStorageSpaceRemaining
	// \sa INIT_INTERFACE
	// \sa ReadStorageFile
	// \sa StorageReady
	// \sa WriteStorageFile

	OpenStorage :: proc(iface: ^StorageInterface, userdata: rawptr) -> ^Storage ---


	// Closes and frees a storage container.
	//
	// \param storage a storage container to close.
	// \returns true if the container was freed with no errors, false otherwise;
	//          call GetError() for more information. Even if the function
	//          returns an error, the container data will be freed; the error is
	//          only for informational purposes.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa OpenFileStorage
	// \sa OpenStorage
	// \sa OpenTitleStorage
	// \sa OpenUserStorage

	CloseStorage :: proc(storage: ^Storage) -> c.bool ---


	// Checks if the storage container is ready to use.
	//
	// This function should be called in regular intervals until it returns true -
	// however, it is not recommended to spinwait on this call, as the backend may
	// depend on a synchronous message loop.
	//
	// \param storage a storage container to query.
	// \returns true if the container is ready, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.

	StorageReady :: proc(storage: ^Storage) -> c.bool ---


	// Query the size of a file within a storage container.
	//
	// \param storage a storage container to query.
	// \param path the relative path of the file to query.
	// \param length a pointer to be filled with the file's length.
	// \returns true if the file could be queried or false on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ReadStorageFile
	// \sa StorageReady

	GetStorageFileSize :: proc(storage: ^Storage, path: cstring, length: ^c.uint64_t) -> c.bool ---


	// Synchronously read a file from a storage container into a client-provided
	// buffer.
	//
	// \param storage a storage container to read from.
	// \param path the relative path of the file to read.
	// \param destination a client-provided buffer to read the file into.
	// \param length the length of the destination buffer.
	// \returns true if the file was read or false on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetStorageFileSize
	// \sa StorageReady
	// \sa WriteStorageFile

	ReadStorageFile :: proc(storage: ^Storage, path: cstring, destination: rawptr, length: c.uint64_t) -> c.bool ---


	// Synchronously write a file from client memory into a storage container.
	//
	// \param storage a storage container to write to.
	// \param path the relative path of the file to write.
	// \param source a client-provided buffer to write from.
	// \param length the length of the source buffer.
	// \returns true if the file was written or false on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetStorageSpaceRemaining
	// \sa ReadStorageFile
	// \sa StorageReady

	WriteStorageFile :: proc(storage: ^Storage, path: cstring, source: rawptr, length: c.uint64_t) -> c.bool ---


	// Create a directory in a writable storage container.
	//
	// \param storage a storage container.
	// \param path the path of the directory to create.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StorageReady

	CreateStorageDirectory :: proc(storage: ^Storage, path: cstring) -> c.bool ---


	// Enumerate a directory in a storage container through a callback function.
	//
	// This function provides every directory entry through an app-provided
	// callback, called once for each directory entry, until all results have been
	// provided or the callback returns <= 0.
	//
	// This will return false if there was a system problem in general, or if a
	// callback returns -1. A successful return means a callback returned 1 to
	// halt enumeration, or all directory entries were enumerated.
	//
	// \param storage a storage container.
	// \param path the path of the directory to enumerate.
	// \param callback a function that is called for each entry in the directory.
	// \param userdata a pointer that is passed to `callback`.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StorageReady

	EnumerateStorageDirectory :: proc(storage: ^Storage, path: cstring, callback: EnumerateDirectoryCallback, userdata: rawptr) -> c.bool ---


	// Remove a file or an empty directory in a writable storage container.
	//
	// \param storage a storage container.
	// \param path the path of the directory to enumerate.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StorageReady

	RemoveStoragePath :: proc(storage: ^Storage, path: cstring) -> c.bool ---


	// Rename a file or directory in a writable storage container.
	//
	// \param storage a storage container.
	// \param oldpath the old path.
	// \param newpath the new path.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StorageReady

	RenameStoragePath :: proc(storage: ^Storage, oldpath, newpath: cstring) -> c.bool ---


	// Copy a file in a writable storage container.
	//
	// \param storage a storage container.
	// \param oldpath the old path.
	// \param newpath the new path.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StorageReady

	CopyStorageFile :: proc(storage: ^Storage, oldpath, newpath: cstring) -> c.bool ---


	// Get information about a filesystem path in a storage container.
	//
	// \param storage a storage container.
	// \param path the path to query.
	// \param info a pointer filled in with information about the path, or NULL to
	//             check for the existence of a file.
	// \returns true on success or false if the file doesn't exist, or another
	//          failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StorageReady

	GetStoragePathInfo :: proc(storage: ^Storage, path: cstring, info: ^PathInfo) -> c.bool ---


	// Queries the remaining space in a storage container.
	//
	// \param storage a storage container to query.
	// \returns the amount of remaining space, in bytes.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa StorageReady
	// \sa WriteStorageFile

	GetStorageSpaceRemaining :: proc(storage: ^Storage) -> c.uint64_t ---


	// Enumerate a directory tree, filtered by pattern, and return a list.
	//
	// Files are filtered out if they don't match the string in `pattern`, which
	// may contain wildcard characters '*' (match everything) and '?' (match one
	// character). If pattern is NULL, no filtering is done and all results are
	// returned. Subdirectories are permitted, and are specified with a path
	// separator of '/'. Wildcard characters '*' and '?' never match a path
	// separator.
	//
	// `flags` may be set to GLOB_CASEINSENSITIVE to make the pattern matching
	// case-insensitive.
	//
	// The returned array is always NULL-terminated, for your iterating
	// convenience, but if `count` is non-NULL, on return it will contain the
	// number of items in the array, not counting the NULL terminator.
	//
	// \param storage a storage container.
	// \param path the path of the directory to enumerate.
	// \param pattern the pattern that files in the directory must match. Can be
	//                NULL.
	// \param flags `GLOB_*` bitflags that affect this search.
	// \param count on return, will be set to the number of items in the returned
	//              array. Can be NULL.
	// \returns an array of strings on success or NULL on failure; call
	//          GetError() for more information. The caller should pass the
	//          returned pointer to free when done with it. This is a single
	//          allocation that should be freed with free() when it is no
	//          longer needed.
	//
	// \threadsafety It is safe to call this function from any thread, assuming
	//               the `storage` object is thread-safe.
	//
	// \since This function is available since SDL 3.0.0.

	GlobStorageDirectory :: proc(storage: ^Storage, path, pattern: cstring, flags: GlobFlags, count: ^c.int) -> [^]cstring ---

}
