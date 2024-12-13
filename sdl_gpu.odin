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

/* WIKI CATEGORY: GPU */

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

// # CategoryGPU
//
// The GPU API offers a cross-platform way for apps to talk to modern graphics
// hardware. It offers both 3D graphics and "compute" support, in the style of
// Metal, Vulkan, and Direct3D 12.
//
// A basic workflow might be something like this:
//
// The app creates a GPU device with SDL_CreateGPUDevice(), and assigns it to
// a window with SDL_ClaimWindowForGPUDevice()--although strictly speaking you
// can render offscreen entirely, perhaps for image processing, and not use a
// window at all.
//
// Next the app prepares static data (things that are created once and used
// over and over). For example:
//
// - Shaders (programs that run on the GPU): use SDL_CreateGPUShader().
// - Vertex buffers (arrays of geometry data) and other data rendering will
//   need: use SDL_UploadToGPUBuffer().
// - Textures (images): use SDL_UploadToGPUTexture().
// - Samplers (how textures should be read from): use SDL_CreateGPUSampler().
// - Render pipelines (precalculated rendering state): use
//   SDL_CreateGPUGraphicsPipeline()
//
// To render, the app creates one or more command buffers, with
// SDL_AcquireGPUCommandBuffer(). Command buffers collect rendering
// instructions that will be submitted to the GPU in batch. Complex scenes can
// use multiple command buffers, maybe configured across multiple threads in
// parallel, as long as they are submitted in the correct order, but many apps
// will just need one command buffer per frame.
//
// Rendering can happen to a texture (what other APIs call a "render target")
// or it can happen to the swapchain texture (which is just a special texture
// that represents a window's contents). The app can use
// SDL_AcquireGPUSwapchainTexture() to render to the window.
//
// Rendering actually happens in a Render Pass, which is encoded into a
// command buffer. One can encode multiple render passes (or alternate between
// render and compute passes) in a single command buffer, but many apps might
// simply need a single render pass in a single command buffer. Render Passes
// can render to up to four color textures and one depth texture
// simultaneously. If the set of textures being rendered to needs to change,
// the Render Pass must be ended and a new one must be begun.
//
// The app calls SDL_BeginGPURenderPass(). Then it sets states it needs for
// each draw:
//
// - SDL_BindGPUGraphicsPipeline()
// - SDL_SetGPUViewport()
// - SDL_BindGPUVertexBuffers()
// - SDL_BindGPUVertexSamplers()
// - etc
//
// Then, make the actual draw commands with these states:
//
// - SDL_DrawGPUPrimitives()
// - SDL_DrawGPUPrimitivesIndirect()
// - SDL_DrawGPUIndexedPrimitivesIndirect()
// - etc
//
// After all the drawing commands for a pass are complete, the app should call
// SDL_EndGPURenderPass(). Once a render pass ends all render-related state is
// reset.
//
// The app can begin new Render Passes and make new draws in the same command
// buffer until the entire scene is rendered.
//
// Once all of the render commands for the scene are complete, the app calls
// SDL_SubmitGPUCommandBuffer() to send it to the GPU for processing.
//
// If the app needs to read back data from texture or buffers, the API has an
// efficient way of doing this, provided that the app is willing to tolerate
// some latency. When the app uses SDL_DownloadFromGPUTexture() or
// SDL_DownloadFromGPUBuffer(), submitting the command buffer with
// SubmitGPUCommandBufferAndAcquireFence() will return a fence handle that the
// app can poll or wait on in a thread. Once the fence indicates that the
// command buffer is done processing, it is safe to read the downloaded data.
// Make sure to call SDL_ReleaseGPUFence() when done with the fence.
//
// The API also has "compute" support. The app calls SDL_BeginGPUComputePass()
// with compute-writeable textures and/or buffers, which can be written to in
// a compute shader. Then it sets states it needs for the compute dispatches:
//
// - SDL_BindGPUComputePipeline()
// - SDL_BindGPUComputeStorageBuffers()
// - SDL_BindGPUComputeStorageTextures()
//
// Then, dispatch compute work:
//
// - SDL_DispatchGPUCompute()
//
// For advanced users, this opens up powerful GPU-driven workflows.
//
// Graphics and compute pipelines require the use of shaders, which as
// mentioned above are small programs executed on the GPU. Each backend
// (Vulkan, Metal, D3D12) requires a different shader format. When the app
// creates the GPU device, the app lets the device know which shader formats
// the app can provide. It will then select the appropriate backend depending
// on the available shader formats and the backends available on the platform.
// When creating shaders, the app must provide the correct shader format for
// the selected backend. If you would like to learn more about why the API
// works this way, there is a detailed
// [blog post](https://moonside.games/posts/layers-all-the-way-down/)
// explaining this situation.
//
// It is optimal for apps to pre-compile the shader formats they might use,
// but for ease of use SDL provides a
// [satellite single-header library](https://github.com/libsdl-org/SDL_gpu_shadercross
// )
// for performing runtime shader cross-compilation.
//
// This is an extremely quick overview that leaves out several important
// details. Already, though, one can see that GPU programming can be quite
// complex! If you just need simple 2D graphics, the
// [Render API](https://wiki.libsdl.org/SDL3/CategoryRender)
// is much easier to use but still hardware-accelerated. That said, even for
// 2D applications the performance benefits and expressiveness of the GPU API
// are significant.
//
// The GPU API targets a feature set with a wide range of hardware support and
// ease of portability. It is designed so that the app won't have to branch
// itself by querying feature support. If you need cutting-edge features with
// limited hardware support, this API is probably not for you.
//
// Examples demonstrating proper usage of this API can be found
// [here](https://github.com/TheSpydog/SDL_gpu_examples)
// .

/* Type Declarations */


// An opaque handle representing the SDL_GPU context.
//
// \since This struct is available since SDL 3.0.0

GPUDevice :: distinct struct {}


// An opaque handle representing a buffer.
//
// Used for vertices, indices, indirect draw commands, and general compute
// data.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUBuffer
// \sa SDL_SetGPUBufferName
// \sa SDL_UploadToGPUBuffer
// \sa SDL_DownloadFromGPUBuffer
// \sa SDL_CopyGPUBufferToBuffer
// \sa SDL_BindGPUVertexBuffers
// \sa SDL_BindGPUIndexBuffer
// \sa SDL_BindGPUVertexStorageBuffers
// \sa SDL_BindGPUFragmentStorageBuffers
// \sa SDL_DrawGPUPrimitivesIndirect
// \sa SDL_DrawGPUIndexedPrimitivesIndirect
// \sa SDL_BindGPUComputeStorageBuffers
// \sa SDL_DispatchGPUComputeIndirect
// \sa SDL_ReleaseGPUBuffer

GPUBuffer :: distinct struct {}


// An opaque handle representing a transfer buffer.
//
// Used for transferring data to and from the device.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUTransferBuffer
// \sa SDL_MapGPUTransferBuffer
// \sa SDL_UnmapGPUTransferBuffer
// \sa SDL_UploadToGPUBuffer
// \sa SDL_UploadToGPUTexture
// \sa SDL_DownloadFromGPUBuffer
// \sa SDL_DownloadFromGPUTexture
// \sa SDL_ReleaseGPUTransferBuffer

GPUTransferBuffer :: distinct struct {}


// An opaque handle representing a texture.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUTexture
// \sa SDL_SetGPUTextureName
// \sa SDL_UploadToGPUTexture
// \sa SDL_DownloadFromGPUTexture
// \sa SDL_CopyGPUTextureToTexture
// \sa SDL_BindGPUVertexSamplers
// \sa SDL_BindGPUVertexStorageTextures
// \sa SDL_BindGPUFragmentSamplers
// \sa SDL_BindGPUFragmentStorageTextures
// \sa SDL_BindGPUComputeStorageTextures
// \sa SDL_GenerateMipmapsForGPUTexture
// \sa SDL_BlitGPUTexture
// \sa SDL_ReleaseGPUTexture

GPUTexture :: distinct struct {}


// An opaque handle representing a sampler.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUSampler
// \sa SDL_BindGPUVertexSamplers
// \sa SDL_BindGPUFragmentSamplers
// \sa SDL_ReleaseGPUSampler

GPUSampler :: distinct struct {}


// An opaque handle representing a compiled shader object.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUShader
// \sa SDL_CreateGPUGraphicsPipeline
// \sa SDL_ReleaseGPUShader

GPUShader :: distinct struct {}


// An opaque handle representing a compute pipeline.
//
// Used during compute passes.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUComputePipeline
// \sa SDL_BindGPUComputePipeline
// \sa SDL_ReleaseGPUComputePipeline

GPUComputePipeline :: distinct struct {}


// An opaque handle representing a graphics pipeline.
//
// Used during render passes.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline
// \sa SDL_BindGPUGraphicsPipeline
// \sa SDL_ReleaseGPUGraphicsPipeline

GPUGraphicsPipeline :: distinct struct {}


// An opaque handle representing a command buffer.
//
// Most state is managed via command buffers. When setting state using a
// command buffer, that state is local to the command buffer.
//
// Commands only begin execution on the GPU once SDL_SubmitGPUCommandBuffer is
// called. Once the command buffer is submitted, it is no longer valid to use
// it.
//
// Command buffers are executed in submission order. If you submit command
// buffer A and then command buffer B all commands in A will begin executing
// before any command in B begins executing.
//
// In multi-threading scenarios, you should acquire and submit a command
// buffer on the same thread. As long as you satisfy this requirement, all
// functionality related to command buffers is thread-safe.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_AcquireGPUCommandBuffer
// \sa SDL_SubmitGPUCommandBuffer
// \sa SDL_SubmitGPUCommandBufferAndAcquireFence

GPUCommandBuffer :: distinct struct {}


// An opaque handle representing a render pass.
//
// This handle is transient and should not be held or referenced after
// SDL_EndGPURenderPass is called.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BeginGPURenderPass
// \sa SDL_EndGPURenderPass

GPURenderPass :: distinct struct {}


// An opaque handle representing a compute pass.
//
// This handle is transient and should not be held or referenced after
// SDL_EndGPUComputePass is called.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BeginGPUComputePass
// \sa SDL_EndGPUComputePass

GPUComputePass :: distinct struct {}


// An opaque handle representing a copy pass.
//
// This handle is transient and should not be held or referenced after
// SDL_EndGPUCopyPass is called.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BeginGPUCopyPass
// \sa SDL_EndGPUCopyPass

GPUCopyPass :: distinct struct {}


// An opaque handle representing a fence.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_SubmitGPUCommandBufferAndAcquireFence
// \sa SDL_QueryGPUFence
// \sa SDL_WaitForGPUFences
// \sa SDL_ReleaseGPUFence

GPUFence :: distinct struct {}


// Specifies the primitive topology of a graphics pipeline.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUPrimitiveType :: enum c.int {
	TRIANGLELIST, /**< A series of separate triangles. */
	TRIANGLESTRIP, /**< A series of connected triangles. */
	LINELIST, /**< A series of separate lines. */
	LINESTRIP, /**< A series of connected lines. */
	POINTLIST, /**< A series of separate points. */
}


// Specifies how the contents of a texture attached to a render pass are
// treated at the beginning of the render pass.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_BeginGPURenderPass

GPULoadOp :: enum c.int {
	LOAD, /**< The previous contents of the texture will be preserved. */
	CLEAR, /**< The contents of the texture will be cleared to a color. */
	DONT_CARE, /**< The previous contents of the texture need not be preserved. The contents will be undefined. */
}


// Specifies how the contents of a texture attached to a render pass are
// treated at the end of the render pass.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_BeginGPURenderPass

GPUStoreOp :: enum c.int {
	STORE, /**< The contents generated during the render pass will be written to memory. */
	DONT_CARE, /**< The contents generated during the render pass are not needed and may be discarded. The contents will be undefined. */
	RESOLVE, /**< The multisample contents generated during the render pass will be resolved to a non-multisample texture. The contents in the multisample texture may then be discarded and will be undefined. */
	RESOLVE_AND_STORE, /**< The multisample contents generated during the render pass will be resolved to a non-multisample texture. The contents in the multisample texture will be written to memory. */
}


// Specifies the size of elements in an index buffer.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUIndexElementSize :: enum c.int {
	SIZE_16BIT, /**< The index elements are 16-bit. */
	SIZE_32BIT, /**< The index elements are 32-bit. */
}


// Specifies the pixel format of a texture.
//
// Texture format support varies depending on driver, hardware, and usage
// flags. In general, you should use SDL_GPUTextureSupportsFormat to query if
// a format is supported before using it. However, there are a few guaranteed
// formats.
//
// FIXME: Check universal support for 32-bit component formats FIXME: Check
// universal support for SIMULTANEOUS_READ_WRITE
//
// For SAMPLER usage, the following formats are universally supported:
//
// - R8G8B8A8_UNORM
// - B8G8R8A8_UNORM
// - R8_UNORM
// - R8_SNORM
// - R8G8_UNORM
// - R8G8_SNORM
// - R8G8B8A8_SNORM
// - R16_FLOAT
// - R16G16_FLOAT
// - R16G16B16A16_FLOAT
// - R32_FLOAT
// - R32G32_FLOAT
// - R32G32B32A32_FLOAT
// - R11G11B10_UFLOAT
// - R8G8B8A8_UNORM_SRGB
// - B8G8R8A8_UNORM_SRGB
// - D16_UNORM
//
// For COLOR_TARGET usage, the following formats are universally supported:
//
// - R8G8B8A8_UNORM
// - B8G8R8A8_UNORM
// - R8_UNORM
// - R16_FLOAT
// - R16G16_FLOAT
// - R16G16B16A16_FLOAT
// - R32_FLOAT
// - R32G32_FLOAT
// - R32G32B32A32_FLOAT
// - R8_UINT
// - R8G8_UINT
// - R8G8B8A8_UINT
// - R16_UINT
// - R16G16_UINT
// - R16G16B16A16_UINT
// - R8_INT
// - R8G8_INT
// - R8G8B8A8_INT
// - R16_INT
// - R16G16_INT
// - R16G16B16A16_INT
// - R8G8B8A8_UNORM_SRGB
// - B8G8R8A8_UNORM_SRGB
//
// For STORAGE usages, the following formats are universally supported:
//
// - R8G8B8A8_UNORM
// - R8G8B8A8_SNORM
// - R16G16B16A16_FLOAT
// - R32_FLOAT
// - R32G32_FLOAT
// - R32G32B32A32_FLOAT
// - R8G8B8A8_UINT
// - R16G16B16A16_UINT
// - R8G8B8A8_INT
// - R16G16B16A16_INT
//
// For DEPTH_STENCIL_TARGET usage, the following formats are universally
// supported:
//
// - D16_UNORM
// - Either (but not necessarily both!) D24_UNORM or D32_SFLOAT
// - Either (but not necessarily both!) D24_UNORM_S8_UINT or
//   D32_SFLOAT_S8_UINT
//
// Unless D16_UNORM is sufficient for your purposes, always check which of
// D24/D32 is supported before creating a depth-stencil texture!
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUTexture
// \sa SDL_GPUTextureSupportsFormat

