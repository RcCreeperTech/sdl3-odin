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


// # CategoryPixels
//
// Pixel management.


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

// A fully opaque 8-bit alpha value.
//
// \since This macro is available since SDL 3.0.0.
//
// \sa ALPHA_TRANSPARENT

ALPHA_OPAQUE :: 255


// A fully opaque floating point alpha value.
//
// \since This macro is available since SDL 3.0.0.
//
// \sa ALPHA_TRANSPARENT_FLOAT

ALPHA_OPAQUE_FLOAT :: 1.0


// A fully transparent 8-bit alpha value.
//
// \since This macro is available since SDL 3.0.0.
//
// \sa ALPHA_OPAQUE

ALPHA_TRANSPARENT :: 0


// A fully transparent floating point alpha value.
//
// \since This macro is available since SDL 3.0.0.
//
// \sa ALPHA_OPAQUE_FLOAT

ALPHA_TRANSPARENT_FLOAT :: 0.0


// Pixel type.
//
// \since This enum is available since SDL 3.0.0.

PixelType :: enum c.int {
	UNKNOWN,
	INDEX1,
	INDEX4,
	INDEX8,
	PACKED8,
	PACKED16,
	PACKED32,
	ARRAYU8,
	ARRAYU16,
	ARRAYU32,
	ARRAYF16,
	ARRAYF32,
	/* appended at the end for compatibility with sdl2-compat:  */
	INDEX2,
}


// Bitmap pixel order, high bit -> low bit.
//
// \since This enum is available since SDL 3.0.0.

BitmapOrder :: enum c.int {
	_NONE,
	_4321,
	_1234,
}


// Packed component order, high bit -> low bit.
//
// \since This enum is available since SDL 3.0.0.

PackedOrder :: enum c.int {
	NONE,
	XRGB,
	RGBX,
	ARGB,
	RGBA,
	XBGR,
	BGRX,
	ABGR,
	BGRA,
}


// Array component order, low byte -> high byte.
//
// \since This enum is available since SDL 3.0.0.

ArrayOrder :: enum c.int {
	NONE,
	RGB,
	RGBA,
	ARGB,
	BGR,
	BGRA,
	ABGR,
}

RawOrder :: struct #raw_union {
	array:  ArrayOrder,
	packed: PackedOrder,
	bitmap: BitmapOrder,
}


// Packed component layout.
//
// \since This enum is available since SDL 3.0.0.

PackedLayout :: enum c.int {
	NONE,
	_332,
	_4444,
	_1555,
	_5551,
	_565,
	_8888,
	_2101010,
	_1010102,
}


PackedPixelFormat :: bit_field u32 {
	bytes:  u8           | 8,
	bits:   u8           | 8,
	layout: PackedLayout | 4,
	order:  c.int        | 4,
	type:   PixelType    | 4,
	flag:   u8           | 4,
}

DEFINE_PIXELFORMAT :: #force_inline proc "c" (
	type: PixelType,
	order: RawOrder,
	layout: PackedLayout,
	bits, bytes: u8,
) -> PackedPixelFormat {
	return {
		bytes = bytes,
		bits = bits,
		layout = layout,
		order = transmute(c.int)order,
		type = type,
		flag = 1,
	}
}

PIXELFLAG :: #force_inline proc "c" (X: PackedPixelFormat) -> c.bool {return X.flag == 1}
ISPIXELFORMAT_FOURCC :: #force_inline proc "c" (format: PackedPixelFormat) -> c.bool {return(
		format.flag !=
		1 \
	)}
PIXELTYPE :: #force_inline proc "c" (X: PackedPixelFormat) -> PixelType {return X.type}
PIXELORDER :: #force_inline proc "c" (X: PackedPixelFormat) -> RawOrder {
	return transmute(RawOrder)X.order
}
PIXELLAYOUT :: #force_inline proc "c" (X: PackedPixelFormat) -> PackedLayout {return X.layout}
BITSPERPIXEL :: #force_inline proc "c" (X: PackedPixelFormat) -> c.int {
	return 0 if ISPIXELFORMAT_FOURCC(X) else c.int(X.bits)
}
BYTESPERPIXEL :: #force_inline proc "c" (X: PackedPixelFormat) -> c.int {
	if ISPIXELFORMAT_FOURCC(X) {
		format := PixelFormat(X)
		#partial switch format {
		case .YUY2, .UYVY, .YVYU, .P010:
			return 2
		case:
			return 1
		}
	} else {
		return c.int(X.bytes)
	}
}

ISPIXELFORMAT_INDEXED :: #force_inline proc "c" (X: PackedPixelFormat) -> c.bool {
	return(
		!ISPIXELFORMAT_FOURCC(X) &&
		(X.type == .INDEX1 || X.type == .INDEX2 || X.type == .INDEX4 || X.type == .INDEX8) \
	)
}

