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
import "core:math"

when ODIN_OS != .Windows {
	foreign import lib "system:SDL3"
} else when ODIN_ARCH == .amd64 {
	foreign import lib "./lib/x64/SDL3.lib"
} else when ODIN_ARCH == .i386 {
	foreign import lib "./lib/x86/SDL3.lib"
} else when ODIN_ARCH == .amd64 {
	foreign import lib "./lib/arm64/SDL3.lib"
} else do #panic("Unsupported Architecture")


FLT_EPSILON :: math.F32_EPSILON


// # CategoryStdinc
//
// This is a general header that includes C language support. It implements a
// subset of the C runtime APIs, but with an `` prefix. For most common
// use cases, these should behave the same way as their C runtime equivalents,
// but they may differ in how or whether they handle certain edge cases. When
// in doubt, consult the documentation for details.


// Define a four character code as a Uint32.
//
// \param A the first ASCII character.
// \param B the second ASCII character.
// \param C the third ASCII character.
// \param D the fourth ASCII character.
// \returns the four characters converted into a Uint32, one character
//          per-byte.
//
// \threadsafety It is safe to call this macro from any thread.
//
// \since This macro is available since SDL 3.0.0.

FOURCC :: #force_inline proc "c" (A, B, C, D: u8) -> u32 {
	return (u32(A) << 0) | (u32(B) << 8) | (u32(C) << 16) | (u32(D) << 24)
}


// A callback used to implement malloc().
//
// SDL will always ensure that the passed `size` is greater than 0.
//
// \param size the size to allocate.
// \returns a pointer to the allocated memory, or NULL if allocation failed.
//
// \threadsafety It should be safe to call this callback from any thread.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa malloc
// \sa GetOriginalMemoryFunctions
// \sa GetMemoryFunctions
// \sa SetMemoryFunctions

Malloc_Func :: #type proc "c" (size: c.size_t) -> rawptr


// A callback used to implement calloc().
//
// SDL will always ensure that the passed `nmemb` and `size` are both greater
// than 0.
//
// \param nmemb the number of elements in the array.
// \param size the size of each element of the array.
// \returns a pointer to the allocated array, or NULL if allocation failed.
//
// \threadsafety It should be safe to call this callback from any thread.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa calloc
// \sa GetOriginalMemoryFunctions
// \sa GetMemoryFunctions
// \sa SetMemoryFunctions

Calloc_Func :: #type proc "c" (nmemb, size: c.size_t) -> rawptr


// A callback used to implement realloc().
//
// SDL will always ensure that the passed `size` is greater than 0.
//
// \param mem a pointer to allocated memory to reallocate, or NULL.
// \param size the new size of the memory.
// \returns a pointer to the newly allocated memory, or NULL if allocation
//          failed.
//
// \threadsafety It should be safe to call this callback from any thread.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa realloc
// \sa GetOriginalMemoryFunctions
// \sa GetMemoryFunctions
// \sa SetMemoryFunctions

Realloc_Func :: #type proc "c" (mem: rawptr, size: c.size_t) -> rawptr


// A callback used to implement free().
//
// SDL will always ensure that the passed `mem` is a non-NULL pointer.
//
// \param mem a pointer to allocated memory.
//
// \threadsafety It should be safe to call this callback from any thread.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa free
// \sa GetOriginalMemoryFunctions
// \sa GetMemoryFunctions
// \sa SetMemoryFunctions

Free_Func :: #type proc "c" (mem: rawptr)


// A thread-safe set of environment variables
//
// \since This struct is available since SDL 3.0.0.
//
// \sa GetEnvironment
// \sa CreateEnvironment
// \sa GetEnvironmentVariable
// \sa GetEnvironmentVariables
// \sa SetEnvironmentVariable
// \sa UnsetEnvironmentVariable
// \sa DestroyEnvironment

Environment :: distinct struct {}


// A callback used with SDL sorting and binary search functions.
//
// \param a a pointer to the first element being compared.
// \param b a pointer to the second element being compared.
// \returns -1 if `a` should be sorted before `b`, 1 if `b` should be sorted
//          before `a`, 0 if they are equal. If two elements are equal, their
//          order in the sorted array is undefined.
//
// \since This callback is available since SDL 3.0.0.
//
// \sa bsearch
// \sa qsort

CompareCallback :: #type proc "c" (a, b: rawptr) -> c.int


// A callback used with SDL sorting and binary search functions.
//
// \param userdata the `userdata` pointer passed to the sort function.
// \param a a pointer to the first element being compared.
// \param b a pointer to the second element being compared.
// \returns -1 if `a` should be sorted before `b`, 1 if `b` should be sorted
//          before `a`, 0 if they are equal. If two elements are equal, their
//          order in the sorted array is undefined.
//
// \since This callback is available since SDL 3.0.0.
//
// \sa qsort_r
// \sa bsearch_r

CompareCallback_r :: #type proc "c" (userdata, a, b: rawptr) -> c.int

// The Unicode REPLACEMENT CHARACTER codepoint.
//
// StepUTF8() reports this codepoint when it encounters a UTF-8 string
// with encoding errors.
//
// This tends to render as something like a question mark in most places.
//
// \since This macro is available since SDL 3.0.0.
//
// \sa StepUTF8

INVALID_UNICODE_CODEPOINT :: 0xFFFD

// A generic function pointer.
//
// In theory, generic function pointers should use this, instead of `void *`,
// since some platforms could treat code addresses differently than data
// addresses. Although in current times no popular platforms make this
// distinction, it is more correct and portable to use the correct type for a
// generic pointer.
//
// If for some reason you need to force this typedef to be an actual `void *`,
// perhaps to work around a compiler or existing code, you can define
// `FUNCTION_POINTER_IS_VOID_POINTER` before including any SDL headers.
//
// \since This datatype is available since SDL 3.0.0.

FunctionPointer :: #type proc "c" ()