GPUTextureFormat :: enum c.int {
	INVALID,

	/* Unsigned Normalized Float Color Formats */
	A8_UNORM,
	R8_UNORM,
	R8G8_UNORM,
	R8G8B8A8_UNORM,
	R16_UNORM,
	R16G16_UNORM,
	R16G16B16A16_UNORM,
	R10G10B10A2_UNORM,
	B5G6R5_UNORM,
	B5G5R5A1_UNORM,
	B4G4R4A4_UNORM,
	B8G8R8A8_UNORM,
	/* Compressed Unsigned Normalized Float Color Formats */
	BC1_RGBA_UNORM,
	BC2_RGBA_UNORM,
	BC3_RGBA_UNORM,
	BC4_R_UNORM,
	BC5_RG_UNORM,
	BC7_RGBA_UNORM,
	/* Compressed Signed Float Color Formats */
	BC6H_RGB_FLOAT,
	/* Compressed Unsigned Float Color Formats */
	BC6H_RGB_UFLOAT,
	/* Signed Normalized Float Color Formats  */
	R8_SNORM,
	R8G8_SNORM,
	R8G8B8A8_SNORM,
	R16_SNORM,
	R16G16_SNORM,
	R16G16B16A16_SNORM,
	/* Signed Float Color Formats */
	R16_FLOAT,
	R16G16_FLOAT,
	R16G16B16A16_FLOAT,
	R32_FLOAT,
	R32G32_FLOAT,
	R32G32B32A32_FLOAT,
	/* Unsigned Float Color Formats */
	R11G11B10_UFLOAT,
	/* Unsigned Integer Color Formats */
	R8_UINT,
	R8G8_UINT,
	R8G8B8A8_UINT,
	R16_UINT,
	R16G16_UINT,
	R16G16B16A16_UINT,
	R32_UINT,
	R32G32_UINT,
	R32G32B32A32_UINT,
	/* Signed Integer Color Formats */
	R8_INT,
	R8G8_INT,
	R8G8B8A8_INT,
	R16_INT,
	R16G16_INT,
	R16G16B16A16_INT,
	R32_INT,
	R32G32_INT,
	R32G32B32A32_INT,
	/* SRGB Unsigned Normalized Color Formats */
	R8G8B8A8_UNORM_SRGB,
	B8G8R8A8_UNORM_SRGB,
	/* Compressed SRGB Unsigned Normalized Color Formats */
	BC1_RGBA_UNORM_SRGB,
	BC2_RGBA_UNORM_SRGB,
	BC3_RGBA_UNORM_SRGB,
	BC7_RGBA_UNORM_SRGB,
	/* Depth Formats */
	D16_UNORM,
	D24_UNORM,
	D32_FLOAT,
	D24_UNORM_S8_UINT,
	D32_FLOAT_S8_UINT,
}


// Specifies how a texture is intended to be used by the client.
//
// A texture must have at least one usage flag. Note that some usage flag
// combinations are invalid.
//
// With regards to compute storage usage, READ | WRITE means that you can have
// shader A that only writes into the texture and shader B that only reads
// from the texture and bind the same texture to either shader respectively.
// SIMULTANEOUS means that you can do reads and writes within the same shader
// or compute pass. It also implies that atomic ops can be used, since those
// are read-modify-write operations. If you use SIMULTANEOUS, you are
// responsible for avoiding data races, as there is no data synchronization
// within a compute pass. Note that SIMULTANEOUS usage is only supported by a
// limited number of texture formats.
//
// \since This datatype is available since SDL 3.0.0
//
// \sa SDL_CreateGPUTexture
GPUTextureUsageFlags :: bit_set[GPUTextureUsageFlag]

GPUTextureUsageFlag :: enum c.uint32_t {
	SAMPLER, /**< Texture supports sampling. */
	COLOR_TARGET, /**< Texture is a color render target. */
	DEPTH_STENCIL_TARGET, /**< Texture is a depth stencil target. */
	GRAPHICS_STORAGE_READ, /**< Texture supports storage reads in graphics stages. */
	COMPUTE_STORAGE_READ, /**< Texture supports storage reads in the compute stage. */
	COMPUTE_STORAGE_WRITE, /**< Texture supports storage writes in the compute stage. */
	COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE, /**< Texture supports reads and writes in the same compute shader. This is NOT equivalent to READ | WRITE. */
}


// Specifies the type of a texture.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUTexture

GPUTextureType :: enum c.int {
	TEXTURETYPE_2D, /**< The texture is a 2-dimensional image. */
	TEXTURETYPE_2D_ARRAY, /**< The texture is a 2-dimensional array image. */
	TEXTURETYPE_3D, /**< The texture is a 3-dimensional image. */
	TEXTURETYPE_CUBE, /**< The texture is a cube image. */
	TEXTURETYPE_CUBE_ARRAY, /**< The texture is a cube array image. */
}


// Specifies the sample count of a texture.
//
// Used in multisampling. Note that this value only applies when the texture
// is used as a render target.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUTexture
// \sa SDL_GPUTextureSupportsSampleCount

GPUSampleCount :: enum c.int {
	SAMPLECOUNT_1, /**< No multisampling. */
	SAMPLECOUNT_2, /**< MSAA 2x */
	SAMPLECOUNT_4, /**< MSAA 4x */
	SAMPLECOUNT_8, /**< MSAA 8x */
}


// Specifies the face of a cube map.
//
// Can be passed in as the layer field in texture-related structs.
//
// \since This enum is available since SDL 3.0.0

GPUCubeMapFace :: enum c.int {
	POSITIVEX,
	NEGATIVEX,
	POSITIVEY,
	NEGATIVEY,
	POSITIVEZ,
	NEGATIVEZ,
}


// Specifies how a buffer is intended to be used by the client.
//
// A buffer must have at least one usage flag. Note that some usage flag
// combinations are invalid.
//
// Unlike textures, READ | WRITE can be used for simultaneous read-write
// usage. The same data synchronization concerns as textures apply.
//
// \since This datatype is available since SDL 3.0.0
//
// \sa SDL_CreateGPUBuffer

GPUBufferUsageFlags :: bit_set[GPUBufferUsageFlag]

GPUBufferUsageFlag :: enum c.uint32_t {
	VERTEX, /**< Buffer is a vertex buffer. */
	INDEX, /**< Buffer is an index buffer. */
	INDIRECT, /**< Buffer is an indirect buffer. */
	GRAPHICS_STORAGE_READ, /**< Buffer supports storage reads in graphics stages. */
	COMPUTE_STORAGE_READ, /**< Buffer supports storage reads in the compute stage. */
	COMPUTE_STORAGE_WRITE, /**< Buffer supports storage writes in the compute stage. */
}


// Specifies how a transfer buffer is intended to be used by the client.
//
// Note that mapping and copying FROM an upload transfer buffer or TO a
// download transfer buffer is undefined behavior.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUTransferBuffer

GPUTransferBufferUsage :: enum c.int {
	UPLOAD,
	DOWNLOAD,
}


// Specifies which stage a shader program corresponds to.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUShader

GPUShaderStage :: enum c.int {
	VERTEX,
	FRAGMENT,
}


// Specifies the format of shader code.
//
// Each format corresponds to a specific backend that accepts it.
//
// \since This datatype is available since SDL 3.0.0
//
// \sa SDL_CreateGPUShader

GPUShaderFormat :: bit_set[GPUShaderFormats]

GPUShaderFormats :: enum c.uint32_t {
	PRIVATE, /**< Shaders for NDA'd platforms. */
	SPIRV, /**< SPIR-V shaders for Vulkan. */
	DXBC, /**< DXBC SM5_0 shaders for D3D11. */
	DXIL, /**< DXIL shaders for D3D12. */
	MSL, /**< MSL shaders for Metal. */
	METALLIB, /**< Precompiled metallib shaders for Metal. */
}

SHADER_FORMAT_INVALID :: 0


// Specifies the format of a vertex attribute.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUVertexElementFormat :: enum c.int {
	INVALID,

	/* 32-bit Signed Integers */
	INT,
	INT2,
	INT3,
	INT4,

	/* 32-bit Unsigned Integers */
	UINT,
	UINT2,
	UINT3,
	UINT4,

	/* 32-bit Floats */
	FLOAT,
	FLOAT2,
	FLOAT3,
	FLOAT4,

	/* 8-bit Signed Integers */
	BYTE2,
	BYTE4,

	/* 8-bit Unsigned Integers */
	UBYTE2,
	UBYTE4,

	/* 8-bit Signed Normalized */
	BYTE2_NORM,
	BYTE4_NORM,

	/* 8-bit Unsigned Normalized */
	UBYTE2_NORM,
	UBYTE4_NORM,

	/* 16-bit Signed Integers */
	SHORT2,
	SHORT4,

	/* 16-bit Unsigned Integers */
	USHORT2,
	USHORT4,

	/* 16-bit Signed Normalized */
	SHORT2_NORM,
	SHORT4_NORM,

	/* 16-bit Unsigned Normalized */
	USHORT2_NORM,
	USHORT4_NORM,

	/* 16-bit Floats */
	HALF2,
	HALF4,
}


// Specifies the rate at which vertex attributes are pulled from buffers.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUVertexInputRate :: enum c.int {
	VERTEX, /**< Attribute addressing is a function of the vertex index. */
	INSTANCE, /**< Attribute addressing is a function of the instance index. */
}


// Specifies the fill mode of the graphics pipeline.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUFillMode :: enum c.int {
	FILL, /**< Polygons will be rendered via rasterization. */
	LINE, /**< Polygon edges will be drawn as line segments. */
}


// Specifies the facing direction in which triangle faces will be culled.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUCullMode :: enum c.int {
	NONE, /**< No triangles are culled. */
	FRONT, /**< Front-facing triangles are culled. */
	BACK, /**< Back-facing triangles are culled. */
}


// Specifies the vertex winding that will cause a triangle to be determined to
// be front-facing.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUFrontFace :: enum c.int {
	COUNTER_CLOCKWISE,
	/**< A triangle with counter-clockwise vertex winding will be considered front-facing. */
	CLOCKWISE, /**< A triangle with clockwise vertex winding will be considered front-facing. */
}


// Specifies a comparison operator for depth, stencil and sampler operations.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUCompareOp :: enum c.int {
	INVALID,
	NEVER, /**< The comparison always evaluates false. */
	LESS, /**< The comparison evaluates reference < test. */
	EQUAL, /**< The comparison evaluates reference == test. */
	LESS_OR_EQUAL, /**< The comparison evaluates reference <= test. */
	GREATER, /**< The comparison evaluates reference > test. */
	NOT_EQUAL, /**< The comparison evaluates reference != test. */
	GREATER_OR_EQUAL, /**< The comparison evalutes reference >= test. */
	ALWAYS, /**< The comparison always evaluates true. */
}


// Specifies what happens to a stored stencil value if stencil tests fail or
// pass.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUStencilOp :: enum c.int {
	INVALID,
	KEEP, /**< Keeps the current value. */
	ZERO, /**< Sets the value to 0. */
	REPLACE, /**< Sets the value to reference. */
	INCREMENT_AND_CLAMP, /**< Increments the current value and clamps to the maximum value. */
	DECREMENT_AND_CLAMP, /**< Decrements the current value and clamps to 0. */
	INVERT, /**< Bitwise-inverts the current value. */
	INCREMENT_AND_WRAP, /**< Increments the current value and wraps back to 0. */
	DECREMENT_AND_WRAP, /**< Decrements the current value and wraps to the maximum value. */
}


// Specifies the operator to be used when pixels in a render target are
// blended with existing pixels in the texture.
//
// The source color is the value written by the fragment shader. The
// destination color is the value currently existing in the texture.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUBlendOp :: enum c.int {
	INVALID,
	ADD, /**< (source * source_factor) + (destination * destination_factor) */
	SUBTRACT, /**< (source * source_factor) - (destination * destination_factor) */
	REVERSE_SUBTRACT, /**< (destination * destination_factor) - (source * source_factor) */
	MIN, /**< min(source, destination) */
	MAX, /**< max(source, destination) */
}


// Specifies a blending factor to be used when pixels in a render target are
// blended with existing pixels in the texture.
//
// The source color is the value written by the fragment shader. The
// destination color is the value currently existing in the texture.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUBlendFactor :: enum c.int {
	INVALID,
	ZERO, /**< 0 */
	ONE, /**< 1 */
	SRC_COLOR, /**< source color */
	ONE_MINUS_SRC_COLOR, /**< 1 - source color */
	DST_COLOR, /**< destination color */
	ONE_MINUS_DST_COLOR, /**< 1 - destination color */
	SRC_ALPHA, /**< source alpha */
	ONE_MINUS_SRC_ALPHA, /**< 1 - source alpha */
	DST_ALPHA, /**< destination alpha */
	ONE_MINUS_DST_ALPHA, /**< 1 - destination alpha */
	CONSTANT_COLOR, /**< blend constant */
	ONE_MINUS_CONSTANT_COLOR, /**< 1 - blend constant */
	SRC_ALPHA_SATURATE, /**< min(source alpha, 1 - destination alpha) */
}


// Specifies which color components are written in a graphics pipeline.
//
// \since This datatype is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUColorComponentFlags :: bit_set[GPUColorComponentFlag]

GPUColorComponentFlag :: enum {
	R, /**< the red component */
	G, /**< the green component */
	B, /**< the blue component */
	A, /**< the alpha component */
}


// Specifies a filter operation used by a sampler.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUSampler

GPUFilter :: enum c.int {
	NEAREST, /**< Point filtering. */
	LINEAR, /**< Linear filtering. */
}


// Specifies a mipmap mode used by a sampler.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUSampler

GPUSamplerMipmapMode :: enum c.int {
	NEAREST, /**< Point filtering. */
	LINEAR, /**< Linear filtering. */
}


// Specifies behavior of texture sampling when the coordinates exceed the 0-1
// range.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_CreateGPUSampler