ISPIXELFORMAT_PACKED :: #force_inline proc "c" (X: PackedPixelFormat) -> c.bool {
	return(
		!ISPIXELFORMAT_FOURCC(X) &&
		(X.type == .PACKED8 || X.type == .PACKED16 || X.type == .PACKED32) \
	)
}
ISPIXELFORMAT_ARRAY :: #force_inline proc "c" (X: PackedPixelFormat) -> c.bool {
	return(
		!ISPIXELFORMAT_FOURCC(X) &&
		(X.type == .ARRAYU8 ||
				X.type == .ARRAYU16 ||
				X.type == .ARRAYU32 ||
				X.type == .ARRAYF16 ||
				X.type == .ARRAYF32) \
	)
}
ISPIXELFORMAT_ALPHA :: #force_inline proc "c" (X: PackedPixelFormat) -> c.bool {
	ord := transmute(RawOrder)X.order
	return(
		ISPIXELFORMAT_PACKED(X) &&
		(ord.packed == .ARGB ||
				ord.packed == .RGBA ||
				ord.packed == .ABGR ||
				ord.packed == .BGRA) \
	)
}
ISPIXELFORMAT_10BIT :: #force_inline proc "c" (X: PackedPixelFormat) -> c.bool {
	return !ISPIXELFORMAT_FOURCC(X) && X.type == .PACKED32 && X.layout == ._2101010
}
ISPIXELFORMAT_FLOAT :: #force_inline proc "c" (X: PackedPixelFormat) -> c.bool {
	return !ISPIXELFORMAT_FOURCC(X) && (X.type == .ARRAYF16 || X.type == .ARRAYF32)
}