/* The SDL implementation of iconv() returns these error codes */
// #define ICONV_ERROR     (size_t)-1
// #define ICONV_E2BIG     (size_t)-2
// #define ICONV_EILSEQ    (size_t)-3
// #define ICONV_EINVAL    (size_t)-4
//
// typedef struct iconv_data_t *iconv_t;
iconv_t :: distinct rawptr

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Allocate uninitialized memory.
	//
	// The allocated memory returned by this function must be freed with
	// free().
	//
	// If `size` is 0, it will be set to 1.
	//
	// If you want to allocate memory aligned to a specific alignment, consider
	// using aligned_alloc().
	//
	// \param size the size to allocate.
	// \returns a pointer to the allocated memory, or NULL if allocation failed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa free
	// \sa calloc
	// \sa realloc
	// \sa aligned_alloc

	malloc :: proc(size: c.size_t) -> rawptr ---


	// Allocate a zero-initialized array.
	//
	// The memory returned by this function must be freed with free().
	//
	// If either of `nmemb` or `size` is 0, they will both be set to 1.
	//
	// \param nmemb the number of elements in the array.
	// \param size the size of each element of the array.
	// \returns a pointer to the allocated array, or NULL if allocation failed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa free
	// \sa malloc
	// \sa realloc

	calloc :: proc(nmemb, size: c.size_t) -> rawptr ---


	// Change the size of allocated memory.
	//
	// The memory returned by this function must be freed with free().
	//
	// If `size` is 0, it will be set to 1. Note that this is unlike some other C
	// runtime `realloc` implementations, which may treat `realloc(mem, 0)` the
	// same way as `free(mem)`.
	//
	// If `mem` is NULL, the behavior of this function is equivalent to
	// malloc(). Otherwise, the function can have one of three possible
	// outcomes:
	//
	// - If it returns the same pointer as `mem`, it means that `mem` was resized
	//   in place without freeing.
	// - If it returns a different non-NULL pointer, it means that `mem` was freed
	//   and cannot be dereferenced anymore.
	// - If it returns NULL (indicating failure), then `mem` will remain valid and
	//   must still be freed with free().
	//
	// \param mem a pointer to allocated memory to reallocate, or NULL.
	// \param size the new size of the memory.
	// \returns a pointer to the newly allocated memory, or NULL if allocation
	//          failed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa free
	// \sa malloc
	// \sa calloc

	realloc :: proc(mem: rawptr, size: c.size_t) -> rawptr ---


	// Free allocated memory.
	//
	// The pointer is no longer valid after this call and cannot be dereferenced
	// anymore.
	//
	// If `mem` is NULL, this function does nothing.
	//
	// \param mem a pointer to allocated memory, or NULL.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa malloc
	// \sa calloc
	// \sa realloc

	free :: proc(mem: rawptr) ---


	// Get the original set of SDL memory functions.
	//
	// This is what malloc and friends will use by default, if there has been
	// no call to SetMemoryFunctions. This is not necessarily using the C
	// runtime's `malloc` functions behind the scenes! Different platforms and
	// build configurations might do any number of unexpected things.
	//
	// \param malloc_func filled with malloc function.
	// \param calloc_func filled with calloc function.
	// \param realloc_func filled with realloc function.
	// \param free_func filled with free function.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetOriginalMemoryFunctions :: proc(malloc_func: ^Malloc_Func, calloc_func: ^Calloc_Func, realloc_func: ^Realloc_Func, free_func: ^Free_Func) ---


	// Get the current set of SDL memory functions.
	//
	// \param malloc_func filled with malloc function.
	// \param calloc_func filled with calloc function.
	// \param realloc_func filled with realloc function.
	// \param free_func filled with free function.
	//
	// \threadsafety This does not hold a lock, so do not call this in the
	//               unlikely event of a background thread calling
	//               SetMemoryFunctions simultaneously.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetMemoryFunctions
	// \sa GetOriginalMemoryFunctions

	GetMemoryFunctions :: proc(malloc_func: ^Malloc_Func, calloc_func: ^Calloc_Func, realloc_func: ^Realloc_Func, free_func: ^Free_Func) ---


	// Replace SDL's memory allocation functions with a custom set.
	//
	// It is not safe to call this function once any allocations have been made,
	// as future calls to free will use the new allocator, even if they came
	// from an malloc made with the old one!
	//
	// If used, usually this needs to be the first call made into the SDL library,
	// if not the very first thing done at program startup time.
	//
	// \param malloc_func custom malloc function.
	// \param calloc_func custom calloc function.
	// \param realloc_func custom realloc function.
	// \param free_func custom free function.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread, but one
	//               should not replace the memory functions once any allocations
	//               are made!
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetMemoryFunctions
	// \sa GetOriginalMemoryFunctions

	SetMemoryFunctions :: proc(malloc_func: Malloc_Func, calloc_func: Calloc_Func, realloc_func: Realloc_Func, free_func: Free_Func) -> c.bool ---

	// Allocate memory aligned to a specific alignment.
	//
	// The memory returned by this function must be freed with aligned_free(),
	// _not_ free().
	//
	// If `alignment` is less than the size of `void *`, it will be increased to
	// match that.
	//
	// The returned memory address will be a multiple of the alignment value, and
	// the size of the memory allocated will be a multiple of the alignment value.
	//
	// \param alignment the alignment of the memory.
	// \param size the size to allocate.
	// \returns a pointer to the aligned memory, or NULL if allocation failed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa aligned_free

	aligned_alloc :: proc(alignment, size: c.size_t) -> rawptr ---


	// Free memory allocated by aligned_alloc().
	//
	// The pointer is no longer valid after this call and cannot be dereferenced
	// anymore.
	//
	// If `mem` is NULL, this function does nothing.
	//
	// \param mem a pointer previously returned by aligned_alloc(), or NULL.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa aligned_alloc

	aligned_free :: proc(mem: rawptr) ---


	// Get the number of outstanding (unfreed) allocations.
	//
	// \returns the number of allocations.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetNumAllocations :: proc() -> c.int ---


	// Get the process environment.
	//
	// This is initialized at application start and is not affected by setenv()
	// and unsetenv() calls after that point. Use SetEnvironmentVariable() and
	// UnsetEnvironmentVariable() if you want to modify this environment, or
	// setenv_unsafe() or unsetenv_unsafe() if you want changes to persist
	// in the C runtime environment after Quit().
	//
	// \returns a pointer to the environment for the process or NULL on failure;
	//          call GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetEnvironmentVariable
	// \sa GetEnvironmentVariables
	// \sa SetEnvironmentVariable
	// \sa UnsetEnvironmentVariable

	GetEnvironment :: proc() -> ^Environment ---


	// Create a set of environment variables
	//
	// \param populated true to initialize it from the C runtime environment,
	//                  false to create an empty environment.
	// \returns a pointer to the new environment or NULL on failure; call
	//          GetError() for more information.
	//
	// \threadsafety If `populated` is false, it is safe to call this function
	//               from any thread, otherwise it is safe if no other threads are
	//               calling setenv() or unsetenv()
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetEnvironmentVariable
	// \sa GetEnvironmentVariables
	// \sa SetEnvironmentVariable
	// \sa UnsetEnvironmentVariable
	// \sa DestroyEnvironment

	CreateEnvironment :: proc(populated: c.bool) -> ^Environment ---


	// Get the value of a variable in the environment.
	//
	// \param env the environment to query.
	// \param name the name of the variable to get.
	// \returns a pointer to the value of the variable or NULL if it can't be
	//          found.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetEnvironment
	// \sa CreateEnvironment
	// \sa GetEnvironmentVariables
	// \sa SetEnvironmentVariable
	// \sa UnsetEnvironmentVariable

	GetEnvironmentVariable :: proc(env: ^Environment, name: cstring) -> cstring ---


	// Get all variables in the environment.
	//
	// \param env the environment to query.
	// \returns a NULL terminated array of pointers to environment variables in
	//          the form "variable=value" or NULL on failure; call GetError()
	//          for more information. This is a single allocation that should be
	//          freed with free() when it is no longer needed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetEnvironment
	// \sa CreateEnvironment
	// \sa GetEnvironmentVariables
	// \sa SetEnvironmentVariable
	// \sa UnsetEnvironmentVariable

	GetEnvironmentVariables :: proc(env: ^Environment) -> [^]cstring ---


	// Set the value of a variable in the environment.
	//
	// \param env the environment to modify.
	// \param name the name of the variable to set.
	// \param value the value of the variable to set.
	// \param overwrite true to overwrite the variable if it exists, false to
	//                  return success without setting the variable if it already
	//                  exists.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetEnvironment
	// \sa CreateEnvironment
	// \sa GetEnvironmentVariable
	// \sa GetEnvironmentVariables
	// \sa UnsetEnvironmentVariable

	SetEnvironmentVariable :: proc(env: ^Environment, name: cstring, value: cstring, overwrite: c.bool) -> c.bool ---


	// Clear a variable from the environment.
	//
	// \param env the environment to modify.
	// \param name the name of the variable to unset.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetEnvironment
	// \sa CreateEnvironment
	// \sa GetEnvironmentVariable
	// \sa GetEnvironmentVariables
	// \sa SetEnvironmentVariable
	// \sa UnsetEnvironmentVariable

	UnsetEnvironmentVariable :: proc(env: ^Environment, name: cstring) -> c.bool ---


	// Destroy a set of environment variables.
	//
	// \param env the environment to destroy.
	//
	// \threadsafety It is safe to call this function from any thread, as long as
	//               the environment is no longer in use.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateEnvironment

	DestroyEnvironment :: proc(env: ^Environment) ---


	// Get the value of a variable in the environment.
	//
	// This function uses SDL's cached copy of the environment and is thread-safe.
	//
	// \param name the name of the variable to get.
	// \returns a pointer to the value of the variable or NULL if it can't be
	//          found.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	getenv :: proc(name: cstring) -> cstring ---


	// Get the value of a variable in the environment.
	//
	// This function bypasses SDL's cached copy of the environment and is not
	// thread-safe.
	//
	// \param name the name of the variable to get.
	// \returns a pointer to the value of the variable or NULL if it can't be
	//          found.
	//
	// \threadsafety This function is not thread safe, consider using getenv()
	//               instead.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa getenv

	getenv_unsafe :: proc(name: cstring) -> cstring ---


	// Set the value of a variable in the environment.
	//
	// \param name the name of the variable to set.
	// \param value the value of the variable to set.
	// \param overwrite 1 to overwrite the variable if it exists, 0 to return
	//                  success without setting the variable if it already exists.
	// \returns 0 on success, -1 on error.
	//
	// \threadsafety This function is not thread safe, consider using
	//               SetEnvironmentVariable() instead.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetEnvironmentVariable

	setenv_unsafe :: proc(name: cstring, value: cstring, overwrite: c.int) -> c.int ---


	// Clear a variable from the environment.
	//
	// \param name the name of the variable to unset.
	// \returns 0 on success, -1 on error.
	//
	// \threadsafety This function is not thread safe, consider using
	//               UnsetEnvironmentVariable() instead.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa UnsetEnvironmentVariable

	unsetenv_unsafe :: proc(name: cstring) -> c.int ---


	// Sort an array.
	//
	// For example:
	//
	// ```c
	// typedef struct {
	//     int key;
	//     str: cstringing;
	// } data;
	//
	// int  compare(const void *a, const void *b)
	// {
	//     const data *A = (const data *)a;
	//     const data *B = (const data *)b;
	//
	//     if (A->n < B->n) {
	//         return -1;
	//     } else if (B->n < A->n) {
	//         return 1;
	//     } else {
	//         return 0;
	//     }
	// }
	//
	// data values[] = {
	//     { 3, "third" }, { 1, "first" }, { 2, "second" }
	// };
	//
	// qsort(values, arraysize(values), sizeof(values[0]), compare);
	// ```
	//
	// \param base a pointer to the start of the array.
	// \param nmemb the number of elements in the array.
	// \param size the size of the elements in the array.
	// \param compare a function used to compare elements in the array.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa bsearch
	// \sa qsort_r

	qsort :: proc(base: rawptr, nmemb: c.size_t, size: c.size_t, compare: CompareCallback) ---


	// Perform a binary search on a previously sorted array.
	//
	// For example:
	//
	// ```c
	// typedef struct {
	//     int key;
	//     str: cstringing;
	// } data;
	//
	// int  compare(const void *a, const void *b)
	// {
	//     const data *A = (const data *)a;
	//     const data *B = (const data *)b;
	//
	//     if (A->n < B->n) {
	//         return -1;
	//     } else if (B->n < A->n) {
	//         return 1;
	//     } else {
	//         return 0;
	//     }
	// }
	//
	// data values[] = {
	//     { 1, "first" }, { 2, "second" }, { 3, "third" }
	// };
	// data key = { 2, NULL };
	//
	// data *result = bsearch(&key, values, arraysize(values), sizeof(values[0]), compare);
	// ```
	//
	// \param key a pointer to a key equal to the element being searched for.
	// \param base a pointer to the start of the array.
	// \param nmemb the number of elements in the array.
	// \param size the size of the elements in the array.
	// \param compare a function used to compare elements in the array.
	// \returns a pointer to the matching element in the array, or NULL if not
	//          found.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa bsearch_r
	// \sa qsort

	bsearch :: proc(key, base: rawptr, nmemb, size: c.size_t, compare: CompareCallback) -> rawptr ---


	// Sort an array, passing a userdata pointer to the compare function.
	//
	// For example:
	//
	// ```c
	// typedef enum {
	//     sort_increasing,
	//     sort_decreasing,
	// } sort_method;
	//
	// typedef struct {
	//     int key;
	//     str: cstringing;
	// } data;
	//
	// int  compare(const void *userdata, const void *a, const void *b)
	// {
	//     sort_method method = (sort_method)(uintptr_t)userdata;
	//     const data *A = (const data *)a;
	//     const data *B = (const data *)b;
	//
	//     if (A->n < B->n) {
	//         return (method == sort_increasing) ? -1 : 1;
	//     } else if (B->n < A->n) {
	//         return (method == sort_increasing) ? 1 : -1;
	//     } else {
	//         return 0;
	//     }
	// }
	//
	// data values[] = {
	//     { 3, "third" }, { 1, "first" }, { 2, "second" }
	// };
	//
	// qsort_r(values, arraysize(values), sizeof(values[0]), compare, (const void *)(uintptr_t)sort_increasing);
	// ```
	//
	// \param base a pointer to the start of the array.
	// \param nmemb the number of elements in the array.
	// \param size the size of the elements in the array.
	// \param compare a function used to compare elements in the array.
	// \param userdata a pointer to pass to the compare function.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa bsearch_r
	// \sa qsort

	qsort_r :: proc(base: rawptr, nmemb, size: c.size_t, compare: CompareCallback_r, userdata: rawptr) ---


	// Perform a binary search on a previously sorted array, passing a userdata
	// pointer to the compare function.
	//
	// For example:
	//
	// ```c
	// typedef enum {
	//     sort_increasing,
	//     sort_decreasing,
	// } sort_method;
	//
	// typedef struct {
	//     int key;
	//     str: cstringing;
	// } data;
	//
	// int  compare(const void *userdata, const void *a, const void *b)
	// {
	//     sort_method method = (sort_method)(uintptr_t)userdata;
	//     const data *A = (const data *)a;
	//     const data *B = (const data *)b;
	//
	//     if (A->n < B->n) {
	//         return (method == sort_increasing) ? -1 : 1;
	//     } else if (B->n < A->n) {
	//         return (method == sort_increasing) ? 1 : -1;
	//     } else {
	//         return 0;
	//     }
	// }
	//
	// data values[] = {
	//     { 1, "first" }, { 2, "second" }, { 3, "third" }
	// };
	// data key = { 2, NULL };
	//
	// data *result = bsearch_r(&key, values, arraysize(values), sizeof(values[0]), compare, (const void *)(uintptr_t)sort_increasing);
	// ```
	//
	// \param key a pointer to a key equal to the element being searched for.
	// \param base a pointer to the start of the array.
	// \param nmemb the number of elements in the array.
	// \param size the size of the elements in the array.
	// \param compare a function used to compare elements in the array.
	// \param userdata a pointer to pass to the compare function.
	// \returns a pointer to the matching element in the array, or NULL if not
	//          found.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa bsearch
	// \sa qsort_r

	bsearch_r :: proc(key, base: rawptr, nmemb, size: c.size_t, compare: CompareCallback_r, userdata: rawptr) -> rawptr ---

	abs :: proc(x: c.int) -> c.int ---

	// Query if a character is alphabetic (a letter).
	//
	// **WARNING**: Regardless of system locale, this will only treat ASCII values
	// for English 'a-z' and 'A-Z' as true.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	isalpha :: proc(x: c.int) -> c.int ---


	// Query if a character is alphabetic (a letter) or a number.
	//
	// **WARNING**: Regardless of system locale, this will only treat ASCII values
	// for English 'a-z', 'A-Z', and '0-9' as true.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	isalnum :: proc(x: c.int) -> c.int ---


	// Report if a character is blank (a space or tab).
	//
	// **WARNING**: Regardless of system locale, this will only treat ASCII values
	// 0x20 (space) or 0x9 (tab) as true.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	isblank :: proc(x: c.int) -> c.int ---


	// Report if a character is a control character.
	//
	// **WARNING**: Regardless of system locale, this will only treat ASCII values
	// 0 through 0x1F, and 0x7F, as true.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	iscntrl :: proc(x: c.int) -> c.int ---


	// Report if a character is a numeric digit.
	//
	// **WARNING**: Regardless of system locale, this will only treat ASCII values
	// '0' (0x30) through '9' (0x39), as true.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	isdigit :: proc(x: c.int) -> c.int ---


	// Report if a character is a hexadecimal digit.
	//
	// **WARNING**: Regardless of system locale, this will only treat ASCII values
	// 'A' through 'F', 'a' through 'f', and '0' through '9', as true.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	isxdigit :: proc(x: c.int) -> c.int ---


	// Report if a character is a punctuation mark.
	//
	// **WARNING**: Regardless of system locale, this is equivalent to
	// `((isgraph(x)) && (!isalnum(x)))`.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa isgraph
	// \sa isalnum

	ispunct :: proc(x: c.int) -> c.int ---


	// Report if a character is whitespace.
	//
	// **WARNING**: Regardless of system locale, this will only treat the
	// following ASCII values as true:
	//
	// - space (0x20)
	// - tab (0x09)
	// - newline (0x0A)
	// - vertical tab (0x0B)
	// - form feed (0x0C)
	// - return (0x0D)
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	isspace :: proc(x: c.int) -> c.int ---


	// Report if a character is upper case.
	//
	// **WARNING**: Regardless of system locale, this will only treat ASCII values
	// 'A' through 'Z' as true.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	isupper :: proc(x: c.int) -> c.int ---


	// Report if a character is lower case.
	//
	// **WARNING**: Regardless of system locale, this will only treat ASCII values
	// 'a' through 'z' as true.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	islower :: proc(x: c.int) -> c.int ---


	// Report if a character is "printable".
	//
	// Be advised that "printable" has a definition that goes back to text
	// terminals from the dawn of computing, making this a sort of special case
	// function that is not suitable for Unicode (or most any) text management.
	//
	// **WARNING**: Regardless of system locale, this will only treat ASCII values
	// ' ' (0x20) through '~' (0x7E) as true.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	isprint :: proc(x: c.int) -> c.int ---


	// Report if a character is any "printable" except space.
	//
	// Be advised that "printable" has a definition that goes back to text
	// terminals from the dawn of computing, making this a sort of special case
	// function that is not suitable for Unicode (or most any) text management.
	//
	// **WARNING**: Regardless of system locale, this is equivalent to
	// `(isprint(x)) && ((x) != ' ')`.
	//
	// \param x character value to check.
	// \returns non-zero if x falls within the character class, zero otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa isprint

	isgraph :: proc(x: c.int) -> c.int ---


	// Convert low-ASCII English letters to uppercase.
	//
	// **WARNING**: Regardless of system locale, this will only convert ASCII
	// values 'a' through 'z' to uppercase.
	//
	// This function returns the uppercase equivalent of `x`. If a character
	// cannot be converted, or is already uppercase, this function returns `x`.
	//
	// \param x character value to check.
	// \returns capitalized version of x, or x if no conversion available.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	toupper :: proc(x: c.int) -> c.int ---


	// Convert low-ASCII English letters to lowercase.
	//
	// **WARNING**: Regardless of system locale, this will only convert ASCII
	// values 'A' through 'Z' to lowercase.
	//
	// This function returns the lowercase equivalent of `x`. If a character
	// cannot be converted, or is already lowercase, this function returns `x`.
	//
	// \param x character value to check.
	// \returns lowercase version of x, or x if no conversion available.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	tolower :: proc(x: c.int) -> c.int ---

	crc16 :: proc(crc: c.uint16_t, data: rawptr, len: c.size_t) -> c.uint16_t ---
	crc32 :: proc(crc: c.uint32_t, data: rawptr, len: c.size_t) -> c.uint32_t ---
	murmur3_32 :: proc(data: rawptr, len: c.size_t, seed: c.uint32_t) -> c.uint32_t ---


	// Copy non-overlapping memory.
	//
	// The memory regions must not overlap. If they do, use memmove() instead.
	//
	// \param dst The destination memory region. Must not be NULL, and must not
	//            overlap with `src`.
	// \param src The source memory region. Must not be NULL, and must not overlap
	//            with `dst`.
	// \param len The length in bytes of both `dst` and `src`.
	// \returns `dst`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa memmove

	memcpy :: proc(dst, src: rawptr, len: c.size_t) -> rawptr ---


	// Copy memory.
	//
	// It is okay for the memory regions to overlap. If you are confident that the
	// regions never overlap, using memcpy() may improve performance.
	//
	// \param dst The destination memory region. Must not be NULL.
	// \param src The source memory region. Must not be NULL.
	// \param len The length in bytes of both `dst` and `src`.
	// \returns `dst`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa memcpy

	memmove :: proc(dst, src: rawptr, len: c.size_t) -> rawptr ---

	memcmp :: proc(s1, s2: rawptr, len: c.size_t) -> c.int ---

	wcslen :: proc(wstr: [^]c.wchar_t) -> c.size_t ---
	wcsnlen :: proc(wstr: [^]c.wchar_t, maxlen: c.size_t) -> c.size_t ---


	// Copy a wide string.
	//
	// This function copies `maxlen` - 1 wide characters from `src` to `dst`, then
	// appends a null terminator.
	//
	// `src` and `dst` must not overlap.
	//
	// If `maxlen` is 0, no wide characters are copied and no null terminator is
	// written.
	//
	// \param dst The destination buffer. Must not be NULL, and must not overlap
	//            with `src`.
	// \param src The null-terminated wide string to copy. Must not be NULL, and
	//            must not overlap with `dst`.
	// \param maxlen The length (in wide characters) of the destination buffer.
	// \returns The length (in wide characters, excluding the null terminator) of
	//          `src`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa wcslcat

	wcslcpy :: proc(dst, src: [^]c.wchar_t, maxlen: c.size_t) -> c.size_t ---


	// Concatenate wide strings.
	//
	// This function appends up to `maxlen` - wcslen(dst) - 1 wide characters
	// from `src` to the end of the wide string in `dst`, then appends a null
	// terminator.
	//
	// `src` and `dst` must not overlap.
	//
	// If `maxlen` - wcslen(dst) - 1 is less than or equal to 0, then `dst` is
	// unmodified.
	//
	// \param dst The destination buffer already containing the first
	//            null-terminated wide string. Must not be NULL and must not
	//            overlap with `src`.
	// \param src The second null-terminated wide string. Must not be NULL, and
	//            must not overlap with `dst`.
	// \param maxlen The length (in wide characters) of the destination buffer.
	// \returns The length (in wide characters, excluding the null terminator) of
	//          the string in `dst` plus the length of `src`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa wcslcpy

	wcslcat :: proc(dst, src: [^]c.wchar_t, maxlen: c.size_t) -> c.size_t ---

	wcsdup :: proc(wstr: [^]c.wchar_t) -> [^]c.wchar_t ---
	wcsstr :: proc(haystack: [^]c.wchar_t, needle: [^]c.wchar_t) -> [^]c.wchar_t ---
	wcsnstr :: proc(haystack: [^]c.wchar_t, needle: [^]c.wchar_t, maxlen: c.size_t) -> [^]c.wchar_t ---


	// Compare two null-terminated wide strings.
	//
	// This only compares wchar_t values until it hits a null-terminating
	// character; it does not care if the string is well-formed UTF-16 (or UTF-32,
	// depending on your platform's wchar_t size), or uses valid Unicode values.
	//
	// \param str1 the first string to compare. NULL is not permitted!
	// \param str2 the second string to compare. NULL is not permitted!
	// \returns less than zero if str1 is "less than" str2, greater than zero if
	//          str1 is "greater than" str2, and zero if the strings match
	//          exactly.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	wcscmp :: proc(str1, str2: [^]c.wchar_t) -> c.int ---


	// Compare two wide strings up to a number of wchar_t values.
	//
	// This only compares wchar_t values; it does not care if the string is
	// well-formed UTF-16 (or UTF-32, depending on your platform's wchar_t size),
	// or uses valid Unicode values.
	//
	// Note that while this function is intended to be used with UTF-16 (or
	// UTF-32, depending on your platform's definition of wchar_t), it is
	// comparing raw wchar_t values and not Unicode codepoints: `maxlen` specifies
	// a wchar_t limit! If the limit lands in the middle of a multi-wchar UTF-16
	// sequence, it will only compare a portion of the final character.
	//
	// `maxlen` specifies a maximum number of wchar_t to compare; if the strings
	// match to this number of wide chars (or both have matched to a
	// null-terminator character before this count), they will be considered
	// equal.
	//
	// \param str1 the first string to compare. NULL is not permitted!
	// \param str2 the second string to compare. NULL is not permitted!
	// \param maxlen the maximum number of wchar_t to compare.
	// \returns less than zero if str1 is "less than" str2, greater than zero if
	//          str1 is "greater than" str2, and zero if the strings match
	//          exactly.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	wcsncmp :: proc(str1, str2: [^]c.wchar_t, maxlen: c.size_t) -> c.int ---


	// Compare two null-terminated wide strings, case-insensitively.
	//
	// This will work with Unicode strings, using a technique called
	// "case-folding" to handle the vast majority of case-sensitive human
	// languages regardless of system locale. It can deal with expanding values: a
	// German Eszett character can compare against two ASCII 's' chars and be
	// considered a match, for example. A notable exception: it does not handle
	// the Turkish 'i' character; human language is complicated!
	//
	// Depending on your platform, "wchar_t" might be 2 bytes, and expected to be
	// UTF-16 encoded (like Windows), or 4 bytes in UTF-32 format. Since this
	// handles Unicode, it expects the string to be well-formed and not a
	// null-terminated string of arbitrary bytes. Characters that are not valid
	// UTF-16 (or UTF-32) are treated as Unicode character U+FFFD (REPLACEMENT
	// CHARACTER), which is to say two strings of random bits may turn out to
	// match if they convert to the same amount of replacement characters.
	//
	// \param str1 the first string to compare. NULL is not permitted!
	// \param str2 the second string to compare. NULL is not permitted!
	// \returns less than zero if str1 is "less than" str2, greater than zero if
	//          str1 is "greater than" str2, and zero if the strings match
	//          exactly.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	wcscasecmp :: proc(str1, str2: [^]c.wchar_t) -> c.int ---


	// Compare two wide strings, case-insensitively, up to a number of wchar_t.
	//
	// This will work with Unicode strings, using a technique called
	// "case-folding" to handle the vast majority of case-sensitive human
	// languages regardless of system locale. It can deal with expanding values: a
	// German Eszett character can compare against two ASCII 's' chars and be
	// considered a match, for example. A notable exception: it does not handle
	// the Turkish 'i' character; human language is complicated!
	//
	// Depending on your platform, "wchar_t" might be 2 bytes, and expected to be
	// UTF-16 encoded (like Windows), or 4 bytes in UTF-32 format. Since this
	// handles Unicode, it expects the string to be well-formed and not a
	// null-terminated string of arbitrary bytes. Characters that are not valid
	// UTF-16 (or UTF-32) are treated as Unicode character U+FFFD (REPLACEMENT
	// CHARACTER), which is to say two strings of random bits may turn out to
	// match if they convert to the same amount of replacement characters.
	//
	// Note that while this function might deal with variable-sized characters,
	// `maxlen` specifies a _wchar_ limit! If the limit lands in the middle of a
	// multi-byte UTF-16 sequence, it may convert a portion of the final character
	// to one or more Unicode character U+FFFD (REPLACEMENT CHARACTER) so as not
	// to overflow a buffer.
	//
	// `maxlen` specifies a maximum number of wchar_t values to compare; if the
	// strings match to this number of wchar_t (or both have matched to a
	// null-terminator character before this number of bytes), they will be
	// considered equal.
	//
	// \param str1 the first string to compare. NULL is not permitted!
	// \param str2 the second string to compare. NULL is not permitted!
	// \param maxlen the maximum number of wchar_t values to compare.
	// \returns less than zero if str1 is "less than" str2, greater than zero if
	//          str1 is "greater than" str2, and zero if the strings match
	//          exactly.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	wcsncasecmp :: proc(str1, str2: [^]c.wchar_t, maxlen: c.size_t) -> c.int ---


	// Parse a `long` from a wide string.
	//
	// If `str` starts with whitespace, then those whitespace characters are
	// skipped before attempting to parse the number.
	//
	// If the parsed number does not fit inside a `long`, the result is clamped to
	// the minimum and maximum representable `long` values.
	//
	// \param str The null-terminated wide string to read. Must not be NULL.
	// \param endp If not NULL, the address of the first invalid wide character
	//             (i.e. the next character after the parsed number) will be
	//             written to this pointer.
	// \param base The base of the integer to read. Supported values are 0 and 2
	//             to 36 inclusive. If 0, the base will be inferred from the
	//             number's prefix (0x for hexadecimal, 0 for octal, decimal
	//             otherwise).
	// \returns The parsed `long`, or 0 if no number could be parsed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa strtol

	wcstol :: proc(str: [^]c.wchar_t, endp: ^^c.wchar_t, base: c.int) -> c.long ---

	strlen :: proc(str: cstring) -> c.size_t ---
	strnlen :: proc(str: cstring, maxlen: c.size_t) -> c.size_t ---


	// Copy a string.
	//
	// This function copies up to `maxlen` - 1 characters from `src` to `dst`,
	// then appends a null terminator.
	//
	// If `maxlen` is 0, no characters are copied and no null terminator is
	// written.
	//
	// If you want to copy an UTF-8 string but need to ensure that multi-byte
	// sequences are not truncated, consider using utf8strlcpy().
	//
	// \param dst The destination buffer. Must not be NULL, and must not overlap
	//            with `src`.
	// \param src The null-terminated string to copy. Must not be NULL, and must
	//            not overlap with `dst`.
	// \param maxlen The length (in characters) of the destination buffer.
	// \returns The length (in characters, excluding the null terminator) of
	//          `src`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa strlcat
	// \sa utf8strlcpy

	strlcpy :: proc(dst, src: cstring, maxlen: c.size_t) -> c.size_t ---


	// Copy an UTF-8 string.
	//
	// This function copies up to `dst_bytes` - 1 bytes from `src` to `dst` while
	// also ensuring that the string written to `dst` does not end in a truncated
	// multi-byte sequence. Finally, it appends a null terminator.
	//
	// `src` and `dst` must not overlap.
	//
	// Note that unlike strlcpy(), this function returns the number of bytes
	// written, not the length of `src`.
	//
	// \param dst The destination buffer. Must not be NULL, and must not overlap
	//            with `src`.
	// \param src The null-terminated UTF-8 string to copy. Must not be NULL, and
	//            must not overlap with `dst`.
	// \param dst_bytes The length (in bytes) of the destination buffer. Must not
	//                  be 0.
	// \returns The number of bytes written, excluding the null terminator.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa strlcpy

	utf8strlcpy :: proc(dst, src: cstring, dst_bytes: c.size_t) -> c.size_t ---


	// Concatenate strings.
	//
	// This function appends up to `maxlen` - strlen(dst) - 1 characters from
	// `src` to the end of the string in `dst`, then appends a null terminator.
	//
	// `src` and `dst` must not overlap.
	//
	// If `maxlen` - strlen(dst) - 1 is less than or equal to 0, then `dst` is
	// unmodified.
	//
	// \param dst The destination buffer already containing the first
	//            null-terminated string. Must not be NULL and must not overlap
	//            with `src`.
	// \param src The second null-terminated string. Must not be NULL, and must
	//            not overlap with `dst`.
	// \param maxlen The length (in characters) of the destination buffer.
	// \returns The length (in characters, excluding the null terminator) of the
	//          string in `dst` plus the length of `src`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa strlcpy

	strlcat :: proc(dst, src: cstring, maxlen: c.size_t) -> c.size_t ---

	strdup :: proc(str: cstring) -> cstring ---
	strndup :: proc(str: cstring, maxlen: c.size_t) -> cstring ---
	strrev :: proc(str: cstring) -> cstring ---


	// Convert a string to uppercase.
	//
	// **WARNING**: Regardless of system locale, this will only convert ASCII
	// values 'A' through 'Z' to uppercase.
	//
	// This function operates on a null-terminated string of bytes--even if it is
	// malformed UTF-8!--and converts ASCII characters 'a' through 'z' to their
	// uppercase equivalents in-place, returning the original `str` pointer.
	//
	// \param str the string to convert in-place. Can not be NULL.
	// \returns the `str` pointer passed into this function.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa strlwr

	strupr :: proc(str: cstring) -> cstring ---


	// Convert a string to lowercase.
	//
	// **WARNING**: Regardless of system locale, this will only convert ASCII
	// values 'A' through 'Z' to lowercase.
	//
	// This function operates on a null-terminated string of bytes--even if it is
	// malformed UTF-8!--and converts ASCII characters 'A' through 'Z' to their
	// lowercase equivalents in-place, returning the original `str` pointer.
	//
	// \param str the string to convert in-place. Can not be NULL.
	// \returns the `str` pointer passed into this function.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa strupr

	strlwr :: proc(std: cstring) -> cstring ---

	strchr :: proc(str: cstring, c: c.int) -> cstring ---
	strrchr :: proc(str: cstring, c: c.int) -> cstring ---
	strstr :: proc(haystack: cstring, needle: cstring) -> cstring ---
	strnstr :: proc(haystack: cstring, needle: cstring, maxlen: c.size_t) -> cstring ---
	strcasestr :: proc(haystack: cstring, needle: cstring) -> cstring ---
	strtok_r :: proc(s1, s2: cstring, saveptr: ^^c.char) -> cstring ---
	utf8strlen :: proc(str: cstring) -> c.size_t ---
	utf8strnlen :: proc(str: cstring, bytes: c.size_t) -> c.size_t ---

	itoa :: proc(value: c.int, str: cstring, radix: c.int) -> cstring ---
	uitoa :: proc(value: c.uint, str: cstring, radix: c.int) -> cstring ---
	ltoa :: proc(value: c.long, str: cstring, radix: c.int) -> cstring ---
	ultoa :: proc(value: c.ulong, str: cstring, radix: c.int) -> cstring ---
	lltoa :: proc(value: c.longlong, str: cstring, radix: c.int) -> cstring ---
	ulltoa :: proc(value: c.ulonglong, str: cstring, radix: c.int) -> cstring ---


	// Parse an `int` from a string.
	//
	// The result of calling `atoi(str)` is equivalent to
	// `(int)strtol(str, NULL, 10)`.
	//
	// \param str The null-terminated string to read. Must not be NULL.
	// \returns The parsed `int`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atof
	// \sa strtol
	// \sa strtoul
	// \sa strtoll
	// \sa strtoull
	// \sa strtod
	// \sa itoa

	atoi :: proc(str: cstring) -> c.int ---


	// Parse a `double` from a string.
	//
	// The result of calling `atof(str)` is equivalent to `strtod(str,
	// NULL)`.
	//
	// \param str The null-terminated string to read. Must not be NULL.
	// \returns The parsed `double`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atoi
	// \sa strtol
	// \sa strtoul
	// \sa strtoll
	// \sa strtoull
	// \sa strtod

	atof :: proc(str: cstring) -> c.double ---


	// Parse a `long` from a string.
	//
	// If `str` starts with whitespace, then those whitespace characters are
	// skipped before attempting to parse the number.
	//
	// If the parsed number does not fit inside a `long`, the result is clamped to
	// the minimum and maximum representable `long` values.
	//
	// \param str The null-terminated string to read. Must not be NULL.
	// \param endp If not NULL, the address of the first invalid character (i.e.
	//             the next character after the parsed number) will be written to
	//             this pointer.
	// \param base The base of the integer to read. Supported values are 0 and 2
	//             to 36 inclusive. If 0, the base will be inferred from the
	//             number's prefix (0x for hexadecimal, 0 for octal, decimal
	//             otherwise).
	// \returns The parsed `long`, or 0 if no number could be parsed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atoi
	// \sa atof
	// \sa strtoul
	// \sa strtoll
	// \sa strtoull
	// \sa strtod
	// \sa ltoa
	// \sa wcstol

	strtol :: proc(str: cstring, endp: ^^c.char, base: c.int) -> c.long ---


	// Parse an `unsigned long` from a string.
	//
	// If `str` starts with whitespace, then those whitespace characters are
	// skipped before attempting to parse the number.
	//
	// If the parsed number does not fit inside an `unsigned long`, the result is
	// clamped to the maximum representable `unsigned long` value.
	//
	// \param str The null-terminated string to read. Must not be NULL.
	// \param endp If not NULL, the address of the first invalid character (i.e.
	//             the next character after the parsed number) will be written to
	//             this pointer.
	// \param base The base of the integer to read. Supported values are 0 and 2
	//             to 36 inclusive. If 0, the base will be inferred from the
	//             number's prefix (0x for hexadecimal, 0 for octal, decimal
	//             otherwise).
	// \returns The parsed `unsigned long`, or 0 if no number could be parsed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atoi
	// \sa atof
	// \sa strtol
	// \sa strtoll
	// \sa strtoull
	// \sa strtod
	// \sa ultoa

	strtoul :: proc(str: cstring, endp: ^^c.char, base: c.int) -> c.ulong ---


	// Parse a `long long` from a string.
	//
	// If `str` starts with whitespace, then those whitespace characters are
	// skipped before attempting to parse the number.
	//
	// If the parsed number does not fit inside a `long long`, the result is
	// clamped to the minimum and maximum representable `long long` values.
	//
	// \param str The null-terminated string to read. Must not be NULL.
	// \param endp If not NULL, the address of the first invalid character (i.e.
	//             the next character after the parsed number) will be written to
	//             this pointer.
	// \param base The base of the integer to read. Supported values are 0 and 2
	//             to 36 inclusive. If 0, the base will be inferred from the
	//             number's prefix (0x for hexadecimal, 0 for octal, decimal
	//             otherwise).
	// \returns The parsed `long long`, or 0 if no number could be parsed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atoi
	// \sa atof
	// \sa strtol
	// \sa strtoul
	// \sa strtoull
	// \sa strtod
	// \sa lltoa

	strtoll :: proc(str: cstring, endp: ^^c.char, base: c.int) -> c.longlong ---


	// Parse an `unsigned long long` from a string.
	//
	// If `str` starts with whitespace, then those whitespace characters are
	// skipped before attempting to parse the number.
	//
	// If the parsed number does not fit inside an `unsigned long long`, the
	// result is clamped to the maximum representable `unsigned long long` value.
	//
	// \param str The null-terminated string to read. Must not be NULL.
	// \param endp If not NULL, the address of the first invalid character (i.e.
	//             the next character after the parsed number) will be written to
	//             this pointer.
	// \param base The base of the integer to read. Supported values are 0 and 2
	//             to 36 inclusive. If 0, the base will be inferred from the
	//             number's prefix (0x for hexadecimal, 0 for octal, decimal
	//             otherwise).
	// \returns The parsed `unsigned long long`, or 0 if no number could be
	//          parsed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atoi
	// \sa atof
	// \sa strtol
	// \sa strtoll
	// \sa strtoul
	// \sa strtod
	// \sa ulltoa

	strtoull :: proc(str: cstring, endp: ^^c.char, base: c.int) -> c.ulonglong ---


	// Parse a `double` from a string.
	//
	// This function makes fewer guarantees than the C runtime `strtod`:
	//
	// - Only decimal notation is guaranteed to be supported. The handling of
	//   scientific and hexadecimal notation is unspecified.
	// - Whether or not INF and NAN can be parsed is unspecified.
	// - The precision of the result is unspecified.
	//
	// \param str The null-terminated string to read. Must not be NULL.
	// \param endp If not NULL, the address of the first invalid character (i.e.
	//             the next character after the parsed number) will be written to
	//             this pointer.
	// \returns The parsed `double`, or 0 if no number could be parsed.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atoi
	// \sa atof
	// \sa strtol
	// \sa strtoll
	// \sa strtoul
	// \sa strtoull

	strtod :: proc(str: cstring, endp: ^^c.char) -> c.double ---


	// Compare two null-terminated UTF-8 strings.
	//
	// Due to the nature of UTF-8 encoding, this will work with Unicode strings,
	// since effectively this function just compares bytes until it hits a
	// null-terminating character. Also due to the nature of UTF-8, this can be
	// used with qsort() to put strings in (roughly) alphabetical order.
	//
	// \param str1 the first string to compare. NULL is not permitted!
	// \param str2 the second string to compare. NULL is not permitted!
	// \returns less than zero if str1 is "less than" str2, greater than zero if
	//          str1 is "greater than" str2, and zero if the strings match
	//          exactly.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	strcmp :: proc(str1, str2: cstring) -> c.int ---


	// Compare two UTF-8 strings up to a number of bytes.
	//
	// Due to the nature of UTF-8 encoding, this will work with Unicode strings,
	// since effectively this function just compares bytes until it hits a
	// null-terminating character. Also due to the nature of UTF-8, this can be
	// used with qsort() to put strings in (roughly) alphabetical order.
	//
	// Note that while this function is intended to be used with UTF-8, it is
	// doing a bytewise comparison, and `maxlen` specifies a _byte_ limit! If the
	// limit lands in the middle of a multi-byte UTF-8 sequence, it will only
	// compare a portion of the final character.
	//
	// `maxlen` specifies a maximum number of bytes to compare; if the strings
	// match to this number of bytes (or both have matched to a null-terminator
	// character before this number of bytes), they will be considered equal.
	//
	// \param str1 the first string to compare. NULL is not permitted!
	// \param str2 the second string to compare. NULL is not permitted!
	// \param maxlen the maximum number of _bytes_ to compare.
	// \returns less than zero if str1 is "less than" str2, greater than zero if
	//          str1 is "greater than" str2, and zero if the strings match
	//          exactly.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	strncmp :: proc(str1, str2: cstring, maxlen: c.size_t) -> c.int ---


	// Compare two null-terminated UTF-8 strings, case-insensitively.
	//
	// This will work with Unicode strings, using a technique called
	// "case-folding" to handle the vast majority of case-sensitive human
	// languages regardless of system locale. It can deal with expanding values: a
	// German Eszett character can compare against two ASCII 's' chars and be
	// considered a match, for example. A notable exception: it does not handle
	// the Turkish 'i' character; human language is complicated!
	//
	// Since this handles Unicode, it expects the string to be well-formed UTF-8
	// and not a null-terminated string of arbitrary bytes. Bytes that are not
	// valid UTF-8 are treated as Unicode character U+FFFD (REPLACEMENT
	// CHARACTER), which is to say two strings of random bits may turn out to
	// match if they convert to the same amount of replacement characters.
	//
	// \param str1 the first string to compare. NULL is not permitted!
	// \param str2 the second string to compare. NULL is not permitted!
	// \returns less than zero if str1 is "less than" str2, greater than zero if
	//          str1 is "greater than" str2, and zero if the strings match
	//          exactly.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	strcasecmp :: proc(str1, str2: cstring) -> c.int ---


	// Compare two UTF-8 strings, case-insensitively, up to a number of bytes.
	//
	// This will work with Unicode strings, using a technique called
	// "case-folding" to handle the vast majority of case-sensitive human
	// languages regardless of system locale. It can deal with expanding values: a
	// German Eszett character can compare against two ASCII 's' chars and be
	// considered a match, for example. A notable exception: it does not handle
	// the Turkish 'i' character; human language is complicated!
	//
	// Since this handles Unicode, it expects the string to be well-formed UTF-8
	// and not a null-terminated string of arbitrary bytes. Bytes that are not
	// valid UTF-8 are treated as Unicode character U+FFFD (REPLACEMENT
	// CHARACTER), which is to say two strings of random bits may turn out to
	// match if they convert to the same amount of replacement characters.
	//
	// Note that while this function is intended to be used with UTF-8, `maxlen`
	// specifies a _byte_ limit! If the limit lands in the middle of a multi-byte
	// UTF-8 sequence, it may convert a portion of the final character to one or
	// more Unicode character U+FFFD (REPLACEMENT CHARACTER) so as not to overflow
	// a buffer.
	//
	// `maxlen` specifies a maximum number of bytes to compare; if the strings
	// match to this number of bytes (or both have matched to a null-terminator
	// character before this number of bytes), they will be considered equal.
	//
	// \param str1 the first string to compare. NULL is not permitted!
	// \param str2 the second string to compare. NULL is not permitted!
	// \param maxlen the maximum number of bytes to compare.
	// \returns less than zero if str1 is "less than" str2, greater than zero if
	//          str1 is "greater than" str2, and zero if the strings match
	//          exactly.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	strncasecmp :: proc(str1, str2: cstring, maxlen: c.size_t) -> c.int ---


	// Searches a string for the first occurence of any character contained in a
	// breakset, and returns a pointer from the string to that character.
	//
	// \param str The null-terminated string to be searched. Must not be NULL, and
	//            must not overlap with `breakset`.
	// \param breakset A null-terminated string containing the list of characters
	//                 to look for. Must not be NULL, and must not overlap with
	//                 `str`.
	// \returns A pointer to the location, in str, of the first occurence of a
	//          character present in the breakset, or NULL if none is found.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	strpbrk :: proc(str: cstring, breakset: cstring) -> cstring ---


	// Decode a UTF-8 string, one Unicode codepoint at a time.
	//
	// This will return the first Unicode codepoint in the UTF-8 encoded string in
	// `*pstr`, and then advance `*pstr` past any consumed bytes before returning.
	//
	// It will not access more than `*pslen` bytes from the string. `*pslen` will
	// be adjusted, as well, subtracting the number of bytes consumed.
	//
	// `pslen` is allowed to be NULL, in which case the string _must_ be
	// NULL-terminated, as the function will blindly read until it sees the NULL
	// char.
	//
	// if `*pslen` is zero, it assumes the end of string is reached and returns a
	// zero codepoint regardless of the contents of the string buffer.
	//
	// If the resulting codepoint is zero (a NULL terminator), or `*pslen` is
	// zero, it will not advance `*pstr` or `*pslen` at all.
	//
	// Generally this function is called in a loop until it returns zero,
	// adjusting its parameters each iteration.
	//
	// If an invalid UTF-8 sequence is encountered, this function returns
	// INVALID_UNICODE_CODEPOINT and advances the string/length by one byte
	// (which is to say, a multibyte sequence might produce several
	// INVALID_UNICODE_CODEPOINT returns before it syncs to the next valid
	// UTF-8 sequence).
	//
	// Several things can generate invalid UTF-8 sequences, including overlong
	// encodings, the use of UTF-16 surrogate values, and truncated data. Please
	// refer to
	// [RFC3629](https://www.ietf.org/rfc/rfc3629.txt)
	// for details.
	//
	// \param pstr a pointer to a UTF-8 string pointer to be read and adjusted.
	// \param pslen a pointer to the number of bytes in the string, to be read and
	//              adjusted. NULL is allowed.
	// \returns the first Unicode codepoint in the string.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	StepUTF8 :: proc(pstr: ^cstring, pslen: ^c.size_t) -> c.uint32_t ---


	// Convert a single Unicode codepoint to UTF-8.
	//
	// The buffer pointed to by `dst` must be at least 4 bytes long, as this
	// function may generate between 1 and 4 bytes of output.
	//
	// This function returns the first byte _after_ the newly-written UTF-8
	// sequence, which is useful for encoding multiple codepoints in a loop, or
	// knowing where to write a NULL-terminator character to end the string (in
	// either case, plan to have a buffer of _more_ than 4 bytes!).
	//
	// If `codepoint` is an invalid value (outside the Unicode range, or a UTF-16
	// surrogate value, etc), this will use U+FFFD (REPLACEMENT CHARACTER) for the
	// codepoint instead, and not set an error.
	//
	// If `dst` is NULL, this returns NULL immediately without writing to the
	// pointer and without setting an error.
	//
	// \param codepoint a Unicode codepoint to convert to UTF-8.
	// \param dst the location to write the encoded UTF-8. Must point to at least
	//            4 bytes!
	// \returns the first byte past the newly-written UTF-8 sequence.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	UCS4ToUTF8 :: proc(codepoint: c.uint32_t, dst: cstring) -> cstring ---


	sscanf :: proc(text, fmt: cstring, #c_vararg args: ..any) -> c.int ---
	vsscanf :: proc(text, fmt: cstring, ap: c.va_list) -> c.int ---
	snprintf :: proc(text: cstring, maxlen: c.size_t, fmt: cstring, #c_vararg args: ..any) -> c.int ---
	swprintf :: proc(text: [^]c.wchar_t, maxlen: c.size_t, fmt: [^]c.wchar_t, #c_vararg args: ..any) -> c.int ---
	vsnprintf :: proc(text: cstring, maxlen: c.size_t, fmt: cstring, ap: c.va_list) -> c.int ---
	vswprintf :: proc(text: [^]c.wchar_t, maxlen: c.size_t, fmt: [^]c.wchar_t, ap: c.va_list) -> c.int ---
	asprintf :: proc(strp: ^^c.char, fmt: cstring, #c_vararg args: ..any) -> c.int ---
	vasprintf :: proc(strp: ^^c.char, fmt: cstring, ap: c.va_list) -> c.int ---


	// Seeds the pseudo-random number generator.
	//
	// Reusing the seed number will cause rand_*() to repeat the same stream
	// of 'random' numbers.
	//
	// \param seed the value to use as a random number seed, or 0 to use
	//             GetPerformanceCounter().
	//
	// \threadsafety This should be called on the same thread that calls
	//               rand*()
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa rand
	// \sa rand_bits
	// \sa randf

	srand :: proc(seed: c.uint64_t) ---


	// Generate a pseudo-random number less than n for positive n
	//
	// The method used is faster and of better quality than `rand() % n`. Odds are
	// roughly 99.9% even for n = 1 million. Evenness is better for smaller n, and
	// much worse as n gets bigger.
	//
	// Example: to simulate a d6 use `rand(6) + 1` The +1 converts 0..5 to
	// 1..6
	//
	// If you want to generate a pseudo-random number in the full range of Sint32,
	// you should use: (Sint32)rand_bits()
	//
	// If you want reproducible output, be sure to initialize with srand()
	// first.
	//
	// There are no guarantees as to the quality of the random sequence produced,
	// and this should not be used for security (cryptography, passwords) or where
	// money is on the line (loot-boxes, casinos). There are many random number
	// libraries available with different characteristics and you should pick one
	// of those to meet any serious needs.
	//
	// \param n the number of possible outcomes. n must be positive.
	// \returns a random value in the range of [0 .. n-1].
	//
	// \threadsafety All calls should be made from a single thread
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa srand
	// \sa randf

	rand :: proc(n: c.int32_t) -> c.int32_t ---


	// Generate a uniform pseudo-random floating point number less than 1.0
	//
	// If you want reproducible output, be sure to initialize with srand()
	// first.
	//
	// There are no guarantees as to the quality of the random sequence produced,
	// and this should not be used for security (cryptography, passwords) or where
	// money is on the line (loot-boxes, casinos). There are many random number
	// libraries available with different characteristics and you should pick one
	// of those to meet any serious needs.
	//
	// \returns a random value in the range of [0.0, 1.0).
	//
	// \threadsafety All calls should be made from a single thread
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa srand
	// \sa rand

	randf :: proc() -> c.float ---


	// Generate 32 pseudo-random bits.
	//
	// You likely want to use rand() to get a psuedo-random number instead.
	//
	// There are no guarantees as to the quality of the random sequence produced,
	// and this should not be used for security (cryptography, passwords) or where
	// money is on the line (loot-boxes, casinos). There are many random number
	// libraries available with different characteristics and you should pick one
	// of those to meet any serious needs.
	//
	// \returns a random value in the range of [0-MAX_UINT32].
	//
	// \threadsafety All calls should be made from a single thread
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa rand
	// \sa randf
	// \sa srand

	rand_bits :: proc() -> c.uint32_t ---


	// Generate a pseudo-random number less than n for positive n
	//
	// The method used is faster and of better quality than `rand() % n`. Odds are
	// roughly 99.9% even for n = 1 million. Evenness is better for smaller n, and
	// much worse as n gets bigger.
	//
	// Example: to simulate a d6 use `rand_r(state, 6) + 1` The +1 converts
	// 0..5 to 1..6
	//
	// If you want to generate a pseudo-random number in the full range of Sint32,
	// you should use: (Sint32)rand_bits_r(state)
	//
	// There are no guarantees as to the quality of the random sequence produced,
	// and this should not be used for security (cryptography, passwords) or where
	// money is on the line (loot-boxes, casinos). There are many random number
	// libraries available with different characteristics and you should pick one
	// of those to meet any serious needs.
	//
	// \param state a pointer to the current random number state, this may not be
	//              NULL.
	// \param n the number of possible outcomes. n must be positive.
	// \returns a random value in the range of [0 .. n-1].
	//
	// \threadsafety This function is thread-safe, as long as the state pointer
	//               isn't shared between threads.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa rand
	// \sa rand_bits_r
	// \sa randf_r

	rand_r :: proc(state: ^c.uint64_t, n: c.int32_t) -> c.int32_t ---


	// Generate a uniform pseudo-random floating point number less than 1.0
	//
	// If you want reproducible output, be sure to initialize with srand()
	// first.
	//
	// There are no guarantees as to the quality of the random sequence produced,
	// and this should not be used for security (cryptography, passwords) or where
	// money is on the line (loot-boxes, casinos). There are many random number
	// libraries available with different characteristics and you should pick one
	// of those to meet any serious needs.
	//
	// \param state a pointer to the current random number state, this may not be
	//              NULL.
	// \returns a random value in the range of [0.0, 1.0).
	//
	// \threadsafety This function is thread-safe, as long as the state pointer
	//               isn't shared between threads.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa rand_bits_r
	// \sa rand_r
	// \sa randf

	randf_r :: proc(state: ^c.uint64_t) -> c.float ---


	// Generate 32 pseudo-random bits.
	//
	// You likely want to use rand_r() to get a psuedo-random number instead.
	//
	// There are no guarantees as to the quality of the random sequence produced,
	// and this should not be used for security (cryptography, passwords) or where
	// money is on the line (loot-boxes, casinos). There are many random number
	// libraries available with different characteristics and you should pick one
	// of those to meet any serious needs.
	//
	// \param state a pointer to the current random number state, this may not be
	//              NULL.
	// \returns a random value in the range of [0-MAX_UINT32].
	//
	// \threadsafety This function is thread-safe, as long as the state pointer
	//               isn't shared between threads.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa rand_r
	// \sa randf_r

	rand_bits_r :: proc(state: ^c.uint64_t) -> c.uint32_t ---


	// Compute the arc cosine of `x`.
	//
	// The definition of `y = acos(x)` is `x = cos(y)`.
	//
	// Domain: `-1 <= x <= 1`
	//
	// Range: `0 <= y <= Pi`
	//
	// This function operates on double-precision floating point values, use
	// acosf for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value.
	// \returns arc cosine of `x`, in radians.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa acosf
	// \sa asin
	// \sa cos

	acos :: proc(x: c.double) -> c.double ---


	// Compute the arc cosine of `x`.
	//
	// The definition of `y = acos(x)` is `x = cos(y)`.
	//
	// Domain: `-1 <= x <= 1`
	//
	// Range: `0 <= y <= Pi`
	//
	// This function operates on single-precision floating point values, use
	// acos for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value.
	// \returns arc cosine of `x`, in radians.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa acos
	// \sa asinf
	// \sa cosf

	acosf :: proc(x: c.float) -> c.float ---


	// Compute the arc sine of `x`.
	//
	// The definition of `y = asin(x)` is `x = sin(y)`.
	//
	// Domain: `-1 <= x <= 1`
	//
	// Range: `-Pi/2 <= y <= Pi/2`
	//
	// This function operates on double-precision floating point values, use
	// asinf for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value.
	// \returns arc sine of `x`, in radians.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa asinf
	// \sa acos
	// \sa sin

	asin :: proc(x: c.double) -> c.double ---


	// Compute the arc sine of `x`.
	//
	// The definition of `y = asin(x)` is `x = sin(y)`.
	//
	// Domain: `-1 <= x <= 1`
	//
	// Range: `-Pi/2 <= y <= Pi/2`
	//
	// This function operates on single-precision floating point values, use
	// asin for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value.
	// \returns arc sine of `x`, in radians.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa asin
	// \sa acosf
	// \sa sinf

	asinf :: proc(x: c.float) -> c.float ---


	// Compute the arc tangent of `x`.
	//
	// The definition of `y = atan(x)` is `x = tan(y)`.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-Pi/2 <= y <= Pi/2`
	//
	// This function operates on double-precision floating point values, use
	// atanf for single-precision floats.
	//
	// To calculate the arc tangent of y / x, use atan2.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value.
	// \returns arc tangent of of `x` in radians, or 0 if `x = 0`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atanf
	// \sa atan2
	// \sa tan

	atan :: proc(x: c.double) -> c.double ---


	// Compute the arc tangent of `x`.
	//
	// The definition of `y = atan(x)` is `x = tan(y)`.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-Pi/2 <= y <= Pi/2`
	//
	// This function operates on single-precision floating point values, use
	// atan for dboule-precision floats.
	//
	// To calculate the arc tangent of y / x, use atan2f.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value.
	// \returns arc tangent of of `x` in radians, or 0 if `x = 0`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atan
	// \sa atan2f
	// \sa tanf

	atanf :: proc(x: c.float) -> c.float ---


	// Compute the arc tangent of `y / x`, using the signs of x and y to adjust
	// the result's quadrant.
	//
	// The definition of `z = atan2(x, y)` is `y = x tan(z)`, where the quadrant
	// of z is determined based on the signs of x and y.
	//
	// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
	//
	// Range: `-Pi/2 <= y <= Pi/2`
	//
	// This function operates on double-precision floating point values, use
	// atan2f for single-precision floats.
	//
	// To calculate the arc tangent of a single value, use atan.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param y floating point value of the numerator (y coordinate).
	// \param x floating point value of the denominator (x coordinate).
	// \returns arc tangent of of `y / x` in radians, or, if `x = 0`, either
	//          `-Pi/2`, `0`, or `Pi/2`, depending on the value of `y`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atan2f
	// \sa atan
	// \sa tan

	atan2 :: proc(y, x: c.double) -> c.double ---


	// Compute the arc tangent of `y / x`, using the signs of x and y to adjust
	// the result's quadrant.
	//
	// The definition of `z = atan2(x, y)` is `y = x tan(z)`, where the quadrant
	// of z is determined based on the signs of x and y.
	//
	// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
	//
	// Range: `-Pi/2 <= y <= Pi/2`
	//
	// This function operates on single-precision floating point values, use
	// atan2 for double-precision floats.
	//
	// To calculate the arc tangent of a single value, use atanf.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param y floating point value of the numerator (y coordinate).
	// \param x floating point value of the denominator (x coordinate).
	// \returns arc tangent of of `y / x` in radians, or, if `x = 0`, either
	//          `-Pi/2`, `0`, or `Pi/2`, depending on the value of `y`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa atan2f
	// \sa atan
	// \sa tan

	atan2f :: proc(y, x: c.float) -> c.float ---


	// Compute the ceiling of `x`.
	//
	// The ceiling of `x` is the smallest integer `y` such that `y > x`, i.e `x`
	// rounded up to the nearest integer.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`, y integer
	//
	// This function operates on double-precision floating point values, use
	// ceilf for single-precision floats.
	//
	// \param x floating point value.
	// \returns the ceiling of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ceilf
	// \sa floor
	// \sa trunc
	// \sa round
	// \sa lround

	ceil :: proc(x: c.double) -> c.double ---


	// Compute the ceiling of `x`.
	//
	// The ceiling of `x` is the smallest integer `y` such that `y > x`, i.e `x`
	// rounded up to the nearest integer.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`, y integer
	//
	// This function operates on single-precision floating point values, use
	// ceil for double-precision floats.
	//
	// \param x floating point value.
	// \returns the ceiling of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ceil
	// \sa floorf
	// \sa truncf
	// \sa roundf
	// \sa lroundf

	ceilf :: proc(x: c.float) -> c.float ---


	// Copy the sign of one floating-point value to another.
	//
	// The definition of copysign is that ``copysign(x, y) = abs(x) * sign(y)``.
	//
	// Domain: `-INF <= x <= INF`, ``-INF <= y <= f``
	//
	// Range: `-INF <= z <= INF`
	//
	// This function operates on double-precision floating point values, use
	// copysignf for single-precision floats.
	//
	// \param x floating point value to use as the magnitude.
	// \param y floating point value to use as the sign.
	// \returns the floating point value with the sign of y and the magnitude of
	//          x.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa copysignf
	// \sa fabs

	copysign :: proc(x, y: c.double) -> c.double ---


	// Copy the sign of one floating-point value to another.
	//
	// The definition of copysign is that ``copysign(x, y) = abs(x) * sign(y)``.
	//
	// Domain: `-INF <= x <= INF`, ``-INF <= y <= f``
	//
	// Range: `-INF <= z <= INF`
	//
	// This function operates on single-precision floating point values, use
	// copysign for double-precision floats.
	//
	// \param x floating point value to use as the magnitude.
	// \param y floating point value to use as the sign.
	// \returns the floating point value with the sign of y and the magnitude of
	//          x.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa copysignf
	// \sa fabsf

	copysignf :: proc(x, y: c.float) -> c.float ---


	// Compute the cosine of `x`.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-1 <= y <= 1`
	//
	// This function operates on double-precision floating point values, use
	// cosf for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value, in radians.
	// \returns cosine of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa cosf
	// \sa acos
	// \sa sin

	cos :: proc(x: c.double) -> c.double ---


	// Compute the cosine of `x`.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-1 <= y <= 1`
	//
	// This function operates on single-precision floating point values, use
	// cos for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value, in radians.
	// \returns cosine of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa cos
	// \sa acosf
	// \sa sinf

	cosf :: proc(x: c.float) -> c.float ---


	// Compute the exponential of `x`.
	//
	// The definition of `y = exp(x)` is `y = e^x`, where `e` is the base of the
	// natural logarithm. The inverse is the natural logarithm, log.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `0 <= y <= INF`
	//
	// The output will overflow if `exp(x)` is too large to be represented.
	//
	// This function operates on double-precision floating point values, use
	// expf for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value.
	// \returns value of `e^x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa expf
	// \sa log

	exp :: proc(x: c.double) -> c.double ---


	// Compute the exponential of `x`.
	//
	// The definition of `y = exp(x)` is `y = e^x`, where `e` is the base of the
	// natural logarithm. The inverse is the natural logarithm, logf.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `0 <= y <= INF`
	//
	// The output will overflow if `exp(x)` is too large to be represented.
	//
	// This function operates on single-precision floating point values, use
	// exp for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value.
	// \returns value of `e^x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa exp
	// \sa logf

	expf :: proc(x: c.float) -> c.float ---


	// Compute the absolute value of `x`
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `0 <= y <= INF`
	//
	// This function operates on double-precision floating point values, use
	// copysignf for single-precision floats.
	//
	// \param x floating point value to use as the magnitude.
	// \returns the absolute value of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa fabsf

	fabs :: proc(x: c.double) -> c.double ---


	// Compute the absolute value of `x`
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `0 <= y <= INF`
	//
	// This function operates on single-precision floating point values, use
	// copysignf for double-precision floats.
	//
	// \param x floating point value to use as the magnitude.
	// \returns the absolute value of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa fabs

	fabsf :: proc(x: c.float) -> c.float ---


	// Compute the floor of `x`.
	//
	// The floor of `x` is the largest integer `y` such that `y > x`, i.e `x`
	// rounded down to the nearest integer.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`, y integer
	//
	// This function operates on double-precision floating point values, use
	// floorf for single-precision floats.
	//
	// \param x floating point value.
	// \returns the floor of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa floorf
	// \sa ceil
	// \sa trunc
	// \sa round
	// \sa lround

	floor :: proc(x: c.double) -> c.double ---


	// Compute the floor of `x`.
	//
	// The floor of `x` is the largest integer `y` such that `y > x`, i.e `x`
	// rounded down to the nearest integer.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`, y integer
	//
	// This function operates on single-precision floating point values, use
	// floorf for double-precision floats.
	//
	// \param x floating point value.
	// \returns the floor of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa floor
	// \sa ceilf
	// \sa truncf
	// \sa roundf
	// \sa lroundf

	floorf :: proc(x: c.float) -> c.float ---


	// Truncate `x` to an integer.
	//
	// Rounds `x` to the next closest integer to 0. This is equivalent to removing
	// the fractional part of `x`, leaving only the integer part.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`, y integer
	//
	// This function operates on double-precision floating point values, use
	// truncf for single-precision floats.
	//
	// \param x floating point value.
	// \returns `x` truncated to an integer.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa truncf
	// \sa fmod
	// \sa ceil
	// \sa floor
	// \sa round
	// \sa lround

	trunc :: proc(x: c.double) -> c.double ---


	// Truncate `x` to an integer.
	//
	// Rounds `x` to the next closest integer to 0. This is equivalent to removing
	// the fractional part of `x`, leaving only the integer part.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`, y integer
	//
	// This function operates on single-precision floating point values, use
	// truncf for double-precision floats.
	//
	// \param x floating point value.
	// \returns `x` truncated to an integer.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa trunc
	// \sa fmodf
	// \sa ceilf
	// \sa floorf
	// \sa roundf
	// \sa lroundf

	truncf :: proc(x: c.float) -> c.float ---


	// Return the floating-point remainder of `x / y`
	//
	// Divides `x` by `y`, and returns the remainder.
	//
	// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`, `y != 0`
	//
	// Range: `-y <= z <= y`
	//
	// This function operates on double-precision floating point values, use
	// fmodf for single-precision floats.
	//
	// \param x the numerator.
	// \param y the denominator. Must not be 0.
	// \returns the remainder of `x / y`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa fmodf
	// \sa modf
	// \sa trunc
	// \sa ceil
	// \sa floor
	// \sa round
	// \sa lround

	fmod :: proc(x, y: c.double) -> c.double ---


	// Return the floating-point remainder of `x / y`
	//
	// Divides `x` by `y`, and returns the remainder.
	//
	// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`, `y != 0`
	//
	// Range: `-y <= z <= y`
	//
	// This function operates on single-precision floating point values, use
	// fmod for single-precision floats.
	//
	// \param x the numerator.
	// \param y the denominator. Must not be 0.
	// \returns the remainder of `x / y`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa fmod
	// \sa truncf
	// \sa modff
	// \sa ceilf
	// \sa floorf
	// \sa roundf
	// \sa lroundf

	fmodf :: proc(x, y: c.float) -> c.float ---


	// Return whether the value is infinity.
	//
	// \param x double-precision floating point value.
	// \returns non-zero if the value is infinity, 0 otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa isinff

	isinf :: proc(x: c.double) -> c.int ---


	// Return whether the value is infinity.
	//
	// \param x floating point value.
	// \returns non-zero if the value is infinity, 0 otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa isinf

	isinff :: proc(x: c.float) -> c.int ---


	// Return whether the value is NaN.
	//
	// \param x double-precision floating point value.
	// \returns non-zero if the value is NaN, 0 otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa isnanf

	isnan :: proc(x: c.double) -> c.int ---


	// Return whether the value is NaN.
	//
	// \param x floating point value.
	// \returns non-zero if the value is NaN, 0 otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa isnan

	isnanf :: proc(x: c.float) -> c.int ---


	// Compute the natural logarithm of `x`.
	//
	// Domain: `0 < x <= INF`
	//
	// Range: `-INF <= y <= INF`
	//
	// It is an error for `x` to be less than or equal to 0.
	//
	// This function operates on double-precision floating point values, use
	// logf for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value. Must be greater than 0.
	// \returns the natural logarithm of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa logf
	// \sa log10
	// \sa exp

	log :: proc(x: c.double) -> c.double ---


	// Compute the natural logarithm of `x`.
	//
	// Domain: `0 < x <= INF`
	//
	// Range: `-INF <= y <= INF`
	//
	// It is an error for `x` to be less than or equal to 0.
	//
	// This function operates on single-precision floating point values, use
	// log for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value. Must be greater than 0.
	// \returns the natural logarithm of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa log
	// \sa expf

	logf :: proc(x: c.float) -> c.float ---


	// Compute the base-10 logarithm of `x`.
	//
	// Domain: `0 < x <= INF`
	//
	// Range: `-INF <= y <= INF`
	//
	// It is an error for `x` to be less than or equal to 0.
	//
	// This function operates on double-precision floating point values, use
	// log10f for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value. Must be greater than 0.
	// \returns the logarithm of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa log10f
	// \sa log
	// \sa pow

	log10 :: proc(x: c.double) -> c.double ---


	// Compute the base-10 logarithm of `x`.
	//
	// Domain: `0 < x <= INF`
	//
	// Range: `-INF <= y <= INF`
	//
	// It is an error for `x` to be less than or equal to 0.
	//
	// This function operates on single-precision floating point values, use
	// log10 for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value. Must be greater than 0.
	// \returns the logarithm of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa log10
	// \sa logf
	// \sa powf

	log10f :: proc(x: c.float) -> c.float ---


	// Split `x` into integer and fractional parts
	//
	// This function operates on double-precision floating point values, use
	// modff for single-precision floats.
	//
	// \param x floating point value.
	// \param y output pointer to store the integer part of `x`.
	// \returns the fractional part of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa modff
	// \sa trunc
	// \sa fmod

	modf :: proc(x: c.double, y: ^c.double) -> c.double ---


	// Split `x` into integer and fractional parts
	//
	// This function operates on single-precision floating point values, use
	// modf for double-precision floats.
	//
	// \param x floating point value.
	// \param y output pointer to store the integer part of `x`.
	// \returns the fractional part of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa modf
	// \sa truncf
	// \sa fmodf

	modff :: proc(x: c.float, y: ^c.float) -> c.float ---


	// Raise `x` to the power `y`
	//
	// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
	//
	// Range: `-INF <= z <= INF`
	//
	// If `y` is the base of the natural logarithm (e), consider using exp
	// instead.
	//
	// This function operates on double-precision floating point values, use
	// powf for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x the base.
	// \param y the exponent.
	// \returns `x` raised to the power `y`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa powf
	// \sa exp
	// \sa log

	pow :: proc(x, y: c.double) -> c.double ---


	// Raise `x` to the power `y`
	//
	// Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
	//
	// Range: `-INF <= z <= INF`
	//
	// If `y` is the base of the natural logarithm (e), consider using exp
	// instead.
	//
	// This function operates on single-precision floating point values, use
	// powf for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x the base.
	// \param y the exponent.
	// \returns `x` raised to the power `y`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa pow
	// \sa expf
	// \sa logf

	powf :: proc(x, y: c.float) -> c.float ---


	// Round `x` to the nearest integer.
	//
	// Rounds `x` to the nearest integer. Values halfway between integers will be
	// rounded away from zero.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`, y integer
	//
	// This function operates on double-precision floating point values, use
	// roundf for single-precision floats. To get the result as an integer
	// type, use lround.
	//
	// \param x floating point value.
	// \returns the nearest integer to `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa roundf
	// \sa lround
	// \sa floor
	// \sa ceil
	// \sa trunc

	round :: proc(x: c.double) -> c.double ---


	// Round `x` to the nearest integer.
	//
	// Rounds `x` to the nearest integer. Values halfway between integers will be
	// rounded away from zero.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`, y integer
	//
	// This function operates on double-precision floating point values, use
	// roundf for single-precision floats. To get the result as an integer
	// type, use lroundf.
	//
	// \param x floating point value.
	// \returns the nearest integer to `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa round
	// \sa lroundf
	// \sa floorf
	// \sa ceilf
	// \sa truncf

	roundf :: proc(x: c.float) -> c.float ---


	// Round `x` to the nearest integer representable as a long
	//
	// Rounds `x` to the nearest integer. Values halfway between integers will be
	// rounded away from zero.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `MIN_LONG <= y <= MAX_LONG`
	//
	// This function operates on double-precision floating point values, use
	// lround for single-precision floats. To get the result as a
	// floating-point type, use round.
	//
	// \param x floating point value.
	// \returns the nearest integer to `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa lroundf
	// \sa round
	// \sa floor
	// \sa ceil
	// \sa trunc

	lround :: proc(x: c.double) -> c.long ---


	// Round `x` to the nearest integer representable as a long
	//
	// Rounds `x` to the nearest integer. Values halfway between integers will be
	// rounded away from zero.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `MIN_LONG <= y <= MAX_LONG`
	//
	// This function operates on single-precision floating point values, use
	// lroundf for double-precision floats. To get the result as a
	// floating-point type, use roundf,
	//
	// \param x floating point value.
	// \returns the nearest integer to `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa lround
	// \sa roundf
	// \sa floorf
	// \sa ceilf
	// \sa truncf

	lroundf :: proc(x: c.float) -> c.long ---


	// Scale `x` by an integer power of two.
	//
	// Multiplies `x` by the `n`th power of the floating point radix (always 2).
	//
	// Domain: `-INF <= x <= INF`, `n` integer
	//
	// Range: `-INF <= y <= INF`
	//
	// This function operates on double-precision floating point values, use
	// scalbnf for single-precision floats.
	//
	// \param x floating point value to be scaled.
	// \param n integer exponent.
	// \returns `x * 2^n`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa scalbnf
	// \sa pow

	scalbn :: proc(x: c.double, n: c.int) -> c.double ---


	// Scale `x` by an integer power of two.
	//
	// Multiplies `x` by the `n`th power of the floating point radix (always 2).
	//
	// Domain: `-INF <= x <= INF`, `n` integer
	//
	// Range: `-INF <= y <= INF`
	//
	// This function operates on single-precision floating point values, use
	// scalbn for double-precision floats.
	//
	// \param x floating point value to be scaled.
	// \param n integer exponent.
	// \returns `x * 2^n`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa scalbn
	// \sa powf

	scalbnf :: proc(x: c.float, n: c.int) -> c.float ---


	// Compute the sine of `x`.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-1 <= y <= 1`
	//
	// This function operates on double-precision floating point values, use
	// sinf for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value, in radians.
	// \returns sine of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa sinf
	// \sa asin
	// \sa cos

	sin :: proc(x: c.double) -> c.double ---


	// Compute the sine of `x`.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-1 <= y <= 1`
	//
	// This function operates on single-precision floating point values, use
	// sinf for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value, in radians.
	// \returns sine of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa sin
	// \sa asinf
	// \sa cosf

	sinf :: proc(x: c.float) -> c.float ---


	// Compute the square root of `x`.
	//
	// Domain: `0 <= x <= INF`
	//
	// Range: `0 <= y <= INF`
	//
	// This function operates on double-precision floating point values, use
	// sqrtf for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value. Must be greater than or equal to 0.
	// \returns square root of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa sqrtf

	sqrt :: proc(x: c.double) -> c.double ---


	// Compute the square root of `x`.
	//
	// Domain: `0 <= x <= INF`
	//
	// Range: `0 <= y <= INF`
	//
	// This function operates on single-precision floating point values, use
	// sqrt for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value. Must be greater than or equal to 0.
	// \returns square root of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa sqrt

	sqrtf :: proc(x: c.float) -> c.float ---


	// Compute the tangent of `x`.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`
	//
	// This function operates on double-precision floating point values, use
	// tanf for single-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value, in radians.
	// \returns tangent of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa tanf
	// \sa sin
	// \sa cos
	// \sa atan
	// \sa atan2

	tan :: proc(x: c.double) -> c.double ---


	// Compute the tangent of `x`.
	//
	// Domain: `-INF <= x <= INF`
	//
	// Range: `-INF <= y <= INF`
	//
	// This function operates on single-precision floating point values, use
	// tanf for double-precision floats.
	//
	// This function may use a different approximation across different versions,
	// platforms and configurations. i.e, it can return a different value given
	// the same input on different machines or operating systems, or if SDL is
	// updated.
	//
	// \param x floating point value, in radians.
	// \returns tangent of `x`.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa tan
	// \sa sinf
	// \sa cosf
	// \sa atanf
	// \sa atan2f

	tanf :: proc(x: c.float) -> c.float ---


	// This function allocates a context for the specified character set
	// conversion.
	//
	// \param tocode The target character encoding, must not be NULL.
	// \param fromcode The source character encoding, must not be NULL.
	// \returns a handle that must be freed with iconv_close, or
	//          ICONV_ERROR on failure.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa iconv
	// \sa iconv_close
	// \sa iconv_string

	iconv_open :: proc(tocode, fromcode: cstring) -> iconv_t ---


	// This function frees a context used for character set conversion.
	//
	// \param cd The character set conversion handle.
	// \returns 0 on success, or -1 on failure.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa iconv
	// \sa iconv_open
	// \sa iconv_string

	iconv_close :: proc(cd: iconv_t) -> c.int ---


	// This function converts text between encodings, reading from and writing to
	// a buffer.
	//
	// It returns the number of succesful conversions.
	//
	// \param cd The character set conversion context, created in
	//           iconv_open().
	// \param inbuf Address of variable that points to the first character of the
	//              input sequence.
	// \param inbytesleft The number of bytes in the input buffer.
	// \param outbuf Address of variable that points to the output buffer.
	// \param outbytesleft The number of bytes in the output buffer.
	// \returns the number of conversions on success, else ICONV_E2BIG is
	//          returned when the output buffer is too small, or ICONV_EILSEQ
	//          is returned when an invalid input sequence is encountered, or
	//          ICONV_EINVAL is returned when an incomplete input sequence is
	//          encountered.
	//
	//          On exit:
	//
	//          - inbuf will point to the beginning of the next multibyte
	//            sequence. On error, this is the location of the problematic
	//            input sequence. On success, this is the end of the input
	//            sequence. - inbytesleft will be set to the number of bytes left
	//            to convert, which will be 0 on success. - outbuf will point to
	//            the location where to store the next output byte. - outbytesleft
	//            will be set to the number of bytes left in the output buffer.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa iconv_open
	// \sa iconv_close
	// \sa iconv_string

	iconv :: proc(cd: iconv_t, inbuf: ^cstring, inbytesleft: ^c.size_t, outbuf: ^cstring, outbytesleft: ^c.size_t) -> c.size_t ---


	// Helper function to convert a string's encoding in one call.
	//
	// This function converts a buffer or string between encodings in one pass.
	//
	// The string does not need to be NULL-terminated; this function operates on
	// the number of bytes specified in `inbytesleft` whether there is a NULL
	// character anywhere in the buffer.
	//
	// The returned string is owned by the caller, and should be passed to
	// free when no longer needed.
	//
	// \param tocode the character encoding of the output string. Examples are
	//               "UTF-8", "UCS-4", etc.
	// \param fromcode the character encoding of data in `inbuf`.
	// \param inbuf the string to convert to a different encoding.
	// \param inbytesleft the size of the input string _in bytes_.
	// \returns a new string, converted to the new encoding, or NULL on error.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa iconv_open
	// \sa iconv_close
	// \sa iconv

	iconv_string :: proc(tocode, fromcode, inbuf: cstring, inbytesleft: c.size_t) -> cstring ---

	/* Some helper macros for common cases... */
	// #define iconv_utf8_locale(S)    iconv_string("", "UTF-8", S, strlen(S)+1)
	// #define iconv_utf8_ucs2(S)      (Uint16 *)iconv_string("UCS-2", "UTF-8", S, strlen(S)+1)
	// #define iconv_utf8_ucs4(S)      (Uint32 *)iconv_string("UCS-4", "UTF-8", S, strlen(S)+1)
	// #define iconv_wchar_utf8(S)     iconv_string("UTF-8", "WCHAR_T", (char *)S, (wcslen(S)+1)*sizeof(wchar_t))

}