GPUSamplerAddressMode :: enum c.int {
	REPEAT, /**< Specifies that the coordinates will wrap around. */
	MIRRORED_REPEAT, /**< Specifies that the coordinates will wrap around mirrored. */
	CLAMP_TO_EDGE, /**< Specifies that the coordinates will clamp to the 0-1 range. */
}


// Specifies the timing that will be used to present swapchain textures to the
// OS.
//
// Note that this value affects the behavior of
// SDL_AcquireGPUSwapchainTexture. VSYNC mode will always be supported.
// IMMEDIATE and MAILBOX modes may not be supported on certain systems.
//
// It is recommended to query SDL_WindowSupportsGPUPresentMode after claiming
// the window if you wish to change the present mode to IMMEDIATE or MAILBOX.
//
// - VSYNC: Waits for vblank before presenting. No tearing is possible. If
//   there is a pending image to present, the new image is enqueued for
//   presentation. Disallows tearing at the cost of visual latency. When using
//   this present mode, AcquireGPUSwapchainTexture will block if too many
//   frames are in flight.
// - IMMEDIATE: Immediately presents. Lowest latency option, but tearing may
//   occur. When using this mode, AcquireGPUSwapchainTexture will return NULL
//   if too many frames are in flight.
// - MAILBOX: Waits for vblank before presenting. No tearing is possible. If
//   there is a pending image to present, the pending image is replaced by the
//   new image. Similar to VSYNC, but with reduced visual latency. When using
//   this mode, AcquireGPUSwapchainTexture will return NULL if too many frames
//   are in flight.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_SetGPUSwapchainParameters
// \sa SDL_WindowSupportsGPUPresentMode
// \sa SDL_AcquireGPUSwapchainTexture

GPUPresentMode :: enum c.int {
	VSYNC,
	IMMEDIATE,
	MAILBOX,
}


// Specifies the texture format and colorspace of the swapchain textures.
//
// SDR will always be supported. Other compositions may not be supported on
// certain systems.
//
// It is recommended to query SDL_WindowSupportsGPUSwapchainComposition after
// claiming the window if you wish to change the swapchain composition from
// SDR.
//
// - SDR: B8G8R8A8 or R8G8B8A8 swapchain. Pixel values are in nonlinear sRGB
//   encoding.
// - SDR_LINEAR: B8G8R8A8_SRGB or R8G8B8A8_SRGB swapchain. Pixel values are in
//   nonlinear sRGB encoding.
// - HDR_EXTENDED_LINEAR: R16G16B16A16_SFLOAT swapchain. Pixel values are in
//   extended linear encoding.
// - HDR10_ST2048: A2R10G10B10 or A2B10G10R10 swapchain. Pixel values are in
//   PQ ST2048 encoding.
//
// \since This enum is available since SDL 3.0.0
//
// \sa SDL_SetGPUSwapchainParameters
// \sa SDL_WindowSupportsGPUSwapchainComposition
// \sa SDL_AcquireGPUSwapchainTexture

GPUSwapchainComposition :: enum c.int {
	SDR,
	SDR_LINEAR,
	HDR_EXTENDED_LINEAR,
	HDR10_ST2048,
}

/* Structures */


// A structure specifying a viewport.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_SetGPUViewport

GPUViewport :: struct {
	x:         c.float, /**< The left offset of the viewport. */
	y:         c.float, /**< The top offset of the viewport. */
	w:         c.float, /**< The width of the viewport. */
	h:         c.float, /**< The height of the viewport. */
	min_depth: c.float, /**< The minimum depth of the viewport. */
	max_depth: c.float, /**< The maximum depth of the viewport. */
}


// A structure specifying parameters related to transferring data to or from a
// texture.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_UploadToGPUTexture
// \sa SDL_DownloadFromGPUTexture

GPUTextureTransferInfo :: struct {
	transfer_buffer: ^GPUTransferBuffer, /**< The transfer buffer used in the transfer operation. */
	offset:          c.uint32_t, /**< The starting byte of the image data in the transfer buffer. */
	pixels_per_row:  c.uint32_t, /**< The number of pixels from one row to the next. */
	rows_per_layer:  c.uint32_t, /**< The number of rows from one layer/depth-slice to the next. */
}


// A structure specifying a location in a transfer buffer.
//
// Used when transferring buffer data to or from a transfer buffer.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_UploadToGPUBuffer
// \sa SDL_DownloadFromGPUBuffer

GPUTransferBufferLocation :: struct {
	transfer_buffer: ^GPUTransferBuffer, /**< The transfer buffer used in the transfer operation. */
	offset:          c.uint32_t, /**< The starting byte of the buffer data in the transfer buffer. */
}


// A structure specifying a location in a texture.
//
// Used when copying data from one texture to another.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CopyGPUTextureToTexture

GPUTextureLocation :: struct {
	texture:   ^GPUTexture, /**< The texture used in the copy operation. */
	mip_level: c.uint32_t, /**< The mip level index of the location. */
	layer:     c.uint32_t, /**< The layer index of the location. */
	x:         c.uint32_t, /**< The left offset of the location. */
	y:         c.uint32_t, /**< The top offset of the location. */
	z:         c.uint32_t, /**< The front offset of the location. */
}


// A structure specifying a region of a texture.
//
// Used when transferring data to or from a texture.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_UploadToGPUTexture
// \sa SDL_DownloadFromGPUTexture

GPUTextureRegion :: struct {
	texture:   ^GPUTexture, /**< The texture used in the copy operation. */
	mip_level: c.uint32_t, /**< The mip level index to transfer. */
	layer:     c.uint32_t, /**< The layer index to transfer. */
	x:         c.uint32_t, /**< The left offset of the region. */
	y:         c.uint32_t, /**< The top offset of the region. */
	z:         c.uint32_t, /**< The front offset of the region. */
	w:         c.uint32_t, /**< The width of the region. */
	h:         c.uint32_t, /**< The height of the region. */
	d:         c.uint32_t, /**< The depth of the region. */
}


// A structure specifying a region of a texture used in the blit operation.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BlitGPUTexture

GPUBlitRegion :: struct {
	texture:              ^GPUTexture, /**< The texture. */
	mip_level:            c.uint32_t, /**< The mip level index of the region. */
	layer_or_depth_plane: c.uint32_t, /**< The layer index or depth plane of the region. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures. */
	x:                    c.uint32_t, /**< The left offset of the region. */
	y:                    c.uint32_t, /**< The top offset of the region.  */
	w:                    c.uint32_t, /**< The width of the region. */
	h:                    c.uint32_t, /**< The height of the region. */
}


// A structure specifying a location in a buffer.
//
// Used when copying data between buffers.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CopyGPUBufferToBuffer

GPUBufferLocation :: struct {
	buffer: ^GPUBuffer, /**< The buffer. */
	offset: c.uint32_t, /**< The starting byte within the buffer. */
}


// A structure specifying a region of a buffer.
//
// Used when transferring data to or from buffers.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_UploadToGPUBuffer
// \sa SDL_DownloadFromGPUBuffer

GPUBufferRegion :: struct {
	buffer: ^GPUBuffer, /**< The buffer. */
	offset: c.uint32_t, /**< The starting byte within the buffer. */
	size:   c.uint32_t, /**< The size in bytes of the region. */
}


// A structure specifying the parameters of an indirect draw command.
//
// Note that the `first_vertex` and `first_instance` parameters are NOT
// compatible with built-in vertex/instance ID variables in shaders (for
// example, SV_VertexID). If your shader depends on these variables, the
// correlating draw call parameter MUST be 0.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_DrawGPUPrimitivesIndirect

GPUIndirectDrawCommand :: struct {
	num_vertices:   c.uint32_t, /**< The number of vertices to draw. */
	num_instances:  c.uint32_t, /**< The number of instances to draw. */
	first_vertex:   c.uint32_t, /**< The index of the first vertex to draw. */
	first_instance: c.uint32_t, /**< The ID of the first instance to draw. */
}


// A structure specifying the parameters of an indexed indirect draw command.
//
// Note that the `first_vertex` and `first_instance` parameters are NOT
// compatible with built-in vertex/instance ID variables in shaders (for
// example, SV_VertexID). If your shader depends on these variables, the
// correlating draw call parameter MUST be 0.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_DrawGPUIndexedPrimitivesIndirect

GPUIndexedIndirectDrawCommand :: struct {
	num_indices:    c.uint32_t, /**< The number of indices to draw per instance. */
	num_instances:  c.uint32_t, /**< The number of instances to draw. */
	first_index:    c.uint32_t, /**< The base index within the index buffer. */
	vertex_offset:  c.int32_t, /**< The value added to the vertex index before indexing into the vertex buffer. */
	first_instance: c.uint32_t, /**< The ID of the first instance to draw. */
}


// A structure specifying the parameters of an indexed dispatch command.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_DispatchGPUComputeIndirect

GPUIndirectDispatchCommand :: struct {
	groupcount_x: c.uint32_t, /**< The number of local workgroups to dispatch in the X dimension. */
	groupcount_y: c.uint32_t, /**< The number of local workgroups to dispatch in the Y dimension. */
	groupcount_z: c.uint32_t, /**< The number of local workgroups to dispatch in the Z dimension. */
}

/* State structures */


// A structure specifying the parameters of a sampler.
//
// \since This function is available since SDL 3.0.0
//
// \sa SDL_CreateGPUSampler

GPUSamplerCreateInfo :: struct {
	min_filter:        GPUFilter, /**< The minification filter to apply to lookups. */
	mag_filter:        GPUFilter, /**< The magnification filter to apply to lookups. */
	mipmap_mode:       GPUSamplerMipmapMode, /**< The mipmap filter to apply to lookups. */
	address_mode_u:    GPUSamplerAddressMode, /**< The addressing mode for U coordinates outside [0, 1). */
	address_mode_v:    GPUSamplerAddressMode, /**< The addressing mode for V coordinates outside [0, 1). */
	address_mode_w:    GPUSamplerAddressMode, /**< The addressing mode for W coordinates outside [0, 1). */
	mip_lod_bias:      c.float, /**< The bias to be added to mipmap LOD calculation. */
	max_anisotropy:    c.float, /**< The anisotropy value clamp used by the sampler. If enable_anisotropy is false, this is ignored. */
	compare_op:        GPUCompareOp, /**< The comparison operator to apply to fetched data before filtering. */
	min_lod:           c.float, /**< Clamps the minimum of the computed LOD value. */
	max_lod:           c.float, /**< Clamps the maximum of the computed LOD value. */
	enable_anisotropy: c.bool, /**< true to enable anisotropic filtering. */
	enable_compare:    c.bool, /**< true to enable comparison against a reference value during lookups. */
	padding1:          c.uint8_t,
	padding2:          c.uint8_t,
	props:             PropertiesID, /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}


// A structure specifying the parameters of vertex buffers used in a graphics
// pipeline.
//
// When you call SDL_BindGPUVertexBuffers, you specify the binding slots of
// the vertex buffers. For example if you called SDL_BindGPUVertexBuffers with
// a first_slot of 2 and num_bindings of 3, the binding slots 2, 3, 4 would be
// used by the vertex buffers you pass in.
//
// Vertex attributes are linked to buffers via the buffer_slot field of
// GPUVertexAttribute. For example, if an attribute has a buffer_slot of
// 0, then that attribute belongs to the vertex buffer bound at slot 0.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUVertexAttribute
// \sa GPUVertexInputState

GPUVertexBufferDescription :: struct {
	slot:               c.uint32_t, /**< The binding slot of the vertex buffer. */
	pitch:              c.uint32_t, /**< The byte pitch between consecutive elements of the vertex buffer. */
	input_rate:         GPUVertexInputRate, /**< Whether attribute addressing is a function of the vertex index or instance index. */
	instance_step_rate: c.uint32_t, /**< The number of instances to draw using the same per-instance data before advancing in the instance buffer by one element. Ignored unless input_rate is GPU_VERTEXINPUTRATE_INSTANCE */
}


// A structure specifying a vertex attribute.
//
// All vertex attribute locations provided to an GPUVertexInputState must
// be unique.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUVertexBufferDescription
// \sa GPUVertexInputState

GPUVertexAttribute :: struct {
	location:    c.uint32_t, /**< The shader input location index. */
	buffer_slot: c.uint32_t, /**< The binding slot of the associated vertex buffer. */
	format:      GPUVertexElementFormat, /**< The size and type of the attribute data. */
	offset:      c.uint32_t, /**< The byte offset of this attribute relative to the start of the vertex element. */
}


// A structure specifying the parameters of a graphics pipeline vertex input
// state.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUGraphicsPipelineCreateInfo

GPUVertexInputState :: struct {
	vertex_buffer_descriptions: ^GPUVertexBufferDescription, /**< A pointer to an array of vertex buffer descriptions. */
	num_vertex_buffers:         c.uint32_t, /**< The number of vertex buffer descriptions in the above array. */
	vertex_attributes:          ^GPUVertexAttribute, /**< A pointer to an array of vertex attribute descriptions. */
	num_vertex_attributes:      c.uint32_t, /**< The number of vertex attribute descriptions in the above array. */
}


// A structure specifying the stencil operation state of a graphics pipeline.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUDepthStencilState

GPUStencilOpState :: struct {
	fail_op:       GPUStencilOp, /**< The action performed on samples that fail the stencil test. */
	pass_op:       GPUStencilOp, /**< The action performed on samples that pass the depth and stencil tests. */
	depth_fail_op: GPUStencilOp, /**< The action performed on samples that pass the stencil test and fail the depth test. */
	compare_op:    GPUCompareOp, /**< The comparison operator used in the stencil test. */
}


// A structure specifying the blend state of a color target.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUColorTargetDescription

GPUColorTargetBlendState :: struct {
	src_color_blendfactor:   GPUBlendFactor, /**< The value to be multiplied by the source RGB value. */
	dst_color_blendfactor:   GPUBlendFactor, /**< The value to be multiplied by the destination RGB value. */
	color_blend_op:          GPUBlendOp, /**< The blend operation for the RGB components. */
	src_alpha_blendfactor:   GPUBlendFactor, /**< The value to be multiplied by the source alpha. */
	dst_alpha_blendfactor:   GPUBlendFactor, /**< The value to be multiplied by the destination alpha. */
	alpha_blend_op:          GPUBlendOp, /**< The blend operation for the alpha component. */
	color_write_mask:        GPUColorComponentFlags, /**< A bitmask specifying which of the RGBA components are enabled for writing. Writes to all channels if enable_color_write_mask is false. */
	enable_blend:            c.bool, /**< Whether blending is enabled for the color target. */
	enable_color_write_mask: c.bool, /**< Whether the color write mask is enabled. */
	padding1:                c.uint8_t,
	padding2:                c.uint8_t,
}