// Pixel format.
//
// SDL's pixel formats have the following naming convention:
//
// - Names with a list of components and a single bit count, such as RGB24 and
//   ABGR32, define a platform-independent encoding into bytes in the order
//   specified. For example, in RGB24 data, each pixel is encoded in 3 bytes
//   (red, green, blue) in that order, and in ABGR32 data, each pixel is
//   encoded in 4 bytes alpha, blue, green, red) in that order. Use these
//   names if the property of a format that is important to you is the order
//   of the bytes in memory or on disk.
// - Names with a bit count per component, such as ARGB8888 and XRGB1555, are
//   "packed" into an appropriately-sized integer in the platform's native
//   endianness. For example, ARGB8888 is a sequence of 32-bit integers; in
//   each integer, the most significant bits are alpha, and the least
//   significant bits are blue. On a little-endian CPU such as x86, the least
//   significant bits of each integer are arranged first in memory, but on a
//   big-endian CPU such as s390x, the most significant bits are arranged
//   first. Use these names if the property of a format that is important to
//   you is the meaning of each bit position within a native-endianness
//   integer.
// - In indexed formats such as INDEX4LSB, each pixel is represented by
//   encoding an index into the palette into the indicated number of bits,
//   with multiple pixels packed into each byte if appropriate. In LSB
//   formats, the first (leftmost) pixel is stored in the least-significant
//   bits of the byte; in MSB formats, it's stored in the most-significant
//   bits. INDEX8 does not need LSB/MSB variants, because each pixel exactly
//   fills one byte.
//
// The 32-bit byte-array encodings such as RGBA32 are aliases for the
// appropriate 8888 encoding for the current platform. For example, RGBA32 is
// an alias for ABGR8888 on little-endian CPUs like x86, or an alias for
// RGBA8888 on big-endian CPUs.
//
// \since This enum is available since SDL 3.0.0.
PixelFormat :: enum u32 {
	UNKNOWN       = 0,
	INDEX1LSB     = 0x11100100,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_INDEX1, BITMAPORDER_4321, 0, 1, 0), */
	INDEX1MSB     = 0x11200100,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_INDEX1, BITMAPORDER_1234, 0, 1, 0), */
	INDEX2LSB     = 0x1c100200,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_INDEX2, BITMAPORDER_4321, 0, 2, 0), */
	INDEX2MSB     = 0x1c200200,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_INDEX2, BITMAPORDER_1234, 0, 2, 0), */
	INDEX4LSB     = 0x12100400,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_INDEX4, BITMAPORDER_4321, 0, 4, 0), */
	INDEX4MSB     = 0x12200400,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_INDEX4, BITMAPORDER_1234, 0, 4, 0), */
	INDEX8        = 0x13000801,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_INDEX8, 0, 0, 8, 1), */
	RGB332        = 0x14110801,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED8, PACKEDORDER_XRGB, PACKEDLAYOUT_332, 8, 1), */
	XRGB4444      = 0x15120c02,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_XRGB, PACKEDLAYOUT_4444, 12, 2), */
	XBGR4444      = 0x15520c02,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_XBGR, PACKEDLAYOUT_4444, 12, 2), */
	XRGB1555      = 0x15130f02,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_XRGB, PACKEDLAYOUT_1555, 15, 2), */
	XBGR1555      = 0x15530f02,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_XBGR, PACKEDLAYOUT_1555, 15, 2), */
	ARGB4444      = 0x15321002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_ARGB, PACKEDLAYOUT_4444, 16, 2), */
	RGBA4444      = 0x15421002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_RGBA, PACKEDLAYOUT_4444, 16, 2), */
	ABGR4444      = 0x15721002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_ABGR, PACKEDLAYOUT_4444, 16, 2), */
	BGRA4444      = 0x15821002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_BGRA, PACKEDLAYOUT_4444, 16, 2), */
	ARGB1555      = 0x15331002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_ARGB, PACKEDLAYOUT_1555, 16, 2), */
	RGBA5551      = 0x15441002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_RGBA, PACKEDLAYOUT_5551, 16, 2), */
	ABGR1555      = 0x15731002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_ABGR, PACKEDLAYOUT_1555, 16, 2), */
	BGRA5551      = 0x15841002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_BGRA, PACKEDLAYOUT_5551, 16, 2), */
	RGB565        = 0x15151002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_XRGB, PACKEDLAYOUT_565, 16, 2), */
	BGR565        = 0x15551002,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED16, PACKEDORDER_XBGR, PACKEDLAYOUT_565, 16, 2), */
	RGB24         = 0x17101803,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYU8, ARRAYORDER_RGB, 0, 24, 3), */
	BGR24         = 0x17401803,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYU8, ARRAYORDER_BGR, 0, 24, 3), */
	XRGB8888      = 0x16161804,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_XRGB, PACKEDLAYOUT_8888, 24, 4), */
	RGBX8888      = 0x16261804,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_RGBX, PACKEDLAYOUT_8888, 24, 4), */
	XBGR8888      = 0x16561804,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_XBGR, PACKEDLAYOUT_8888, 24, 4), */
	BGRX8888      = 0x16661804,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_BGRX, PACKEDLAYOUT_8888, 24, 4), */
	ARGB8888      = 0x16362004,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_ARGB, PACKEDLAYOUT_8888, 32, 4), */
	RGBA8888      = 0x16462004,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_RGBA, PACKEDLAYOUT_8888, 32, 4), */
	ABGR8888      = 0x16762004,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_ABGR, PACKEDLAYOUT_8888, 32, 4), */
	BGRA8888      = 0x16862004,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_BGRA, PACKEDLAYOUT_8888, 32, 4), */
	XRGB2101010   = 0x16172004,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_XRGB, PACKEDLAYOUT_2101010, 32, 4), */
	XBGR2101010   = 0x16572004,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_XBGR, PACKEDLAYOUT_2101010, 32, 4), */
	ARGB2101010   = 0x16372004,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_ARGB, PACKEDLAYOUT_2101010, 32, 4), */
	ABGR2101010   = 0x16772004,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_PACKED32, PACKEDORDER_ABGR, PACKEDLAYOUT_2101010, 32, 4), */
	RGB48         = 0x18103006,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYU16, ARRAYORDER_RGB, 0, 48, 6), */
	BGR48         = 0x18403006,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYU16, ARRAYORDER_BGR, 0, 48, 6), */
	RGBA64        = 0x18204008,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYU16, ARRAYORDER_RGBA, 0, 64, 8), */
	ARGB64        = 0x18304008,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYU16, ARRAYORDER_ARGB, 0, 64, 8), */
	BGRA64        = 0x18504008,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYU16, ARRAYORDER_BGRA, 0, 64, 8), */
	ABGR64        = 0x18604008,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYU16, ARRAYORDER_ABGR, 0, 64, 8), */
	RGB48_FLOAT   = 0x1a103006,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF16, ARRAYORDER_RGB, 0, 48, 6), */
	BGR48_FLOAT   = 0x1a403006,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF16, ARRAYORDER_BGR, 0, 48, 6), */
	RGBA64_FLOAT  = 0x1a204008,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF16, ARRAYORDER_RGBA, 0, 64, 8), */
	ARGB64_FLOAT  = 0x1a304008,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF16, ARRAYORDER_ARGB, 0, 64, 8), */
	BGRA64_FLOAT  = 0x1a504008,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF16, ARRAYORDER_BGRA, 0, 64, 8), */
	ABGR64_FLOAT  = 0x1a604008,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF16, ARRAYORDER_ABGR, 0, 64, 8), */
	RGB96_FLOAT   = 0x1b10600c,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF32, ARRAYORDER_RGB, 0, 96, 12), */
	BGR96_FLOAT   = 0x1b40600c,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF32, ARRAYORDER_BGR, 0, 96, 12), */
	RGBA128_FLOAT = 0x1b208010,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF32, ARRAYORDER_RGBA, 0, 128, 16), */
	ARGB128_FLOAT = 0x1b308010,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF32, ARRAYORDER_ARGB, 0, 128, 16), */
	BGRA128_FLOAT = 0x1b508010,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF32, ARRAYORDER_BGRA, 0, 128, 16), */
	ABGR128_FLOAT = 0x1b608010,
	/* DEFINE_PIXELFORMAT(PIXELTYPE_ARRAYF32, ARRAYORDER_ABGR, 0, 128, 16), */
	YV12          = 0x32315659, /**< Planar mode: Y + V + U  (3 planes) */
	/* DEFINE_PIXELFOURCC('Y', 'V', '1', '2'), */
	IYUV          = 0x56555949, /**< Planar mode: Y + U + V  (3 planes) */
	/* DEFINE_PIXELFOURCC('I', 'Y', 'U', 'V'), */
	YUY2          = 0x32595559, /**< Packed mode: Y0+U0+Y1+V0 (1 plane) */
	/* DEFINE_PIXELFOURCC('Y', 'U', 'Y', '2'), */
	UYVY          = 0x59565955, /**< Packed mode: U0+Y0+V0+Y1 (1 plane) */
	/* DEFINE_PIXELFOURCC('U', 'Y', 'V', 'Y'), */
	YVYU          = 0x55595659, /**< Packed mode: Y0+V0+Y1+U0 (1 plane) */
	/* DEFINE_PIXELFOURCC('Y', 'V', 'Y', 'U'), */
	NV12          = 0x3231564e, /**< Planar mode: Y + U/V interleaved  (2 planes) */
	/* DEFINE_PIXELFOURCC('N', 'V', '1', '2'), */
	NV21          = 0x3132564e, /**< Planar mode: Y + V/U interleaved  (2 planes) */
	/* DEFINE_PIXELFOURCC('N', 'V', '2', '1'), */
	P010          = 0x30313050, /**< Planar mode: Y + U/V interleaved  (2 planes) */
	/* DEFINE_PIXELFOURCC('P', '0', '1', '0'), */
	EXTERNAL_OES  = 0x2053454f, /**< Android video texture format */
	/* DEFINE_PIXELFOURCC('O', 'E', 'S', ' ') */
	RGBA32        = RGBA8888 when ODIN_ENDIAN == .Big else ABGR8888,
	ARGB32        = ARGB8888 when ODIN_ENDIAN == .Big else BGRA8888,
	BGRA32        = BGRA8888 when ODIN_ENDIAN == .Big else ARGB8888,
	ABGR32        = ABGR8888 when ODIN_ENDIAN == .Big else RGBA8888,
	RGBX32        = RGBX8888 when ODIN_ENDIAN == .Big else XBGR8888,
	XRGB32        = XRGB8888 when ODIN_ENDIAN == .Big else BGRX8888,
	BGRX32        = BGRX8888 when ODIN_ENDIAN == .Big else XRGB8888,
	XBGR32        = XBGR8888 when ODIN_ENDIAN == .Big else RGBX8888,

	/* Aliases for RGBA byte arrays of color data, for the current platform */
}


