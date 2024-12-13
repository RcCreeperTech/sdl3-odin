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


// # CategoryRender
//
// Header file for SDL 2D rendering functions.
//
// This API supports the following features:
//
// - single pixel points
// - single pixel lines
// - filled rectangles
// - texture images
// - 2D polygons
//
// The primitives may be drawn in opaque, blended, or additive modes.
//
// The texture images may be drawn in opaque, blended, or additive modes. They
// can have an additional color tint or alpha modulation applied to them, and
// may also be stretched with linear interpolation.
//
// This API is designed to accelerate simple 2D operations. You may want more
// functionality such as polygons and particle effects and in that case you
// should use SDL's OpenGL/Direct3D support, the SDL3 GPU API, or one of the
// many good 3D engines.
//
// These functions must be called from the main thread. See this bug for
// details: https://github.com/libsdl-org/SDL/issues/986


// The name of the software renderer.
//
// \since This macro is available since SDL 3.0.0.

SOFTWARE_RENDERER :: "software"


// Vertex structure.
//
// \since This struct is available since SDL 3.0.0.

Vertex :: struct {
	position:  FPoint, /**< Vertex position, in Renderer coordinates  */
	color:     FColor, /**< Vertex color */
	tex_coord: FPoint, /**< Normalized texture coordinates, if needed */
}


// The access pattern allowed for a texture.
//
// \since This enum is available since SDL 3.0.0.

TextureAccess :: enum c.int {
	STATIC, /**< Changes rarely, not lockable */
	STREAMING, /**< Changes frequently, lockable */
	TARGET, /**< Texture can be used as a render target */
}


// How the logical size is mapped to the output.
//
// \since This enum is available since SDL 3.0.0.

RendererLogicalPresentation :: enum c.int {
	DISABLED, /**< There is no logical size in effect */
	STRETCH, /**< The rendered content is stretched to the output resolution */
	LETTERBOX, /**< The rendered content is fit to the largest dimension and the other dimension is letterboxed with black bars */
	OVERSCAN, /**< The rendered content is fit to the smallest dimension and the other dimension extends beyond the output bounds */
	INTEGER_SCALE, /**< The rendered content is scaled up by integer multiples to fit the output resolution */
}


// A structure representing rendering state
//
// \since This struct is available since SDL 3.0.0.

Renderer :: distinct struct {}

/**
 * An efficient driver-specific representation of pixel data
 *
 * \since This struct is available since SDL 3.0.0.
 *
 * \sa SDL_CreateTexture
 * \sa SDL_CreateTextureFromSurface
 * \sa SDL_CreateTextureWithProperties
 * \sa SDL_DestroyTexture
 */
Texture :: struct {
	format:   PixelFormat, /**< The format of the texture, read-only */
	w:        c.int, /**< The width of the texture, read-only. */
	h:        c.int, /**< The height of the texture, read-only. */
	refcount: c.int, /**< Application reference count, used when freeing texture */
}

PROP_RENDERER_CREATE_NAME_STRING :: "SDL.renderer.create.name"
PROP_RENDERER_CREATE_WINDOW_POINTER :: "SDL.renderer.create.window"
PROP_RENDERER_CREATE_SURFACE_POINTER :: "SDL.renderer.create.surface"
PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER :: "SDL.renderer.create.output_colorspace"
PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER :: "SDL.renderer.create.present_vsync"
PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER :: "SDL.renderer.create.vulkan.instance"
PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER :: "SDL.renderer.create.vulkan.surface"
PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER :: "SDL.renderer.create.vulkan.physical_device"
PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER :: "SDL.renderer.create.vulkan.device"
PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.create.vulkan.graphics_queue_family_index"
PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.create.vulkan.present_queue_family_index"

PROP_RENDERER_NAME_STRING :: "SDL.renderer.name"
PROP_RENDERER_WINDOW_POINTER :: "SDL.renderer.window"
PROP_RENDERER_SURFACE_POINTER :: "SDL.renderer.surface"
PROP_RENDERER_VSYNC_NUMBER :: "SDL.renderer.vsync"
PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER :: "SDL.renderer.max_texture_size"
PROP_RENDERER_TEXTURE_FORMATS_POINTER :: "SDL.renderer.texture_formats"
PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER :: "SDL.renderer.output_colorspace"
PROP_RENDERER_HDR_ENABLED_BOOLEAN :: "SDL.renderer.HDR_enabled"
PROP_RENDERER_SDR_WHITE_POINT_FLOAT :: "SDL.renderer.SDR_white_point"
PROP_RENDERER_HDR_HEADROOM_FLOAT :: "SDL.renderer.HDR_headroom"
PROP_RENDERER_D3D9_DEVICE_POINTER :: "SDL.renderer.d3d9.device"
PROP_RENDERER_D3D11_DEVICE_POINTER :: "SDL.renderer.d3d11.device"
PROP_RENDERER_D3D11_SWAPCHAIN_POINTER :: "SDL.renderer.d3d11.swap_chain"
PROP_RENDERER_D3D12_DEVICE_POINTER :: "SDL.renderer.d3d12.device"
PROP_RENDERER_D3D12_SWAPCHAIN_POINTER :: "SDL.renderer.d3d12.swap_chain"
PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER :: "SDL.renderer.d3d12.command_queue"
PROP_RENDERER_VULKAN_INSTANCE_POINTER :: "SDL.renderer.vulkan.instance"
PROP_RENDERER_VULKAN_SURFACE_NUMBER :: "SDL.renderer.vulkan.surface"
PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER :: "SDL.renderer.vulkan.physical_device"
PROP_RENDERER_VULKAN_DEVICE_POINTER :: "SDL.renderer.vulkan.device"
PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.vulkan.graphics_queue_family_index"
PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.vulkan.present_queue_family_index"
PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER :: "SDL.renderer.vulkan.swapchain_image_count"

PROP_TEXTURE_CREATE_COLORSPACE_NUMBER :: "SDL.texture.create.colorspace"
PROP_TEXTURE_CREATE_FORMAT_NUMBER :: "SDL.texture.create.format"
PROP_TEXTURE_CREATE_ACCESS_NUMBER :: "SDL.texture.create.access"
PROP_TEXTURE_CREATE_WIDTH_NUMBER :: "SDL.texture.create.width"
PROP_TEXTURE_CREATE_HEIGHT_NUMBER :: "SDL.texture.create.height"
PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT :: "SDL.texture.create.SDR_white_point"
PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT :: "SDL.texture.create.HDR_headroom"
PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER :: "SDL.texture.create.d3d11.texture"
PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER :: "SDL.texture.create.d3d11.texture_u"
PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER :: "SDL.texture.create.d3d11.texture_v"
PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER :: "SDL.texture.create.d3d12.texture"
PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER :: "SDL.texture.create.d3d12.texture_u"
PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER :: "SDL.texture.create.d3d12.texture_v"
PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER :: "SDL.texture.create.metal.pixelbuffer"
PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER :: "SDL.texture.create.opengl.texture"
PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER :: "SDL.texture.create.opengl.texture_uv"
PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER :: "SDL.texture.create.opengl.texture_u"
PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER :: "SDL.texture.create.opengl.texture_v"
PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER :: "SDL.texture.create.opengles2.texture"
PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER :: "SDL.texture.create.opengles2.texture_uv"
PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER :: "SDL.texture.create.opengles2.texture_u"
PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER :: "SDL.texture.create.opengles2.texture_v"
PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER :: "SDL.texture.create.vulkan.texture"

PROP_TEXTURE_COLORSPACE_NUMBER :: "SDL.texture.colorspace"
PROP_TEXTURE_FORMAT_NUMBER :: "SDL.texture.format"
PROP_TEXTURE_ACCESS_NUMBER :: "SDL.texture.access"
PROP_TEXTURE_WIDTH_NUMBER :: "SDL.texture.width"
PROP_TEXTURE_HEIGHT_NUMBER :: "SDL.texture.height"
PROP_TEXTURE_SDR_WHITE_POINT_FLOAT :: "SDL.texture.SDR_white_point"
PROP_TEXTURE_HDR_HEADROOM_FLOAT :: "SDL.texture.HDR_headroom"
PROP_TEXTURE_D3D11_TEXTURE_POINTER :: "SDL.texture.d3d11.texture"
PROP_TEXTURE_D3D11_TEXTURE_U_POINTER :: "SDL.texture.d3d11.texture_u"
PROP_TEXTURE_D3D11_TEXTURE_V_POINTER :: "SDL.texture.d3d11.texture_v"
PROP_TEXTURE_D3D12_TEXTURE_POINTER :: "SDL.texture.d3d12.texture"
PROP_TEXTURE_D3D12_TEXTURE_U_POINTER :: "SDL.texture.d3d12.texture_u"
PROP_TEXTURE_D3D12_TEXTURE_V_POINTER :: "SDL.texture.d3d12.texture_v"
PROP_TEXTURE_OPENGL_TEXTURE_NUMBER :: "SDL.texture.opengl.texture"
PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER :: "SDL.texture.opengl.texture_uv"
PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER :: "SDL.texture.opengl.texture_u"
PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER :: "SDL.texture.opengl.texture_v"
PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER :: "SDL.texture.opengl.target"
PROP_TEXTURE_OPENGL_TEX_W_FLOAT :: "SDL.texture.opengl.tex_w"
PROP_TEXTURE_OPENGL_TEX_H_FLOAT :: "SDL.texture.opengl.tex_h"
PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER :: "SDL.texture.opengles2.texture"
PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER :: "SDL.texture.opengles2.texture_uv"
PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER :: "SDL.texture.opengles2.texture_u"
PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER :: "SDL.texture.opengles2.texture_v"
PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER :: "SDL.texture.opengles2.target"
PROP_TEXTURE_VULKAN_TEXTURE_NUMBER :: "SDL.texture.vulkan.texture"