// A structure specifying code and metadata for creating a shader object.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUShader

GPUShaderCreateInfo :: struct {
	code_size:            c.size_t, /**< The size in bytes of the code pointed to. */
	code:                 cstring, /**< A pointer to shader code. */
	entrypoint:           cstring, /**< A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader. */
	format:               GPUShaderFormat, /**< The format of the shader code. */
	stage:                GPUShaderStage, /**< The stage the shader program corresponds to. */
	num_samplers:         c.uint32_t, /**< The number of samplers defined in the shader. */
	num_storage_textures: c.uint32_t, /**< The number of storage textures defined in the shader. */
	num_storage_buffers:  c.uint32_t, /**< The number of storage buffers defined in the shader. */
	num_uniform_buffers:  c.uint32_t, /**< The number of uniform buffers defined in the shader. */
	props:                PropertiesID, /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}


// A structure specifying the parameters of a texture.
//
// Usage flags can be bitwise OR'd together for combinations of usages. Note
// that certain usage combinations are invalid, for example SAMPLER and
// GRAPHICS_STORAGE.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUTexture

GPUTextureCreateInfo :: struct {
	type:                 GPUTextureType, /**< The base dimensionality of the texture. */
	format:               GPUTextureFormat, /**< The pixel format of the texture. */
	usage:                GPUTextureUsageFlags, /**< How the texture is intended to be used by the client. */
	width:                c.uint32_t, /**< The width of the texture. */
	height:               c.uint32_t, /**< The height of the texture. */
	layer_count_or_depth: c.uint32_t, /**< The layer count or depth of the texture. This value is treated as a layer count on 2D array textures, and as a depth value on 3D textures. */
	num_levels:           c.uint32_t, /**< The number of mip levels in the texture. */
	sample_count:         GPUSampleCount, /**< The number of samples per texel. Only applies if the texture is used as a render target. */
	props:                PropertiesID, /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}

PROP_GPU_CREATETEXTURE_D3D12_CLEAR_R_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.r"
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_G_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.g"
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_B_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.b"
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_A_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.a"
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_DEPTH_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.depth"
PROP_GPU_CREATETEXTURE_D3D12_CLEAR_STENCIL_UINT8 :: "SDL.gpu.createtexture.d3d12.clear.stencil"


// A structure specifying the parameters of a buffer.
//
// Usage flags can be bitwise OR'd together for combinations of usages. Note
// that certain combinations are invalid, for example VERTEX and INDEX.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUBuffer

GPUBufferCreateInfo :: struct {
	usage: GPUBufferUsageFlags, /**< How the buffer is intended to be used by the client. */
	size:  c.uint32_t, /**< The size in bytes of the buffer. */
	props: PropertiesID, /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}


// A structure specifying the parameters of a transfer buffer.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUTransferBuffer

GPUTransferBufferCreateInfo :: struct {
	usage: GPUTransferBufferUsage, /**< How the transfer buffer is intended to be used by the client. */
	size:  c.uint32_t, /**< The size in bytes of the transfer buffer. */
	props: PropertiesID, /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}

/* Pipeline state structures */


// A structure specifying the parameters of the graphics pipeline rasterizer
// state.
//
// NOTE: Some backend APIs (D3D11/12) will enable depth clamping even if
// enable_depth_clip is true. If you rely on this clamp+clip behavior,
// consider enabling depth clip and then manually clamping depth in your
// fragment shaders on Metal and Vulkan.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUGraphicsPipelineCreateInfo

GPURasterizerState :: struct {
	fill_mode:                  GPUFillMode, /**< Whether polygons will be filled in or drawn as lines. */
	cull_mode:                  GPUCullMode, /**< The facing direction in which triangles will be culled. */
	front_face:                 GPUFrontFace, /**< The vertex winding that will cause a triangle to be determined as front-facing. */
	depth_bias_constant_factor: c.float, /**< A scalar factor controlling the depth value added to each fragment. */
	depth_bias_clamp:           c.float, /**< The maximum depth bias of a fragment. */
	depth_bias_slope_factor:    c.float, /**< A scalar factor applied to a fragment's slope in depth calculations. */
	enable_depth_bias:          c.bool, /**< true to bias fragment depth values. */
	enable_depth_clip:          c.bool, /**< true to enable depth clip, false to enable depth clamp. */
	padding1:                   c.uint8_t,
	padding2:                   c.uint8_t,
}


// A structure specifying the parameters of the graphics pipeline multisample
// state.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUGraphicsPipelineCreateInfo

GPUMultisampleState :: struct {
	sample_count: GPUSampleCount, /**< The number of samples to be used in rasterization. */
	sample_mask:  c.uint32_t, /**< Determines which samples get updated in the render targets. Treated as 0xFFFFFFFF if enable_mask is false. */
	enable_mask:  c.bool, /**< Enables sample masking. */
	padding1:     c.uint8_t,
	padding2:     c.uint8_t,
	padding3:     c.uint8_t,
}


// A structure specifying the parameters of the graphics pipeline depth
// stencil state.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUGraphicsPipelineCreateInfo

GPUDepthStencilState :: struct {
	compare_op:          GPUCompareOp, /**< The comparison operator used for depth testing. */
	back_stencil_state:  GPUStencilOpState, /**< The stencil op state for back-facing triangles. */
	front_stencil_state: GPUStencilOpState, /**< The stencil op state for front-facing triangles. */
	compare_mask:        c.uint8_t, /**< Selects the bits of the stencil values participating in the stencil test. */
	write_mask:          c.uint8_t, /**< Selects the bits of the stencil values updated by the stencil test. */
	enable_depth_test:   c.bool, /**< true enables the depth test. */
	enable_depth_write:  c.bool, /**< true enables depth writes. Depth writes are always disabled when enable_depth_test is false. */
	enable_stencil_test: c.bool, /**< true enables the stencil test. */
	padding1:            c.uint8_t,
	padding2:            c.uint8_t,
	padding3:            c.uint8_t,
}


// A structure specifying the parameters of color targets used in a graphics
// pipeline.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUGraphicsPipelineTargetInfo

GPUColorTargetDescription :: struct {
	format:      GPUTextureFormat, /**< The pixel format of the texture to be used as a color target. */
	blend_state: GPUColorTargetBlendState, /**< The blend state to be used for the color target. */
}


// A structure specifying the descriptions of render targets used in a
// graphics pipeline.
//
// \since This struct is available since SDL 3.0.0
//
// \sa GPUGraphicsPipelineCreateInfo

GPUGraphicsPipelineTargetInfo :: struct {
	color_target_descriptions: ^GPUColorTargetDescription, /**< A pointer to an array of color target descriptions. */
	num_color_targets:         c.uint32_t, /**< The number of color target descriptions in the above array. */
	depth_stencil_format:      GPUTextureFormat, /**< The pixel format of the depth-stencil target. Ignored if has_depth_stencil_target is false. */
	has_depth_stencil_target:  c.bool, /**< true specifies that the pipeline uses a depth-stencil target. */
	padding1:                  c.uint8_t,
	padding2:                  c.uint8_t,
	padding3:                  c.uint8_t,
}


// A structure specifying the parameters of a graphics pipeline state.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUGraphicsPipeline

GPUGraphicsPipelineCreateInfo :: struct {
	vertex_shader:       ^GPUShader, /**< The vertex shader used by the graphics pipeline. */
	fragment_shader:     ^GPUShader, /**< The fragment shader used by the graphics pipeline. */
	vertex_input_state:  GPUVertexInputState, /**< The vertex layout of the graphics pipeline. */
	primitive_type:      GPUPrimitiveType, /**< The primitive topology of the graphics pipeline. */
	rasterizer_state:    GPURasterizerState, /**< The rasterizer state of the graphics pipeline. */
	multisample_state:   GPUMultisampleState, /**< The multisample state of the graphics pipeline. */
	depth_stencil_state: GPUDepthStencilState, /**< The depth-stencil state of the graphics pipeline. */
	target_info:         GPUGraphicsPipelineTargetInfo, /**< Formats and blend modes for the render targets of the graphics pipeline. */
	props:               PropertiesID, /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}


// A structure specifying the parameters of a compute pipeline state.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_CreateGPUComputePipeline

GPUComputePipelineCreateInfo :: struct {
	code_size:                      c.size_t, /**< The size in bytes of the compute shader code pointed to. */
	code:                           cstring, /**< A pointer to compute shader code. */
	entrypoint:                     cstring, /**< A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader. */
	format:                         GPUShaderFormat, /**< The format of the compute shader code. */
	num_samplers:                   c.uint32_t, /**< The number of samplers defined in the shader. */
	num_readonly_storage_textures:  c.uint32_t, /**< The number of readonly storage textures defined in the shader. */
	num_readonly_storage_buffers:   c.uint32_t, /**< The number of readonly storage buffers defined in the shader. */
	num_readwrite_storage_textures: c.uint32_t, /**< The number of read-write storage textures defined in the shader. */
	num_readwrite_storage_buffers:  c.uint32_t, /**< The number of read-write storage buffers defined in the shader. */
	num_uniform_buffers:            c.uint32_t, /**< The number of uniform buffers defined in the shader. */
	threadcount_x:                  c.uint32_t, /**< The number of threads in the X dimension. This should match the value in the shader. */
	threadcount_y:                  c.uint32_t, /**< The number of threads in the Y dimension. This should match the value in the shader. */
	threadcount_z:                  c.uint32_t, /**< The number of threads in the Z dimension. This should match the value in the shader. */
	props:                          PropertiesID, /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}


// A structure specifying the parameters of a color target used by a render
// pass.
//
// The load_op field determines what is done with the texture at the beginning
// of the render pass.
//
// - LOAD: Loads the data currently in the texture. Not recommended for
//   multisample textures as it requires significant memory bandwidth.
// - CLEAR: Clears the texture to a single color.
// - DONT_CARE: The driver will do whatever it wants with the texture memory.
//   This is a good option if you know that every single pixel will be touched
//   in the render pass.
//
// The store_op field determines what is done with the color results of the
// render pass.
//
// - STORE: Stores the results of the render pass in the texture. Not
//   recommended for multisample textures as it requires significant memory
//   bandwidth.
// - DONT_CARE: The driver will do whatever it wants with the texture memory.
//   This is often a good option for depth/stencil textures.
// - RESOLVE: Resolves a multisample texture into resolve_texture, which must
//   have a sample count of 1. Then the driver may discard the multisample
//   texture memory. This is the most performant method of resolving a
//   multisample target.
// - RESOLVE_AND_STORE: Resolves a multisample texture into the
//   resolve_texture, which must have a sample count of 1. Then the driver
//   stores the multisample texture's contents. Not recommended as it requires
//   significant memory bandwidth.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BeginGPURenderPass

GPUColorTargetInfo :: struct {
	texture:               ^GPUTexture, /**< The texture that will be used as a color target by a render pass. */
	mip_level:             c.uint32_t, /**< The mip level to use as a color target. */
	layer_or_depth_plane:  c.uint32_t, /**< The layer index or depth plane to use as a color target. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures. */
	clear_color:           FColor, /**< The color to clear the color target to at the start of the render pass. Ignored if GPU_LOADOP_CLEAR is not used. */
	load_op:               GPULoadOp, /**< What is done with the contents of the color target at the beginning of the render pass. */
	store_op:              GPUStoreOp, /**< What is done with the results of the render pass. */
	resolve_texture:       ^GPUTexture, /**< The texture that will receive the results of a multisample resolve operation. Ignored if a RESOLVE* store_op is not used. */
	resolve_mip_level:     c.uint32_t, /**< The mip level of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used. */
	resolve_layer:         c.uint32_t, /**< The layer index of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used. */
	cycle:                 c.bool, /**< true cycles the texture if the texture is bound and load_op is not LOAD */
	cycle_resolve_texture: c.bool, /**< true cycles the resolve texture if the resolve texture is bound. Ignored if a RESOLVE* store_op is not used. */
	padding1:              c.uint8_t,
	padding2:              c.uint8_t,
}


// A structure specifying the parameters of a depth-stencil target used by a
// render pass.
//
// The load_op field determines what is done with the depth contents of the
// texture at the beginning of the render pass.
//
// - LOAD: Loads the depth values currently in the texture.
// - CLEAR: Clears the texture to a single depth.
// - DONT_CARE: The driver will do whatever it wants with the memory. This is
//   a good option if you know that every single pixel will be touched in the
//   render pass.
//
// The store_op field determines what is done with the depth results of the
// render pass.
//
// - STORE: Stores the depth results in the texture.
// - DONT_CARE: The driver will do whatever it wants with the depth results.
//   This is often a good option for depth/stencil textures that don't need to
//   be reused again.
//
// The stencil_load_op field determines what is done with the stencil contents
// of the texture at the beginning of the render pass.
//
// - LOAD: Loads the stencil values currently in the texture.
// - CLEAR: Clears the stencil values to a single value.
// - DONT_CARE: The driver will do whatever it wants with the memory. This is
//   a good option if you know that every single pixel will be touched in the
//   render pass.
//
// The stencil_store_op field determines what is done with the stencil results
// of the render pass.
//
// - STORE: Stores the stencil results in the texture.
// - DONT_CARE: The driver will do whatever it wants with the stencil results.
//   This is often a good option for depth/stencil textures that don't need to
//   be reused again.
//
// Note that depth/stencil targets do not support multisample resolves.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BeginGPURenderPass

GPUDepthStencilTargetInfo :: struct {
	texture:          ^GPUTexture, /**< The texture that will be used as the depth stencil target by the render pass. */
	clear_depth:      c.float, /**< The value to clear the depth component to at the beginning of the render pass. Ignored if GPU_LOADOP_CLEAR is not used. */
	load_op:          GPULoadOp, /**< What is done with the depth contents at the beginning of the render pass. */
	store_op:         GPUStoreOp, /**< What is done with the depth results of the render pass. */
	stencil_load_op:  GPULoadOp, /**< What is done with the stencil contents at the beginning of the render pass. */
	stencil_store_op: GPUStoreOp, /**< What is done with the stencil results of the render pass. */
	cycle:            c.bool, /**< true cycles the texture if the texture is bound and any load ops are not LOAD */
	clear_stencil:    c.uint8_t, /**< The value to clear the stencil component to at the beginning of the render pass. Ignored if GPU_LOADOP_CLEAR is not used. */
	padding1:         c.uint8_t,
	padding2:         c.uint8_t,
}