// Pixels are a representation of a color in a particular color space.
//
// The first characteristic of a color space is the color type. SDL understands two different color types, RGB and YCbCr, or in SDL also referred to as YUV.
//
// RGB colors consist of red, green, and blue channels of color that are added together to represent the colors we see on the screen.
// https://en.wikipedia.org/wiki/RGB_color_model
//
// YCbCr colors represent colors as a Y luma brightness component and red and blue chroma color offsets. This color representation takes advantage of the fact that the human eye is more sensitive to brightness than the color in an image. The Cb and Cr components are often compressed and have lower resolution than the luma component.
// https://en.wikipedia.org/wiki/YCbCr
//
// When the color information in YCbCr is compressed, the Y pixels are left at full resolution and each Cr and Cb pixel represents an average of the color information in a block of Y pixels. The chroma location determines where in that block of pixels the color information is coming from.
//
// The color range defines how much of the pixel to use when converting a pixel into a color on the display. When the full color range is used, the entire numeric range of the pixel bits is significant. When narrow color range is used, for historical reasons, the pixel uses only a portion of the numeric range to represent colors.
//
// The color primaries and white point are a definition of the colors in the color space relative to the standard XYZ color space.
// https://en.wikipedia.org/wiki/CIE_1931_color_space
//
// The transfer characteristic, or opto-electrical transfer function (OETF), is the way a color is converted from mathematically linear space into a non-linear output signals.
// https://en.wikipedia.org/wiki/Rec._709#Transfer_characteristics
//
// The matrix coefficients are used to convert between YCbCr and RGB colors.


// Colorspace color type.
//
// \since This enum is available since SDL 3.0.0.

ColorType :: enum c.int {
	UNKNOWN = 0,
	RGB     = 1,
	YCBCR   = 2,
}


// Colorspace color range, as described by
// https://www.itu.int/rec/R-REC-BT.2100-2-201807-I/en
//
// \since This enum is available since SDL 3.0.0.

ColorRange :: enum c.int {
	UNKNOWN = 0,
	LIMITED = 1, /**< Narrow range, e.g. 16-235 for 8-bit RGB and luma, and 16-240 for 8-bit chroma */
	FULL    = 2, /**< Full range, e.g. 0-255 for 8-bit RGB and luma, and 1-255 for 8-bit chroma */
}


// Colorspace color primaries, as described by
// https://www.itu.int/rec/T-REC-H.273-201612-S/en
//
// \since This enum is available since SDL 3.0.0.

ColorPrimaries :: enum c.int {
	UNKNOWN      = 0,
	BT709        = 1, /**< ITU-R BT.709-6 */
	UNSPECIFIED  = 2,
	BT470M       = 4, /**< ITU-R BT.470-6 System M */
	BT470BG      = 5, /**< ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625 */
	BT601        = 6, /**< ITU-R BT.601-7 525, SMPTE 170M */
	SMPTE240     = 7, /**< SMPTE 240M, functionally the same as COLOR_PRIMARIES_BT601 */
	GENERIC_FILM = 8, /**< Generic film (color filters using Illuminant C) */
	BT2020       = 9, /**< ITU-R BT.2020-2 / ITU-R BT.2100-0 */
	XYZ          = 10, /**< SMPTE ST 428-1 */
	SMPTE431     = 11, /**< SMPTE RP 431-2 */
	SMPTE432     = 12, /**< SMPTE EG 432-1 / DCI P3 */
	EBU3213      = 22, /**< EBU Tech. 3213-E */
	CUSTOM       = 31,
}


// Colorspace transfer characteristics.
//
// These are as described by https://www.itu.int/rec/T-REC-H.273-201612-S/en
//
// \since This enum is available since SDL 3.0.0.

