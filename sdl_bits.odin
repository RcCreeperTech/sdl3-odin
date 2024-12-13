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

/**
 * # CategoryBits
 *
 * Functions for fiddling with bits and bitmasks.
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
/**
 * Get the index of the most significant (set) bit in a 32-bit number.
 *
 * Result is undefined when called with 0. This operation can also be stated
 * as "count leading zeroes" and "log base 2".
 *
 * Note that this is a forced-inline function in a header, and not a public
 * API function available in the SDL library (which is to say, the code is
 * embedded in the calling program and the linker and dynamic loader will not
 * be able to find this function inside SDL itself).
 *
 * \param x the 32-bit value to examine.
 * \returns the index of the most significant bit, or -1 if the value is 0.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.0.0.
 */
MostSignificantBitIndex32 :: #force_inline proc "c" (x: u32) -> c.int {
	return c.int(intrinsics.count_leading_zeros(x))
}

/**
 * Determine if a unsigned 32-bit value has exactly one bit set.
 *
 * If there are no bits set (`x` is zero), or more than one bit set, this
 * returns false. If any one bit is exclusively set, this returns true.
 *
 * Note that this is a forced-inline function in a header, and not a public
 * API function available in the SDL library (which is to say, the code is
 * embedded in the calling program and the linker and dynamic loader will not
 * be able to find this function inside SDL itself).
 *
 * \param x the 32-bit value to examine.
 * \returns true if exactly one bit is set in `x`, false otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.0.0.
 */
HasExactlyOneBitSet32 :: #force_inline proc "c" (x: u32) -> bool {
	return intrinsics.count_ones(x) == 1
}