// A structure containing parameters for a blit command.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BlitGPUTexture

GPUBlitInfo :: struct {
	source:      GPUBlitRegion, /**< The source region for the blit. */
	destination: GPUBlitRegion, /**< The destination region for the blit. */
	load_op:     GPULoadOp, /**< What is done with the contents of the destination before the blit. */
	clear_color: FColor, /**< The color to clear the destination region to before the blit. Ignored if load_op is not GPU_LOADOP_CLEAR. */
	flip_mode:   FlipMode, /**< The flip mode for the source region. */
	filter:      GPUFilter, /**< The filter mode used when blitting. */
	cycle:       c.bool, /**< true cycles the destination texture if it is already bound. */
	padding1:    c.uint8_t,
	padding2:    c.uint8_t,
	padding3:    c.uint8_t,
}

/* Binding structs */


// A structure specifying parameters in a buffer binding call.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BindGPUVertexBuffers
// \sa SDL_BindGPUIndexBuffers

GPUBufferBinding :: struct {
	buffer: ^GPUBuffer, /**< The buffer to bind. Must have been created with GPU_BUFFERUSAGE_VERTEX for SDL_BindGPUVertexBuffers, or GPU_BUFFERUSAGE_INDEX for SDL_BindGPUIndexBuffers. */
	offset: c.uint32_t, /**< The starting byte of the data to bind in the buffer. */
}


// A structure specifying parameters in a sampler binding call.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BindGPUVertexSamplers
// \sa SDL_BindGPUFragmentSamplers

GPUTextureSamplerBinding :: struct {
	texture: ^GPUTexture, /**< The texture to bind. Must have been created with GPU_TEXTUREUSAGE_SAMPLER. */
	sampler: ^GPUSampler, /**< The sampler to bind. */
}


// A structure specifying parameters related to binding buffers in a compute
// pass.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BeginGPUComputePass

GPUStorageBufferReadWriteBinding :: struct {
	buffer:   ^GPUBuffer, /**< The buffer to bind. Must have been created with GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE. */
	cycle:    c.bool, /**< true cycles the buffer if it is already bound. */
	padding1: c.uint8_t,
	padding2: c.uint8_t,
	padding3: c.uint8_t,
}


// A structure specifying parameters related to binding textures in a compute
// pass.
//
// \since This struct is available since SDL 3.0.0
//
// \sa SDL_BeginGPUComputePass

GPUStorageTextureReadWriteBinding :: struct {
	texture:   ^GPUTexture, /**< The texture to bind. Must have been created with GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE or GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE. */
	mip_level: c.uint32_t, /**< The mip level index to bind. */
	layer:     c.uint32_t, /**< The layer index to bind. */
	cycle:     c.bool, /**< true cycles the texture if it is already bound. */
	padding1:  c.uint8_t,
	padding2:  c.uint8_t,
	padding3:  c.uint8_t,
}

PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOL :: "SDL.gpu.device.create.debugmode"
PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOL :: "SDL.gpu.device.create.preferlowpower"
PROP_GPU_DEVICE_CREATE_NAME_STRING :: "SDL.gpu.device.create.name"
PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOL :: "SDL.gpu.device.create.shaders.private"
PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOL :: "SDL.gpu.device.create.shaders.spirv"
PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOL :: "SDL.gpu.device.create.shaders.dxbc"
PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOL :: "SDL.gpu.device.create.shaders.dxil"
PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOL :: "SDL.gpu.device.create.shaders.msl"
PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOL :: "SDL.gpu.device.create.shaders.metallib"
PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING :: "SDL.gpu.device.create.d3d12.semantic"