TransferCharacteristics :: enum c.int {
	UNKNOWN       = 0,
	BT709         = 1, /**< Rec. ITU-R BT.709-6 / ITU-R BT1361 */
	UNSPECIFIED   = 2,
	GAMMA22       = 4, /**< ITU-R BT.470-6 System M / ITU-R BT1700 625 PAL & SECAM */
	GAMMA28       = 5, /**< ITU-R BT.470-6 System B, G */
	BT601         = 6, /**< SMPTE ST 170M / ITU-R BT.601-7 525 or 625 */
	SMPTE240      = 7, /**< SMPTE ST 240M */
	LINEAR        = 8,
	LOG100        = 9,
	LOG100_SQRT10 = 10,
	IEC61966      = 11, /**< IEC 61966-2-4 */
	BT1361        = 12, /**< ITU-R BT1361 Extended Colour Gamut */
	SRGB          = 13, /**< IEC 61966-2-1 (sRGB or sYCC) */
	BT2020_10BIT  = 14, /**< ITU-R BT2020 for 10-bit system */
	BT2020_12BIT  = 15, /**< ITU-R BT2020 for 12-bit system */
	PQ            = 16, /**< SMPTE ST 2084 for 10-, 12-, 14- and 16-bit systems */
	SMPTE428      = 17, /**< SMPTE ST 428-1 */
	HLG           = 18, /**< ARIB STD-B67, known as "hybrid log-gamma" (HLG) */
	CUSTOM        = 31,
}


// Colorspace matrix coefficients.
//
// These are as described by https://www.itu.int/rec/T-REC-H.273-201612-S/en
//
// \since This enum is available since SDL 3.0.0.

MatrixCoefficients :: enum c.int {
	IDENTITY           = 0,
	BT709              = 1, /**< ITU-R BT.709-6 */
	UNSPECIFIED        = 2,
	FCC                = 4, /**< US FCC Title 47 */
	BT470BG            = 5, /**< ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625, functionally the same as MATRIX_COEFFICIENTS_BT601 */
	BT601              = 6, /**< ITU-R BT.601-7 525 */
	SMPTE240           = 7, /**< SMPTE 240M */
	YCGCO              = 8,
	BT2020_NCL         = 9, /**< ITU-R BT.2020-2 non-constant luminance */
	BT2020_CL          = 10, /**< ITU-R BT.2020-2 constant luminance */
	SMPTE2085          = 11, /**< SMPTE ST 2085 */
	CHROMA_DERIVED_NCL = 12,
	CHROMA_DERIVED_CL  = 13,
	ICTCP              = 14, /**< ITU-R BT.2100-0 ICTCP */
	CUSTOM             = 31,
}


// Colorspace chroma sample location.
//
// \since This enum is available since SDL 3.0.0.

ChromaLocation :: enum c.int {
	NONE    = 0, /**< RGB, no chroma sampling */
	LEFT    = 1, /**< In MPEG-2, MPEG-4, and AVC, Cb and Cr are taken on midpoint of the left-edge of the 2x2 square. In other words, they have the same horizontal location as the top-left pixel, but is shifted one-half pixel down vertically. */
	CENTER  = 2, /**< In JPEG/JFIF, H.261, and MPEG-1, Cb and Cr are taken at the center of the 2x2 square. In other words, they are offset one-half pixel to the right and one-half pixel down compared to the top-left pixel. */
	TOPLEFT = 3, /**< In HEVC for BT.2020 and BT.2100 content (in particular on Blu-rays), Cb and Cr are sampled at the same location as the group's top-left Y pixel ("co-sited", "co-located"). */
}


PackedColorspace :: bit_field u32 {
	mtx:       MatrixCoefficients      | 5,
	transfer:  TransferCharacteristics | 5,
	primaries: ColorPrimaries          | 10,
	chroma:    ChromaLocation          | 4,
	range:     ColorRange              | 4,
	type:      ColorType               | 4,
}

/* Colorspace definition */
DEFINE_COLORSPACE :: #force_inline proc "c" (
	type: ColorType,
	range: ColorRange,
	primaries: ColorPrimaries,
	transfer: TransferCharacteristics,
	mtx: MatrixCoefficients,
	chroma: ChromaLocation,
) -> PackedColorspace {
	return {
		mtx = mtx,
		transfer = transfer,
		primaries = primaries,
		chroma = chroma,
		range = range,
		type = type,
	}
}

COLORSPACETYPE :: #force_inline proc "c" (X: PackedColorspace) -> ColorType {return X.type}
COLORSPACERANGE :: #force_inline proc "c" (X: PackedColorspace) -> ColorRange {return X.range}
COLORSPACECHROMA :: #force_inline proc "c" (X: PackedColorspace) -> ChromaLocation {return(
		X.chroma \
	)}
COLORSPACEPRIMARIES :: #force_inline proc "c" (X: PackedColorspace) -> ColorPrimaries {return(
		X.primaries \
	)}
COLORSPACETRANSFER :: #force_inline proc "c" (
	X: PackedColorspace,
) -> TransferCharacteristics {return X.transfer}
COLORSPACEMATRIX :: #force_inline proc "c" (X: PackedColorspace) -> MatrixCoefficients {return(
		X.mtx \
	)}

ISCOLORSPACE_MATRIX_BT601 :: #force_inline proc "c" (X: PackedColorspace) -> c.bool {
	return X.mtx == .BT601 || X.mtx == .BT470BG
}
ISCOLORSPACE_MATRIX_BT709 :: #force_inline proc "c" (X: PackedColorspace) -> c.bool {
	return X.mtx == .BT709
}
ISCOLORSPACE_MATRIX_BT2020_NCL :: #force_inline proc "c" (X: PackedColorspace) -> c.bool {
	return X.mtx == .BT2020_CL
}
ISCOLORSPACE_LIMITED_RANGE :: #force_inline proc "c" (X: PackedColorspace) -> c.bool {
	return X.range != .FULL
}
ISCOLORSPACE_FULL_RANGE :: #force_inline proc "c" (X: PackedColorspace) -> c.bool {
	return X.range == .FULL
}