RENDERER_VSYNC_DISABLED :: 0
RENDERER_VSYNC_ADAPTIVE :: -1


/* Function prototypes */

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get the number of 2D rendering drivers available for the current display.
	//
	// A render driver is a set of code that handles rendering and texture
	// management on a particular display. Normally there is only one, but some
	// drivers may have several available with different capabilities.
	//
	// There may be none if SDL was compiled without render support.
	//
	// \returns the number of built in render drivers.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateRenderer
	// \sa GetRenderDriver

	GetNumRenderDrivers :: proc() -> c.int ---


	// Use this function to get the name of a built in 2D rendering driver.
	//
	// The list of rendering drivers is given in the order that they are normally
	// initialized by default; the drivers that seem more reasonable to choose
	// first (as far as the SDL developers believe) are earlier in the list.
	//
	// The names of drivers are all simple, low-ASCII identifiers, like "opengl",
	// "direct3d12" or "metal". These never have Unicode characters, and are not
	// meant to be proper names.
	//
	// \param index the index of the rendering driver; the value ranges from 0 to
	//              GetNumRenderDrivers() - 1.
	// \returns the name of the rendering driver at the requested index, or NULL
	//          if an invalid index was specified.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetNumRenderDrivers

	GetRenderDriver :: proc(index: c.int) -> cstring ---


	// Create a window and default renderer.
	//
	// \param title the title of the window, in UTF-8 encoding.
	// \param width the width of the window.
	// \param height the height of the window.
	// \param window_flags the flags used to create the window (see
	//                     CreateWindow()).
	// \param window a pointer filled with the window, or NULL on error.
	// \param renderer a pointer filled with the renderer, or NULL on error.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateRenderer
	// \sa CreateWindow

	CreateWindowAndRenderer :: proc(title: cstring, width, height: c.int, window_flags: WindowFlags, window: ^^Window, renderer: ^^Renderer) -> c.bool ---


	// Create a 2D rendering context for a window.
	//
	// If you want a specific renderer, you can specify its name here. A list of
	// available renderers can be obtained by calling GetRenderDriver multiple
	// times, with indices from 0 to GetNumRenderDrivers()-1. If you don't
	// need a specific renderer, specify NULL and SDL will attempt to choose the
	// best option for you, based on what is available on the user's system.
	//
	// By default the rendering size matches the window size in pixels, but you
	// can call SetRenderLogicalPresentation() to change the content size and
	// scaling options.
	//
	// \param window the window where rendering is displayed.
	// \param name the name of the rendering driver to initialize, or NULL to
	//             initialize the first one supporting the requested flags.
	// \returns a valid rendering context or NULL if there was an error; call
	//          GetError() for more information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateRendererWithProperties
	// \sa CreateSoftwareRenderer
	// \sa DestroyRenderer
	// \sa GetNumRenderDrivers
	// \sa GetRenderDriver
	// \sa GetRendererName

	CreateRenderer :: proc(window: ^Window, name: cstring) -> ^Renderer ---


	// Create a 2D rendering context for a window, with the specified properties.
	//
	// These are the supported properties:
	//
	// - `PROP_RENDERER_CREATE_NAME_STRING`: the name of the rendering driver
	//   to use, if a specific one is desired
	// - `PROP_RENDERER_CREATE_WINDOW_POINTER`: the window where rendering is
	//   displayed, required if this isn't a software renderer using a surface
	// - `PROP_RENDERER_CREATE_SURFACE_POINTER`: the surface where rendering
	//   is displayed, if you want a software renderer without a window
	// - `PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER`: an ColorSpace
	//   value describing the colorspace for output to the display, defaults to
	//   COLORSPACE_SRGB. The direct3d11, direct3d12, and metal renderers
	//   support COLORSPACE_SRGB_LINEAR, which is a linear color space and
	//   supports HDR output. If you select COLORSPACE_SRGB_LINEAR, drawing
	//   still uses the sRGB colorspace, but values can go beyond 1.0 and float
	//   (linear) format textures can be used for HDR content.
	// - `PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER`: non-zero if you want
	//   present synchronized with the refresh rate. This property can take any
	//   value that is supported by SetRenderVSync() for the renderer.
	//
	// With the vulkan renderer:
	//
	// - `PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER`: the VkInstance to use
	//   with the renderer, optional.
	// - `PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER`: the VkSurfaceKHR to use
	//   with the renderer, optional.
	// - `PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER`: the
	//   VkPhysicalDevice to use with the renderer, optional.
	// - `PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER`: the VkDevice to use
	//   with the renderer, optional.
	// - `PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER`: the
	//   queue family index used for rendering.
	// - `PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER`: the
	//   queue family index used for presentation.
	//
	// \param props the properties to use.
	// \returns a valid rendering context or NULL if there was an error; call
	//          GetError() for more information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProperties
	// \sa CreateRenderer
	// \sa CreateSoftwareRenderer
	// \sa DestroyRenderer
	// \sa GetRendererName

	CreateRendererWithProperties :: proc(props: PropertiesID) -> ^Renderer ---


	// Create a 2D software rendering context for a surface.
	//
	// Two other API which can be used to create Renderer:
	// CreateRenderer() and CreateWindowAndRenderer(). These can _also_
	// create a software renderer, but they are intended to be used with an
	// Window as the final destination and not an Surface.
	//
	// \param surface the Surface structure representing the surface where
	//                rendering is done.
	// \returns a valid rendering context or NULL if there was an error; call
	//          GetError() for more information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa DestroyRenderer

	CreateSoftwareRenderer :: proc(surface: ^Surface) -> ^Renderer ---


	// Get the renderer associated with a window.
	//
	// \param window the window to query.
	// \returns the rendering context on success or NULL on failure; call
	//          GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetRenderer :: proc(window: ^Window) -> ^Renderer ---


	// Get the window associated with a renderer.
	//
	// \param renderer the renderer to query.
	// \returns the window on success or NULL on failure; call GetError() for
	//          more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetRenderWindow :: proc(renderer: ^Renderer) -> ^Window ---


	// Get the name of a renderer.
	//
	// \param renderer the rendering context.
	// \returns the name of the selected renderer, or NULL on failure; call
	//          GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateRenderer
	// \sa CreateRendererWithProperties

	GetRendererName :: proc(renderer: ^Renderer) -> cstring ---


	// Get the properties associated with a renderer.
	//
	// The following read-only properties are provided by SDL:
	//
	// - `PROP_RENDERER_NAME_STRING`: the name of the rendering driver
	// - `PROP_RENDERER_WINDOW_POINTER`: the window where rendering is
	//   displayed, if any
	// - `PROP_RENDERER_SURFACE_POINTER`: the surface where rendering is
	//   displayed, if this is a software renderer without a window
	// - `PROP_RENDERER_VSYNC_NUMBER`: the current vsync setting
	// - `PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER`: the maximum texture width
	//   and height
	// - `PROP_RENDERER_TEXTURE_FORMATS_POINTER`: a (const PixelFormat *)
	//   array of pixel formats, terminated with PIXELFORMAT_UNKNOWN,
	//   representing the available texture formats for this renderer.
	// - `PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER`: an ColorSpace value
	//   describing the colorspace for output to the display, defaults to
	//   COLORSPACE_SRGB.
	// - `PROP_RENDERER_HDR_ENABLED_BOOLEAN`: true if the output colorspace is
	//   COLORSPACE_SRGB_LINEAR and the renderer is showing on a display with
	//   HDR enabled. This property can change dynamically when
	//   EVENT_DISPLAY_HDR_STATE_CHANGED is sent.
	// - `PROP_RENDERER_SDR_WHITE_POINT_FLOAT`: the value of SDR white in the
	//   COLORSPACE_SRGB_LINEAR colorspace. When HDR is enabled, this value is
	//   automatically multiplied into the color scale. This property can change
	//   dynamically when EVENT_DISPLAY_HDR_STATE_CHANGED is sent.
	// - `PROP_RENDERER_HDR_HEADROOM_FLOAT`: the additional high dynamic range
	//   that can be displayed, in terms of the SDR white point. When HDR is not
	//   enabled, this will be 1.0. This property can change dynamically when
	//   EVENT_DISPLAY_HDR_STATE_CHANGED is sent.
	//
	// With the direct3d renderer:
	//
	// - `PROP_RENDERER_D3D9_DEVICE_POINTER`: the IDirect3DDevice9 associated
	//   with the renderer
	//
	// With the direct3d11 renderer:
	//
	// - `PROP_RENDERER_D3D11_DEVICE_POINTER`: the ID3D11Device associated
	//   with the renderer
	// - `PROP_RENDERER_D3D11_SWAPCHAIN_POINTER`: the IDXGISwapChain1
	//   associated with the renderer. This may change when the window is resized.
	//
	// With the direct3d12 renderer:
	//
	// - `PROP_RENDERER_D3D12_DEVICE_POINTER`: the ID3D12Device associated
	//   with the renderer
	// - `PROP_RENDERER_D3D12_SWAPCHAIN_POINTER`: the IDXGISwapChain4
	//   associated with the renderer.
	// - `PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER`: the ID3D12CommandQueue
	//   associated with the renderer
	//
	// With the vulkan renderer:
	//
	// - `PROP_RENDERER_VULKAN_INSTANCE_POINTER`: the VkInstance associated
	//   with the renderer
	// - `PROP_RENDERER_VULKAN_SURFACE_NUMBER`: the VkSurfaceKHR associated
	//   with the renderer
	// - `PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER`: the VkPhysicalDevice
	//   associated with the renderer
	// - `PROP_RENDERER_VULKAN_DEVICE_POINTER`: the VkDevice associated with
	//   the renderer
	// - `PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER`: the queue
	//   family index used for rendering
	// - `PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER`: the queue
	//   family index used for presentation
	// - `PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER`: the number of
	//   swapchain images, or potential frames in flight, used by the Vulkan
	//   renderer
	//
	// \param renderer the rendering context.
	// \returns a valid property ID on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetRendererProperties :: proc(renderer: ^Renderer) -> PropertiesID ---


	// Get the output size in pixels of a rendering context.
	//
	// This returns the true output size in pixels, ignoring any render targets or
	// logical size and presentation.
	//
	// \param renderer the rendering context.
	// \param w a pointer filled in with the width in pixels.
	// \param h a pointer filled in with the height in pixels.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetCurrentRenderOutputSize

	GetRenderOutputSize :: proc(renderer: ^Renderer, w, h: ^c.int) -> c.bool ---


	// Get the current output size in pixels of a rendering context.
	//
	// If a rendering target is active, this will return the size of the rendering
	// target in pixels, otherwise if a logical size is set, it will return the
	// logical size, otherwise it will return the value of
	// GetRenderOutputSize().
	//
	// \param renderer the rendering context.
	// \param w a pointer filled in with the current width.
	// \param h a pointer filled in with the current height.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderOutputSize

	GetCurrentRenderOutputSize :: proc(renderer: ^Renderer, w, h: ^c.int) -> c.bool ---


	// Create a texture for a rendering context.
	//
	// The contents of a texture when first created are not defined.
	//
	// \param renderer the rendering context.
	// \param format one of the enumerated values in PixelFormat.
	// \param access one of the enumerated values in TextureAccess.
	// \param w the width of the texture in pixels.
	// \param h the height of the texture in pixels.
	// \returns a pointer to the created texture or NULL if no rendering context
	//          was active, the format was unsupported, or the width or height
	//          were out of range; call GetError() for more information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateTextureFromSurface
	// \sa CreateTextureWithProperties
	// \sa DestroyTexture
	// \sa GetTextureSize
	// \sa UpdateTexture

	CreateTexture :: proc(renderer: ^Renderer, format: PixelFormat, access: TextureAccess, w, h: c.int) -> ^Texture ---


	// Create a texture from an existing surface.
	//
	// The surface is not modified or freed by this function.
	//
	// The TextureAccess hint for the created texture is
	// `TEXTUREACCESS_STATIC`.
	//
	// The pixel format of the created texture may be different from the pixel
	// format of the surface, and can be queried using the
	// PROP_TEXTURE_FORMAT_NUMBER property.
	//
	// \param renderer the rendering context.
	// \param surface the Surface structure containing pixel data used to fill
	//                the texture.
	// \returns the created texture or NULL on failure; call GetError() for
	//          more information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateTexture
	// \sa CreateTextureWithProperties
	// \sa DestroyTexture

	CreateTextureFromSurface :: proc(renderer: ^Renderer, surface: ^Surface) -> ^Texture ---


	// Create a texture for a rendering context with the specified properties.
	//
	// These are the supported properties:
	//
	// - `PROP_TEXTURE_CREATE_COLORSPACE_NUMBER`: an ColorSpace value
	//   describing the texture colorspace, defaults to COLORSPACE_SRGB_LINEAR
	//   for floating point textures, COLORSPACE_HDR10 for 10-bit textures,
	//   COLORSPACE_SRGB for other RGB textures and COLORSPACE_JPEG for
	//   YUV textures.
	// - `PROP_TEXTURE_CREATE_FORMAT_NUMBER`: one of the enumerated values in
	//   PixelFormat, defaults to the best RGBA format for the renderer
	// - `PROP_TEXTURE_CREATE_ACCESS_NUMBER`: one of the enumerated values in
	//   TextureAccess, defaults to TEXTUREACCESS_STATIC
	// - `PROP_TEXTURE_CREATE_WIDTH_NUMBER`: the width of the texture in
	//   pixels, required
	// - `PROP_TEXTURE_CREATE_HEIGHT_NUMBER`: the height of the texture in
	//   pixels, required
	// - `PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT`: for HDR10 and floating
	//   point textures, this defines the value of 100% diffuse white, with higher
	//   values being displayed in the High Dynamic Range headroom. This defaults
	//   to 100 for HDR10 textures and 1.0 for floating point textures.
	// - `PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT`: for HDR10 and floating
	//   point textures, this defines the maximum dynamic range used by the
	//   content, in terms of the SDR white point. This would be equivalent to
	//   maxCLL / PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT for HDR10 content.
	//   If this is defined, any values outside the range supported by the display
	//   will be scaled into the available HDR headroom, otherwise they are
	//   clipped.
	//
	// With the direct3d11 renderer:
	//
	// - `PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER`: the ID3D11Texture2D
	//   associated with the texture, if you want to wrap an existing texture.
	// - `PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER`: the ID3D11Texture2D
	//   associated with the U plane of a YUV texture, if you want to wrap an
	//   existing texture.
	// - `PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER`: the ID3D11Texture2D
	//   associated with the V plane of a YUV texture, if you want to wrap an
	//   existing texture.
	//
	// With the direct3d12 renderer:
	//
	// - `PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER`: the ID3D12Resource
	//   associated with the texture, if you want to wrap an existing texture.
	// - `PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER`: the ID3D12Resource
	//   associated with the U plane of a YUV texture, if you want to wrap an
	//   existing texture.
	// - `PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER`: the ID3D12Resource
	//   associated with the V plane of a YUV texture, if you want to wrap an
	//   existing texture.
	//
	// With the metal renderer:
	//
	// - `PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER`: the CVPixelBufferRef
	//   associated with the texture, if you want to create a texture from an
	//   existing pixel buffer.
	//
	// With the opengl renderer:
	//
	// - `PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER`: the GLuint texture
	//   associated with the texture, if you want to wrap an existing texture.
	// - `PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER`: the GLuint texture
	//   associated with the UV plane of an NV12 texture, if you want to wrap an
	//   existing texture.
	// - `PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER`: the GLuint texture
	//   associated with the U plane of a YUV texture, if you want to wrap an
	//   existing texture.
	// - `PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER`: the GLuint texture
	//   associated with the V plane of a YUV texture, if you want to wrap an
	//   existing texture.
	//
	// With the opengles2 renderer:
	//
	// - `PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER`: the GLuint texture
	//   associated with the texture, if you want to wrap an existing texture.
	// - `PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER`: the GLuint texture
	//   associated with the texture, if you want to wrap an existing texture.
	// - `PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER`: the GLuint texture
	//   associated with the UV plane of an NV12 texture, if you want to wrap an
	//   existing texture.
	// - `PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER`: the GLuint texture
	//   associated with the U plane of a YUV texture, if you want to wrap an
	//   existing texture.
	// - `PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER`: the GLuint texture
	//   associated with the V plane of a YUV texture, if you want to wrap an
	//   existing texture.
	//
	// With the vulkan renderer:
	//
	// - `PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER`: the VkImage with layout
	//   VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL associated with the texture, if
	//   you want to wrap an existing texture.
	//
	// \param renderer the rendering context.
	// \param props the properties to use.
	// \returns a pointer to the created texture or NULL if no rendering context
	//          was active, the format was unsupported, or the width or height
	//          were out of range; call GetError() for more information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProperties
	// \sa CreateTexture
	// \sa CreateTextureFromSurface
	// \sa DestroyTexture
	// \sa GetTextureSize
	// \sa UpdateTexture

	CreateTextureWithProperties :: proc(renderer: ^Renderer, props: PropertiesID) -> ^Texture ---


	// Get the properties associated with a texture.
	//
	// The following read-only properties are provided by SDL:
	//
	// - `PROP_TEXTURE_COLORSPACE_NUMBER`: an ColorSpace value describing
	//   the texture colorspace.
	// - `PROP_TEXTURE_FORMAT_NUMBER`: one of the enumerated values in
	//   PixelFormat.
	// - `PROP_TEXTURE_ACCESS_NUMBER`: one of the enumerated values in
	//   TextureAccess.
	// - `PROP_TEXTURE_WIDTH_NUMBER`: the width of the texture in pixels.
	// - `PROP_TEXTURE_HEIGHT_NUMBER`: the height of the texture in pixels.
	// - `PROP_TEXTURE_SDR_WHITE_POINT_FLOAT`: for HDR10 and floating point
	//   textures, this defines the value of 100% diffuse white, with higher
	//   values being displayed in the High Dynamic Range headroom. This defaults
	//   to 100 for HDR10 textures and 1.0 for other textures.
	// - `PROP_TEXTURE_HDR_HEADROOM_FLOAT`: for HDR10 and floating point
	//   textures, this defines the maximum dynamic range used by the content, in
	//   terms of the SDR white point. If this is defined, any values outside the
	//   range supported by the display will be scaled into the available HDR
	//   headroom, otherwise they are clipped. This defaults to 1.0 for SDR
	//   textures, 4.0 for HDR10 textures, and no default for floating point
	//   textures.
	//
	// With the direct3d11 renderer:
	//
	// - `PROP_TEXTURE_D3D11_TEXTURE_POINTER`: the ID3D11Texture2D associated
	//   with the texture
	// - `PROP_TEXTURE_D3D11_TEXTURE_U_POINTER`: the ID3D11Texture2D
	//   associated with the U plane of a YUV texture
	// - `PROP_TEXTURE_D3D11_TEXTURE_V_POINTER`: the ID3D11Texture2D
	//   associated with the V plane of a YUV texture
	//
	// With the direct3d12 renderer:
	//
	// - `PROP_TEXTURE_D3D12_TEXTURE_POINTER`: the ID3D12Resource associated
	//   with the texture
	// - `PROP_TEXTURE_D3D12_TEXTURE_U_POINTER`: the ID3D12Resource associated
	//   with the U plane of a YUV texture
	// - `PROP_TEXTURE_D3D12_TEXTURE_V_POINTER`: the ID3D12Resource associated
	//   with the V plane of a YUV texture
	//
	// With the vulkan renderer:
	//
	// - `PROP_TEXTURE_VULKAN_TEXTURE_POINTER`: the VkImage associated with
	//   the texture
	// - `PROP_TEXTURE_VULKAN_TEXTURE_U_POINTER`: the VkImage associated with
	//   the U plane of a YUV texture
	// - `PROP_TEXTURE_VULKAN_TEXTURE_V_POINTER`: the VkImage associated with
	//   the V plane of a YUV texture
	// - `PROP_TEXTURE_VULKAN_TEXTURE_UV_POINTER`: the VkImage associated with
	//   the UV plane of a NV12/NV21 texture
	//
	// With the opengl renderer:
	//
	// - `PROP_TEXTURE_OPENGL_TEXTURE_NUMBER`: the GLuint texture associated
	//   with the texture
	// - `PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER`: the GLuint texture
	//   associated with the UV plane of an NV12 texture
	// - `PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER`: the GLuint texture associated
	//   with the U plane of a YUV texture
	// - `PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER`: the GLuint texture associated
	//   with the V plane of a YUV texture
	// - `PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER`: the GLenum for the
	//   texture target (`GL_TEXTURE_2D`, `GL_TEXTURE_RECTANGLE_ARB`, etc)
	// - `PROP_TEXTURE_OPENGL_TEX_W_FLOAT`: the texture coordinate width of
	//   the texture (0.0 - 1.0)
	// - `PROP_TEXTURE_OPENGL_TEX_H_FLOAT`: the texture coordinate height of
	//   the texture (0.0 - 1.0)
	//
	// With the opengles2 renderer:
	//
	// - `PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER`: the GLuint texture
	//   associated with the texture
	// - `PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER`: the GLuint texture
	//   associated with the UV plane of an NV12 texture
	// - `PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER`: the GLuint texture
	//   associated with the U plane of a YUV texture
	// - `PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER`: the GLuint texture
	//   associated with the V plane of a YUV texture
	// - `PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER`: the GLenum for the
	//   texture target (`GL_TEXTURE_2D`, `GL_TEXTURE_EXTERNAL_OES`, etc)
	//
	// With the vulkan renderer:
	//
	// - `PROP_TEXTURE_VULKAN_TEXTURE_NUMBER`: the VkImage associated with the
	//   texture
	//
	// \param texture the texture to query.
	// \returns a valid property ID on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetTextureProperties :: proc(texture: ^Texture) -> PropertiesID ---


	// Get the renderer that created an Texture.
	//
	// \param texture the texture to query.
	// \returns a pointer to the Renderer that created the texture, or NULL on
	//          failure; call GetError() for more information.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetRendererFromTexture :: proc(texture: ^Texture) -> ^Renderer ---


	// Get the size of a texture, as floating point values.
	//
	// \param texture the texture to query.
	// \param w a pointer filled in with the width of the texture in pixels. This
	//          argument can be NULL if you don't need this information.
	// \param h a pointer filled in with the height of the texture in pixels. This
	//          argument can be NULL if you don't need this information.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetTextureSize :: proc(texture: ^Texture, w, h: ^c.float) -> c.bool ---


	// Set an additional color value multiplied into render copy operations.
	//
	// When this texture is rendered, during the copy operation each source color
	// channel is modulated by the appropriate color value according to the
	// following formula:
	//
	// `srcC = srcC * (color / 255)`
	//
	// Color modulation is not always supported by the renderer; it will return
	// false if color modulation is not supported.
	//
	// \param texture the texture to update.
	// \param r the red color value multiplied into copy operations.
	// \param g the green color value multiplied into copy operations.
	// \param b the blue color value multiplied into copy operations.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureColorMod
	// \sa SetTextureAlphaMod
	// \sa SetTextureColorModFloat

	SetTextureColorMod :: proc(texture: ^Texture, r, g, b: c.uint8_t) -> c.bool ---


	// Set an additional color value multiplied into render copy operations.
	//
	// When this texture is rendered, during the copy operation each source color
	// channel is modulated by the appropriate color value according to the
	// following formula:
	//
	// `srcC = srcC * color`
	//
	// Color modulation is not always supported by the renderer; it will return
	// false if color modulation is not supported.
	//
	// \param texture the texture to update.
	// \param r the red color value multiplied into copy operations.
	// \param g the green color value multiplied into copy operations.
	// \param b the blue color value multiplied into copy operations.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureColorModFloat
	// \sa SetTextureAlphaModFloat
	// \sa SetTextureColorMod

	SetTextureColorModFloat :: proc(texture: ^Texture, r, g, b: c.float) -> c.bool ---


	// Get the additional color value multiplied into render copy operations.
	//
	// \param texture the texture to query.
	// \param r a pointer filled in with the current red color value.
	// \param g a pointer filled in with the current green color value.
	// \param b a pointer filled in with the current blue color value.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureAlphaMod
	// \sa GetTextureColorModFloat
	// \sa SetTextureColorMod

	GetTextureColorMod :: proc(texture: ^Texture, r, g, b: ^c.uint8_t) -> c.bool ---


	// Get the additional color value multiplied into render copy operations.
	//
	// \param texture the texture to query.
	// \param r a pointer filled in with the current red color value.
	// \param g a pointer filled in with the current green color value.
	// \param b a pointer filled in with the current blue color value.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureAlphaModFloat
	// \sa GetTextureColorMod
	// \sa SetTextureColorModFloat

	GetTextureColorModFloat :: proc(texture: ^Texture, r, g, b: ^c.float) -> c.bool ---


	// Set an additional alpha value multiplied into render copy operations.
	//
	// When this texture is rendered, during the copy operation the source alpha
	// value is modulated by this alpha value according to the following formula:
	//
	// `srcA = srcA * (alpha / 255)`
	//
	// Alpha modulation is not always supported by the renderer; it will return
	// false if alpha modulation is not supported.
	//
	// \param texture the texture to update.
	// \param alpha the source alpha value multiplied into copy operations.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureAlphaMod
	// \sa SetTextureAlphaModFloat
	// \sa SetTextureColorMod

	SetTextureAlphaMod :: proc(texture: ^Texture, alpha: c.uint8_t) -> c.bool ---


	// Set an additional alpha value multiplied into render copy operations.
	//
	// When this texture is rendered, during the copy operation the source alpha
	// value is modulated by this alpha value according to the following formula:
	//
	// `srcA = srcA * alpha`
	//
	// Alpha modulation is not always supported by the renderer; it will return
	// false if alpha modulation is not supported.
	//
	// \param texture the texture to update.
	// \param alpha the source alpha value multiplied into copy operations.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureAlphaModFloat
	// \sa SetTextureAlphaMod
	// \sa SetTextureColorModFloat

	SetTextureAlphaModFloat :: proc(texture: ^Texture, alpha: c.float) -> c.bool ---


	// Get the additional alpha value multiplied into render copy operations.
	//
	// \param texture the texture to query.
	// \param alpha a pointer filled in with the current alpha value.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureAlphaModFloat
	// \sa GetTextureColorMod
	// \sa SetTextureAlphaMod

	GetTextureAlphaMod :: proc(texture: ^Texture, alpha: ^c.uint8_t) -> c.bool ---


	// Get the additional alpha value multiplied into render copy operations.
	//
	// \param texture the texture to query.
	// \param alpha a pointer filled in with the current alpha value.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureAlphaMod
	// \sa GetTextureColorModFloat
	// \sa SetTextureAlphaModFloat

	GetTextureAlphaModFloat :: proc(texture: ^Texture, alpha: ^c.float) -> c.bool ---


	// Set the blend mode for a texture, used by RenderTexture().
	//
	// If the blend mode is not supported, the closest supported mode is chosen
	// and this function returns false.
	//
	// \param texture the texture to update.
	// \param blendMode the BlendMode to use for texture blending.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureBlendMode

	SetTextureBlendMode :: proc(texture: ^Texture, blendMode: BlendMode) -> c.bool ---


	// Get the blend mode used for texture copy operations.
	//
	// \param texture the texture to query.
	// \param blendMode a pointer filled in with the current BlendMode.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetTextureBlendMode

	GetTextureBlendMode :: proc(texture: ^Texture, blendMode: ^BlendMode) -> c.bool ---


	// Set the scale mode used for texture scale operations.
	//
	// The default texture scale mode is SCALEMODE_LINEAR.
	//
	// If the scale mode is not supported, the closest supported mode is chosen.
	//
	// \param texture the texture to update.
	// \param scaleMode the ScaleMode to use for texture scaling.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetTextureScaleMode

	SetTextureScaleMode :: proc(texture: ^Texture, scaleMode: ScaleMode) -> c.bool ---


	// Get the scale mode used for texture scale operations.
	//
	// \param texture the texture to query.
	// \param scaleMode a pointer filled in with the current scale mode.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetTextureScaleMode

	GetTextureScaleMode :: proc(texture: ^Texture, scaleMode: ^ScaleMode) -> c.bool ---


	// Update the given texture rectangle with new pixel data.
	//
	// The pixel data must be in the pixel format of the texture, which can be
	// queried using the PROP_TEXTURE_FORMAT_NUMBER property.
	//
	// This is a fairly slow function, intended for use with static textures that
	// do not change often.
	//
	// If the texture is intended to be updated often, it is preferred to create
	// the texture as streaming and use the locking functions referenced below.
	// While this function will work with streaming textures, for optimization
	// reasons you may not get the pixels back if you lock the texture afterward.
	//
	// \param texture the texture to update.
	// \param rect an Rect structure representing the area to update, or NULL
	//             to update the entire texture.
	// \param pixels the raw pixel data in the format of the texture.
	// \param pitch the number of bytes in a row of pixel data, including padding
	//              between lines.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LockTexture
	// \sa UnlockTexture
	// \sa UpdateNVTexture
	// \sa UpdateYUVTexture

	UpdateTexture :: proc(texture: ^Texture, rect: ^Rect, pixels: rawptr, pitch: c.int) -> c.bool ---


	// Update a rectangle within a planar YV12 or IYUV texture with new pixel
	// data.
	//
	// You can use UpdateTexture() as long as your pixel data is a contiguous
	// block of Y and U/V planes in the proper order, but this function is
	// available if your pixel data is not contiguous.
	//
	// \param texture the texture to update.
	// \param rect a pointer to the rectangle of pixels to update, or NULL to
	//             update the entire texture.
	// \param Yplane the raw pixel data for the Y plane.
	// \param Ypitch the number of bytes between rows of pixel data for the Y
	//               plane.
	// \param Uplane the raw pixel data for the U plane.
	// \param Upitch the number of bytes between rows of pixel data for the U
	//               plane.
	// \param Vplane the raw pixel data for the V plane.
	// \param Vpitch the number of bytes between rows of pixel data for the V
	//               plane.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa UpdateNVTexture
	// \sa UpdateTexture

	UpdateYUVTexture :: proc(texture: ^Texture, rect: ^Rect, Yplane: ^c.uint8_t, Ypitch: c.int, Uplane: ^c.uint8_t, Upitch: c.int, Vplane: ^c.uint8_t, Vpitch: c.int) -> c.bool ---


	// Update a rectangle within a planar NV12 or NV21 texture with new pixels.
	//
	// You can use UpdateTexture() as long as your pixel data is a contiguous
	// block of NV12/21 planes in the proper order, but this function is available
	// if your pixel data is not contiguous.
	//
	// \param texture the texture to update.
	// \param rect a pointer to the rectangle of pixels to update, or NULL to
	//             update the entire texture.
	// \param Yplane the raw pixel data for the Y plane.
	// \param Ypitch the number of bytes between rows of pixel data for the Y
	//               plane.
	// \param UVplane the raw pixel data for the UV plane.
	// \param UVpitch the number of bytes between rows of pixel data for the UV
	//                plane.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa UpdateTexture
	// \sa UpdateYUVTexture

	UpdateNVTexture :: proc(texture: ^Texture, rect: ^Rect, Yplane: ^c.uint8_t, Ypitch: c.int, UVplane: ^c.uint8_t, UVpitch: c.int) -> c.bool ---


	// Lock a portion of the texture for **write-only** pixel access.
	//
	// As an optimization, the pixels made available for editing don't necessarily
	// contain the old texture data. This is a write-only operation, and if you
	// need to keep a copy of the texture data you should do that at the
	// application level.
	//
	// You must use UnlockTexture() to unlock the pixels and apply any
	// changes.
	//
	// \param texture the texture to lock for access, which was created with
	//                `TEXTUREACCESS_STREAMING`.
	// \param rect an Rect structure representing the area to lock for access;
	//             NULL to lock the entire texture.
	// \param pixels this is filled in with a pointer to the locked pixels,
	//               appropriately offset by the locked area.
	// \param pitch this is filled in with the pitch of the locked pixels; the
	//              pitch is the length of one row in bytes.
	// \returns true on success or false if the texture is not valid or was not
	//          created with `TEXTUREACCESS_STREAMING`; call GetError()
	//          for more information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LockTextureToSurface
	// \sa UnlockTexture

	LockTexture :: proc(texture: ^Texture, rect: ^Rect, pixels: ^rawptr, pitch: ^c.int) -> c.bool ---


	// Lock a portion of the texture for **write-only** pixel access, and expose
	// it as a SDL surface.
	//
	// Besides providing an Surface instead of raw pixel data, this function
	// operates like LockTexture.
	//
	// As an optimization, the pixels made available for editing don't necessarily
	// contain the old texture data. This is a write-only operation, and if you
	// need to keep a copy of the texture data you should do that at the
	// application level.
	//
	// You must use UnlockTexture() to unlock the pixels and apply any
	// changes.
	//
	// The returned surface is freed internally after calling UnlockTexture()
	// or DestroyTexture(). The caller should not free it.
	//
	// \param texture the texture to lock for access, which must be created with
	//                `TEXTUREACCESS_STREAMING`.
	// \param rect a pointer to the rectangle to lock for access. If the rect is
	//             NULL, the entire texture will be locked.
	// \param surface this is filled in with an SDL surface representing the
	//                locked area.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LockTexture
	// \sa UnlockTexture

	LockTextureToSurface :: proc(texture: ^Texture, rect: ^Rect, surface: ^^Surface) -> c.bool ---


	// Unlock a texture, uploading the changes to video memory, if needed.
	//
	// **Warning**: Please note that LockTexture() is intended to be
	// write-only; it will not guarantee the previous contents of the texture will
	// be provided. You must fully initialize any area of a texture that you lock
	// before unlocking it, as the pixels might otherwise be uninitialized memory.
	//
	// Which is to say: locking and immediately unlocking a texture can result in
	// corrupted textures, depending on the renderer in use.
	//
	// \param texture a texture locked by LockTexture().
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa LockTexture

	UnlockTexture :: proc(texture: ^Texture) ---


	// Set a texture as the current rendering target.
	//
	// The default render target is the window for which the renderer was created.
	// To stop rendering to a texture and render to the window again, call this
	// function with a NULL `texture`.
	//
	// \param renderer the rendering context.
	// \param texture the targeted texture, which must be created with the
	//                `TEXTUREACCESS_TARGET` flag, or NULL to render to the
	//                window instead of a texture.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderTarget

	SetRenderTarget :: proc(renderer: ^Renderer, texture: ^Texture) -> c.bool ---


	// Get the current render target.
	//
	// The default render target is the window for which the renderer was created,
	// and is reported a NULL here.
	//
	// \param renderer the rendering context.
	// \returns the current render target or NULL for the default render target.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderTarget

	GetRenderTarget :: proc(renderer: ^Renderer) -> ^Texture ---


	// Set a device independent resolution and presentation mode for rendering.
	//
	// This function sets the width and height of the logical rendering output.
	// The renderer will act as if the window is always the requested dimensions,
	// scaling to the actual window resolution as necessary.
	//
	// This can be useful for games that expect a fixed size, but would like to
	// scale the output to whatever is available, regardless of how a user resizes
	// a window, or if the display is high DPI.
	//
	// You can disable logical coordinates by setting the mode to
	// LOGICAL_PRESENTATION_DISABLED, and in that case you get the full pixel
	// resolution of the output window; it is safe to toggle logical presentation
	// during the rendering of a frame: perhaps most of the rendering is done to
	// specific dimensions but to make fonts look sharp, the app turns off logical
	// presentation while drawing text.
	//
	// Letterboxing will only happen if logical presentation is enabled during
	// RenderPresent; be sure to reenable it first if you were using it.
	//
	// You can convert coordinates in an event into rendering coordinates using
	// ConvertEventToRenderCoordinates().
	//
	// \param renderer the rendering context.
	// \param w the width of the logical resolution.
	// \param h the height of the logical resolution.
	// \param mode the presentation mode used.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ConvertEventToRenderCoordinates
	// \sa GetRenderLogicalPresentation
	// \sa GetRenderLogicalPresentationRect

	SetRenderLogicalPresentation :: proc(renderer: ^Renderer, w, h: c.int, mode: RendererLogicalPresentation) -> c.bool ---


	// Get device independent resolution and presentation mode for rendering.
	//
	// This function gets the width and height of the logical rendering output, or
	// the output size in pixels if a logical resolution is not enabled.
	//
	// \param renderer the rendering context.
	// \param w an int to be filled with the width.
	// \param h an int to be filled with the height.
	// \param mode the presentation mode used.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderLogicalPresentation

	GetRenderLogicalPresentation :: proc(renderer: ^Renderer, w, h: ^c.int, mode: ^RendererLogicalPresentation) -> c.bool ---


	// Get the final presentation rectangle for rendering.
	//
	// This function returns the calculated rectangle used for logical
	// presentation, based on the presentation mode and output size. If logical
	// presentation is disabled, it will fill the rectangle with the output size,
	// in pixels.
	//
	// \param renderer the rendering context.
	// \param rect a pointer filled in with the final presentation rectangle, may
	//             be NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderLogicalPresentation

	GetRenderLogicalPresentationRect :: proc(renderer: ^Renderer, rect: ^FRect) -> c.bool ---


	// Get a point in render coordinates when given a point in window coordinates.
	//
	// This takes into account several states:
	//
	// - The window dimensions.
	// - The logical presentation settings (SetRenderLogicalPresentation)
	// - The scale (SetRenderScale)
	// - The viewport (SetRenderViewport)
	//
	// \param renderer the rendering context.
	// \param window_x the x coordinate in window coordinates.
	// \param window_y the y coordinate in window coordinates.
	// \param x a pointer filled with the x coordinate in render coordinates.
	// \param y a pointer filled with the y coordinate in render coordinates.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderLogicalPresentation
	// \sa SetRenderScale

	RenderCoordinatesFromWindow :: proc(renderer: ^Renderer, window_x, window_y: c.float, x, y: ^c.float) -> c.bool ---


	// Get a point in window coordinates when given a point in render coordinates.
	//
	// This takes into account several states:
	//
	// - The window dimensions.
	// - The logical presentation settings (SetRenderLogicalPresentation)
	// - The scale (SetRenderScale)
	// - The viewport (SetRenderViewport)
	//
	// \param renderer the rendering context.
	// \param x the x coordinate in render coordinates.
	// \param y the y coordinate in render coordinates.
	// \param window_x a pointer filled with the x coordinate in window
	//                 coordinates.
	// \param window_y a pointer filled with the y coordinate in window
	//                 coordinates.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderLogicalPresentation
	// \sa SetRenderScale
	// \sa SetRenderViewport

	RenderCoordinatesToWindow :: proc(renderer: ^Renderer, x, y: c.float, window_x, window_y: ^c.float) -> c.bool ---


	// Convert the coordinates in an event to render coordinates.
	//
	// This takes into account several states:
	//
	// - The window dimensions.
	// - The logical presentation settings (SetRenderLogicalPresentation)
	// - The scale (SetRenderScale)
	// - The viewport (SetRenderViewport)
	//
	// Touch coordinates are converted from normalized coordinates in the window
	// to non-normalized rendering coordinates.
	//
	// Once converted, the coordinates may be outside the rendering area.
	//
	// \param renderer the rendering context.
	// \param event the event to modify.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderCoordinatesFromWindow

	ConvertEventToRenderCoordinates :: proc(renderer: ^Renderer, event: ^Event) -> c.bool ---


	// Set the drawing area for rendering on the current target.
	//
	// Drawing will clip to this area (separately from any clipping done with
	// SetRenderClipRect), and the top left of the area will become coordinate
	// (0, 0) for future drawing commands.
	//
	// The area's width and height must be >= 0.
	//
	// \param renderer the rendering context.
	// \param rect the Rect structure representing the drawing area, or NULL
	//             to set the viewport to the entire target.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderViewport
	// \sa RenderViewportSet

	SetRenderViewport :: proc(renderer: ^Renderer, rect: ^Rect) -> c.bool ---


	// Get the drawing area for the current target.
	//
	// \param renderer the rendering context.
	// \param rect an Rect structure filled in with the current drawing area.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderViewportSet
	// \sa SetRenderViewport

	GetRenderViewport :: proc(renderer: ^Renderer, rect: ^Rect) -> c.bool ---


	// Return whether an explicit rectangle was set as the viewport.
	//
	// This is useful if you're saving and restoring the viewport and want to know
	// whether you should restore a specific rectangle or NULL. Note that the
	// viewport is always reset when changing rendering targets.
	//
	// \param renderer the rendering context.
	// \returns true if the viewport was set to a specific rectangle, or false if
	//          it was set to NULL (the entire target).
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderViewport
	// \sa SetRenderViewport

	RenderViewportSet :: proc(renderer: ^Renderer) -> c.bool ---


	// Get the safe area for rendering within the current viewport.
	//
	// Some devices have portions of the screen which are partially obscured or
	// not interactive, possibly due to on-screen controls, curved edges, camera
	// notches, TV overscan, etc. This function provides the area of the current
	// viewport which is safe to have interactible content. You should continue
	// rendering into the rest of the render target, but it should not contain
	// visually important or interactible content.
	//
	// \param renderer the rendering context.
	// \param rect a pointer filled in with the area that is safe for interactive
	//             content.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.

	GetRenderSafeArea :: proc(renderer: ^Renderer, rect: ^Rect) -> c.bool ---


	// Set the clip rectangle for rendering on the specified target.
	//
	// \param renderer the rendering context.
	// \param rect an Rect structure representing the clip area, relative to
	//             the viewport, or NULL to disable clipping.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderClipRect
	// \sa RenderClipEnabled

	SetRenderClipRect :: proc(renderer: ^Renderer, rect: ^Rect) -> c.bool ---


	// Get the clip rectangle for the current target.
	//
	// \param renderer the rendering context.
	// \param rect an Rect structure filled in with the current clipping area
	//             or an empty rectangle if clipping is disabled.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderClipEnabled
	// \sa SetRenderClipRect

	GetRenderClipRect :: proc(renderer: ^Renderer, rect: ^Rect) -> c.bool ---


	// Get whether clipping is enabled on the given renderer.
	//
	// \param renderer the rendering context.
	// \returns true if clipping is enabled or false if not; call GetError()
	//          for more information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderClipRect
	// \sa SetRenderClipRect

	RenderClipEnabled :: proc(renderer: ^Renderer) -> c.bool ---


	// Set the drawing scale for rendering on the current target.
	//
	// The drawing coordinates are scaled by the x/y scaling factors before they
	// are used by the renderer. This allows resolution independent drawing with a
	// single coordinate system.
	//
	// If this results in scaling or subpixel drawing by the rendering backend, it
	// will be handled using the appropriate quality hints. For best results use
	// integer scaling factors.
	//
	// \param renderer the rendering context.
	// \param scaleX the horizontal scaling factor.
	// \param scaleY the vertical scaling factor.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderScale

	SetRenderScale :: proc(renderer: ^Renderer, scaleX, scaleY: c.float) -> c.bool ---


	// Get the drawing scale for the current target.
	//
	// \param renderer the rendering context.
	// \param scaleX a pointer filled in with the horizontal scaling factor.
	// \param scaleY a pointer filled in with the vertical scaling factor.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderScale

	GetRenderScale :: proc(renderer: ^Renderer, scaleX, scaleY: ^c.float) -> c.bool ---


	// Set the color used for drawing operations.
	//
	// Set the color for drawing or filling rectangles, lines, and points, and for
	// RenderClear().
	//
	// \param renderer the rendering context.
	// \param r the red value used to draw on the rendering target.
	// \param g the green value used to draw on the rendering target.
	// \param b the blue value used to draw on the rendering target.
	// \param a the alpha value used to draw on the rendering target; usually
	//          `ALPHA_OPAQUE` (255). Use SetRenderDrawBlendMode to
	//          specify how the alpha channel is used.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderDrawColor
	// \sa SetRenderDrawColorFloat

	SetRenderDrawColor :: proc(renderer: ^Renderer, r, g, b, a: c.uint8_t) -> c.bool ---


	// Set the color used for drawing operations (Rect, Line and Clear).
	//
	// Set the color for drawing or filling rectangles, lines, and points, and for
	// RenderClear().
	//
	// \param renderer the rendering context.
	// \param r the red value used to draw on the rendering target.
	// \param g the green value used to draw on the rendering target.
	// \param b the blue value used to draw on the rendering target.
	// \param a the alpha value used to draw on the rendering target. Use
	//          SetRenderDrawBlendMode to specify how the alpha channel is
	//          used.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderDrawColorFloat
	// \sa SetRenderDrawColor

	SetRenderDrawColorFloat :: proc(renderer: ^Renderer, r, g, b, a: c.float) -> c.bool ---


	// Get the color used for drawing operations (Rect, Line and Clear).
	//
	// \param renderer the rendering context.
	// \param r a pointer filled in with the red value used to draw on the
	//          rendering target.
	// \param g a pointer filled in with the green value used to draw on the
	//          rendering target.
	// \param b a pointer filled in with the blue value used to draw on the
	//          rendering target.
	// \param a a pointer filled in with the alpha value used to draw on the
	//          rendering target; usually `ALPHA_OPAQUE` (255).
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderDrawColorFloat
	// \sa SetRenderDrawColor

	GetRenderDrawColor :: proc(renderer: ^Renderer, r, g, b, a: ^c.uint8_t) -> c.bool ---


	// Get the color used for drawing operations (Rect, Line and Clear).
	//
	// \param renderer the rendering context.
	// \param r a pointer filled in with the red value used to draw on the
	//          rendering target.
	// \param g a pointer filled in with the green value used to draw on the
	//          rendering target.
	// \param b a pointer filled in with the blue value used to draw on the
	//          rendering target.
	// \param a a pointer filled in with the alpha value used to draw on the
	//          rendering target.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderDrawColorFloat
	// \sa GetRenderDrawColor

	GetRenderDrawColorFloat :: proc(renderer: ^Renderer, r, g, b, a: ^c.float) -> c.bool ---


	// Set the color scale used for render operations.
	//
	// The color scale is an additional scale multiplied into the pixel color
	// value while rendering. This can be used to adjust the brightness of colors
	// during HDR rendering, or changing HDR video brightness when playing on an
	// SDR display.
	//
	// The color scale does not affect the alpha channel, only the color
	// brightness.
	//
	// \param renderer the rendering context.
	// \param scale the color scale value.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderColorScale

	SetRenderColorScale :: proc(renderer: ^Renderer, scale: c.float) -> c.bool ---


	// Get the color scale used for render operations.
	//
	// \param renderer the rendering context.
	// \param scale a pointer filled in with the current color scale value.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderColorScale

	GetRenderColorScale :: proc(renderer: ^Renderer, scale: ^c.float) -> c.bool ---


	// Set the blend mode used for drawing operations (Fill and Line).
	//
	// If the blend mode is not supported, the closest supported mode is chosen.
	//
	// \param renderer the rendering context.
	// \param blendMode the BlendMode to use for blending.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderDrawBlendMode

	SetRenderDrawBlendMode :: proc(renderer: ^Renderer, blendMode: BlendMode) -> c.bool ---


	// Get the blend mode used for drawing operations.
	//
	// \param renderer the rendering context.
	// \param blendMode a pointer filled in with the current BlendMode.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderDrawBlendMode

	GetRenderDrawBlendMode :: proc(renderer: ^Renderer, blendMode: ^BlendMode) -> c.bool ---


	// Clear the current rendering target with the drawing color.
	//
	// This function clears the entire rendering target, ignoring the viewport and
	// the clip rectangle. Note, that clearing will also set/fill all pixels of
	// the rendering target to current renderer draw color, so make sure to invoke
	// SetRenderDrawColor() when needed.
	//
	// \param renderer the rendering context.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderDrawColor

	RenderClear :: proc(renderer: ^Renderer) -> c.bool ---


	// Draw a point on the current rendering target at subpixel precision.
	//
	// \param renderer the renderer which should draw a point.
	// \param x the x coordinate of the point.
	// \param y the y coordinate of the point.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderPoints

	RenderPoint :: proc(renderer: ^Renderer, x, y: c.float) -> c.bool ---


	// Draw multiple points on the current rendering target at subpixel precision.
	//
	// \param renderer the renderer which should draw multiple points.
	// \param points the points to draw.
	// \param count the number of points to draw.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderPoint

	RenderPoints :: proc(renderer: ^Renderer, points: [^]FPoint, count: c.int) -> c.bool ---


	// Draw a line on the current rendering target at subpixel precision.
	//
	// \param renderer the renderer which should draw a line.
	// \param x1 the x coordinate of the start point.
	// \param y1 the y coordinate of the start point.
	// \param x2 the x coordinate of the end point.
	// \param y2 the y coordinate of the end point.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderLines

	RenderLine :: proc(renderer: ^Renderer, x1, y1, x2, y2: c.float) -> c.bool ---


	// Draw a series of connected lines on the current rendering target at
	// subpixel precision.
	//
	// \param renderer the renderer which should draw multiple lines.
	// \param points the points along the lines.
	// \param count the number of points, drawing count-1 lines.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderLine

	RenderLines :: proc(renderer: ^Renderer, points: [^]FPoint, count: c.int) -> c.bool ---


	// Draw a rectangle on the current rendering target at subpixel precision.
	//
	// \param renderer the renderer which should draw a rectangle.
	// \param rect a pointer to the destination rectangle, or NULL to outline the
	//             entire rendering target.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderRects

	RenderRect :: proc(renderer: ^Renderer, rect: ^FRect) -> c.bool ---


	// Draw some number of rectangles on the current rendering target at subpixel
	// precision.
	//
	// \param renderer the renderer which should draw multiple rectangles.
	// \param rects a pointer to an array of destination rectangles.
	// \param count the number of rectangles.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderRect

	RenderRects :: proc(renderer: ^Renderer, rects: [^]FRect, count: c.int) -> c.bool ---


	// Fill a rectangle on the current rendering target with the drawing color at
	// subpixel precision.
	//
	// \param renderer the renderer which should fill a rectangle.
	// \param rect a pointer to the destination rectangle, or NULL for the entire
	//             rendering target.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderFillRects

	RenderFillRect :: proc(renderer: ^Renderer, rect: ^FRect) -> c.bool ---


	// Fill some number of rectangles on the current rendering target with the
	// drawing color at subpixel precision.
	//
	// \param renderer the renderer which should fill multiple rectangles.
	// \param rects a pointer to an array of destination rectangles.
	// \param count the number of rectangles.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderFillRect

	RenderFillRects :: proc(renderer: ^Renderer, rects: [^]FRect, count: c.int) -> c.bool ---


	// Copy a portion of the texture to the current rendering target at subpixel
	// precision.
	//
	// \param renderer the renderer which should copy parts of a texture.
	// \param texture the source texture.
	// \param srcrect a pointer to the source rectangle, or NULL for the entire
	//                texture.
	// \param dstrect a pointer to the destination rectangle, or NULL for the
	//                entire rendering target.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderTextureRotated
	// \sa RenderTextureTiled

	RenderTexture :: proc(renderer: ^Renderer, texture: ^Texture, srcrect, dstrect: ^FRect) -> c.bool ---


	// Copy a portion of the source texture to the current rendering target, with
	// rotation and flipping, at subpixel precision.
	//
	// \param renderer the renderer which should copy parts of a texture.
	// \param texture the source texture.
	// \param srcrect a pointer to the source rectangle, or NULL for the entire
	//                texture.
	// \param dstrect a pointer to the destination rectangle, or NULL for the
	//                entire rendering target.
	// \param angle an angle in degrees that indicates the rotation that will be
	//              applied to dstrect, rotating it in a clockwise direction.
	// \param center a pointer to a point indicating the point around which
	//               dstrect will be rotated (if NULL, rotation will be done
	//               around dstrect.w/2, dstrect.h/2).
	// \param flip an FlipMode value stating which flipping actions should be
	//             performed on the texture.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderTexture

	RenderTextureRotated :: proc(renderer: ^Renderer, texture: ^Texture, srcrect, dstrect: ^FRect, angle: c.double, center: ^FPoint, flip: FlipMode) -> c.bool ---


	// Tile a portion of the texture to the current rendering target at subpixel
	// precision.
	//
	// The pixels in `srcrect` will be repeated as many times as needed to
	// completely fill `dstrect`.
	//
	// \param renderer the renderer which should copy parts of a texture.
	// \param texture the source texture.
	// \param srcrect a pointer to the source rectangle, or NULL for the entire
	//                texture.
	// \param scale the scale used to transform srcrect into the destination
	//              rectangle, e.g. a 32x32 texture with a scale of 2 would fill
	//              64x64 tiles.
	// \param dstrect a pointer to the destination rectangle, or NULL for the
	//                entire rendering target.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderTexture

	RenderTextureTiled :: proc(renderer: ^Renderer, texture: ^Texture, srcrect: ^FRect, scale: c.float, dstrect: ^FRect) -> c.bool ---


	// Perform a scaled copy using the 9-grid algorithm to the current rendering
	// target at subpixel precision.
	//
	// The pixels in the texture are split into a 3x3 grid, using the different
	// corner sizes for each corner, and the sides and center making up the
	// remaining pixels. The corners are then scaled using `scale` and fit into
	// the corners of the destination rectangle. The sides and center are then
	// stretched into place to cover the remaining destination rectangle.
	//
	// \param renderer the renderer which should copy parts of a texture.
	// \param texture the source texture.
	// \param srcrect the Rect structure representing the rectangle to be used
	//                for the 9-grid, or NULL to use the entire texture.
	// \param left_width the width, in pixels, of the left corners in `srcrect`.
	// \param right_width the width, in pixels, of the right corners in `srcrect`.
	// \param top_height the height, in pixels, of the top corners in `srcrect`.
	// \param bottom_height the height, in pixels, of the bottom corners in
	//                      `srcrect`.
	// \param scale the scale used to transform the corner of `srcrect` into the
	//              corner of `dstrect`, or 0.0f for an unscaled copy.
	// \param dstrect a pointer to the destination rectangle, or NULL for the
	//                entire rendering target.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderTexture

	RenderTexture9Grid :: proc(renderer: ^Renderer, texture: ^Texture, srcrect: ^FRect, left_width, right_width, top_height, bottom_height, scale: c.float, dstrec: ^FRect) -> c.bool ---


	// Render a list of triangles, optionally using a texture and indices into the
	// vertex array Color and alpha modulation is done per vertex
	// (SetTextureColorMod and SetTextureAlphaMod are ignored).
	//
	// \param renderer the rendering context.
	// \param texture (optional) The SDL texture to use.
	// \param vertices vertices.
	// \param num_vertices number of vertices.
	// \param indices (optional) An array of integer indices into the 'vertices'
	//                array, if NULL all vertices will be rendered in sequential
	//                order.
	// \param num_indices number of indices.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderGeometryRaw

	RenderGeometry :: proc(renderer: ^Renderer, texture: ^Texture, vertices: [^]Vertex, num_vertices: c.int, indices: [^]c.int, num_indices: c.int) -> c.bool ---


	// Render a list of triangles, optionally using a texture and indices into the
	// vertex arrays Color and alpha modulation is done per vertex
	// (SetTextureColorMod and SetTextureAlphaMod are ignored).
	//
	// \param renderer the rendering context.
	// \param texture (optional) The SDL texture to use.
	// \param xy vertex positions.
	// \param xy_stride byte size to move from one element to the next element.
	// \param color vertex colors (as FColor).
	// \param color_stride byte size to move from one element to the next element.
	// \param uv vertex normalized texture coordinates.
	// \param uv_stride byte size to move from one element to the next element.
	// \param num_vertices number of vertices.
	// \param indices (optional) An array of indices into the 'vertices' arrays,
	//                if NULL all vertices will be rendered in sequential order.
	// \param num_indices number of indices.
	// \param size_indices index size: 1 (byte), 2 (short), 4 (int).
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RenderGeometry

	RenderGeometryRaw :: proc(renderer: ^Renderer, texture: ^Texture, xy: ^c.float, xy_stride: c.int, color: ^FColor, color_stride: c.int, uv: ^c.float, uv_stride: c.int, num_vertices: c.int, indices: rawptr, num_indices, size_indices: c.int) -> c.bool ---


	// Read pixels from the current rendering target.
	//
	// The returned surface should be freed with DestroySurface()
	//
	// **WARNING**: This is a very slow operation, and should not be used
	// frequently. If you're using this on the main rendering target, it should be
	// called after rendering and before RenderPresent().
	//
	// \param renderer the rendering context.
	// \param rect an Rect structure representing the area in pixels relative
	//             to the to current viewport, or NULL for the entire viewport.
	// \returns a new Surface on success or NULL on failure; call
	//          GetError() for more information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.

	RenderReadPixels :: proc(renderer: ^Renderer, rect: ^Rect) -> ^Surface ---


	// Update the screen with any rendering performed since the previous call.
	//
	// SDL's rendering functions operate on a backbuffer; that is, calling a
	// rendering function such as RenderLine() does not directly put a line on
	// the screen, but rather updates the backbuffer. As such, you compose your
	// entire scene and *present* the composed backbuffer to the screen as a
	// complete picture.
	//
	// Therefore, when using SDL's rendering API, one does all drawing intended
	// for the frame, and then calls this function once per frame to present the
	// final drawing to the user.
	//
	// The backbuffer should be considered invalidated after each present; do not
	// assume that previous contents will exist between frames. You are strongly
	// encouraged to call RenderClear() to initialize the backbuffer before
	// starting each new frame's drawing, even if you plan to overwrite every
	// pixel.
	//
	// Please note, that in case of rendering to a texture - there is **no need**
	// to call `RenderPresent` after drawing needed objects to a texture, and
	// should not be done; you are only required to change back the rendering
	// target to default via `SetRenderTarget(renderer, NULL)` afterwards, as
	// textures by themselves do not have a concept of backbuffers. Calling
	// RenderPresent while rendering to a texture will still update the screen
	// with any current drawing that has been done _to the window itself_.
	//
	// \param renderer the rendering context.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateRenderer
	// \sa RenderClear
	// \sa RenderFillRect
	// \sa RenderFillRects
	// \sa RenderLine
	// \sa RenderLines
	// \sa RenderPoint
	// \sa RenderPoints
	// \sa RenderRect
	// \sa RenderRects
	// \sa SetRenderDrawBlendMode
	// \sa SetRenderDrawColor

	RenderPresent :: proc(renderer: ^Renderer) -> c.bool ---


	// Destroy the specified texture.
	//
	// Passing NULL or an otherwise invalid texture will set the SDL error message
	// to "Invalid texture".
	//
	// \param texture the texture to destroy.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateTexture
	// \sa CreateTextureFromSurface

	DestroyTexture :: proc(texture: ^Texture) ---


	// Destroy the rendering context for a window and free all associated
	// textures.
	//
	// This should be called before destroying the associated window.
	//
	// \param renderer the rendering context.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateRenderer

	DestroyRenderer :: proc(renderer: ^Renderer) ---


	// Force the rendering context to flush any pending commands and state.
	//
	// You do not need to (and in fact, shouldn't) call this function unless you
	// are planning to call into OpenGL/Direct3D/Metal/whatever directly, in
	// addition to using an Renderer.
	//
	// This is for a very-specific case: if you are using SDL's render API, and
	// you plan to make OpenGL/D3D/whatever calls in addition to SDL render API
	// calls. If this applies, you should call this function between calls to
	// SDL's render API and the low-level API you're using in cooperation.
	//
	// In all other cases, you can ignore this function.
	//
	// This call makes SDL flush any pending rendering work it was queueing up to
	// do later in a single batch, and marks any internal cached state as invalid,
	// so it'll prepare all its state again later, from scratch.
	//
	// This means you do not need to save state in your rendering code to protect
	// the SDL renderer. However, there lots of arbitrary pieces of Direct3D and
	// OpenGL state that can confuse things; you should use your best judgment and
	// be prepared to make changes if specific state needs to be protected.
	//
	// \param renderer the rendering context.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.

	FlushRenderer :: proc(renderer: ^Renderer) -> c.bool ---


	// Get the CAMetalLayer associated with the given Metal renderer.
	//
	// This function returns `void *`, so SDL doesn't have to include Metal's
	// headers, but it can be safely cast to a `CAMetalLayer *`.
	//
	// \param renderer the renderer to query.
	// \returns a `CAMetalLayer *` on success, or NULL if the renderer isn't a
	//          Metal renderer.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderMetalCommandEncoder

	GetRenderMetalLayer :: proc(renderer: ^Renderer) -> rawptr ---


	// Get the Metal command encoder for the current frame.
	//
	// This function returns `void *`, so SDL doesn't have to include Metal's
	// headers, but it can be safely cast to an `id<MTLRenderCommandEncoder>`.
	//
	// This will return NULL if Metal refuses to give SDL a drawable to render to,
	// which might happen if the window is hidden/minimized/offscreen. This
	// doesn't apply to command encoders for render targets, just the window's
	// backbuffer. Check your return values!
	//
	// \param renderer the renderer to query.
	// \returns an `id<MTLRenderCommandEncoder>` on success, or NULL if the
	//          renderer isn't a Metal renderer or there was an error.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderMetalLayer

	GetRenderMetalCommandEncoder :: proc(renderer: ^Renderer) -> rawptr ---


	// Add a set of synchronization semaphores for the current frame.
	//
	// The Vulkan renderer will wait for `wait_semaphore` before submitting
	// rendering commands and signal `signal_semaphore` after rendering commands
	// are complete for this frame.
	//
	// This should be called each frame that you want semaphore synchronization.
	// The Vulkan renderer may have multiple frames in flight on the GPU, so you
	// should have multiple semaphores that are used for synchronization. Querying
	// PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER will give you the
	// maximum number of semaphores you'll need.
	//
	// \param renderer the rendering context.
	// \param wait_stage_mask the VkPipelineStageFlags for the wait.
	// \param wait_semaphore a VkSempahore to wait on before rendering the current
	//                       frame, or 0 if not needed.
	// \param signal_semaphore a VkSempahore that SDL will signal when rendering
	//                         for the current frame is complete, or 0 if not
	//                         needed.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety It is **NOT** safe to call this function from two threads at
	//               once.
	//
	// \since This function is available since SDL 3.0.0.

	AddVulkanRenderSemaphores :: proc(renderer: ^Renderer, wait_stage_mask: c.uint32_t, wait_semaphore, signal_semaphore: c.int64_t) -> c.bool ---


	// Toggle VSync of the given renderer.
	//
	// When a renderer is created, vsync defaults to RENDERER_VSYNC_DISABLED.
	//
	// The `vsync` parameter can be 1 to synchronize present with every vertical
	// refresh, 2 to synchronize present with every second vertical refresh, etc.,
	// WINDOW_SURFACE_VSYNC_ADAPTIVE for late swap tearing (adaptive vsync),
	// or WINDOW_SURFACE_VSYNC_DISABLED to disable. Not every value is
	// supported by every driver, so you should check the return value to see
	// whether the requested setting is supported.
	//
	// \param renderer the renderer to toggle.
	// \param vsync the vertical refresh sync interval.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderVSync

	SetRenderVSync :: proc(renderer: ^Renderer, vsync: c.int) -> c.bool ---


	// Get VSync of the given renderer.
	//
	// \param renderer the renderer to toggle.
	// \param vsync an int filled with the current vertical refresh sync interval.
	//              See SetRenderVSync() for the meaning of the value.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \threadsafety You may only call this function from the main thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetRenderVSync

	GetRenderVSync :: proc(renderer: ^Renderer, vsync: ^c.int) -> c.bool ---
}