/* Functions */


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	/* Device */


	// Checks for GPU runtime support.
	//
	// \param format_flags a bitflag indicating which shader formats the app is
	//                     able to provide.
	// \param name the preferred GPU driver, or NULL to let SDL pick the optimal
	//             driver.
	// \returns true if supported, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateGPUDevice

	GPUSupportsShaderFormats :: proc(format_flags: GPUShaderFormat, name: cstring) -> c.bool ---


	// Checks for GPU runtime support.
	//
	// \param props the properties to use.
	// \returns true if supported, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateGPUDeviceWithProperties

	GPUSupportsProperties :: proc(props: PropertiesID) -> c.bool ---


	// Creates a GPU context.
	//
	// \param format_flags a bitflag indicating which shader formats the app is
	//                     able to provide.
	// \param debug_mode enable debug mode properties and validations.
	// \param name the preferred GPU driver, or NULL to let SDL pick the optimal
	//             driver.
	// \returns a GPU context on success or NULL on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetGPUShaderFormats
	// \sa GetGPUDeviceDriver
	// \sa DestroyGPUDevice
	// \sa GPUSupportsShaderFormats

	CreateGPUDevice :: proc(format_flags: GPUShaderFormat, debug_mode: c.bool, name: cstring) -> ^GPUDevice ---


	// Creates a GPU context.
	//
	// These are the supported properties:
	//
	// - `PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOL`: enable debug mode properties
	//   and validations, defaults to true.
	// - `PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOL`: enable to prefer energy
	//   efficiency over maximum GPU performance, defaults to false.
	// - `PROP_GPU_DEVICE_CREATE_NAME_STRING`: the name of the GPU driver to
	//   use, if a specific one is desired.
	//
	// These are the current shader format properties:
	//
	// - `PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOL`: The app is able to
	//   provide shaders for an NDA platform.
	// - `PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOL`: The app is able to
	//   provide SPIR-V shaders if applicable.
	// - PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOL`: The app is able to provide
	//   DXBC shaders if applicable
	//   `PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOL`: The app is able to
	//   provide DXIL shaders if applicable.
	// - `PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOL`: The app is able to provide
	//   MSL shaders if applicable.
	// - `PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOL`: The app is able to
	//   provide Metal shader libraries if applicable.
	//
	// With the D3D12 renderer:
	//
	// - `PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING`: the prefix to
	//   use for all vertex semantics, default is "TEXCOORD".
	//
	// \param props the properties to use.
	// \returns a GPU context on success or NULL on failure; call GetError()
	//          for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetGPUShaderFormats
	// \sa GetGPUDeviceDriver
	// \sa DestroyGPUDevice
	// \sa GPUSupportsProperties

	CreateGPUDeviceWithProperties :: proc(props: PropertiesID) -> ^GPUDevice ---


	// Destroys a GPU context previously returned by CreateGPUDevice.
	//
	// \param device a GPU Context to destroy.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateGPUDevice

	DestroyGPUDevice :: proc(device: ^GPUDevice) ---


	// Get the number of GPU drivers compiled into SDL.
	//
	// \returns the number of built in GPU drivers.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetGPUDriver

	GetNumGPUDrivers :: proc() -> c.int ---


	// Get the name of a built in GPU driver.
	//
	// The GPU drivers are presented in the order in which they are normally
	// checked during initialization.
	//
	// The names of drivers are all simple, low-ASCII identifiers, like "vulkan",
	// "metal" or "direct3d12". These never have Unicode characters, and are not
	// meant to be proper names.
	//
	// \param index the index of a GPU driver.
	// \returns the name of the GPU driver with the given **index**.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetNumGPUDrivers

	GetGPUDriver :: proc(index: c.int) -> cstring ---


	// Returns the name of the backend used to create this GPU context.
	//
	// \param device a GPU context to query.
	// \returns the name of the device's driver, or NULL on error.
	//
	// \since This function is available since SDL 3.0.0.

	GetGPUDeviceDriver :: proc(device: ^GPUDevice) -> cstring ---


	// Returns the supported shader formats for this GPU context.
	//
	// \param device a GPU context to query.
	// \returns a bitflag indicating which shader formats the driver is able to
	//          consume.
	//
	// \since This function is available since SDL 3.0.0.

	GetGPUShaderFormats :: proc(device: ^GPUDevice) -> GPUShaderFormat ---

	/* State Creation */


	// Creates a pipeline object to be used in a compute workflow.
	//
	// Shader resource bindings must be authored to follow a particular order
	// depending on the shader format.
	//
	// For SPIR-V shaders, use the following resource sets:
	//
	// - 0: Sampled textures, followed by read-only storage textures, followed by
	//   read-only storage buffers
	// - 1: Write-only storage textures, followed by write-only storage buffers
	// - 2: Uniform buffers
	//
	// For DXBC Shader Model 5_0 shaders, use the following register order:
	//
	// - t registers: Sampled textures, followed by read-only storage textures,
	//   followed by read-only storage buffers
	// - u registers: Write-only storage textures, followed by write-only storage
	//   buffers
	// - b registers: Uniform buffers
	//
	// For DXIL shaders, use the following register order:
	//
	// - (t[n], space0): Sampled textures, followed by read-only storage textures,
	//   followed by read-only storage buffers
	// - (u[n], space1): Write-only storage textures, followed by write-only
	//   storage buffers
	// - (b[n], space2): Uniform buffers
	//
	// For MSL/metallib, use the following order:
	//
	// - [[buffer]]: Uniform buffers, followed by write-only storage buffers,
	//   followed by write-only storage buffers
	// - [[texture]]: Sampled textures, followed by read-only storage textures,
	//   followed by write-only storage textures
	//
	// \param device a GPU Context.
	// \param createinfo a struct describing the state of the compute pipeline to
	//                   create.
	// \returns a compute pipeline object on success, or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa BindGPUComputePipeline
	// \sa ReleaseGPUComputePipeline

	CreateGPUComputePipeline :: proc(device: ^GPUDevice, createinfo: ^GPUComputePipelineCreateInfo) -> ^GPUComputePipeline ---


	// Creates a pipeline object to be used in a graphics workflow.
	//
	// \param device a GPU Context.
	// \param createinfo a struct describing the state of the graphics pipeline to
	//                   create.
	// \returns a graphics pipeline object on success, or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateGPUShader
	// \sa BindGPUGraphicsPipeline
	// \sa ReleaseGPUGraphicsPipeline

	CreateGPUGraphicsPipeline :: proc(device: ^GPUDevice, createinfo: ^GPUGraphicsPipelineCreateInfo) -> ^GPUGraphicsPipeline ---


	// Creates a sampler object to be used when binding textures in a graphics
	// workflow.
	//
	// \param device a GPU Context.
	// \param createinfo a struct describing the state of the sampler to create.
	// \returns a sampler object on success, or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa BindGPUVertexSamplers
	// \sa BindGPUFragmentSamplers
	// \sa ReleaseSampler

	CreateGPUSampler :: proc(device: ^GPUDevice, createinfo: ^GPUSamplerCreateInfo) -> ^GPUSampler ---


	// Creates a shader to be used when creating a graphics pipeline.
	//
	// Shader resource bindings must be authored to follow a particular order
	// depending on the shader format.
	//
	// For SPIR-V shaders, use the following resource sets:
	//
	// For vertex shaders:
	//
	// - 0: Sampled textures, followed by storage textures, followed by storage
	//   buffers
	// - 1: Uniform buffers
	//
	// For fragment shaders:
	//
	// - 2: Sampled textures, followed by storage textures, followed by storage
	//   buffers
	// - 3: Uniform buffers
	//
	// For DXBC Shader Model 5_0 shaders, use the following register order:
	//
	// - t registers: Sampled textures, followed by storage textures, followed by
	//   storage buffers
	// - s registers: Samplers with indices corresponding to the sampled textures
	// - b registers: Uniform buffers
	//
	// For DXIL shaders, use the following register order:
	//
	// For vertex shaders:
	//
	// - (t[n], space0): Sampled textures, followed by storage textures, followed
	//   by storage buffers
	// - (s[n], space0): Samplers with indices corresponding to the sampled
	//   textures
	// - (b[n], space1): Uniform buffers
	//
	// For pixel shaders:
	//
	// - (t[n], space2): Sampled textures, followed by storage textures, followed
	//   by storage buffers
	// - (s[n], space2): Samplers with indices corresponding to the sampled
	//   textures
	// - (b[n], space3): Uniform buffers
	//
	// For MSL/metallib, use the following order:
	//
	// - [[texture]]: Sampled textures, followed by storage textures
	// - [[sampler]]: Samplers with indices corresponding to the sampled textures
	// - [[buffer]]: Uniform buffers, followed by storage buffers. Vertex buffer 0
	//   is bound at [[buffer(14)]], vertex buffer 1 at [[buffer(15)]], and so on.
	//   Rather than manually authoring vertex buffer indices, use the
	//   [[stage_in]] attribute which will automatically use the vertex input
	//   information from the GPUPipeline.
	//
	// \param device a GPU Context.
	// \param createinfo a struct describing the state of the shader to create.
	// \returns a shader object on success, or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateGPUGraphicsPipeline
	// \sa ReleaseGPUShader

	CreateGPUShader :: proc(device: ^GPUDevice, createinfo: ^GPUShaderCreateInfo) -> ^GPUShader ---


	// Creates a texture object to be used in graphics or compute workflows.
	//
	// The contents of this texture are undefined until data is written to the
	// texture.
	//
	// Note that certain combinations of usage flags are invalid. For example, a
	// texture cannot have both the SAMPLER and GRAPHICS_STORAGE_READ flags.
	//
	// If you request a sample count higher than the hardware supports, the
	// implementation will automatically fall back to the highest available sample
	// count.
	//
	// \param device a GPU Context.
	// \param createinfo a struct describing the state of the texture to create.
	// \returns a texture object on success, or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa UploadToGPUTexture
	// \sa DownloadFromGPUTexture
	// \sa BindGPUVertexSamplers
	// \sa BindGPUVertexStorageTextures
	// \sa BindGPUFragmentSamplers
	// \sa BindGPUFragmentStorageTextures
	// \sa BindGPUComputeStorageTextures
	// \sa BlitGPUTexture
	// \sa ReleaseGPUTexture
	// \sa GPUTextureSupportsFormat

	CreateGPUTexture :: proc(device: ^GPUDevice, createinfo: ^GPUTextureCreateInfo) -> ^GPUTexture ---


	// Creates a buffer object to be used in graphics or compute workflows.
	//
	// The contents of this buffer are undefined until data is written to the
	// buffer.
	//
	// Note that certain combinations of usage flags are invalid. For example, a
	// buffer cannot have both the VERTEX and INDEX flags.
	//
	// \param device a GPU Context.
	// \param createinfo a struct describing the state of the buffer to create.
	// \returns a buffer object on success, or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetGPUBufferName
	// \sa UploadToGPUBuffer
	// \sa DownloadFromGPUBuffer
	// \sa CopyGPUBufferToBuffer
	// \sa BindGPUVertexBuffers
	// \sa BindGPUIndexBuffer
	// \sa BindGPUVertexStorageBuffers
	// \sa BindGPUFragmentStorageBuffers
	// \sa DrawGPUPrimitivesIndirect
	// \sa DrawGPUIndexedPrimitivesIndirect
	// \sa BindGPUComputeStorageBuffers
	// \sa DispatchGPUComputeIndirect
	// \sa ReleaseGPUBuffer

	CreateGPUBuffer :: proc(device: ^GPUDevice, createinfo: ^GPUBufferCreateInfo) -> ^GPUBuffer ---


	// Creates a transfer buffer to be used when uploading to or downloading from
	// graphics resources.
	//
	// \param device a GPU Context.
	// \param createinfo a struct describing the state of the transfer buffer to
	//                   create.
	// \returns a transfer buffer on success, or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa UploadToGPUBuffer
	// \sa DownloadFromGPUBuffer
	// \sa UploadToGPUTexture
	// \sa DownloadFromGPUTexture
	// \sa ReleaseGPUTransferBuffer

	CreateGPUTransferBuffer :: proc(device: ^GPUDevice, createinfo: ^GPUTransferBufferCreateInfo) -> ^GPUTransferBuffer ---

	/* Debug Naming */


	// Sets an arbitrary string constant to label a buffer.
	//
	// Useful for debugging.
	//
	// \param device a GPU Context.
	// \param buffer a buffer to attach the name to.
	// \param text a UTF-8 string constant to mark as the name of the buffer.
	//
	// \since This function is available since SDL 3.0.0.

	SetGPUBufferName :: proc(device: ^GPUDevice, buffer: ^GPUBuffer, text: cstring) ---


	// Sets an arbitrary string constant to label a texture.
	//
	// Useful for debugging.
	//
	// \param device a GPU Context.
	// \param texture a texture to attach the name to.
	// \param text a UTF-8 string constant to mark as the name of the texture.
	//
	// \since This function is available since SDL 3.0.0.

	SetGPUTextureName :: proc(device: ^GPUDevice, texture: ^GPUTexture, text: cstring) ---


	// Inserts an arbitrary string label into the command buffer callstream.
	//
	// Useful for debugging.
	//
	// \param command_buffer a command buffer.
	// \param text a UTF-8 string constant to insert as the label.
	//
	// \since This function is available since SDL 3.0.0.

	InsertGPUDebugLabel :: proc(command_buffer: ^GPUCommandBuffer, text: cstring) ---


	// Begins a debug group with an arbitary name.
	//
	// Used for denoting groups of calls when viewing the command buffer
	// callstream in a graphics debugging tool.
	//
	// Each call to PushGPUDebugGroup must have a corresponding call to
	// PopGPUDebugGroup.
	//
	// On some backends (e.g. Metal), pushing a debug group during a
	// render/blit/compute pass will create a group that is scoped to the native
	// pass rather than the command buffer. For best results, if you push a debug
	// group during a pass, always pop it in the same pass.
	//
	// \param command_buffer a command buffer.
	// \param name a UTF-8 string constant that names the group.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa PopGPUDebugGroup

	PushGPUDebugGroup :: proc(command_buffer: ^GPUCommandBuffer, name: cstring) ---


	// Ends the most-recently pushed debug group.
	//
	// \param command_buffer a command buffer.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa PushGPUDebugGroup

	PopGPUDebugGroup :: proc(command_buffer: ^GPUCommandBuffer) ---

	/* Disposal */


	// Frees the given texture as soon as it is safe to do so.
	//
	// You must not reference the texture after calling this function.
	//
	// \param device a GPU context.
	// \param texture a texture to be destroyed.
	//
	// \since This function is available since SDL 3.0.0.

	ReleaseGPUTexture :: proc(device: ^GPUDevice, texture: ^GPUTexture) ---


	// Frees the given sampler as soon as it is safe to do so.
	//
	// You must not reference the sampler after calling this function.
	//
	// \param device a GPU context.
	// \param sampler a sampler to be destroyed.
	//
	// \since This function is available since SDL 3.0.0.

	ReleaseGPUSampler :: proc(device: ^GPUDevice, sampler: ^GPUSampler) ---


	// Frees the given buffer as soon as it is safe to do so.
	//
	// You must not reference the buffer after calling this function.
	//
	// \param device a GPU context.
	// \param buffer a buffer to be destroyed.
	//
	// \since This function is available since SDL 3.0.0.

	ReleaseGPUBuffer :: proc(device: ^GPUDevice, buffer: ^GPUBuffer) ---


	// Frees the given transfer buffer as soon as it is safe to do so.
	//
	// You must not reference the transfer buffer after calling this function.
	//
	// \param device a GPU context.
	// \param transfer_buffer a transfer buffer to be destroyed.
	//
	// \since This function is available since SDL 3.0.0.

	ReleaseGPUTransferBuffer :: proc(device: ^GPUDevice, transfer_buffer: ^GPUTransferBuffer) ---


	// Frees the given compute pipeline as soon as it is safe to do so.
	//
	// You must not reference the compute pipeline after calling this function.
	//
	// \param device a GPU context.
	// \param compute_pipeline a compute pipeline to be destroyed.
	//
	// \since This function is available since SDL 3.0.0.

	ReleaseGPUComputePipeline :: proc(device: ^GPUDevice, compute_pipeline: ^GPUComputePipeline) ---


	// Frees the given shader as soon as it is safe to do so.
	//
	// You must not reference the shader after calling this function.
	//
	// \param device a GPU context.
	// \param shader a shader to be destroyed.
	//
	// \since This function is available since SDL 3.0.0.

	ReleaseGPUShader :: proc(device: ^GPUDevice, shader: ^GPUShader) ---


	// Frees the given graphics pipeline as soon as it is safe to do so.
	//
	// You must not reference the graphics pipeline after calling this function.
	//
	// \param device a GPU context.
	// \param graphics_pipeline a graphics pipeline to be destroyed.
	//
	// \since This function is available since SDL 3.0.0.

	ReleaseGPUGraphicsPipeline :: proc(device: ^GPUDevice, graphics_pipeline: ^GPUGraphicsPipeline) ---


	// Acquire a command buffer.
	//
	// This command buffer is managed by the implementation and should not be
	// freed by the user. The command buffer may only be used on the thread it was
	// acquired on. The command buffer should be submitted on the thread it was
	// acquired on.
	//
	// \param device a GPU context.
	// \returns a command buffer, or NULL on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SubmitGPUCommandBuffer
	// \sa SubmitGPUCommandBufferAndAcquireFence

	AcquireGPUCommandBuffer :: proc(device: ^GPUDevice) -> ^GPUCommandBuffer ---

	// UNIFORM DATA
	//
	// Uniforms are for passing data to shaders.
	// The uniform data will be constant across all executions of the shader.
	//
	// There are 4 available uniform slots per shader stage (vertex, fragment, compute).
	// Uniform data pushed to a slot on a stage keeps its value throughout the command buffer
	// until you call the relevant Push function on that slot again.
	//
	// For example, you could write your vertex shaders to read a camera matrix from uniform binding slot 0,
	// push the camera matrix at the start of the command buffer, and that data will be used for every
	// subsequent draw call.
	//
	// It is valid to push uniform data during a render or compute pass.
	//
	// Uniforms are best for pushing small amounts of data.
	// If you are pushing more than a matrix or two per call you should consider using a storage buffer instead.


	// Pushes data to a vertex uniform slot on the command buffer.
	//
	// Subsequent draw calls will use this uniform data.
	//
	// \param command_buffer a command buffer.
	// \param slot_index the vertex uniform slot to push data to.
	// \param data client data to write.
	// \param length the length of the data to write.
	//
	// \since This function is available since SDL 3.0.0.

	PushGPUVertexUniformData :: proc(command_buffer: ^GPUCommandBuffer, slot_index: c.uint32_t, data: rawptr, length: c.uint32_t) ---


	// Pushes data to a fragment uniform slot on the command buffer.
	//
	// Subsequent draw calls will use this uniform data.
	//
	// \param command_buffer a command buffer.
	// \param slot_index the fragment uniform slot to push data to.
	// \param data client data to write.
	// \param length the length of the data to write.
	//
	// \since This function is available since SDL 3.0.0.

	PushGPUFragmentUniformData :: proc(command_buffer: ^GPUCommandBuffer, slot_index: c.uint32_t, data: rawptr, length: c.uint32_t) ---


	// Pushes data to a uniform slot on the command buffer.
	//
	// Subsequent draw calls will use this uniform data.
	//
	// \param command_buffer a command buffer.
	// \param slot_index the uniform slot to push data to.
	// \param data client data to write.
	// \param length the length of the data to write.
	//
	// \since This function is available since SDL 3.0.0.

	PushGPUComputeUniformData :: proc(command_buffer: ^GPUCommandBuffer, slot_index: c.uint32_t, data: rawptr, length: c.uint32_t) ---

	// A NOTE ON CYCLING
	//
	// When using a command buffer, operations do not occur immediately -
	// they occur some time after the command buffer is submitted.
	//
	// When a resource is used in a pending or active command buffer, it is considered to be "bound".
	// When a resource is no longer used in any pending or active command buffers, it is considered to be "unbound".
	//
	// If data resources are bound, it is unspecified when that data will be unbound
	// unless you acquire a fence when submitting the command buffer and wait on it.
	// However, this doesn't mean you need to track resource usage manually.
	//
	// All of the functions and structs that involve writing to a resource have a "cycle" bool.
	// GPUTransferBuffer, GPUBuffer, and GPUTexture all effectively function as ring buffers on internal resources.
	// When cycle is true, if the resource is bound, the cycle rotates to the next unbound internal resource,
	// or if none are available, a new one is created.
	// This means you don't have to worry about complex state tracking and synchronization as long as cycling is correctly employed.
	//
	// For example: you can call MapTransferBuffer, write texture data, UnmapTransferBuffer, and then UploadToTexture.
	// The next time you write texture data to the transfer buffer, if you set the cycle param to true, you don't have
	// to worry about overwriting any data that is not yet uploaded.
	//
	// Another example: If you are using a texture in a render pass every frame, this can cause a data dependency between frames.
	// If you set cycle to true in the GPUColorTargetInfo struct, you can prevent this data dependency.
	//
	// Cycling will never undefine already bound data.
	// When cycling, all data in the resource is considered to be undefined for subsequent commands until that data is written again.
	// You must take care not to read undefined data.
	//
	// Note that when cycling a texture, the entire texture will be cycled,
	// even if only part of the texture is used in the call,
	// so you must consider the entire texture to contain undefined data after cycling.
	//
	// You must also take care not to overwrite a section of data that has been referenced in a command without cycling first.
	// It is OK to overwrite unreferenced data in a bound resource without cycling,
	// but overwriting a section of data that has already been referenced will produce unexpected results.


	/* Graphics State */


	// Begins a render pass on a command buffer.
	//
	// A render pass consists of a set of texture subresources (or depth slices in
	// the 3D texture case) which will be rendered to during the render pass,
	// along with corresponding clear values and load/store operations. All
	// operations related to graphics pipelines must take place inside of a render
	// pass. A default viewport and scissor state are automatically set when this
	// is called. You cannot begin another render pass, or begin a compute pass or
	// copy pass until you have ended the render pass.
	//
	// \param command_buffer a command buffer.
	// \param color_target_infos an array of texture subresources with
	//                           corresponding clear values and load/store ops.
	// \param num_color_targets the number of color targets in the
	//                          color_target_infos array.
	// \param depth_stencil_target_info a texture subresource with corresponding
	//                                  clear value and load/store ops, may be
	//                                  NULL.
	// \returns a render pass handle.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa EndGPURenderPass

	BeginGPURenderPass :: proc(command_buffer: ^GPUCommandBuffer, color_target_infos: ^GPUColorTargetInfo, num_color_targets: c.uint32_t, depth_stencil_target_info: ^GPUDepthStencilTargetInfo) ---


	// Binds a graphics pipeline on a render pass to be used in rendering.
	//
	// A graphics pipeline must be bound before making any draw calls.
	//
	// \param render_pass a render pass handle.
	// \param graphics_pipeline the graphics pipeline to bind.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUGraphicsPipeline :: proc(render_pass: ^GPURenderPass, graphics_pipeline: ^GPUGraphicsPipeline) ---


	// Sets the current viewport state on a command buffer.
	//
	// \param render_pass a render pass handle.
	// \param viewport the viewport to set.
	//
	// \since This function is available since SDL 3.0.0.

	SetGPUViewport :: proc(render_pass: ^GPURenderPass, viewport: ^GPUViewport) ---


	// Sets the current scissor state on a command buffer.
	//
	// \param render_pass a render pass handle.
	// \param scissor the scissor area to set.
	//
	// \since This function is available since SDL 3.0.0.

	SetGPUScissor :: proc(render_pass: ^GPURenderPass, scissor: ^Rect) ---


	// Sets the current blend constants on a command buffer.
	//
	// \param render_pass a render pass handle.
	// \param blend_constants the blend constant color.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GPU_BLENDFACTOR_CONSTANT_COLOR
	// \sa GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR

	SetGPUBlendConstants :: proc(render_pass: ^GPURenderPass, blend_constants: FColor) ---


	// Sets the current stencil reference value on a command buffer.
	//
	// \param render_pass a render pass handle.
	// \param reference the stencil reference value to set.
	//
	// \since This function is available since SDL 3.0.0.

	SetGPUStencilReference :: proc(render_pass: ^GPURenderPass, referenc: c.uint8_t) ---


	// Binds vertex buffers on a command buffer for use with subsequent draw
	// calls.
	//
	// \param render_pass a render pass handle.
	// \param first_slot the vertex buffer slot to begin binding from.
	// \param bindings an array of GPUBufferBinding structs containing vertex
	//                 buffers and offset values.
	// \param num_bindings the number of bindings in the bindings array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUVertexBuffers :: proc(render_pass: ^GPURenderPass, first_slot: c.uint32_t, bindings: ^GPUBufferBinding, num_bindings: c.uint32_t) ---


	// Binds an index buffer on a command buffer for use with subsequent draw
	// calls.
	//
	// \param render_pass a render pass handle.
	// \param binding a pointer to a struct containing an index buffer and offset.
	// \param index_element_size whether the index values in the buffer are 16- or
	//                           32-bit.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUIndexBuffer :: proc(render_pass: ^GPURenderPass, binding: ^GPUBufferBinding, index_element_size: GPUIndexElementSize) ---


	// Binds texture-sampler pairs for use on the vertex shader.
	//
	// The textures must have been created with GPU_TEXTUREUSAGE_SAMPLER.
	//
	// \param render_pass a render pass handle.
	// \param first_slot the vertex sampler slot to begin binding from.
	// \param texture_sampler_bindings an array of texture-sampler binding
	//                                 structs.
	// \param num_bindings the number of texture-sampler pairs to bind from the
	//                     array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUVertexSamplers :: proc(render_pass: ^GPURenderPass, first_slot: c.uint32_t, texture_sampler_bindings: ^GPUTextureSamplerBinding, num_bindings: c.uint32_t) ---

	// Binds storage textures for use on the vertex shader.
	//
	// These textures must have been created with
	// GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ.
	//
	// \param render_pass a render pass handle.
	// \param first_slot the vertex storage texture slot to begin binding from.
	// \param storage_textures an array of storage textures.
	// \param num_bindings the number of storage texture to bind from the array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUVertexStorageTextures :: proc(render_pass: ^GPURenderPass, first_slot: c.uint32_t, storage_textures: [^]^GPUTexture, num_bindings: c.uint32_t) ---


	// Binds storage buffers for use on the vertex shader.
	//
	// These buffers must have been created with
	// GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ.
	//
	// \param render_pass a render pass handle.
	// \param first_slot the vertex storage buffer slot to begin binding from.
	// \param storage_buffers an array of buffers.
	// \param num_bindings the number of buffers to bind from the array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUVertexStorageBuffers :: proc(render_pass: ^GPURenderPass, first_slot: c.uint32_t, storage_buffers: [^]^GPUBuffer, num_bindings: c.uint32_t) ---


	// Binds texture-sampler pairs for use on the fragment shader.
	//
	// The textures must have been created with GPU_TEXTUREUSAGE_SAMPLER.
	//
	// \param render_pass a render pass handle.
	// \param first_slot the fragment sampler slot to begin binding from.
	// \param texture_sampler_bindings an array of texture-sampler binding
	//                                 structs.
	// \param num_bindings the number of texture-sampler pairs to bind from the
	//                     array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUFragmentSamplers :: proc(render_pass: ^GPURenderPass, first_slot: c.uint32_t, texture_sampler_bindings: ^GPUTextureSamplerBinding, num_bindings: c.uint32_t) ---


	// Binds storage textures for use on the fragment shader.
	//
	// These textures must have been created with
	// GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ.
	//
	// \param render_pass a render pass handle.
	// \param first_slot the fragment storage texture slot to begin binding from.
	// \param storage_textures an array of storage textures.
	// \param num_bindings the number of storage textures to bind from the array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUFragmentStorageTextures :: proc(render_pass: ^GPURenderPass, first_slot: c.uint32_t, storage_textures: [^]^GPUTexture, num_bindings: c.uint32_t) ---


	// Binds storage buffers for use on the fragment shader.
	//
	// These buffers must have been created with
	// GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ.
	//
	// \param render_pass a render pass handle.
	// \param first_slot the fragment storage buffer slot to begin binding from.
	// \param storage_buffers an array of storage buffers.
	// \param num_bindings the number of storage buffers to bind from the array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUFragmentStorageBuffers :: proc(render_pass: ^GPURenderPass, first_slot: c.uint32_t, storage_buffers: [^]^GPUBuffer, num_bindings: c.uint32_t) ---

	/* Drawing */


	// Draws data using bound graphics state with an index buffer and instancing
	// enabled.
	//
	// You must not call this function before binding a graphics pipeline.
	//
	// Note that the `first_vertex` and `first_instance` parameters are NOT
	// compatible with built-in vertex/instance ID variables in shaders (for
	// example, SV_VertexID). If your shader depends on these variables, the
	// correlating draw call parameter MUST be 0.
	//
	// \param render_pass a render pass handle.
	// \param num_indices the number of indices to draw per instance.
	// \param num_instances the number of instances to draw.
	// \param first_index the starting index within the index buffer.
	// \param vertex_offset value added to vertex index before indexing into the
	//                      vertex buffer.
	// \param first_instance the ID of the first instance to draw.
	//
	// \since This function is available since SDL 3.0.0.

	DrawGPUIndexedPrimitives :: proc(render_pass: ^GPURenderPass, num_indices: c.uint32_t, num_instances: c.uint32_t, first_index: c.uint32_t, vertex_offset: c.int32_t, first_instance: c.uint32_t) ---

	// Draws data using bound graphics state.
	//
	// You must not call this function before binding a graphics pipeline.
	//
	// Note that the `first_vertex` and `first_instance` parameters are NOT
	// compatible with built-in vertex/instance ID variables in shaders (for
	// example, SV_VertexID). If your shader depends on these variables, the
	// correlating draw call parameter MUST be 0.
	//
	// \param render_pass a render pass handle.
	// \param num_vertices the number of vertices to draw.
	// \param num_instances the number of instances that will be drawn.
	// \param first_vertex the index of the first vertex to draw.
	// \param first_instance the ID of the first instance to draw.
	//
	// \since This function is available since SDL 3.0.0.

	DrawGPUPrimitives :: proc(render_pass: ^GPURenderPass, num_vertices: c.uint32_t, num_instances: c.uint32_t, first_vertex: c.uint32_t, first_instance: c.uint32_t) ---


	// Draws data using bound graphics state and with draw parameters set from a
	// buffer.
	//
	// The buffer must consist of tightly-packed draw parameter sets that each
	// match the layout of GPUIndirectDrawCommand. You must not call this
	// function before binding a graphics pipeline.
	//
	// \param render_pass a render pass handle.
	// \param buffer a buffer containing draw parameters.
	// \param offset the offset to start reading from the draw buffer.
	// \param draw_count the number of draw parameter sets that should be read
	//                   from the draw buffer.
	//
	// \since This function is available since SDL 3.0.0.

	DrawGPUPrimitivesIndirect :: proc(render_pass: ^GPURenderPass, buffer: ^GPUBuffer, offset: c.uint32_t, draw_count: c.uint32_t) ---


	// Draws data using bound graphics state with an index buffer enabled and with
	// draw parameters set from a buffer.
	//
	// The buffer must consist of tightly-packed draw parameter sets that each
	// match the layout of GPUIndexedIndirectDrawCommand. You must not call
	// this function before binding a graphics pipeline.
	//
	// \param render_pass a render pass handle.
	// \param buffer a buffer containing draw parameters.
	// \param offset the offset to start reading from the draw buffer.
	// \param draw_count the number of draw parameter sets that should be read
	//                   from the draw buffer.
	//
	// \since This function is available since SDL 3.0.0.

	DrawGPUIndexedPrimitivesIndirect :: proc(render_pass: ^GPURenderPass, buffer: ^GPUBuffer, offset: c.uint32_t, draw_count: c.uint32_t) ---


	// Ends the given render pass.
	//
	// All bound graphics state on the render pass command buffer is unset. The
	// render pass handle is now invalid.
	//
	// \param render_pass a render pass handle.
	//
	// \since This function is available since SDL 3.0.0.

	EndGPURenderPass :: proc(render_pass: ^GPURenderPass) ---

	/* Compute Pass */


	// Begins a compute pass on a command buffer.
	//
	// A compute pass is defined by a set of texture subresources and buffers that
	// may be written to by compute pipelines. These textures and buffers must
	// have been created with the COMPUTE_STORAGE_WRITE bit or the
	// COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE bit. If you do not create a texture
	// with COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE, you must not read from the
	// texture in the compute pass. All operations related to compute pipelines
	// must take place inside of a compute pass. You must not begin another
	// compute pass, or a render pass or copy pass before ending the compute pass.
	//
	// A VERY IMPORTANT NOTE - Reads and writes in compute passes are NOT
	// implicitly synchronized. This means you may cause data races by both
	// reading and writing a resource region in a compute pass, or by writing
	// multiple times to a resource region. If your compute work depends on
	// reading the completed output from a previous dispatch, you MUST end the
	// current compute pass and begin a new one before you can safely access the
	// data. Otherwise you will receive unexpected results. Reading and writing a
	// texture in the same compute pass is only supported by specific texture
	// formats. Make sure you check the format support!
	//
	// \param command_buffer a command buffer.
	// \param storage_texture_bindings an array of writeable storage texture
	//                                 binding structs.
	// \param num_storage_texture_bindings the number of storage textures to bind
	//                                     from the array.
	// \param storage_buffer_bindings an array of writeable storage buffer binding
	//                                structs.
	// \param num_storage_buffer_bindings the number of storage buffers to bind
	//                                    from the array.
	// \returns a compute pass handle.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa EndGPUComputePass

	BeginGPUComputePass :: proc(command_buffer: ^GPUCommandBuffer, storage_texture_bindings: ^GPUStorageTextureReadWriteBinding, num_storage_texture_bindings: c.uint32_t, storage_buffer_bindings: ^GPUStorageBufferReadWriteBinding, num_storage_buffer_bindings: c.uint32_t) ---


	// Binds a compute pipeline on a command buffer for use in compute dispatch.
	//
	// \param compute_pass a compute pass handle.
	// \param compute_pipeline a compute pipeline to bind.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUComputePipeline :: proc(compute_pass: ^GPUComputePass, compute_pipeline: ^GPUComputePipeline) ---


	// Binds texture-sampler pairs for use on the compute shader.
	//
	// The textures must have been created with GPU_TEXTUREUSAGE_SAMPLER.
	//
	// \param compute_pass a compute pass handle.
	// \param first_slot the compute sampler slot to begin binding from.
	// \param texture_sampler_bindings an array of texture-sampler binding
	//                                 structs.
	// \param num_bindings the number of texture-sampler bindings to bind from the
	//                     array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUComputeSamplers :: proc(compute_pass: ^GPUComputePass, first_slot: c.uint32_t, texture_sampler_bindings: ^GPUTextureSamplerBinding, num_bindings: c.uint32_t) ---


	// Binds storage textures as readonly for use on the compute pipeline.
	//
	// These textures must have been created with
	// GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ.
	//
	// \param compute_pass a compute pass handle.
	// \param first_slot the compute storage texture slot to begin binding from.
	// \param storage_textures an array of storage textures.
	// \param num_bindings the number of storage textures to bind from the array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUComputeStorageTextures :: proc(compute_pass: ^GPUComputePass, first_slot: c.uint32_t, storage_textures: [^]^GPUTexture, num_bindings: c.uint32_t) ---


	// Binds storage buffers as readonly for use on the compute pipeline.
	//
	// These buffers must have been created with
	// GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ.
	//
	// \param compute_pass a compute pass handle.
	// \param first_slot the compute storage buffer slot to begin binding from.
	// \param storage_buffers an array of storage buffer binding structs.
	// \param num_bindings the number of storage buffers to bind from the array.
	//
	// \since This function is available since SDL 3.0.0.

	BindGPUComputeStorageBuffers :: proc(compute_pass: ^GPUComputePass, first_slot: c.uint32_t, storage_buffers: [^]^GPUBuffer, num_bindings: c.uint32_t) ---


	// Dispatches compute work.
	//
	// You must not call this function before binding a compute pipeline.
	//
	// A VERY IMPORTANT NOTE If you dispatch multiple times in a compute pass, and
	// the dispatches write to the same resource region as each other, there is no
	// guarantee of which order the writes will occur. If the write order matters,
	// you MUST end the compute pass and begin another one.
	//
	// \param compute_pass a compute pass handle.
	// \param groupcount_x number of local workgroups to dispatch in the X
	//                     dimension.
	// \param groupcount_y number of local workgroups to dispatch in the Y
	//                     dimension.
	// \param groupcount_z number of local workgroups to dispatch in the Z
	//                     dimension.
	//
	// \since This function is available since SDL 3.0.0.

	DispatchGPUCompute :: proc(compute_pass: ^GPUComputePass, groupcount_x: c.uint32_t, groupcount_y: c.uint32_t, groupcount_z: c.uint32_t) ---


	// Dispatches compute work with parameters set from a buffer.
	//
	// The buffer layout should match the layout of
	// GPUIndirectDispatchCommand. You must not call this function before
	// binding a compute pipeline.
	//
	// A VERY IMPORTANT NOTE If you dispatch multiple times in a compute pass, and
	// the dispatches write to the same resource region as each other, there is no
	// guarantee of which order the writes will occur. If the write order matters,
	// you MUST end the compute pass and begin another one.
	//
	// \param compute_pass a compute pass handle.
	// \param buffer a buffer containing dispatch parameters.
	// \param offset the offset to start reading from the dispatch buffer.
	//
	// \since This function is available since SDL 3.0.0.

	DispatchGPUComputeIndirect :: proc(compute_pass: ^GPUComputePass, buffer: ^GPUBuffer, offset: c.uint32_t) ---


	// Ends the current compute pass.
	//
	// All bound compute state on the command buffer is unset. The compute pass
	// handle is now invalid.
	//
	// \param compute_pass a compute pass handle.
	//
	// \since This function is available since SDL 3.0.0.

	EndGPUComputePass :: proc(compute_pass: ^GPUComputePass) ---

	/* TransferBuffer Data */


	// Maps a transfer buffer into application address space.
	//
	// You must unmap the transfer buffer before encoding upload commands.
	//
	// \param device a GPU context.
	// \param transfer_buffer a transfer buffer.
	// \param cycle if true, cycles the transfer buffer if it is already bound.
	// \returns the address of the mapped transfer buffer memory, or NULL on
	//          failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	MapGPUTransferBuffer :: proc(device: ^GPUDevice, transfer_buffer: ^GPUTransferBuffer, cycle: bool) -> rawptr ---


	// Unmaps a previously mapped transfer buffer.
	//
	// \param device a GPU context.
	// \param transfer_buffer a previously mapped transfer buffer.
	//
	// \since This function is available since SDL 3.0.0.

	UnmapGPUTransferBuffer :: proc(device: ^GPUDevice, transfer_buffer: ^GPUTransferBuffer) ---

	/* Copy Pass */


	// Begins a copy pass on a command buffer.
	//
	// All operations related to copying to or from buffers or textures take place
	// inside a copy pass. You must not begin another copy pass, or a render pass
	// or compute pass before ending the copy pass.
	//
	// \param command_buffer a command buffer.
	// \returns a copy pass handle.
	//
	// \since This function is available since SDL 3.0.0.

	BeginGPUCopyPass :: proc(command_buffer: ^GPUCommandBuffer) -> ^GPUCopyPass ---


	// Uploads data from a transfer buffer to a texture.
	//
	// The upload occurs on the GPU timeline. You may assume that the upload has
	// finished in subsequent commands.
	//
	// You must align the data in the transfer buffer to a multiple of the texel
	// size of the texture format.
	//
	// \param copy_pass a copy pass handle.
	// \param source the source transfer buffer with image layout information.
	// \param destination the destination texture region.
	// \param cycle if true, cycles the texture if the texture is bound, otherwise
	//              overwrites the data.
	//
	// \since This function is available since SDL 3.0.0.

	UploadToGPUTexture :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTextureTransferInfo, destination: ^GPUTextureRegion, cycle: bool) ---

	/* Uploads data from a TransferBuffer to a Buffer. */


	// Uploads data from a transfer buffer to a buffer.
	//
	// The upload occurs on the GPU timeline. You may assume that the upload has
	// finished in subsequent commands.
	//
	// \param copy_pass a copy pass handle.
	// \param source the source transfer buffer with offset.
	// \param destination the destination buffer with offset and size.
	// \param cycle if true, cycles the buffer if it is already bound, otherwise
	//              overwrites the data.
	//
	// \since This function is available since SDL 3.0.0.

	UploadToGPUBuffer :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTransferBufferLocation, destination: ^GPUBufferRegion, cycle: c.bool) ---


	// Performs a texture-to-texture copy.
	//
	// This copy occurs on the GPU timeline. You may assume the copy has finished
	// in subsequent commands.
	//
	// \param copy_pass a copy pass handle.
	// \param source a source texture region.
	// \param destination a destination texture region.
	// \param w the width of the region to copy.
	// \param h the height of the region to copy.
	// \param d the depth of the region to copy.
	// \param cycle if true, cycles the destination texture if the destination
	//              texture is bound, otherwise overwrites the data.
	//
	// \since This function is available since SDL 3.0.0.

	CopyGPUTextureToTexture :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTextureLocation, destination: ^GPUTextureLocation, w: c.uint32_t, h: c.uint32_t, d: c.uint32_t, cycle: c.bool) ---

	/* Copies data from a buffer to a buffer. */


	// Performs a buffer-to-buffer copy.
	//
	// This copy occurs on the GPU timeline. You may assume the copy has finished
	// in subsequent commands.
	//
	// \param copy_pass a copy pass handle.
	// \param source the buffer and offset to copy from.
	// \param destination the buffer and offset to copy to.
	// \param size the length of the buffer to copy.
	// \param cycle if true, cycles the destination buffer if it is already bound,
	//              otherwise overwrites the data.
	//
	// \since This function is available since SDL 3.0.0.

	CopyGPUBufferToBuffer :: proc(copy_pass: ^GPUCopyPass, source: ^GPUBufferLocation, destination: ^GPUBufferLocation, size: c.uint32_t, cycle: c.bool) ---

	// Copies data from a texture to a transfer buffer on the GPU timeline.
	//
	// This data is not guaranteed to be copied until the command buffer fence is
	// signaled.
	//
	// \param copy_pass a copy pass handle.
	// \param source the source texture region.
	// \param destination the destination transfer buffer with image layout
	//                    information.
	//
	// \since This function is available since SDL 3.0.0.

	DownloadFromGPUTexture :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTextureRegion, destination: ^GPUTextureTransferInfo) ---


	// Copies data from a buffer to a transfer buffer on the GPU timeline.
	//
	// This data is not guaranteed to be copied until the command buffer fence is
	// signaled.
	//
	// \param copy_pass a copy pass handle.
	// \param source the source buffer with offset and size.
	// \param destination the destination transfer buffer with offset.
	//
	// \since This function is available since SDL 3.0.0.

	DownloadFromGPUBuffer :: proc(copy_pass: ^GPUCopyPass, source: ^GPUBufferRegion, destination: ^GPUTransferBufferLocation) ---


	// Ends the current copy pass.
	//
	// \param copy_pass a copy pass handle.
	//
	// \since This function is available since SDL 3.0.0.

	EndGPUCopyPass :: proc(copy_pass: ^GPUCopyPass) ---


	// Generates mipmaps for the given texture.
	//
	// This function must not be called inside of any pass.
	//
	// \param command_buffer a command_buffer.
	// \param texture a texture with more than 1 mip level.
	//
	// \since This function is available since SDL 3.0.0.

	GenerateMipmapsForGPUTexture :: proc(command_buffer: ^GPUCommandBuffer, texture: ^GPUTexture) ---


	// Blits from a source texture region to a destination texture region.
	//
	// This function must not be called inside of any pass.
	//
	// \param command_buffer a command buffer.
	// \param info the blit info struct containing the blit parameters.
	//
	// \since This function is available since SDL 3.0.0.

	BlitGPUTexture :: proc(command_buffer: ^GPUCommandBuffer, info: ^GPUBlitInfo) ---

	/* Submission/Presentation */


	// Determines whether a swapchain composition is supported by the window.
	//
	// The window must be claimed before calling this function.
	//
	// \param device a GPU context.
	// \param window an Window.
	// \param swapchain_composition the swapchain composition to check.
	// \returns true if supported, false if unsupported.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ClaimWindowForGPUDevice

	WindowSupportsGPUSwapchainComposition :: proc(device: ^GPUDevice, window: ^Window, swapchain_composition: GPUSwapchainComposition) -> c.bool ---


	// Determines whether a presentation mode is supported by the window.
	//
	// The window must be claimed before calling this function.
	//
	// \param device a GPU context.
	// \param window an Window.
	// \param present_mode the presentation mode to check.
	// \returns true if supported, false if unsupported.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ClaimWindowForGPUDevice

	WindowSupportsGPUPresentMode :: proc(device: ^GPUDevice, window: ^Window, present_mode: GPUPresentMode) -> c.bool ---

	// Claims a window, creating a swapchain structure for it.
	//
	// This must be called before AcquireGPUSwapchainTexture is called using
	// the window. You should only call this function from the thread that created
	// the window.
	//
	// The swapchain will be created with GPU_SWAPCHAINCOMPOSITION_SDR and
	// GPU_PRESENTMODE_VSYNC. If you want to have different swapchain
	// parameters, you must call SetGPUSwapchainParameters after claiming the
	// window.
	//
	// \param device a GPU context.
	// \param window an Window.
	// \returns true on success, or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa AcquireGPUSwapchainTexture
	// \sa ReleaseWindowFromGPUDevice
	// \sa WindowSupportsGPUPresentMode
	// \sa WindowSupportsGPUSwapchainComposition

	ClaimWindowForGPUDevice :: proc(device: ^GPUDevice, window: ^Window) -> c.bool ---


	// Unclaims a window, destroying its swapchain structure.
	//
	// \param device a GPU context.
	// \param window an Window that has been claimed.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ClaimWindowForGPUDevice

	ReleaseWindowFromGPUDevice :: proc(device: ^GPUDevice, window: ^Window) ---


	// Changes the swapchain parameters for the given claimed window.
	//
	// This function will fail if the requested present mode or swapchain
	// composition are unsupported by the device. Check if the parameters are
	// supported via WindowSupportsGPUPresentMode /
	// WindowSupportsGPUSwapchainComposition prior to calling this function.
	//
	// GPU_PRESENTMODE_VSYNC and GPU_SWAPCHAINCOMPOSITION_SDR are always
	// supported.
	//
	// \param device a GPU context.
	// \param window an Window that has been claimed.
	// \param swapchain_composition the desired composition of the swapchain.
	// \param present_mode the desired present mode for the swapchain.
	// \returns true if successful, false on error; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa WindowSupportsGPUPresentMode
	// \sa WindowSupportsGPUSwapchainComposition

	SetGPUSwapchainParameters :: proc(device: ^GPUDevice, window: ^Window, swapchain_composition: GPUSwapchainComposition, present_mode: GPUPresentMode) -> c.bool ---


	// Obtains the texture format of the swapchain for the given window.
	//
	// Note that this format can change if the swapchain parameters change.
	//
	// \param device a GPU context.
	// \param window an Window that has been claimed.
	// \returns the texture format of the swapchain.
	//
	// \since This function is available since SDL 3.0.0.

	GetGPUSwapchainTextureFormat :: proc(device: ^GPUDevice, window: ^Window) -> GPUTextureFormat ---


	// Acquire a texture to use in presentation.
	//
	// When a swapchain texture is acquired on a command buffer, it will
	// automatically be submitted for presentation when the command buffer is
	// submitted. The swapchain texture should only be referenced by the command
	// buffer used to acquire it. The swapchain texture handle can be filled in
	// with NULL under certain conditions. This is not necessarily an error. If
	// this function returns false then there is an error.
	//
	// The swapchain texture is managed by the implementation and must not be
	// freed by the user. You MUST NOT call this function from any thread other
	// than the one that created the window.
	//
	// \param command_buffer a command buffer.
	// \param window a window that has been claimed.
	// \param swapchain_texture a pointer filled in with a swapchain texture
	//                          handle.
	// \param swapchain_texture_width a pointer filled in with the swapchain
	//                                texture width, may be NULL.
	// \param swapchain_texture_height a pointer filled in with the swapchain
	//                                 texture height, may be NULL.
	// \returns true on success, false on error; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ClaimWindowForGPUDevice
	// \sa SubmitGPUCommandBuffer
	// \sa SubmitGPUCommandBufferAndAcquireFence
	// \sa GetWindowSizeInPixels

	AcquireGPUSwapchainTexture :: proc(command_buffer: ^GPUCommandBuffer, window: ^Window, swapchain_texture: ^^GPUTexture, swapchain_texture_width: ^c.uint32_t, swapchain_texture_height: ^c.uint32_t) -> c.bool ---


	// Submits a command buffer so its commands can be processed on the GPU.
	//
	// It is invalid to use the command buffer after this is called.
	//
	// This must be called from the thread the command buffer was acquired on.
	//
	// All commands in the submission are guaranteed to begin executing before any
	// command in a subsequent submission begins executing.
	//
	// \param command_buffer a command buffer.
	// \returns true on success, false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa AcquireGPUCommandBuffer
	// \sa AcquireGPUSwapchainTexture
	// \sa SubmitGPUCommandBufferAndAcquireFence

	SubmitGPUCommandBuffer :: proc(command_buffer: ^GPUCommandBuffer) -> c.bool ---


	// Submits a command buffer so its commands can be processed on the GPU, and
	// acquires a fence associated with the command buffer.
	//
	// You must release this fence when it is no longer needed or it will cause a
	// leak. It is invalid to use the command buffer after this is called.
	//
	// This must be called from the thread the command buffer was acquired on.
	//
	// All commands in the submission are guaranteed to begin executing before any
	// command in a subsequent submission begins executing.
	//
	// \param command_buffer a command buffer.
	// \returns a fence associated with the command buffer, or NULL on failure;
	//          call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa AcquireGPUCommandBuffer
	// \sa AcquireGPUSwapchainTexture
	// \sa SubmitGPUCommandBuffer
	// \sa ReleaseGPUFence

	SubmitGPUCommandBufferAndAcquireFence :: proc(command_buffer: ^GPUCommandBuffer) -> ^GPUFence ---


	// Blocks the thread until the GPU is completely idle.
	//
	// \param device a GPU context.
	// \returns true on success, false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa WaitForGPUFences

	WaitForGPUIdle :: proc(device: ^GPUDevice) -> c.bool ---


	// Blocks the thread until the given fences are signaled.
	//
	// \param device a GPU context.
	// \param wait_all if 0, wait for any fence to be signaled, if 1, wait for all
	//                 fences to be signaled.
	// \param fences an array of fences to wait on.
	// \param num_fences the number of fences in the fences array.
	// \returns true on success, false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SubmitGPUCommandBufferAndAcquireFence
	// \sa WaitForGPUIdle

	WaitForGPUFences :: proc(device: ^GPUDevice, wait_all: c.bool, fences: [^]^GPUFence, num_fences: c.uint32_t) -> c.bool ---


	// Checks the status of a fence.
	//
	// \param device a GPU context.
	// \param fence a fence.
	// \returns true if the fence is signaled, false if it is not.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SubmitGPUCommandBufferAndAcquireFence

	QueryGPUFence :: proc(device: ^GPUDevice, fence: ^GPUFence) -> c.bool ---


	// Releases a fence obtained from SubmitGPUCommandBufferAndAcquireFence.
	//
	// \param device a GPU context.
	// \param fence a fence.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SubmitGPUCommandBufferAndAcquireFence

	ReleaseGPUFence :: proc(device: ^GPUDevice, fence: ^GPUFence) ---

	/* Format Info */


	// Obtains the texel block size for a texture format.
	//
	// \param format the texture format you want to know the texel size of.
	// \returns the texel block size of the texture format.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa UploadToGPUTexture

	GPUTextureFormatTexelBlockSize :: proc(format: GPUTextureFormat) -> c.uint32_t ---


	// Determines whether a texture format is supported for a given type and
	// usage.
	//
	// \param device a GPU context.
	// \param format the texture format to check.
	// \param type the type of texture (2D, 3D, Cube).
	// \param usage a bitmask of all usage scenarios to check.
	// \returns whether the texture format is supported for this type and usage.
	//
	// \since This function is available since SDL 3.0.0.

	GPUTextureSupportsFormat :: proc(device: ^GPUDevice, format: GPUTextureFormat, type: GPUTextureType, usage: GPUTextureUsageFlags) -> c.bool ---


	// Determines if a sample count for a texture format is supported.
	//
	// \param device a GPU context.
	// \param format the texture format to check.
	// \param sample_count the sample count to check.
	// \returns a hardware-specific version of min(preferred, possible).
	//
	// \since This function is available since SDL 3.0.0.

	GPUTextureSupportsSampleCount :: proc(device: ^GPUDevice, format: GPUTextureFormat, sample_count: GPUSampleCount) -> c.bool ---


	// Call this to suspend GPU operation on Xbox when you receive the
	// EVENT_DID_ENTER_BACKGROUND event.
	//
	// Do NOT call any GPU functions after calling this function! This must
	// also be called before calling GDKSuspendComplete.
	//
	// \param device a GPU context.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa AddEventWatch

	GDKSuspendGPU :: proc(device: ^GPUDevice) ---


	// Call this to resume GPU operation on Xbox when you receive the
	// EVENT_WILL_ENTER_FOREGROUND event.
	//
	// When resuming, this function MUST be called before calling any other
	// GPU functions.
	//
	// \param device a GPU context.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa AddEventWatch

	GDKResumeGPU :: proc(device: ^GPUDevice) ---
}