// Colorspace definitions.
//
// Since similar colorspaces may vary in their details (matrix, transfer
// function, etc.), this is not an exhaustive list, but rather a
// representative sample of the kinds of colorspaces supported in SDL.
//
// \since This enum is available since SDL 3.0.0.
//
// \sa ColorPrimaries
// \sa ColorRange
// \sa ColorType
// \sa MatrixCoefficients
// \sa TransferCharacteristics

Colorspace :: enum u32 {
	COLORSPACE_UNKNOWN        = 0,

	/* sRGB is a gamma corrected colorspace, and the default colorspace for SDL rendering and 8-bit RGB surfaces */
	COLORSPACE_SRGB           = 0x120005a0, /**< Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709 */
	/* DEFINE_COLORSPACE(COLOR_TYPE_RGB,
                                 COLOR_RANGE_FULL,
                                 COLOR_PRIMARIES_BT709,
                                 TRANSFER_CHARACTERISTICS_SRGB,
                                 MATRIX_COEFFICIENTS_IDENTITY,
                                 CHROMA_LOCATION_NONE), */

	/* This is a linear colorspace and the default colorspace for floating point surfaces. On Windows this is the scRGB colorspace, and on Apple platforms this is kCGColorSpaceExtendedLinearSRGB for EDR content */
	COLORSPACE_SRGB_LINEAR    = 0x12000500, /**< Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709  */
	/* DEFINE_COLORSPACE(COLOR_TYPE_RGB,
                                 COLOR_RANGE_FULL,
                                 COLOR_PRIMARIES_BT709,
                                 TRANSFER_CHARACTERISTICS_LINEAR,
                                 MATRIX_COEFFICIENTS_IDENTITY,
                                 CHROMA_LOCATION_NONE), */

	/* HDR10 is a non-linear HDR colorspace and the default colorspace for 10-bit surfaces */
	COLORSPACE_HDR10          = 0x12002600, /**< Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020  */
	/* DEFINE_COLORSPACE(COLOR_TYPE_RGB,
                                 COLOR_RANGE_FULL,
                                 COLOR_PRIMARIES_BT2020,
                                 TRANSFER_CHARACTERISTICS_PQ,
                                 MATRIX_COEFFICIENTS_IDENTITY,
                                 CHROMA_LOCATION_NONE), */
	COLORSPACE_JPEG           = 0x220004c6, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601 */
	/* DEFINE_COLORSPACE(COLOR_TYPE_YCBCR,
                                 COLOR_RANGE_FULL,
                                 COLOR_PRIMARIES_BT709,
                                 TRANSFER_CHARACTERISTICS_BT601,
                                 MATRIX_COEFFICIENTS_BT601,
                                 CHROMA_LOCATION_NONE), */
	COLORSPACE_BT601_LIMITED  = 0x211018c6, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601 */
	/* DEFINE_COLORSPACE(COLOR_TYPE_YCBCR,
                                 COLOR_RANGE_LIMITED,
                                 COLOR_PRIMARIES_BT601,
                                 TRANSFER_CHARACTERISTICS_BT601,
                                 MATRIX_COEFFICIENTS_BT601,
                                 CHROMA_LOCATION_LEFT), */
	COLORSPACE_BT601_FULL     = 0x221018c6, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601 */
	/* DEFINE_COLORSPACE(COLOR_TYPE_YCBCR,
                                 COLOR_RANGE_FULL,
                                 COLOR_PRIMARIES_BT601,
                                 TRANSFER_CHARACTERISTICS_BT601,
                                 MATRIX_COEFFICIENTS_BT601,
                                 CHROMA_LOCATION_LEFT), */
	COLORSPACE_BT709_LIMITED  = 0x21100421, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709 */
	/* DEFINE_COLORSPACE(COLOR_TYPE_YCBCR,
                                 COLOR_RANGE_LIMITED,
                                 COLOR_PRIMARIES_BT709,
                                 TRANSFER_CHARACTERISTICS_BT709,
                                 MATRIX_COEFFICIENTS_BT709,
                                 CHROMA_LOCATION_LEFT), */
	COLORSPACE_BT709_FULL     = 0x22100421, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709 */
	/* DEFINE_COLORSPACE(COLOR_TYPE_YCBCR,
                                 COLOR_RANGE_FULL,
                                 COLOR_PRIMARIES_BT709,
                                 TRANSFER_CHARACTERISTICS_BT709,
                                 MATRIX_COEFFICIENTS_BT709,
                                 CHROMA_LOCATION_LEFT), */
	COLORSPACE_BT2020_LIMITED = 0x21102609, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020 */
	/* DEFINE_COLORSPACE(COLOR_TYPE_YCBCR,
                                 COLOR_RANGE_LIMITED,
                                 COLOR_PRIMARIES_BT2020,
                                 TRANSFER_CHARACTERISTICS_PQ,
                                 MATRIX_COEFFICIENTS_BT2020_NCL,
                                 CHROMA_LOCATION_LEFT), */
	COLORSPACE_BT2020_FULL    = 0x22102609, /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020 */
	/* DEFINE_COLORSPACE(COLOR_TYPE_YCBCR,
                                 COLOR_RANGE_FULL,
                                 COLOR_PRIMARIES_BT2020,
                                 TRANSFER_CHARACTERISTICS_PQ,
                                 MATRIX_COEFFICIENTS_BT2020_NCL,
                                 CHROMA_LOCATION_LEFT), */
	COLORSPACE_RGB_DEFAULT    = COLORSPACE_SRGB, /**< The default colorspace for RGB surfaces if no colorspace is specified */
	COLORSPACE_YUV_DEFAULT    = COLORSPACE_JPEG, /**< The default colorspace for YUV surfaces if no colorspace is specified */
}


