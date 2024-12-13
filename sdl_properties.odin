package sdl3

/*
  Simple DiretMedia Layer
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


// # CategoryProperties
//
// A property is a variable that can be created and retrieved by name at
// runtime.
//
// All properties are part of a property group (PropertiesID). A property
// group can be created with the CreateProperties function and destroyed
// with the DestroyProperties function.
//
// Properties can be added to and retrieved from a property group through the
// following functions:
//
// - SetPointerProperty and GetPointerProperty operate on `void*`
//   pointer types.
// - SetStringProperty and GetStringProperty operate on string types.
// - SetNumberProperty and GetNumberProperty operate on signed 64-bit
//   integer types.
// - SetFloatProperty and GetFloatProperty operate on floating point
//   types.
// - SetBooleanProperty and GetBooleanProperty operate on boolean
//   types.
//
// Properties can be removed from a group by using ClearProperty.


// SDL properties ID
//
// \since This datatype is available since SDL 3.0.0.

PropertiesID :: distinct c.uint32_t


// SDL property type
//
// \since This enum is available since SDL 3.0.0.

PropertyType :: enum c.int {
	INVALID,
	POINTER,
	STRING,
	NUMBER,
	FLOAT,
	BOOLEAN,
}


// A callback used to free resources when a property is deleted.
//
// This should release any resources associated with `value` that are no
// longer needed.
//
// This callback is set per-property. Different properties in the same group
// can have different cleanup callbacks.
//
// This callback will be called _during_ SetPointerPropertyWithCleanup if
// the function fails for any reason.
//
// \param userdata an app-defined pointer passed to the callback.
// \param value the pointer assigned to the property to clean up.
//
// \threadsafety This callback may fire without any locks held; if this is a
//               concern, the app should provide its own locking.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa SetPointerPropertyWithCleanup

CleanupPropertyCallback :: #type proc "c" (userdata, value: rawptr)


// A callback used to enumerate all the properties in a group of properties.
//
// This callback is called from EnumerateProperties(), and is called once
// per property in the set.
//
// \param userdata an app-defined pointer passed to the callback.
// \param props the PropertiesID that is being enumerated.
// \param name the next property name in the enumeration.
//
// \threadsafety EnumerateProperties holds a lock on `props` during this
//               callback.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa EnumerateProperties

EnumeratePropertiesCallback :: #type proc "c" (
	userdata: rawptr,
	props: PropertiesID,
	name: cstring,
)

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get the global SDL properties.
	//
	// \returns a valid property ID on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetGlobalProperties :: proc() -> PropertiesID ---


	// Create a group of properties.
	//
	// All properties are automatically destroyed when Quit() is called.
	//
	// \returns an ID for a new group of properties, or 0 on failure; call
	//          GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa DestroyProperties

	CreateProperties :: proc() -> PropertiesID ---


	// Copy a group of properties.
	//
	// Copy all the properties from one group of properties to another, with the
	// exception of properties requiring cleanup (set using
	// SetPointerPropertyWithCleanup()), which will not be copied. Any
	// property that already exists on `dst` will be overwritten.
	//
	// \param src the properties to copy.
	// \param dst the destination properties.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	CopyProperties :: proc(src, dst: PropertiesID) -> c.bool ---


	// Lock a group of properties.
	//
	// Obtain a multi-threaded lock for these properties. Other threads will wait
	// while trying to lock these properties until they are unlocked. Properties
	// must be unlocked before they are destroyed.
	//
	// The lock is automatically taken when setting individual properties, this
	// function is only needed when you want to set several properties atomically
	// or want to guarantee that properties being queried aren't freed in another
	// thread.
	//
	// \param props the properties to lock.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa UnlockProperties

	LockProperties :: proc(props: PropertiesID) -> c.bool ---


	// Unlock a group of properties.
	//
	// \param props the properties to unlock.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LockProperties

	UnlockProperties :: proc(props: PropertiesID) ---


	// Set a pointer property in a group of properties with a cleanup function
	// that is called when the property is deleted.
	//
	// The cleanup function is also called if setting the property fails for any
	// reason.
	//
	// For simply setting basic data types, like numbers, bools, or strings, use
	// SetNumberProperty, SetBooleanProperty, or SetStringProperty
	// instead, as those functions will handle cleanup on your behalf. This
	// function is only for more complex, custom data.
	//
	// \param props the properties to modify.
	// \param name the name of the property to modify.
	// \param value the new value of the property, or NULL to delete the property.
	// \param cleanup the function to call when this property is deleted, or NULL
	//                if no cleanup is necessary.
	// \param userdata a pointer that is passed to the cleanup function.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPointerProperty
	// \sa SetPointerProperty
	// \sa CleanupPropertyCallback

	SetPointerPropertyWithCleanup :: proc(props: PropertiesID, name: cstring, value: rawptr, cleanup: CleanupPropertyCallback, userdata: rawptr) -> c.bool ---


	// Set a pointer property in a group of properties.
	//
	// \param props the properties to modify.
	// \param name the name of the property to modify.
	// \param value the new value of the property, or NULL to delete the property.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPointerProperty
	// \sa HasProperty
	// \sa SetBooleanProperty
	// \sa SetFloatProperty
	// \sa SetNumberProperty
	// \sa SetPointerPropertyWithCleanup
	// \sa SetStringProperty

	SetPointerProperty :: proc(props: PropertiesID, name: cstring, value: rawptr) -> c.bool ---


	// Set a string property in a group of properties.
	//
	// This function makes a copy of the string; the caller does not have to
	// preserve the data after this call completes.
	//
	// \param props the properties to modify.
	// \param name the name of the property to modify.
	// \param value the new value of the property, or NULL to delete the property.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetStringProperty

	SetStringProperty :: proc(props: PropertiesID, name, value: cstring) -> c.bool ---


	// Set an integer property in a group of properties.
	//
	// \param props the properties to modify.
	// \param name the name of the property to modify.
	// \param value the new value of the property.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetNumberProperty

	SetNumberProperty :: proc(props: PropertiesID, name: cstring, value: c.int64_t) -> c.bool ---


	// Set a floating point property in a group of properties.
	//
	// \param props the properties to modify.
	// \param name the name of the property to modify.
	// \param value the new value of the property.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetFloatProperty

	SetFloatProperty :: proc(props: PropertiesID, name: cstring, value: c.float) -> c.bool ---


	// Set a boolean property in a group of properties.
	//
	// \param props the properties to modify.
	// \param name the name of the property to modify.
	// \param value the new value of the property.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetBooleanProperty

	SetBooleanProperty :: proc(props: PropertiesID, name: cstring, value: c.bool) -> c.bool ---


	// Return whether a property exists in a group of properties.
	//
	// \param props the properties to query.
	// \param name the name of the property to query.
	// \returns true if the property exists, or false if it doesn't.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPropertyType

	HasProperty :: proc(props: PropertiesID, name: cstring) -> c.bool ---


	// Get the type of a property in a group of properties.
	//
	// \param props the properties to query.
	// \param name the name of the property to query.
	// \returns the type of the property, or PROPERTY_TYPE_INVALID if it is
	//          not set.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa HasProperty

	GetPropertyType :: proc(props: PropertiesID, name: cstring) -> PropertyType ---


	// Get a pointer property from a group of properties.
	//
	// By convention, the names of properties that SDL exposes on objects will
	// start with "SDL.", and properties that SDL uses internally will start with
	// "SDL.internal.". These should be considered read-only and should not be
	// modified by applications.
	//
	// \param props the properties to query.
	// \param name the name of the property to query.
	// \param default_value the default value of the property.
	// \returns the value of the property, or `default_value` if it is not set or
	//          not a pointer property.
	//
	// \threadsafety It is safe to call this function from any thread, although
	//               the data returned is not protected and could potentially be
	//               freed if you call SetPointerProperty() or
	//               ClearProperty() on these properties from another thread.
	//               If you need to avoid this, use LockProperties() and
	//               UnlockProperties().
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetBooleanProperty
	// \sa GetFloatProperty
	// \sa GetNumberProperty
	// \sa GetPropertyType
	// \sa GetStringProperty
	// \sa HasProperty
	// \sa SetPointerProperty

	GetPointerProperty :: proc(props: PropertiesID, name: cstring, default_value: rawptr) -> rawptr ---


	// Get a string property from a group of properties.
	//
	// \param props the properties to query.
	// \param name the name of the property to query.
	// \param default_value the default value of the property.
	// \returns the value of the property, or `default_value` if it is not set or
	//          not a string property.
	//
	// \threadsafety It is safe to call this function from any thread, although
	//               the data returned is not protected and could potentially be
	//               freed if you call SetStringProperty() or
	//               ClearProperty() on these properties from another thread.
	//               If you need to avoid this, use LockProperties() and
	//               UnlockProperties().
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPropertyType
	// \sa HasProperty
	// \sa SetStringProperty

	GetStringProperty :: proc(props: PropertiesID, name, default_value: cstring) -> cstring ---


	// Get a number property from a group of properties.
	//
	// You can use GetPropertyType() to query whether the property exists and
	// is a number property.
	//
	// \param props the properties to query.
	// \param name the name of the property to query.
	// \param default_value the default value of the property.
	// \returns the value of the property, or `default_value` if it is not set or
	//          not a number property.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPropertyType
	// \sa HasProperty
	// \sa SetNumberProperty

	GetNumberProperty :: proc(props: PropertiesID, name: cstring, default_value: c.int64_t) -> c.int64_t ---


	// Get a floating point property from a group of properties.
	//
	// You can use GetPropertyType() to query whether the property exists and
	// is a floating point property.
	//
	// \param props the properties to query.
	// \param name the name of the property to query.
	// \param default_value the default value of the property.
	// \returns the value of the property, or `default_value` if it is not set or
	//          not a float property.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPropertyType
	// \sa HasProperty
	// \sa SetFloatProperty

	GetFloatProperty :: proc(props: PropertiesID, name: cstring, default_value: c.float) -> c.float ---


	// Get a boolean property from a group of properties.
	//
	// You can use GetPropertyType() to query whether the property exists and
	// is a boolean property.
	//
	// \param props the properties to query.
	// \param name the name of the property to query.
	// \param default_value the default value of the property.
	// \returns the value of the property, or `default_value` if it is not set or
	//          not a boolean property.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPropertyType
	// \sa HasProperty
	// \sa SetBooleanProperty

	GetBooleanProperty :: proc(props: PropertiesID, name: cstring, default_value: c.bool) -> c.bool ---


	// Clear a property from a group of properties.
	//
	// \param props the properties to modify.
	// \param name the name of the property to clear.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	ClearProperty :: proc(props: PropertiesID, name: cstring) -> c.bool ---


	// Enumerate the properties contained in a group of properties.
	//
	// The callback function is called for each property in the group of
	// properties. The properties are locked during enumeration.
	//
	// \param props the properties to query.
	// \param callback the function to call for each property.
	// \param userdata a pointer that is passed to `callback`.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	EnumerateProperties :: proc(props: PropertiesID, callback: EnumeratePropertiesCallback, userdata: rawptr) -> c.bool ---


	// Destroy a group of properties.
	//
	// All properties are deleted and their cleanup functions will be called, if
	// any.
	//
	// \param props the properties to destroy.
	//
	// \threadsafety This function should not be called while these properties are
	//               locked or other threads might be setting or getting values
	//               from these properties.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProperties

	DestroyProperties :: proc(props: PropertiesID) ---
}
