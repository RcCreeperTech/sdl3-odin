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
 * # CategoryEndian
 *
 * Functions for reading and writing endian-specific values.
 */

import "base:intrinsics"
import "core:c"
import "core:math/bits"


/**
 *  \name The two types of endianness
 */
LIL_ENDIAN :: 1234
BIG_ENDIAN :: 4321

BYTEORDER :: LIL_ENDIAN when ODIN_ENDIAN == .Little else BIG_ENDIAN
FLOATWORDORDER :: BYTEORDER

/**
 * Byte-swap a floating point number.
 *
 * This will always byte-swap the value, whether it's currently in the native
 * byteorder of the system or not. You should use SDL_SwapFloatLE or
 * SDL_SwapFloatBE instead, in most cases.
 *
 * Note that this is a forced-inline function in a header, and not a public
 * API function available in the SDL library (which is to say, the code is
 * embedded in the calling program and the linker and dynamic loader will not
 * be able to find this function inside SDL itself).
 *
 * \param x the value to byte-swap.
 * \returns x, with its bytes in the opposite endian order.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.0.0.
 */
SwapFloat :: intrinsics.byte_swap

/**
 * Byte-swap an unsigned 16-bit number.
 *
 * This will always byte-swap the value, whether it's currently in the native
 * byteorder of the system or not. You should use SDL_Swap16LE or SDL_Swap16BE
 * instead, in most cases.
 *
 * Note that this is a forced-inline function in a header, and not a public
 * API function available in the SDL library (which is to say, the code is
 * embedded in the calling program and the linker and dynamic loader will not
 * be able to find this function inside SDL itself).
 *
 * \param x the value to byte-swap.
 * \returns `x`, with its bytes in the opposite endian order.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.0.0.
 */
Swap16 :: intrinsics.byte_swap

/**
 * Byte-swap an unsigned 32-bit number.
 *
 * This will always byte-swap the value, whether it's currently in the native
 * byteorder of the system or not. You should use SDL_Swap32LE or SDL_Swap32BE
 * instead, in most cases.
 *
 * Note that this is a forced-inline function in a header, and not a public
 * API function available in the SDL library (which is to say, the code is
 * embedded in the calling program and the linker and dynamic loader will not
 * be able to find this function inside SDL itself).
 *
 * \param x the value to byte-swap.
 * \returns `x`, with its bytes in the opposite endian order.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.0.0.
 */
Swap32 :: intrinsics.byte_swap

/**
 * Byte-swap an unsigned 64-bit number.
 *
 * This will always byte-swap the value, whether it's currently in the native
 * byteorder of the system or not. You should use SDL_Swap64LE or SDL_Swap64BE
 * instead, in most cases.
 *
 * Note that this is a forced-inline function in a header, and not a public
 * API function available in the SDL library (which is to say, the code is
 * embedded in the calling program and the linker and dynamic loader will not
 * be able to find this function inside SDL itself).
 *
 * \param x the value to byte-swap.
 * \returns `x`, with its bytes in the opposite endian order.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.0.0.
 */
Swap64 :: intrinsics.byte_swap


/**
 * Swap a 16-bit value from littleendian to native byte order.
 *
 * If this is running on a littleendian system, `x` is returned unchanged.
 *
 * This macro never references `x` more than once, avoiding side effects.
 *
 * \param x the value to swap, in littleendian byte order.
 * \returns `x` in native byte order.
 *
 * \since This macro is available since SDL 3.0.0.
 */
Swap16LE :: #force_inline proc "c" (x: u16le) -> u16 {
	when ODIN_ENDIAN == .Little {
		return cast(u16)x
	} else {
		return cast(u16)intrinsics.byte_swap(x)
	}
}

/**
 * Swap a 32-bit value from littleendian to native byte order.
 *
 * If this is running on a littleendian system, `x` is returned unchanged.
 *
 * This macro never references `x` more than once, avoiding side effects.
 *
 * \param x the value to swap, in littleendian byte order.
 * \returns `x` in native byte order.
 *
 * \since This macro is available since SDL 3.0.0.
 */