// A structure that represents a color as RGBA components.
//
// The bits of this structure can be directly reinterpreted as an
// integer-packed color which uses the PIXELFORMAT_RGBA32 format
// (PIXELFORMAT_ABGR8888 on little-endian systems and
// PIXELFORMAT_RGBA8888 on big-endian systems).
//
// \since This struct is available since SDL 3.0.0.

Color :: struct {
	r, g, b, a: c.uint8_t,
}


// The bits of this structure can be directly reinterpreted as a float-packed
// color which uses the PIXELFORMAT_RGBA128_FLOAT format
//
// \since This struct is available since SDL 3.0.0.

FColor :: struct {
	r, g, b, a: c.float,
}


// A set of indexed colors representing a palette.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa SetPaletteColors

Palette :: struct {
	ncolors:  c.int, /**< number of elements in `colors`. */
	colors:   [^]Color, /**< an array of colors, `ncolors` long. */
	version:  c.uint32_t, /**< internal use only, do not touch. */
	refcount: c.int, /**< internal use only, do not touch. */
}


// Details about the format of a pixel.
//
// \since This struct is available since SDL 3.0.0.

PixelFormatDetails :: struct {
	format:          PixelFormat,
	bits_per_pixel:  c.uint8_t,
	bytes_per_pixel: c.uint8_t,
	padding:         [2]c.uint8_t,
	Rmask:           c.uint32_t,
	Gmask:           c.uint32_t,
	Bmask:           c.uint32_t,
	Amask:           c.uint32_t,
	Rbits:           c.uint8_t,
	Gbits:           c.uint8_t,
	Bbits:           c.uint8_t,
	Abits:           c.uint8_t,
	Rshift:          c.uint8_t,
	Gshift:          c.uint8_t,
	Bshift:          c.uint8_t,
	Ashift:          c.uint8_t,
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get the human readable name of a pixel format.
	//
	// \param format the pixel format to query.
	// \returns the human readable name of the specified pixel format or
	//          "PIXELFORMAT_UNKNOWN" if the format isn't recognized.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetPixelFormatName :: proc(format: PixelFormat) -> cstring ---


	// Convert one of the enumerated pixel formats to a bpp value and RGBA masks.
	//
	// \param format one of the PixelFormat values.
	// \param bpp a bits per pixel value; usually 15, 16, or 32.
	// \param Rmask a pointer filled in with the red mask for the format.
	// \param Gmask a pointer filled in with the green mask for the format.
	// \param Bmask a pointer filled in with the blue mask for the format.
	// \param Amask a pointer filled in with the alpha mask for the format.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPixelFormatForMasks

	GetMasksForPixelFormat :: proc(format: PixelFormat, bpp: ^c.int, Rmask, Gmask, Bmask, Amask: ^c.uint32_t) -> c.bool ---


	// Convert a bpp value and RGBA masks to an enumerated pixel format.
	//
	// This will return `PIXELFORMAT_UNKNOWN` if the conversion wasn't
	// possible.
	//
	// \param bpp a bits per pixel value; usually 15, 16, or 32.
	// \param Rmask the red mask for the format.
	// \param Gmask the green mask for the format.
	// \param Bmask the blue mask for the format.
	// \param Amask the alpha mask for the format.
	// \returns the PixelFormat value corresponding to the format masks, or
	//          PIXELFORMAT_UNKNOWN if there isn't a match.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetMasksForPixelFormat

	GetPixelFormatForMasks :: proc(_: int) -> PixelFormat ---


	// Create an PixelFormatDetails structure corresponding to a pixel format.
	//
	// Returned structure may come from a shared global cache (i.e. not newly
	// allocated), and hence should not be modified, especially the palette. Weird
	// errors such as `Blit combination not supported` may occur.
	//
	// \param format one of the PixelFormat values.
	// \returns a pointer to a PixelFormatDetails structure or NULL on
	//          failure; call GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetPixelFormatDetails :: proc(format: PixelFormat) -> ^PixelFormatDetails ---


	// Create a palette structure with the specified number of color entries.
	//
	// The palette entries are initialized to white.
	//
	// \param ncolors represents the number of color entries in the color palette.
	// \returns a new Palette structure on success or NULL on failure (e.g. if
	//          there wasn't enough memory); call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa DestroyPalette
	// \sa SetPaletteColors
	// \sa SetSurfacePalette

	CreatePalette :: proc(ncolors: c.int) -> ^Palette ---


	// Set a range of colors in a palette.
	//
	// \param palette the Palette structure to modify.
	// \param colors an array of Color structures to copy into the palette.
	// \param firstcolor the index of the first palette entry to modify.
	// \param ncolors the number of entries to modify.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is safe to call this function from any thread, as long as
	//               the palette is not modified or destroyed in another thread.
	//
	// \since This function is available since SDL 3.0.0.

	SetPaletteColors :: proc(palette: ^Palette, colors: [^]Color, firstcolor: c.int, ncolors: c.int) -> c.bool ---


	// Free a palette created with CreatePalette().
	//
	// \param palette the Palette structure to be freed.
	//
	// \threadsafety It is safe to call this function from any thread, as long as
	//               the palette is not modified or destroyed in another thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreatePalette

	DestroyPalette :: proc(palette: ^Palette) ---


	// Map an RGB triple to an opaque pixel value for a given pixel format.
	//
	// This function maps the RGB color value to the specified pixel format and
	// returns the pixel value best approximating the given RGB color value for
	// the given pixel format.
	//
	// If the format has a palette (8-bit) the index of the closest matching color
	// in the palette will be returned.
	//
	// If the specified pixel format has an alpha component it will be returned as
	// all 1 bits (fully opaque).
	//
	// If the pixel format bpp (color depth) is less than 32-bpp then the unused
	// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
	// format the return value can be assigned to a Uint16, and similarly a Uint8
	// for an 8-bpp format).
	//
	// \param format a pointer to PixelFormatDetails describing the pixel
	//               format.
	// \param palette an optional palette for indexed formats, may be NULL.
	// \param r the red component of the pixel in the range 0-255.
	// \param g the green component of the pixel in the range 0-255.
	// \param b the blue component of the pixel in the range 0-255.
	// \returns a pixel value.
	//
	// \threadsafety It is safe to call this function from any thread, as long as
	//               the palette is not modified.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPixelFormatDetails
	// \sa GetRGB
	// \sa MapRGBA
	// \sa MapSurfaceRGB

	MapRGB :: proc(format: ^PixelFormatDetails, palette: ^Palette, r, g, b: c.uint8_t) -> c.uint32_t ---


	// Map an RGBA quadruple to a pixel value for a given pixel format.
	//
	// This function maps the RGBA color value to the specified pixel format and
	// returns the pixel value best approximating the given RGBA color value for
	// the given pixel format.
	//
	// If the specified pixel format has no alpha component the alpha value will
	// be ignored (as it will be in formats with a palette).
	//
	// If the format has a palette (8-bit) the index of the closest matching color
	// in the palette will be returned.
	//
	// If the pixel format bpp (color depth) is less than 32-bpp then the unused
	// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
	// format the return value can be assigned to a Uint16, and similarly a Uint8
	// for an 8-bpp format).
	//
	// \param format a pointer to PixelFormatDetails describing the pixel
	//               format.
	// \param palette an optional palette for indexed formats, may be NULL.
	// \param r the red component of the pixel in the range 0-255.
	// \param g the green component of the pixel in the range 0-255.
	// \param b the blue component of the pixel in the range 0-255.
	// \param a the alpha component of the pixel in the range 0-255.
	// \returns a pixel value.
	//
	// \threadsafety It is safe to call this function from any thread, as long as
	//               the palette is not modified.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPixelFormatDetails
	// \sa GetRGBA
	// \sa MapRGB
	// \sa MapSurfaceRGBA

	MapRGBA :: proc(format: ^PixelFormatDetails, palette: ^Palette, r, g, b, a: c.uint8_t) -> c.uint32_t ---


	// Get RGB values from a pixel in the specified format.
	//
	// This function uses the entire 8-bit [0..255] range when converting color
	// components from pixel formats with less than 8-bits per RGB component
	// (e.g., a completely white pixel in 16-bit RGB565 format would return [0xff,
	// 0xff, 0xff] not [0xf8, 0xfc, 0xf8]).
	//
	// \param pixel a pixel value.
	// \param format a pointer to PixelFormatDetails describing the pixel
	//               format.
	// \param palette an optional palette for indexed formats, may be NULL.
	// \param r a pointer filled in with the red component, may be NULL.
	// \param g a pointer filled in with the green component, may be NULL.
	// \param b a pointer filled in with the blue component, may be NULL.
	//
	// \threadsafety It is safe to call this function from any thread, as long as
	//               the palette is not modified.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPixelFormatDetails
	// \sa GetRGBA
	// \sa MapRGB
	// \sa MapRGBA

	GetRGB :: proc(pixel: c.uint32_t, format: ^PixelFormatDetails, palette: ^Palette, r, g, b: ^c.uint8_t) ---


	// Get RGBA values from a pixel in the specified format.
	//
	// This function uses the entire 8-bit [0..255] range when converting color
	// components from pixel formats with less than 8-bits per RGB component
	// (e.g., a completely white pixel in 16-bit RGB565 format would return [0xff,
	// 0xff, 0xff] not [0xf8, 0xfc, 0xf8]).
	//
	// If the surface has no alpha component, the alpha will be returned as 0xff
	// (100% opaque).
	//
	// \param pixel a pixel value.
	// \param format a pointer to PixelFormatDetails describing the pixel
	//               format.
	// \param palette an optional palette for indexed formats, may be NULL.
	// \param r a pointer filled in with the red component, may be NULL.
	// \param g a pointer filled in with the green component, may be NULL.
	// \param b a pointer filled in with the blue component, may be NULL.
	// \param a a pointer filled in with the alpha component, may be NULL.
	//
	// \threadsafety It is safe to call this function from any thread, as long as
	//               the palette is not modified.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetPixelFormatDetails
	// \sa GetRGB
	// \sa MapRGB
	// \sa MapRGBA

	GetRGBA :: proc(pixel: c.uint32_t, format: ^PixelFormatDetails, palette: ^Palette, r, g, b, a: ^c.uint8_t) ---
}
