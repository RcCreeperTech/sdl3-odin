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

/* WIKI CATEGORY: CPUInfo */

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

// # CategoryCPUInfo
//
// CPU feature detection for SDL.
//
// These functions are largely concerned with reporting if the system has
// access to various SIMD instruction sets, but also has other important info
// to share, such as system RAM size and number of logical CPU cores.

// A guess for the cacheline size used for padding.
//
// Most x86 processors have a 64 byte cache line. The 64-bit PowerPC
// processors have a 128 byte cache line. We use the larger value to be
// generally safe.
//
// \since This macro is available since SDL 3.0.0.
SDL_CACHELINE_SIZE :: 128

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get the number of logical CPU cores available.
	//
	// \returns the total number of logical CPU cores. On CPUs that include
	//          technologies such as hyperthreading, the number of logical cores
	//          may be more than the number of physical cores.
	//
	// \since This function is available since SDL 3.0.0.

	GetNumLogicalCPUCores :: proc() -> c.int ---


	// Determine the L1 cache line size of the CPU.
	//
	// This is useful for determining multi-threaded structure padding or SIMD
	// prefetch sizes.
	//
	// \returns the L1 cache line size of the CPU, in bytes.
	//
	// \since This function is available since SDL 3.0.0.

	GetCPUCacheLineSize :: proc() -> c.int ---


	// Determine whether the CPU has AltiVec features.
	//
	// This always returns false on CPUs that aren't using PowerPC instruction
	// sets.
	//
	// \returns true if the CPU has AltiVec features or false if not.
	//
	// \since This function is available since SDL 3.0.0.

	HasAltiVec :: proc() -> c.bool ---


	// Determine whether the CPU has MMX features.
	//
	// This always returns false on CPUs that aren't using Intel instruction sets.
	//
	// \returns true if the CPU has MMX features or false if not.
	//
	// \since This function is available since SDL 3.0.0.

	HasMMX :: proc() -> c.bool ---


	// Determine whether the CPU has SSE features.
	//
	// This always returns false on CPUs that aren't using Intel instruction sets.
	//
	// \returns true if the CPU has SSE features or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasSSE2
	// \sa SDL_HasSSE3
	// \sa SDL_HasSSE41
	// \sa SDL_HasSSE42

	HasSSE :: proc() -> c.bool ---


	// Determine whether the CPU has SSE2 features.
	//
	// This always returns false on CPUs that aren't using Intel instruction sets.
	//
	// \returns true if the CPU has SSE2 features or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasSSE
	// \sa SDL_HasSSE3
	// \sa SDL_HasSSE41
	// \sa SDL_HasSSE42

	HasSSE2 :: proc() -> c.bool ---


	// Determine whether the CPU has SSE3 features.
	//
	// This always returns false on CPUs that aren't using Intel instruction sets.
	//
	// \returns true if the CPU has SSE3 features or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasSSE
	// \sa SDL_HasSSE2
	// \sa SDL_HasSSE41
	// \sa SDL_HasSSE42

	HasSSE3 :: proc() -> c.bool ---


	// Determine whether the CPU has SSE4.1 features.
	//
	// This always returns false on CPUs that aren't using Intel instruction sets.
	//
	// \returns true if the CPU has SSE4.1 features or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasSSE
	// \sa SDL_HasSSE2
	// \sa SDL_HasSSE3
	// \sa SDL_HasSSE42

	HasSSE41 :: proc() -> c.bool ---


	// Determine whether the CPU has SSE4.2 features.
	//
	// This always returns false on CPUs that aren't using Intel instruction sets.
	//
	// \returns true if the CPU has SSE4.2 features or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasSSE
	// \sa SDL_HasSSE2
	// \sa SDL_HasSSE3
	// \sa SDL_HasSSE41

	HasSSE42 :: proc() -> c.bool ---


	// Determine whether the CPU has AVX features.
	//
	// This always returns false on CPUs that aren't using Intel instruction sets.
	//
	// \returns true if the CPU has AVX features or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasAVX2
	// \sa SDL_HasAVX512F

	HasAVX :: proc() -> c.bool ---


	// Determine whether the CPU has AVX2 features.
	//
	// This always returns false on CPUs that aren't using Intel instruction sets.
	//
	// \returns true if the CPU has AVX2 features or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasAVX
	// \sa SDL_HasAVX512F

	HasAVX2 :: proc() -> c.bool ---


	// Determine whether the CPU has AVX-512F (foundation) features.
	//
	// This always returns false on CPUs that aren't using Intel instruction sets.
	//
	// \returns true if the CPU has AVX-512F features or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasAVX
	// \sa SDL_HasAVX2

	HasAVX512F :: proc() -> c.bool ---


	// Determine whether the CPU has ARM SIMD (ARMv6) features.
	//
	// This is different from ARM NEON, which is a different instruction set.
	//
	// This always returns false on CPUs that aren't using ARM instruction sets.
	//
	// \returns true if the CPU has ARM SIMD features or false if not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_HasNEON

	HasARMSIMD :: proc() -> c.bool ---


	// Determine whether the CPU has NEON (ARM SIMD) features.
	//
	// This always returns false on CPUs that aren't using ARM instruction sets.
	//
	// \returns true if the CPU has ARM NEON features or false if not.
	//
	// \since This function is available since SDL 3.0.0.

	HasNEON :: proc() -> c.bool ---


	// Determine whether the CPU has LSX (LOONGARCH SIMD) features.
	//
	// This always returns false on CPUs that aren't using LOONGARCH instruction
	// sets.
	//
	// \returns true if the CPU has LOONGARCH LSX features or false if not.
	//
	// \since This function is available since SDL 3.0.0.

	HasLSX :: proc() -> c.bool ---


	// Determine whether the CPU has LASX (LOONGARCH SIMD) features.
	//
	// This always returns false on CPUs that aren't using LOONGARCH instruction
	// sets.
	//
	// \returns true if the CPU has LOONGARCH LASX features or false if not.
	//
	// \since This function is available since SDL 3.0.0.

	HasLASX :: proc() -> c.bool ---


	// Get the amount of RAM configured in the system.
	//
	// \returns the amount of RAM configured in the system in MiB.
	//
	// \since This function is available since SDL 3.0.0.

	GetSystemRAM :: proc() -> c.int ---


	// Report the alignment this system needs for SIMD allocations.
	//
	// This will return the minimum number of bytes to which a pointer must be
	// aligned to be compatible with SIMD instructions on the current machine. For
	// example, if the machine supports SSE only, it will return 16, but if it
	// supports AVX-512F, it'll return 64 (etc). This only reports values for
	// instruction sets SDL knows about, so if your SDL build doesn't have
	// SDL_HasAVX512F(), then it might return 16 for the SSE support it sees and
	// not 64 for the AVX-512 instructions that exist but SDL doesn't know about.
	// Plan accordingly.
	//
	// \returns the alignment in bytes needed for available, known SIMD
	//          instructions.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SDL_aligned_alloc
	// \sa SDL_aligned_free

	GetSIMDAlignment :: proc() -> c.size_t ---
}