Swap32LE :: #force_inline proc "c" (x: u32le) -> u32 {
	when ODIN_ENDIAN == .Little {
		return cast(u32)x
	} else {
		return cast(u32)intrinsics.byte_swap(x)
	}
}

/**
 * Swap a 64-bit value from littleendian to native byte order.
 *
 * If this is running on a littleendian system, `x` is returned unchanged.
 *
 * This macro never references `x` more than once, avoiding side effects.
 *
 * \param x the value to swap, in littleendian byte order.
 * \returns `x` in native byte order.
 *
 * \since This macro is available since SDL 3.0.0.
 */
Swap64LE :: #force_inline proc "c" (x: u64le) -> u64 {
	when ODIN_ENDIAN == .Little {
		return cast(u64)x
	} else {
		return cast(u64)intrinsics.byte_swap(x)
	}
}

/**
 * Swap a floating point value from littleendian to native byte order.
 *
 * If this is running on a littleendian system, `x` is returned unchanged.
 *
 * This macro never references `x` more than once, avoiding side effects.
 *
 * \param x the value to swap, in littleendian byte order.
 * \returns `x` in native byte order.
 *
 * \since This macro is available since SDL 3.0.0.
 */
SwapFloatLE :: #force_inline proc "c" (x: f32le) -> f32 {
	when ODIN_ENDIAN == .Little {
		return cast(f32)x
	} else {
		return cast(f32)intrinsics.byte_swap(x)
	}
}


/**
 * Swap a 16-bit value from bigendian to native byte order.
 *
 * If this is running on a bigendian system, `x` is returned unchanged.
 *
 * This macro never references `x` more than once, avoiding side effects.
 *
 * \param x the value to swap, in bigendian byte order.
 * \returns `x` in native byte order.
 *
 * \since This macro is available since SDL 3.0.0.
 */
Swap16BE :: #force_inline proc "c" (x: u16be) -> u16 {
	when ODIN_ENDIAN == .Big {
		return cast(u16)x
	} else {
		return cast(u16)intrinsics.byte_swap(x)
	}
}

/**
 * Swap a 32-bit value from bigendian to native byte order.
 *
 * If this is running on a bigendian system, `x` is returned unchanged.
 *
 * This macro never references `x` more than once, avoiding side effects.
 *
 * \param x the value to swap, in bigendian byte order.
 * \returns `x` in native byte order.
 *
 * \since This macro is available since SDL 3.0.0.
 */
Swap32BE :: #force_inline proc "c" (x: u32be) -> u32 {
	when ODIN_ENDIAN == .Big {
		return cast(u32)x
	} else {
		return cast(u32)intrinsics.byte_swap(x)
	}
}

/**
 * Swap a 64-bit value from bigendian to native byte order.
 *
 * If this is running on a bigendian system, `x` is returned unchanged.
 *
 * This macro never references `x` more than once, avoiding side effects.
 *
 * \param x the value to swap, in bigendian byte order.
 * \returns `x` in native byte order.
 *
 * \since This macro is available since SDL 3.0.0.
 */
Swap64BE :: #force_inline proc "c" (x: u64be) -> u64 {
	when ODIN_ENDIAN == .Big {
		return cast(u64)x
	} else {
		return cast(u64)intrinsics.byte_swap(x)
	}
}

/**
 * Swap a floating point value from bigendian to native byte order.
 *
 * If this is running on a bigendian system, `x` is returned unchanged.
 *
 * This macro never references `x` more than once, avoiding side effects.
 *
 * \param x the value to swap, in bigendian byte order.
 * \returns `x` in native byte order.
 *
 * \since This macro is available since SDL 3.0.0.
 */
SwapFloatBE :: #force_inline proc "c" (x: f32be) -> f32 {
	when ODIN_ENDIAN == .Big {
		return cast(f32)x
	} else {
		return cast(f32)intrinsics.byte_swap(x)
	}
}
