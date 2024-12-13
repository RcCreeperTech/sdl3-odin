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


// # CategoryVideo
//
// SDL's video subsystem is largely interested in abstracting window
// management from the underlying operating system. You can create windows,
// manage them in various ways, set them fullscreen, and get events when
// interesting things happen with them, such as the mouse or keyboard
// interacting with a window.
//
// The video subsystem is also interested in abstracting away some
// platform-specific differences in OpenGL: context creation, swapping
// buffers, etc. This may be crucial to your app, but also you are not
// required to use OpenGL at all. In fact, SDL can provide rendering to those
// windows as well, either with an easy-to-use
// [2D API](https://wiki.libsdl.org/SDL3/CategoryRender)
// or with a more-powerful
// [GPU API](https://wiki.libsdl.org/SDL3/CategoryGPU)
// . Of course, it can simply get out of your way and give you the window
// handles you need to use Vulkan, Direct3D, Metal, or whatever else you like
// directly, too.
//
// The video subsystem covers a lot of functionality, out of necessity, so it
// is worth perusing the list of functions just to see what's available, but
// most apps can get by with simply creating a window and listening for
// events, so start with CreateWindow() and PollEvent().


// This is a unique ID for a display for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// If the display is disconnected and reconnected, it will get a new ID.
//
// The value 0 is an invalid ID.
//
// \since This datatype is available since SDL 3.0.0.

DisplayID :: distinct c.uint32_t


// This is a unique ID for a window.
//
// The value 0 is an invalid ID.
//
// \since This datatype is available since SDL 3.0.0.

WindowID :: distinct c.uint32_t

/* Global video properties... */


// The pointer to the global `wl_display` object used by the Wayland video
// backend.
//
// Can be set before the video subsystem is initialized to import an external
// `wl_display` object from an application or toolkit for use in SDL, or read
// after initialization to export the `wl_display` used by the Wayland video
// backend. Setting this property after the video subsystem has been
// initialized has no effect, and reading it when the video subsystem is
// uninitialized will either return the user provided value, if one was set
// prior to initialization, or NULL. See docs/README-wayland.md for more
// information.

PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER :: "SDL.video.wayland.wl_display"


// System theme.
//
// \since This enum is available since SDL 3.0.0.

SystemTheme :: enum c.int {
	UNKNOWN, /**< Unknown system theme */
	LIGHT, /**< Light colored system theme */
	DARK, /**< Dark colored system theme */
}

/* Internal display mode data */
DisplayModeData :: distinct struct {}


// The structure that defines a display mode.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa GetFullscreenDisplayModes
// \sa GetDesktopDisplayMode
// \sa GetCurrentDisplayMode
// \sa SetWindowFullscreenMode
// \sa GetWindowFullscreenMode

DisplayMode :: struct {
	displayID:                DisplayID, /**< the display this mode is associated with */
	format:                   PixelFormat, /**< pixel format */
	w:                        c.int, /**< width */
	h:                        c.int, /**< height */
	pixel_density:            c.float, /**< scale converting size to pixels (e.g. a 1920x1080 mode with 2.0 scale would have 3840x2160 pixels) */
	refresh_rate:             c.float, /**< refresh rate (or 0.0f for unspecified) */
	refresh_rate_numerator:   c.int, /**< precise refresh rate numerator (or 0 for unspecified) */
	refresh_rate_denominator: c.int, /**< precise refresh rate denominator */
	internal:                 ^DisplayModeData, /**< Private */
}


// Display orientation values; the way a display is rotated.
//
// \since This enum is available since SDL 3.0.0.

DisplayOrientation :: enum c.int {
	UNKNOWN, /**< The display orientation can't be determined */
	LANDSCAPE, /**< The display is in landscape mode, with the right side up, relative to portrait mode */
	LANDSCAPE_FLIPPED, /**< The display is in landscape mode, with the left side up, relative to portrait mode */
	PORTRAIT, /**< The display is in portrait mode */
	PORTRAIT_FLIPPED, /**< The display is in portrait mode, upside down */
}


// The struct used as an opaque handle to a window.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa CreateWindow

Window :: distinct struct {}


// The flags on a window.
//
// These cover a lot of true/false, or on/off, window state. Some of it is
// immutable after being set through CreateWindow(), some of it can be
// changed on existing windows by the app, and some of it might be altered by
// the user or system outside of the app's control.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa GetWindowFlags

WindowFlags :: bit_set[WindowFlag]
WindowFlag :: enum c.uint64_t {
	FULLSCREEN          = 0, /**< window is in fullscreen mode */
	OPENGL              = 1, /**< window usable with OpenGL context */
	OCCLUDED            = 2, /**< window is occluded */
	HIDDEN              = 3, /**< window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; ShowWindow() is required for it to become visible */
	BORDERLESS          = 4, /**< no window decoration */
	RESIZABLE           = 5, /**< window can be resized */
	MINIMIZED           = 6, /**< window is minimized */
	MAXIMIZED           = 7, /**< window is maximized */
	MOUSE_GRABBED       = 8, /**< window has grabbed mouse input */
	INPUT_FOCUS         = 9, /**< window has input focus */
	MOUSE_FOCUS         = 10, /**< window has mouse focus */
	EXTERNAL            = 11, /**< window not created by SDL */
	MODAL               = 12, /**< window is modal */
	HIGH_PIXEL_DENSITY  = 13, /**< window uses high pixel density back buffer if possible */
	MOUSE_CAPTURE       = 14, /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
	MOUSE_RELATIVE_MODE = 15, /**< window has relative mode enabled */
	ALWAYS_ON_TOP       = 16, /**< window should always be above others */
	UTILITY             = 17, /**< window should be treated as a utility window, not showing in the task bar and window list */
	TOOLTIP             = 18, /**< window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window */
	POPUP_MENU          = 19, /**< window should be treated as a popup menu, requires a parent window */
	KEYBOARD_GRABBED    = 20, /**< window has grabbed keyboard input */
	VULKAN              = 29, /**< window usable for Vulkan surface */
	METAL               = 30, /**< window usable for Metal view */
	TRANSPARENT         = 31, /**< window with transparent buffer */
	NOT_FOCUSABLE       = 32, /**< window should not be focusable */
}


// Used to indicate that you don't care what the window position is.
//
// \since This macro is available since SDL 3.0.0.

WINDOWPOS_UNDEFINED_MASK :: 0x1FFF0000
WINDOWPOS_UNDEFINED_DISPLAY :: #force_inline proc "c" (X: c.int) -> c.int {return(
		WINDOWPOS_UNDEFINED_MASK |
		X \
	)}
WINDOWPOS_UNDEFINED := WINDOWPOS_UNDEFINED_DISPLAY(0)
WINDOWPOS_ISUNDEFINED :: #force_inline proc "c" (X: c.int) -> c.bool {
	return (X & transmute(i32)u32(0xFFFF0000)) == WINDOWPOS_UNDEFINED_MASK
}


// Used to indicate that the window position should be centered.
//
// \since This macro is available since SDL 3.0.0.

WINDOWPOS_CENTERED_MASK :: 0x2FFF0000
WINDOWPOS_CENTERED_DISPLAY :: #force_inline proc "c" (X: c.int) -> c.int {return(
		WINDOWPOS_CENTERED_MASK |
		X \
	)}
WINDOWPOS_CENTERED := WINDOWPOS_CENTERED_DISPLAY(0)
WINDOWPOS_ISCENTERED :: #force_inline proc "c" (X: c.int) -> c.bool {
	return (X & transmute(i32)u32(0xFFFF0000)) == WINDOWPOS_CENTERED_MASK
}


// Window flash operation.
//
// \since This enum is available since SDL 3.0.0.

FlashOperation :: enum c.int {
	CANCEL, /**< Cancel any window flash state */
	BRIEFLY, /**< Flash the window briefly to get attention */
	UNTIL_FOCUSED, /**< Flash the window until it gets focus */
}


// An opaque handle to an OpenGL context.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa GL_CreateContext

GLContext :: distinct rawptr


// Opaque EGL types.
//
// \since This datatype is available since SDL 3.0.0.

EGLDisplay :: distinct rawptr
EGLConfig :: distinct rawptr
EGLSurface :: distinct rawptr
EGLAttrib :: distinct c.intptr_t
EGLint :: distinct c.int


// EGL platform attribute initialization callback.
//
// This is called when SDL is attempting to create an EGL context, to let the
// app add extra attributes to its eglGetPlatformDisplay() call.
//
// The callback should return a pointer to an EGL attribute array terminated
// with `EGL_NONE`. If this function returns NULL, the CreateWindow
// process will fail gracefully.
//
// The returned pointer should be allocated with malloc() and will be
// passed to free().
//
// The arrays returned by each callback will be appended to the existing
// attribute arrays defined by SDL.
//
// \param userdata an app-controlled pointer that is passed to the callback.
// \returns a newly-allocated array of attributes, terminated with `EGL_NONE`.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa EGL_SetAttributeCallbacks

EGLAttribArrayCallback :: #type proc "c" (userdata: rawptr) -> ^EGLAttrib


// EGL surface/context attribute initialization callback types.
//
// This is called when SDL is attempting to create an EGL surface, to let the
// app add extra attributes to its eglCreateWindowSurface() or
// eglCreateContext calls.
//
// For convenience, the EGLDisplay and EGLConfig to use are provided to the
// callback.
//
// The callback should return a pointer to an EGL attribute array terminated
// with `EGL_NONE`. If this function returns NULL, the CreateWindow
// process will fail gracefully.
//
// The returned pointer should be allocated with malloc() and will be
// passed to free().
//
// The arrays returned by each callback will be appended to the existing
// attribute arrays defined by SDL.
//
// \param userdata an app-controlled pointer that is passed to the callback.
// \param display the EGL display to be used.
// \param config the EGL config to be used.
// \returns a newly-allocated array of attributes, terminated with `EGL_NONE`.
//
// \since This datatype is available since SDL 3.0.0.
//
// \sa EGL_SetAttributeCallbacks

EGLIntArrayCallback :: #type proc "c" (
	userdata: rawptr,
	display: EGLDisplay,
	config: EGLConfig,
) -> ^EGLint


// An enumeration of OpenGL configuration attributes.
//
// While you can set most OpenGL attributes normally, the attributes listed
// above must be known before SDL creates the window that will be used with
// the OpenGL context. These attributes are set and read with
// GL_SetAttribute() and GL_GetAttribute().
//
// In some cases, these attributes are minimum requests; the GL does not
// promise to give you exactly what you asked for. It's possible to ask for a
// 16-bit depth buffer and get a 24-bit one instead, for example, or to ask
// for no stencil buffer and still have one available. Context creation should
// fail if the GL can't provide your requested attributes at a minimum, but
// you should check to see exactly what you got.
//
// \since This enum is available since SDL 3.0.0.

GLattr :: enum c.int {
	RED_SIZE,
	/**< the minimum number of bits for the red channel of the color buffer; defaults to 3. */
	GREEN_SIZE,
	/**< the minimum number of bits for the green channel of the color buffer; defaults to 3. */
	BLUE_SIZE,
	/**< the minimum number of bits for the blue channel of the color buffer; defaults to 2. */
	ALPHA_SIZE,
	/**< the minimum number of bits for the alpha channel of the color buffer; defaults to 0. */
	BUFFER_SIZE,
	/**< the minimum number of bits for frame buffer size; defaults to 0. */
	DOUBLEBUFFER,
	/**< whether the output is single or double buffered; defaults to double buffering on. */
	DEPTH_SIZE,
	/**< the minimum number of bits in the depth buffer; defaults to 16. */
	STENCIL_SIZE,
	/**< the minimum number of bits in the stencil buffer; defaults to 0. */
	ACCUM_RED_SIZE,
	/**< the minimum number of bits for the red channel of the accumulation buffer; defaults to 0. */
	ACCUM_GREEN_SIZE,
	/**< the minimum number of bits for the green channel of the accumulation buffer; defaults to 0. */
	ACCUM_BLUE_SIZE,
	/**< the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0. */
	ACCUM_ALPHA_SIZE,
	/**< the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0. */
	STEREO,
	/**< whether the output is stereo 3D; defaults to off. */
	MULTISAMPLEBUFFERS,
	/**< the number of buffers used for multisample anti-aliasing; defaults to 0. */
	MULTISAMPLESAMPLES,
	/**< the number of samples used around the current pixel used for multisample anti-aliasing. */
	ACCELERATED_VISUAL,
	/**< set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either. */
	RETAINED_BACKING,
	/**< not used (deprecated). */
	CONTEXT_MAJOR_VERSION,
	/**< OpenGL context major version. */
	CONTEXT_MINOR_VERSION,
	/**< OpenGL context minor version. */
	CONTEXT_FLAGS,
	/**< some combination of 0 or more of elements of the GLcontextFlag enumeration; defaults to 0. */
	CONTEXT_PROFILE_MASK,
	/**< type of GL context (Core, Compatibility, ES). See GLprofile; default value depends on platform. */
	SHARE_WITH_CURRENT_CONTEXT,
	/**< OpenGL context sharing; defaults to 0. */
	FRAMEBUFFER_SRGB_CAPABLE,
	/**< requests sRGB capable visual; defaults to 0. */
	CONTEXT_RELEASE_BEHAVIOR,
	/**< sets context the release behavior. See GLcontextReleaseFlag; defaults to FLUSH. */
	CONTEXT_RESET_NOTIFICATION,
	/**< set context reset notification. See GLContextResetNotification; defaults to NO_NOTIFICATION. */
	CONTEXT_NO_ERROR,
	FLOATBUFFERS,
	EGL_PLATFORM,
}


// Possible values to be set for the GL_CONTEXT_PROFILE_MASK attribute.
//
// \since This enum is available since SDL 3.0.0.

GLprofile :: enum c.int {
	CORE          = 0x0001,
	COMPATIBILITY = 0x0002,
	ES            = 0x0004, /**< GLX_CONTEXT_ES2_PROFILE_BIT_EXT */
}


// Possible values to be set for the GL_CONTEXT_FLAGS attribute.
//
// \since This enum is available since SDL 3.0.0.

GLcontextFlag :: enum c.int {
	DEBUG_FLAG              = 0x0001,
	FORWARD_COMPATIBLE_FLAG = 0x0002,
	ROBUST_ACCESS_FLAG      = 0x0004,
	RESET_ISOLATION_FLAG    = 0x0008,
}


// Possible values to be set for the GL_CONTEXT_RELEASE_BEHAVIOR
// attribute.
//
// \since This enum is available since SDL 3.0.0.

GLcontextReleaseFlag :: enum c.int {
	NONE  = 0x0000,
	FLUSH = 0x0001,
}


// Possible values to be set GL_CONTEXT_RESET_NOTIFICATION attribute.
//
// \since This enum is available since SDL 3.0.0.

GLContextResetNotification :: enum c.int {
	NO_NOTIFICATION = 0x0000,
	LOSE_CONTEXT    = 0x0001,
}

PROP_DISPLAY_HDR_ENABLED_BOOLEAN :: "SDL.display.HDR_enabled"
PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER :: "SDL.display.KMSDRM.panel_orientation"

PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN :: "SDL.window.create.always_on_top"
PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN :: "SDL.window.create.borderless"
PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN :: "SDL.window.create.focusable"
PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN :: "SDL.window.create.external_graphics_context"
PROP_WINDOW_CREATE_FLAGS_NUMBER :: "SDL.window.create.flags"
PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN :: "SDL.window.create.fullscreen"
PROP_WINDOW_CREATE_HEIGHT_NUMBER :: "SDL.window.create.height"
PROP_WINDOW_CREATE_HIDDEN_BOOLEAN :: "SDL.window.create.hidden"
PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN :: "SDL.window.create.high_pixel_density"
PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN :: "SDL.window.create.maximized"
PROP_WINDOW_CREATE_MENU_BOOLEAN :: "SDL.window.create.menu"
PROP_WINDOW_CREATE_METAL_BOOLEAN :: "SDL.window.create.metal"
PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN :: "SDL.window.create.minimized"
PROP_WINDOW_CREATE_MODAL_BOOLEAN :: "SDL.window.create.modal"
PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN :: "SDL.window.create.mouse_grabbed"
PROP_WINDOW_CREATE_OPENGL_BOOLEAN :: "SDL.window.create.opengl"
PROP_WINDOW_CREATE_PARENT_POINTER :: "SDL.window.create.parent"
PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN :: "SDL.window.create.resizable"
PROP_WINDOW_CREATE_TITLE_STRING :: "SDL.window.create.title"
PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN :: "SDL.window.create.transparent"
PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN :: "SDL.window.create.tooltip"
PROP_WINDOW_CREATE_UTILITY_BOOLEAN :: "SDL.window.create.utility"
PROP_WINDOW_CREATE_VULKAN_BOOLEAN :: "SDL.window.create.vulkan"
PROP_WINDOW_CREATE_WIDTH_NUMBER :: "SDL.window.create.width"
PROP_WINDOW_CREATE_X_NUMBER :: "SDL.window.create.x"
PROP_WINDOW_CREATE_Y_NUMBER :: "SDL.window.create.y"
PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER :: "SDL.window.create.cocoa.window"
PROP_WINDOW_CREATE_COCOA_VIEW_POINTER :: "SDL.window.create.cocoa.view"
PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN :: "SDL.window.create.wayland.surface_role_custom"
PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN :: "SDL.window.create.wayland.create_egl_window"
PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER :: "SDL.window.create.wayland.wl_surface"
PROP_WINDOW_CREATE_WIN32_HWND_POINTER :: "SDL.window.create.win32.hwnd"
PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER :: "SDL.window.create.win32.pixel_format_hwnd"
PROP_WINDOW_CREATE_X11_WINDOW_NUMBER :: "SDL.window.create.x11.window"

PROP_WINDOW_SHAPE_POINTER :: "SDL.window.shape"
PROP_WINDOW_HDR_ENABLED_BOOLEAN :: "SDL.window.HDR_enabled"
PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT :: "SDL.window.SDR_white_level"
PROP_WINDOW_HDR_HEADROOM_FLOAT :: "SDL.window.HDR_headroom"
PROP_WINDOW_ANDROID_WINDOW_POINTER :: "SDL.window.android.window"
PROP_WINDOW_ANDROID_SURFACE_POINTER :: "SDL.window.android.surface"
PROP_WINDOW_UIKIT_WINDOW_POINTER :: "SDL.window.uikit.window"
PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER :: "SDL.window.uikit.metal_view_tag"
PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER :: "SDL.window.uikit.opengl.framebuffer"
PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER :: "SDL.window.uikit.opengl.renderbuffer"
PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER :: "SDL.window.uikit.opengl.resolve_framebuffer"
PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER :: "SDL.window.kmsdrm.dev_index"
PROP_WINDOW_KMSDRM_DRM_FD_NUMBER :: "SDL.window.kmsdrm.drm_fd"
PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER :: "SDL.window.kmsdrm.gbm_dev"
PROP_WINDOW_COCOA_WINDOW_POINTER :: "SDL.window.cocoa.window"
PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER :: "SDL.window.cocoa.metal_view_tag"
PROP_WINDOW_VIVANTE_DISPLAY_POINTER :: "SDL.window.vivante.display"
PROP_WINDOW_VIVANTE_WINDOW_POINTER :: "SDL.window.vivante.window"
PROP_WINDOW_VIVANTE_SURFACE_POINTER :: "SDL.window.vivante.surface"
PROP_WINDOW_WIN32_HWND_POINTER :: "SDL.window.win32.hwnd"
PROP_WINDOW_WIN32_HDC_POINTER :: "SDL.window.win32.hdc"
PROP_WINDOW_WIN32_INSTANCE_POINTER :: "SDL.window.win32.instance"
PROP_WINDOW_WAYLAND_DISPLAY_POINTER :: "SDL.window.wayland.display"
PROP_WINDOW_WAYLAND_SURFACE_POINTER :: "SDL.window.wayland.surface"
PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER :: "SDL.window.wayland.egl_window"
PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER :: "SDL.window.wayland.xdg_surface"
PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER :: "SDL.window.wayland.xdg_toplevel"
PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING :: "SDL.window.wayland.xdg_toplevel_export_handle"
PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER :: "SDL.window.wayland.xdg_popup"
PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER :: "SDL.window.wayland.xdg_positioner"
PROP_WINDOW_X11_DISPLAY_POINTER :: "SDL.window.x11.display"
PROP_WINDOW_X11_SCREEN_NUMBER :: "SDL.window.x11.screen"
PROP_WINDOW_X11_WINDOW_NUMBER :: "SDL.window.x11.window"

WINDOW_SURFACE_VSYNC_DISABLED :: 0
WINDOW_SURFACE_VSYNC_ADAPTIVE :: -1


// Possible return values from the HitTest callback.
//
// \since This enum is available since SDL 3.0.0.
//
// \sa HitTest

HitTestResult :: enum c.int {
	NORMAL, /**< Region is normal. No special properties. */
	DRAGGABLE, /**< Region can drag entire window. */
	RESIZE_TOPLEFT, /**< Region is the resizable top-left corner border. */
	RESIZE_TOP, /**< Region is the resizable top border. */
	RESIZE_TOPRIGHT, /**< Region is the resizable top-right corner border. */
	RESIZE_RIGHT, /**< Region is the resizable right border. */
	RESIZE_BOTTOMRIGHT, /**< Region is the resizable bottom-right corner border. */
	RESIZE_BOTTOM, /**< Region is the resizable bottom border. */
	RESIZE_BOTTOMLEFT, /**< Region is the resizable bottom-left corner border. */
	RESIZE_LEFT, /**< Region is the resizable left border. */
}


// Callback used for hit-testing.
//
// \param win the Window where hit-testing was set on.
// \param area an Point which should be hit-tested.
// \param data what was passed as `callback_data` to SetWindowHitTest().
// \returns an HitTestResult value.
//
// \sa SetWindowHitTest

HitTest :: #type proc "c" (win: ^Window, area: ^Point, data: rawptr) -> HitTestResult

/* Function prototypes */

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get the number of video drivers compiled into SDL.
	//
	// \returns the number of built in video drivers.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetVideoDriver

	GetNumVideoDrivers :: proc() -> c.int ---


	// Get the name of a built in video driver.
	//
	// The video drivers are presented in the order in which they are normally
	// checked during initialization.
	//
	// The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
	// "x11" or "windows". These never have Unicode characters, and are not meant
	// to be proper names.
	//
	// \param index the index of a video driver.
	// \returns the name of the video driver with the given **index**.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetNumVideoDrivers

	GetVideoDriver :: proc(index: c.int) -> cstring ---


	// Get the name of the currently initialized video driver.
	//
	// The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
	// "x11" or "windows". These never have Unicode characters, and are not meant
	// to be proper names.
	//
	// \returns the name of the current video driver or NULL if no driver has been
	//          initialized.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetNumVideoDrivers
	// \sa GetVideoDriver

	GetCurrentVideoDriver :: proc() -> cstring ---


	// Get the current system theme.
	//
	// \returns the current system theme, light, dark, or unknown.
	//
	// \since This function is available since SDL 3.0.0.

	GetSystemTheme :: proc() -> SystemTheme ---


	// Get a list of currently connected displays.
	//
	// \param count a pointer filled in with the number of displays returned, may
	//              be NULL.
	// \returns a 0 terminated array of display instance IDs or NULL on failure;
	//          call GetError() for more information. This should be freed
	//          with free() when it is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.

	GetDisplays :: proc(count: ^c.int) -> ^DisplayID ---


	// Return the primary display.
	//
	// \returns the instance ID of the primary display on success or 0 on failure;
	//          call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplays

	GetPrimaryDisplay :: proc() -> DisplayID ---


	// Get the properties associated with a display.
	//
	// The following read-only properties are provided by SDL:
	//
	// - `PROP_DISPLAY_HDR_ENABLED_BOOLEAN`: true if the display has HDR
	//   headroom above the SDR white point. This is for informational and
	//   diagnostic purposes only, as not all platforms provide this information
	//   at the display level.
	//
	// On KMS/DRM:
	//
	// - `PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER`: the "panel
	//   orientation" property for the display in degrees of clockwise rotation.
	//   Note that this is provided only as a hint, and the application is
	//   responsible for any coordinate transformations needed to conform to the
	//   requested display orientation.
	//
	// \param displayID the instance ID of the display to query.
	// \returns a valid property ID on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetDisplayProperties :: proc(displayID: DisplayID) -> PropertiesID ---


	// Get the name of a display in UTF-8 encoding.
	//
	// \param displayID the instance ID of the display to query.
	// \returns the name of a display or NULL on failure; call GetError() for
	//          more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplays

	GetDisplayName :: proc(displayID: DisplayID) -> cstring ---


	// Get the desktop area represented by a display.
	//
	// The primary display is always located at (0,0).
	//
	// \param displayID the instance ID of the display to query.
	// \param rect the Rect structure filled in with the display bounds.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplayUsableBounds
	// \sa GetDisplays

	GetDisplayBounds :: proc(displayID: DisplayID, rect: ^Rect) -> c.bool ---


	// Get the usable desktop area represented by a display, in screen
	// coordinates.
	//
	// This is the same area as GetDisplayBounds() reports, but with portions
	// reserved by the system removed. For example, on Apple's macOS, this
	// subtracts the area occupied by the menu bar and dock.
	//
	// Setting a window to be fullscreen generally bypasses these unusable areas,
	// so these are good guidelines for the maximum space available to a
	// non-fullscreen window.
	//
	// \param displayID the instance ID of the display to query.
	// \param rect the Rect structure filled in with the display bounds.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplayBounds
	// \sa GetDisplays

	GetDisplayUsableBounds :: proc(displayID: DisplayID, rect: ^Rect) -> c.bool ---


	// Get the orientation of a display when it is unrotated.
	//
	// \param displayID the instance ID of the display to query.
	// \returns the DisplayOrientation enum value of the display, or
	//          `ORIENTATION_UNKNOWN` if it isn't available.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplays

	GetNaturalDisplayOrientation :: proc(displayID: DisplayID) -> DisplayOrientation ---


	// Get the orientation of a display.
	//
	// \param displayID the instance ID of the display to query.
	// \returns the DisplayOrientation enum value of the display, or
	//          `ORIENTATION_UNKNOWN` if it isn't available.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplays

	GetCurrentDisplayOrientation :: proc(displayID: DisplayID) -> DisplayOrientation ---


	// Get the content scale of a display.
	//
	// The content scale is the expected scale for content based on the DPI
	// settings of the display. For example, a 4K display might have a 2.0 (200%)
	// display scale, which means that the user expects UI elements to be twice as
	// big on this display, to aid in readability.
	//
	// \param displayID the instance ID of the display to query.
	// \returns the content scale of the display, or 0.0f on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplays

	GetDisplayContentScale :: proc(displayID: DisplayID) -> c.float ---


	// Get a list of fullscreen display modes available on a display.
	//
	// The display modes are sorted in this priority:
	//
	// - w -> largest to smallest
	// - h -> largest to smallest
	// - bits per pixel -> more colors to fewer colors
	// - packed pixel layout -> largest to smallest
	// - refresh rate -> highest to lowest
	// - pixel density -> lowest to highest
	//
	// \param displayID the instance ID of the display to query.
	// \param count a pointer filled in with the number of display modes returned,
	//              may be NULL.
	// \returns a NULL terminated array of display mode pointers or NULL on
	//          failure; call GetError() for more information. This is a
	//          single allocation that should be freed with free() when it is
	//          no longer needed.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplays

	GetFullscreenDisplayModes :: proc(displayID: DisplayID, count: ^c.int) -> [^]^DisplayMode ---


	// Get the closest match to the requested display mode.
	//
	// The available display modes are scanned and `closest` is filled in with the
	// closest mode matching the requested mode and returned. The mode format and
	// refresh rate default to the desktop mode if they are set to 0. The modes
	// are scanned with size being first priority, format being second priority,
	// and finally checking the refresh rate. If all the available modes are too
	// small, then NULL is returned.
	//
	// \param displayID the instance ID of the display to query.
	// \param w the width in pixels of the desired display mode.
	// \param h the height in pixels of the desired display mode.
	// \param refresh_rate the refresh rate of the desired display mode, or 0.0f
	//                     for the desktop refresh rate.
	// \param include_high_density_modes boolean to include high density modes in
	//                                   the search.
	// \param mode a pointer filled in with the closest display mode equal to or
	//             larger than the desired mode.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplays
	// \sa GetFullscreenDisplayModes

	GetClosestFullscreenDisplayMode :: proc(displayID: DisplayID, w, h: c.int, refresh_rate: c.float, include_high_density_modes: c.bool, mode: ^DisplayMode) -> c.bool ---


	// Get information about the desktop's display mode.
	//
	// There's a difference between this function and GetCurrentDisplayMode()
	// when SDL runs fullscreen and has changed the resolution. In that case this
	// function will return the previous native display mode, and not the current
	// display mode.
	//
	// \param displayID the instance ID of the display to query.
	// \returns a pointer to the desktop display mode or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetCurrentDisplayMode
	// \sa GetDisplays

	GetDesktopDisplayMode :: proc(displayID: DisplayID) -> ^DisplayMode ---


	// Get information about the current display mode.
	//
	// There's a difference between this function and GetDesktopDisplayMode()
	// when SDL runs fullscreen and has changed the resolution. In that case this
	// function will return the current display mode, and not the previous native
	// display mode.
	//
	// \param displayID the instance ID of the display to query.
	// \returns a pointer to the desktop display mode or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDesktopDisplayMode
	// \sa GetDisplays

	GetCurrentDisplayMode :: proc(displayID: DisplayID) -> ^DisplayMode ---


	// Get the display containing a point.
	//
	// \param point the point to query.
	// \returns the instance ID of the display containing the point or 0 on
	//          failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplayBounds
	// \sa GetDisplays

	GetDisplayForPoint :: proc(point: ^Point) -> DisplayID ---


	// Get the display primarily containing a rect.
	//
	// \param rect the rect to query.
	// \returns the instance ID of the display entirely containing the rect or
	//          closest to the center of the rect on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplayBounds
	// \sa GetDisplays

	GetDisplayForRect :: proc(rect: ^Rect) -> DisplayID ---


	// Get the display associated with a window.
	//
	// \param window the window to query.
	// \returns the instance ID of the display containing the center of the window
	//          on success or 0 on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetDisplayBounds
	// \sa GetDisplays

	GetDisplayForWindow :: proc(window: ^Window) -> DisplayID ---


	// Get the pixel density of a window.
	//
	// This is a ratio of pixel size to window size. For example, if the window is
	// 1920x1080 and it has a high density back buffer of 3840x2160 pixels, it
	// would have a pixel density of 2.0.
	//
	// \param window the window to query.
	// \returns the pixel density or 0.0f on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowDisplayScale

	GetWindowPixelDensity :: proc(window: ^Window) -> c.float ---


	// Get the content display scale relative to a window's pixel size.
	//
	// This is a combination of the window pixel density and the display content
	// scale, and is the expected scale for displaying content in this window. For
	// example, if a 3840x2160 window had a display scale of 2.0, the user expects
	// the content to take twice as many pixels and be the same physical size as
	// if it were being displayed in a 1920x1080 window with a display scale of
	// 1.0.
	//
	// Conceptually this value corresponds to the scale display setting, and is
	// updated when that setting is changed, or the window moves to a display with
	// a different scale setting.
	//
	// \param window the window to query.
	// \returns the display scale, or 0.0f on failure; call GetError() for
	//          more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetWindowDisplayScale :: proc(window: ^Window) -> c.float ---


	// Set the display mode to use when a window is visible and fullscreen.
	//
	// This only affects the display mode used when the window is fullscreen. To
	// change the window size when the window is not fullscreen, use
	// SetWindowSize().
	//
	// If the window is currently in the fullscreen state, this request is
	// asynchronous on some windowing systems and the new mode dimensions may not
	// be applied immediately upon the return of this function. If an immediate
	// change is required, call SyncWindow() to block until the changes have
	// taken effect.
	//
	// When the new mode takes effect, an EVENT_WINDOW_RESIZED and/or an
	// EVENT_WINDOW_PIXEL_SIZE_CHANGED event will be emitted with the new mode
	// dimensions.
	//
	// \param window the window to affect.
	// \param mode a pointer to the display mode to use, which can be NULL for
	//             borderless fullscreen desktop mode, or one of the fullscreen
	//             modes returned by GetFullscreenDisplayModes() to set an
	//             exclusive fullscreen mode.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowFullscreenMode
	// \sa SetWindowFullscreen
	// \sa SyncWindow

	SetWindowFullscreenMode :: proc(window: ^Window, mode: ^DisplayMode) -> c.bool ---


	// Query the display mode to use when a window is visible at fullscreen.
	//
	// \param window the window to query.
	// \returns a pointer to the exclusive fullscreen mode to use or NULL for
	//          borderless fullscreen desktop mode.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowFullscreenMode
	// \sa SetWindowFullscreen

	GetWindowFullscreenMode :: proc(window: ^Window) -> ^DisplayMode ---


	// Get the raw ICC profile data for the screen the window is currently on.
	//
	// \param window the window to query.
	// \param size the size of the ICC profile.
	// \returns the raw ICC profile data on success or NULL on failure; call
	//          GetError() for more information. This should be freed with
	//          free() when it is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.

	GetWindowICCProfile :: proc(window: ^Window, size: ^c.size_t) -> rawptr ---


	// Get the pixel format associated with the window.
	//
	// \param window the window to query.
	// \returns the pixel format of the window on success or
	//          PIXELFORMAT_UNKNOWN on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GetWindowPixelFormat :: proc(window: ^Window) -> PixelFormat ---


	// Get a list of valid windows.
	//
	// \param count a pointer filled in with the number of windows returned, may
	//              be NULL.
	// \returns a NULL terminated array of Window pointers or NULL on failure;
	//          call GetError() for more information. This is a single
	//          allocation that should be freed with free() when it is no
	//          longer needed.
	//
	// \since This function is available since SDL 3.0.0.

	GetWindows :: proc(count: ^c.int) -> [^]^Window ---


	// Create a window with the specified dimensions and flags.
	//
	// `flags` may be any of the following OR'd together:
	//
	// - `WINDOW_FULLSCREEN`: fullscreen window at desktop resolution
	// - `WINDOW_OPENGL`: window usable with an OpenGL context
	// - `WINDOW_OCCLUDED`: window partially or completely obscured by another
	//   window
	// - `WINDOW_HIDDEN`: window is not visible
	// - `WINDOW_BORDERLESS`: no window decoration
	// - `WINDOW_RESIZABLE`: window can be resized
	// - `WINDOW_MINIMIZED`: window is minimized
	// - `WINDOW_MAXIMIZED`: window is maximized
	// - `WINDOW_MOUSE_GRABBED`: window has grabbed mouse focus
	// - `WINDOW_INPUT_FOCUS`: window has input focus
	// - `WINDOW_MOUSE_FOCUS`: window has mouse focus
	// - `WINDOW_EXTERNAL`: window not created by SDL
	// - `WINDOW_MODAL`: window is modal
	// - `WINDOW_HIGH_PIXEL_DENSITY`: window uses high pixel density back
	//   buffer if possible
	// - `WINDOW_MOUSE_CAPTURE`: window has mouse captured (unrelated to
	//   MOUSE_GRABBED)
	// - `WINDOW_ALWAYS_ON_TOP`: window should always be above others
	// - `WINDOW_UTILITY`: window should be treated as a utility window, not
	//   showing in the task bar and window list
	// - `WINDOW_TOOLTIP`: window should be treated as a tooltip and does not
	//   get mouse or keyboard focus, requires a parent window
	// - `WINDOW_POPUP_MENU`: window should be treated as a popup menu,
	//   requires a parent window
	// - `WINDOW_KEYBOARD_GRABBED`: window has grabbed keyboard input
	// - `WINDOW_VULKAN`: window usable with a Vulkan instance
	// - `WINDOW_METAL`: window usable with a Metal instance
	// - `WINDOW_TRANSPARENT`: window with transparent buffer
	// - `WINDOW_NOT_FOCUSABLE`: window should not be focusable
	//
	// The Window is implicitly shown if WINDOW_HIDDEN is not set.
	//
	// On Apple's macOS, you **must** set the NSHighResolutionCapable Info.plist
	// property to YES, otherwise you will not receive a High-DPI OpenGL canvas.
	//
	// The window pixel size may differ from its window coordinate size if the
	// window is on a high pixel density display. Use GetWindowSize() to query
	// the client area's size in window coordinates, and
	// GetWindowSizeInPixels() or GetRenderOutputSize() to query the
	// drawable size in pixels. Note that the drawable size can vary after the
	// window is created and should be queried again if you get an
	// EVENT_WINDOW_PIXEL_SIZE_CHANGED event.
	//
	// If the window is created with any of the WINDOW_OPENGL or
	// WINDOW_VULKAN flags, then the corresponding LoadLibrary function
	// (GL_LoadLibrary or Vulkan_LoadLibrary) is called and the
	// corresponding UnloadLibrary function is called by DestroyWindow().
	//
	// If WINDOW_VULKAN is specified and there isn't a working Vulkan driver,
	// CreateWindow() will fail because Vulkan_LoadLibrary() will fail.
	//
	// If WINDOW_METAL is specified on an OS that does not support Metal,
	// CreateWindow() will fail.
	//
	// If you intend to use this window with an Renderer, you should use
	// CreateWindowAndRenderer() instead of this function, to avoid window
	// flicker.
	//
	// On non-Apple devices, SDL requires you to either not link to the Vulkan
	// loader or link to a dynamic library version. This limitation may be removed
	// in a future version of SDL.
	//
	// \param title the title of the window, in UTF-8 encoding.
	// \param w the width of the window.
	// \param h the height of the window.
	// \param flags 0, or one or more WindowFlags OR'd together.
	// \returns the window that was created or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreatePopupWindow
	// \sa CreateWindowWithProperties
	// \sa DestroyWindow

	CreateWindow :: proc(title: cstring, w, h: c.int, flags: WindowFlags) -> ^Window ---


	// Create a child popup window of the specified parent window.
	//
	// 'flags' **must** contain exactly one of the following: -
	// 'WINDOW_TOOLTIP': The popup window is a tooltip and will not pass any
	// input events. - 'WINDOW_POPUP_MENU': The popup window is a popup menu.
	// The topmost popup menu will implicitly gain the keyboard focus.
	//
	// The following flags are not relevant to popup window creation and will be
	// ignored:
	//
	// - 'WINDOW_MINIMIZED'
	// - 'WINDOW_MAXIMIZED'
	// - 'WINDOW_FULLSCREEN'
	// - 'WINDOW_BORDERLESS'
	//
	// The parent parameter **must** be non-null and a valid window. The parent of
	// a popup window can be either a regular, toplevel window, or another popup
	// window.
	//
	// Popup windows cannot be minimized, maximized, made fullscreen, raised,
	// flash, be made a modal window, be the parent of a modal window, or grab the
	// mouse and/or keyboard. Attempts to do so will fail.
	//
	// Popup windows implicitly do not have a border/decorations and do not appear
	// on the taskbar/dock or in lists of windows such as alt-tab menus.
	//
	// If a parent window is hidden, any child popup windows will be recursively
	// hidden as well. Child popup windows not explicitly hidden will be restored
	// when the parent is shown.
	//
	// If the parent window is destroyed, any child popup windows will be
	// recursively destroyed as well.
	//
	// \param parent the parent of the window, must not be NULL.
	// \param offset_x the x position of the popup window relative to the origin
	//                 of the parent.
	// \param offset_y the y position of the popup window relative to the origin
	//                 of the parent window.
	// \param w the width of the window.
	// \param h the height of the window.
	// \param flags WINDOW_TOOLTIP or WINDOW_POPUP_MENU, and zero or more
	//              additional WindowFlags OR'd together.
	// \returns the window that was created or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateWindow
	// \sa CreateWindowWithProperties
	// \sa DestroyWindow
	// \sa GetWindowParent

	CreatePopupWindow :: proc(parent: ^Window, offset_x, offset_y, w, h: c.int, flags: WindowFlags) -> ^Window ---


	// Create a window with the specified properties.
	//
	// These are the supported properties:
	//
	// - `PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN`: true if the window should
	//   be always on top
	// - `PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN`: true if the window has no
	//   window decoration
	// - `PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN`: true if the
	//   window will be used with an externally managed graphics context.
	// - `PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN`: true if the window should
	//   accept keyboard input (defaults true)
	// - `PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN`: true if the window should
	//   start in fullscreen mode at desktop resolution
	// - `PROP_WINDOW_CREATE_HEIGHT_NUMBER`: the height of the window
	// - `PROP_WINDOW_CREATE_HIDDEN_BOOLEAN`: true if the window should start
	//   hidden
	// - `PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN`: true if the window
	//   uses a high pixel density buffer if possible
	// - `PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN`: true if the window should
	//   start maximized
	// - `PROP_WINDOW_CREATE_MENU_BOOLEAN`: true if the window is a popup menu
	// - `PROP_WINDOW_CREATE_METAL_BOOLEAN`: true if the window will be used
	//   with Metal rendering
	// - `PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN`: true if the window should
	//   start minimized
	// - `PROP_WINDOW_CREATE_MODAL_BOOLEAN`: true if the window is modal to
	//   its parent
	// - `PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN`: true if the window starts
	//   with grabbed mouse focus
	// - `PROP_WINDOW_CREATE_OPENGL_BOOLEAN`: true if the window will be used
	//   with OpenGL rendering
	// - `PROP_WINDOW_CREATE_PARENT_POINTER`: an Window that will be the
	//   parent of this window, required for windows with the "toolip", "menu",
	//   and "modal" properties
	// - `PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN`: true if the window should be
	//   resizable
	// - `PROP_WINDOW_CREATE_TITLE_STRING`: the title of the window, in UTF-8
	//   encoding
	// - `PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN`: true if the window show
	//   transparent in the areas with alpha of 0
	// - `PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN`: true if the window is a tooltip
	// - `PROP_WINDOW_CREATE_UTILITY_BOOLEAN`: true if the window is a utility
	//   window, not showing in the task bar and window list
	// - `PROP_WINDOW_CREATE_VULKAN_BOOLEAN`: true if the window will be used
	//   with Vulkan rendering
	// - `PROP_WINDOW_CREATE_WIDTH_NUMBER`: the width of the window
	// - `PROP_WINDOW_CREATE_X_NUMBER`: the x position of the window, or
	//   `WINDOWPOS_CENTERED`, defaults to `WINDOWPOS_UNDEFINED`. This is
	//   relative to the parent for windows with the "parent" property set.
	// - `PROP_WINDOW_CREATE_Y_NUMBER`: the y position of the window, or
	//   `WINDOWPOS_CENTERED`, defaults to `WINDOWPOS_UNDEFINED`. This is
	//   relative to the parent for windows with the "parent" property set.
	//
	// These are additional supported properties on macOS:
	//
	// - `PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER`: the
	//   `(__unsafe_unretained)` NSWindow associated with the window, if you want
	//   to wrap an existing window.
	// - `PROP_WINDOW_CREATE_COCOA_VIEW_POINTER`: the `(__unsafe_unretained)`
	//   NSView associated with the window, defaults to `[window contentView]`
	//
	// These are additional supported properties on Wayland:
	//
	// - `PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN` - true if
	//   the application wants to use the Wayland surface for a custom role and
	//   does not want it attached to an XDG toplevel window. See
	//   [README/wayland](README/wayland) for more information on using custom
	//   surfaces.
	// - `PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN` - true if the
	//   application wants an associated `wl_egl_window` object to be created,
	//   even if the window does not have the OpenGL property or flag set.
	// - `PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER` - the wl_surface
	//   associated with the window, if you want to wrap an existing window. See
	//   [README/wayland](README/wayland) for more information.
	//
	// These are additional supported properties on Windows:
	//
	// - `PROP_WINDOW_CREATE_WIN32_HWND_POINTER`: the HWND associated with the
	//   window, if you want to wrap an existing window.
	// - `PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER`: optional,
	//   another window to share pixel format with, useful for OpenGL windows
	//
	// These are additional supported properties with X11:
	//
	// - `PROP_WINDOW_CREATE_X11_WINDOW_NUMBER`: the X11 Window associated
	//   with the window, if you want to wrap an existing window.
	//
	// The window is implicitly shown if the "hidden" property is not set.
	//
	// Windows with the "tooltip" and "menu" properties are popup windows and have
	// the behaviors and guidelines outlined in CreatePopupWindow().
	//
	// If this window is being created to be used with an Renderer, you should
	// not add a graphics API specific property
	// (`PROP_WINDOW_CREATE_OPENGL_BOOLEAN`, etc), as SDL will handle that
	// internally when it chooses a renderer. However, SDL might need to recreate
	// your window at that point, which may cause the window to appear briefly,
	// and then flicker as it is recreated. The correct approach to this is to
	// create the window with the `PROP_WINDOW_CREATE_HIDDEN_BOOLEAN` property
	// set to true, then create the renderer, then show the window with
	// ShowWindow().
	//
	// \param props the properties to use.
	// \returns the window that was created or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateProperties
	// \sa CreateWindow
	// \sa DestroyWindow

	CreateWindowWithProperties :: proc(props: PropertiesID) -> ^Window ---


	// Get the numeric ID of a window.
	//
	// The numeric ID is what WindowEvent references, and is necessary to map
	// these events to specific Window objects.
	//
	// \param window the window to query.
	// \returns the ID of the window on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowFromID

	GetWindowID :: proc(window: ^Window) -> WindowID ---


	// Get a window from a stored ID.
	//
	// The numeric ID is what WindowEvent references, and is necessary to map
	// these events to specific Window objects.
	//
	// \param id the ID of the window.
	// \returns the window associated with `id` or NULL if it doesn't exist; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowID

	GetWindowFromID :: proc(id: WindowID) -> ^Window ---


	// Get parent of a window.
	//
	// \param window the window to query.
	// \returns the parent of the window on success or NULL if the window has no
	//          parent.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreatePopupWindow

	GetWindowParent :: proc(window: ^Window) -> ^Window ---


	// Get the properties associated with a window.
	//
	// The following read-only properties are provided by SDL:
	//
	// - `PROP_WINDOW_SHAPE_POINTER`: the surface associated with a shaped
	//   window
	// - `PROP_WINDOW_HDR_ENABLED_BOOLEAN`: true if the window has HDR
	//   headroom above the SDR white point. This property can change dynamically
	//   when EVENT_WINDOW_HDR_STATE_CHANGED is sent.
	// - `PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT`: the value of SDR white in the
	//   COLORSPACE_SRGB_LINEAR colorspace. On Windows this corresponds to the
	//   SDR white level in scRGB colorspace, and on Apple platforms this is
	//   always 1.0 for EDR content. This property can change dynamically when
	//   EVENT_WINDOW_HDR_STATE_CHANGED is sent.
	// - `PROP_WINDOW_HDR_HEADROOM_FLOAT`: the additional high dynamic range
	//   that can be displayed, in terms of the SDR white point. When HDR is not
	//   enabled, this will be 1.0. This property can change dynamically when
	//   EVENT_WINDOW_HDR_STATE_CHANGED is sent.
	//
	// On Android:
	//
	// - `PROP_WINDOW_ANDROID_WINDOW_POINTER`: the ANativeWindow associated
	//   with the window
	// - `PROP_WINDOW_ANDROID_SURFACE_POINTER`: the EGLSurface associated with
	//   the window
	//
	// On iOS:
	//
	// - `PROP_WINDOW_UIKIT_WINDOW_POINTER`: the `(__unsafe_unretained)`
	//   UIWindow associated with the window
	// - `PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER`: the NSInteger tag
	//   assocated with metal views on the window
	// - `PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER`: the OpenGL view's
	//   framebuffer object. It must be bound when rendering to the screen using
	//   OpenGL.
	// - `PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER`: the OpenGL view's
	//   renderbuffer object. It must be bound when GL_SwapWindow is called.
	// - `PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER`: the OpenGL
	//   view's resolve framebuffer, when MSAA is used.
	//
	// On KMS/DRM:
	//
	// - `PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER`: the device index associated
	//   with the window (e.g. the X in /dev/dri/cardX)
	// - `PROP_WINDOW_KMSDRM_DRM_FD_NUMBER`: the DRM FD associated with the
	//   window
	// - `PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER`: the GBM device associated
	//   with the window
	//
	// On macOS:
	//
	// - `PROP_WINDOW_COCOA_WINDOW_POINTER`: the `(__unsafe_unretained)`
	//   NSWindow associated with the window
	// - `PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER`: the NSInteger tag
	//   assocated with metal views on the window
	//
	// On Vivante:
	//
	// - `PROP_WINDOW_VIVANTE_DISPLAY_POINTER`: the EGLNativeDisplayType
	//   associated with the window
	// - `PROP_WINDOW_VIVANTE_WINDOW_POINTER`: the EGLNativeWindowType
	//   associated with the window
	// - `PROP_WINDOW_VIVANTE_SURFACE_POINTER`: the EGLSurface associated with
	//   the window
	//
	// On Windows:
	//
	// - `PROP_WINDOW_WIN32_HWND_POINTER`: the HWND associated with the window
	// - `PROP_WINDOW_WIN32_HDC_POINTER`: the HDC associated with the window
	// - `PROP_WINDOW_WIN32_INSTANCE_POINTER`: the HINSTANCE associated with
	//   the window
	//
	// On Wayland:
	//
	// Note: The `xdg_*` window objects do not internally persist across window
	// show/hide calls. They will be null if the window is hidden and must be
	// queried each time it is shown.
	//
	// - `PROP_WINDOW_WAYLAND_DISPLAY_POINTER`: the wl_display associated with
	//   the window
	// - `PROP_WINDOW_WAYLAND_SURFACE_POINTER`: the wl_surface associated with
	//   the window
	// - `PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER`: the wl_egl_window
	//   associated with the window
	// - `PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER`: the xdg_surface associated
	//   with the window
	// - `PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER`: the xdg_toplevel role
	//   associated with the window
	// - 'PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING': the export
	//   handle associated with the window
	// - `PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER`: the xdg_popup role
	//   associated with the window
	// - `PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER`: the xdg_positioner
	//   associated with the window, in popup mode
	//
	// On X11:
	//
	// - `PROP_WINDOW_X11_DISPLAY_POINTER`: the X11 Display associated with
	//   the window
	// - `PROP_WINDOW_X11_SCREEN_NUMBER`: the screen number associated with
	//   the window
	// - `PROP_WINDOW_X11_WINDOW_NUMBER`: the X11 Window associated with the
	//   window
	//
	// \param window the window to query.
	// \returns a valid property ID on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetWindowProperties :: proc(window: ^Window) -> PropertiesID ---


	// Get the window flags.
	//
	// \param window the window to query.
	// \returns a mask of the WindowFlags associated with `window`.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateWindow
	// \sa HideWindow
	// \sa MaximizeWindow
	// \sa MinimizeWindow
	// \sa SetWindowFullscreen
	// \sa SetWindowMouseGrab
	// \sa ShowWindow

	GetWindowFlags :: proc(window: ^Window) -> WindowFlags ---


	// Set the title of a window.
	//
	// This string is expected to be in UTF-8 encoding.
	//
	// \param window the window to change.
	// \param title the desired window title in UTF-8 format.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowTitle

	SetWindowTitle :: proc(window: ^Window, title: cstring) -> c.bool ---


	// Get the title of a window.
	//
	// \param window the window to query.
	// \returns the title of the window in UTF-8 format or "" if there is no
	//          title.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowTitle

	GetWindowTitle :: proc(window: ^Window) -> cstring ---


	// Set the icon for a window.
	//
	// If this function is passed a surface with alternate representations, the
	// surface will be interpreted as the content to be used for 100% display
	// scale, and the alternate representations will be used for high DPI
	// situations. For example, if the original surface is 32x32, then on a 2x
	// macOS display or 200% display scale on Windows, a 64x64 version of the
	// image will be used, if available. If a matching version of the image isn't
	// available, the closest larger size image will be downscaled to the
	// appropriate size and be used instead, if available. Otherwise, the closest
	// smaller image will be upscaled and be used instead.
	//
	// \param window the window to change.
	// \param icon an Surface structure containing the icon for the window.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	SetWindowIcon :: proc(window: ^Window, icon: ^Surface) -> bool ---


	// Request that the window's position be set.
	//
	// If, at the time of this request, the window is in a fixed-size state such
	// as maximized, this request may be deferred until the window returns to a
	// resizable state.
	//
	// This can be used to reposition fullscreen-desktop windows onto a different
	// display, however, exclusive fullscreen windows are locked to a specific
	// display and can only be repositioned programmatically via
	// SetWindowFullscreenMode().
	//
	// On some windowing systems this request is asynchronous and the new
	// coordinates may not have have been applied immediately upon the return of
	// this function. If an immediate change is required, call SyncWindow() to
	// block until the changes have taken effect.
	//
	// When the window position changes, an EVENT_WINDOW_MOVED event will be
	// emitted with the window's new coordinates. Note that the new coordinates
	// may not match the exact coordinates requested, as some windowing systems
	// can restrict the position of the window in certain scenarios (e.g.
	// constraining the position so the window is always within desktop bounds).
	// Additionally, as this is just a request, it can be denied by the windowing
	// system.
	//
	// \param window the window to reposition.
	// \param x the x coordinate of the window, or `WINDOWPOS_CENTERED` or
	//          `WINDOWPOS_UNDEFINED`.
	// \param y the y coordinate of the window, or `WINDOWPOS_CENTERED` or
	//          `WINDOWPOS_UNDEFINED`.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowPosition
	// \sa SyncWindow

	SetWindowPosition :: proc(window: ^Window, x, y: c.int) -> c.bool ---


	// Get the position of a window.
	//
	// This is the current position of the window as last reported by the
	// windowing system.
	//
	// If you do not need the value for one of the positions a NULL may be passed
	// in the `x` or `y` parameter.
	//
	// \param window the window to query.
	// \param x a pointer filled in with the x position of the window, may be
	//          NULL.
	// \param y a pointer filled in with the y position of the window, may be
	//          NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowPosition

	GetWindowPosition :: proc(window: ^Window, x, y: ^c.int) -> c.bool ---


	// Request that the size of a window's client area be set.
	//
	// If, at the time of this request, the window in a fixed-size state, such as
	// maximized or fullscreen, the request will be deferred until the window
	// exits this state and becomes resizable again.
	//
	// To change the fullscreen mode of a window, use
	// SetWindowFullscreenMode()
	//
	// On some windowing systems, this request is asynchronous and the new window
	// size may not have have been applied immediately upon the return of this
	// function. If an immediate change is required, call SyncWindow() to
	// block until the changes have taken effect.
	//
	// When the window size changes, an EVENT_WINDOW_RESIZED event will be
	// emitted with the new window dimensions. Note that the new dimensions may
	// not match the exact size requested, as some windowing systems can restrict
	// the window size in certain scenarios (e.g. constraining the size of the
	// content area to remain within the usable desktop bounds). Additionally, as
	// this is just a request, it can be denied by the windowing system.
	//
	// \param window the window to change.
	// \param w the width of the window, must be > 0.
	// \param h the height of the window, must be > 0.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowSize
	// \sa SetWindowFullscreenMode
	// \sa SyncWindow

	SetWindowSize :: proc(window: ^Window, w, h: c.int) -> c.bool ---


	// Get the size of a window's client area.
	//
	// The window pixel size may differ from its window coordinate size if the
	// window is on a high pixel density display. Use GetWindowSizeInPixels()
	// or GetRenderOutputSize() to get the real client area size in pixels.
	//
	// \param window the window to query the width and height from.
	// \param w a pointer filled in with the width of the window, may be NULL.
	// \param h a pointer filled in with the height of the window, may be NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRenderOutputSize
	// \sa GetWindowSizeInPixels
	// \sa SetWindowSize

	GetWindowSize :: proc(window: ^Window, w, h: ^c.int) -> c.bool ---


	// Get the safe area for this window.
	//
	// Some devices have portions of the screen which are partially obscured or
	// not interactive, possibly due to on-screen controls, curved edges, camera
	// notches, TV overscan, etc. This function provides the area of the window
	// which is safe to have interactible content. You should continue rendering
	// into the rest of the window, but it should not contain visually important
	// or interactible content.
	//
	// \param window the window to query.
	// \param rect a pointer filled in with the client area that is safe for
	//             interactive content.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GetWindowSafeArea :: proc(window: ^Window, rect: ^Rect) -> c.bool ---


	// Request that the aspect ratio of a window's client area be set.
	//
	// The aspect ratio is the ratio of width divided by height, e.g. 2560x1600
	// would be 1.6. Larger aspect ratios are wider and smaller aspect ratios are
	// narrower.
	//
	// If, at the time of this request, the window in a fixed-size state, such as
	// maximized or fullscreen, the request will be deferred until the window
	// exits this state and becomes resizable again.
	//
	// On some windowing systems, this request is asynchronous and the new window
	// aspect ratio may not have have been applied immediately upon the return of
	// this function. If an immediate change is required, call SyncWindow() to
	// block until the changes have taken effect.
	//
	// When the window size changes, an EVENT_WINDOW_RESIZED event will be
	// emitted with the new window dimensions. Note that the new dimensions may
	// not match the exact aspect ratio requested, as some windowing systems can
	// restrict the window size in certain scenarios (e.g. constraining the size
	// of the content area to remain within the usable desktop bounds).
	// Additionally, as this is just a request, it can be denied by the windowing
	// system.
	//
	// \param window the window to change.
	// \param min_aspect the minimum aspect ratio of the window, or 0.0f for no
	//                   limit.
	// \param max_aspect the maximum aspect ratio of the window, or 0.0f for no
	//                   limit.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowAspectRatio
	// \sa SyncWindow

	SetWindowAspectRatio :: proc(window: ^Window, min_aspect, max_aspect: c.float) -> c.bool ---


	// Get the size of a window's client area.
	//
	// \param window the window to query the width and height from.
	// \param min_aspect a pointer filled in with the minimum aspect ratio of the
	//                   window, may be NULL.
	// \param max_aspect a pointer filled in with the maximum aspect ratio of the
	//                   window, may be NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowAspectRatio

	GetWindowAspectRatio :: proc(window: ^Window, min_aspect, max_aspect: ^c.float) -> c.bool ---


	// Get the size of a window's borders (decorations) around the client area.
	//
	// Note: If this function fails (returns false), the size values will be
	// initialized to 0, 0, 0, 0 (if a non-NULL pointer is provided), as if the
	// window in question was borderless.
	//
	// Note: This function may fail on systems where the window has not yet been
	// decorated by the display server (for example, immediately after calling
	// CreateWindow). It is recommended that you wait at least until the
	// window has been presented and composited, so that the window system has a
	// chance to decorate the window and provide the border dimensions to SDL.
	//
	// This function also returns false if getting the information is not
	// supported.
	//
	// \param window the window to query the size values of the border
	//               (decorations) from.
	// \param top pointer to variable for storing the size of the top border; NULL
	//            is permitted.
	// \param left pointer to variable for storing the size of the left border;
	//             NULL is permitted.
	// \param bottom pointer to variable for storing the size of the bottom
	//               border; NULL is permitted.
	// \param right pointer to variable for storing the size of the right border;
	//              NULL is permitted.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowSize

	GetWindowBordersSize :: proc(window: ^Window, top, left, bottom, right: ^c.int) -> c.bool ---


	// Get the size of a window's client area, in pixels.
	//
	// \param window the window from which the drawable size should be queried.
	// \param w a pointer to variable for storing the width in pixels, may be
	//          NULL.
	// \param h a pointer to variable for storing the height in pixels, may be
	//          NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateWindow
	// \sa GetWindowSize

	GetWindowSizeInPixels :: proc(window: ^Window, w, h: ^c.int) -> c.bool ---


	// Set the minimum size of a window's client area.
	//
	// \param window the window to change.
	// \param min_w the minimum width of the window, or 0 for no limit.
	// \param min_h the minimum height of the window, or 0 for no limit.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowMinimumSize
	// \sa SetWindowMaximumSize

	SetWindowMinimumSize :: proc(window: ^Window, min_w, min_h: c.int) -> c.bool ---


	// Get the minimum size of a window's client area.
	//
	// \param window the window to query.
	// \param w a pointer filled in with the minimum width of the window, may be
	//          NULL.
	// \param h a pointer filled in with the minimum height of the window, may be
	//          NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowMaximumSize
	// \sa SetWindowMinimumSize

	GetWindowMinimumSize :: proc(window: ^Window, w, h: ^c.int) -> c.bool ---


	// Set the maximum size of a window's client area.
	//
	// \param window the window to change.
	// \param max_w the maximum width of the window, or 0 for no limit.
	// \param max_h the maximum height of the window, or 0 for no limit.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowMaximumSize
	// \sa SetWindowMinimumSize

	SetWindowMaximumSize :: proc(window: ^Window, max_w, max_h: c.int) -> c.bool ---


	// Get the maximum size of a window's client area.
	//
	// \param window the window to query.
	// \param w a pointer filled in with the maximum width of the window, may be
	//          NULL.
	// \param h a pointer filled in with the maximum height of the window, may be
	//          NULL.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowMinimumSize
	// \sa SetWindowMaximumSize

	GetWindowMaximumSize :: proc(window: ^Window, w, h: ^c.int) -> c.bool ---


	// Set the border state of a window.
	//
	// This will add or remove the window's `WINDOW_BORDERLESS` flag and add
	// or remove the border from the actual window. This is a no-op if the
	// window's border already matches the requested state.
	//
	// You can't change the border state of a fullscreen window.
	//
	// \param window the window of which to change the border state.
	// \param bordered false to remove border, true to add border.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowFlags

	SetWindowBordered :: proc(window: ^Window, bordered: c.bool) -> c.bool ---


	// Set the user-resizable state of a window.
	//
	// This will add or remove the window's `WINDOW_RESIZABLE` flag and
	// allow/disallow user resizing of the window. This is a no-op if the window's
	// resizable state already matches the requested state.
	//
	// You can't change the resizable state of a fullscreen window.
	//
	// \param window the window of which to change the resizable state.
	// \param resizable true to allow resizing, false to disallow.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowFlags

	SetWindowResizable :: proc(window: ^Window, resizable: c.bool) -> c.bool ---


	// Set the window to always be above the others.
	//
	// This will add or remove the window's `WINDOW_ALWAYS_ON_TOP` flag. This
	// will bring the window to the front and keep the window above the rest.
	//
	// \param window the window of which to change the always on top state.
	// \param on_top true to set the window always on top, false to disable.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowFlags

	SetWindowAlwaysOnTop :: proc(window: ^Window, on_top: c.bool) -> c.bool ---


	// Show a window.
	//
	// \param window the window to show.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa HideWindow
	// \sa RaiseWindow

	ShowWindow :: proc(window: ^Window) -> c.bool ---


	// Hide a window.
	//
	// \param window the window to hide.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ShowWindow

	HideWindow :: proc(window: ^Window) -> c.bool ---


	// Request that a window be raised above other windows and gain the input
	// focus.
	//
	// The result of this request is subject to desktop window manager policy,
	// particularly if raising the requested window would result in stealing focus
	// from another application. If the window is successfully raised and gains
	// input focus, an EVENT_WINDOW_FOCUS_GAINED event will be emitted, and
	// the window will have the WINDOW_INPUT_FOCUS flag set.
	//
	// \param window the window to raise.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	RaiseWindow :: proc(window: ^Window) -> c.bool ---


	// Request that the window be made as large as possible.
	//
	// Non-resizable windows can't be maximized. The window must have the
	// WINDOW_RESIZABLE flag set, or this will have no effect.
	//
	// On some windowing systems this request is asynchronous and the new window
	// state may not have have been applied immediately upon the return of this
	// function. If an immediate change is required, call SyncWindow() to
	// block until the changes have taken effect.
	//
	// When the window state changes, an EVENT_WINDOW_MAXIMIZED event will be
	// emitted. Note that, as this is just a request, the windowing system can
	// deny the state change.
	//
	// When maximizing a window, whether the constraints set via
	// SetWindowMaximumSize() are honored depends on the policy of the window
	// manager. Win32 and macOS enforce the constraints when maximizing, while X11
	// and Wayland window managers may vary.
	//
	// \param window the window to maximize.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa MinimizeWindow
	// \sa RestoreWindow
	// \sa SyncWindow

	MaximizeWindow :: proc(window: ^Window) -> c.bool ---


	// Request that the window be minimized to an iconic representation.
	//
	// On some windowing systems this request is asynchronous and the new window
	// state may not have have been applied immediately upon the return of this
	// function. If an immediate change is required, call SyncWindow() to
	// block until the changes have taken effect.
	//
	// When the window state changes, an EVENT_WINDOW_MINIMIZED event will be
	// emitted. Note that, as this is just a request, the windowing system can
	// deny the state change.
	//
	// \param window the window to minimize.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa MaximizeWindow
	// \sa RestoreWindow
	// \sa SyncWindow

	MinimizeWindow :: proc(window: ^Window) -> c.bool ---


	// Request that the size and position of a minimized or maximized window be
	// restored.
	//
	// On some windowing systems this request is asynchronous and the new window
	// state may not have have been applied immediately upon the return of this
	// function. If an immediate change is required, call SyncWindow() to
	// block until the changes have taken effect.
	//
	// When the window state changes, an EVENT_WINDOW_RESTORED event will be
	// emitted. Note that, as this is just a request, the windowing system can
	// deny the state change.
	//
	// \param window the window to restore.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa MaximizeWindow
	// \sa MinimizeWindow
	// \sa SyncWindow

	RestoreWindow :: proc(window: ^Window) -> c.bool ---


	// Request that the window's fullscreen state be changed.
	//
	// By default a window in fullscreen state uses borderless fullscreen desktop
	// mode, but a specific exclusive display mode can be set using
	// SetWindowFullscreenMode().
	//
	// On some windowing systems this request is asynchronous and the new
	// fullscreen state may not have have been applied immediately upon the return
	// of this function. If an immediate change is required, call SyncWindow()
	// to block until the changes have taken effect.
	//
	// When the window state changes, an EVENT_WINDOW_ENTER_FULLSCREEN or
	// EVENT_WINDOW_LEAVE_FULLSCREEN event will be emitted. Note that, as this
	// is just a request, it can be denied by the windowing system.
	//
	// \param window the window to change.
	// \param fullscreen true for fullscreen mode, false for windowed mode.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowFullscreenMode
	// \sa SetWindowFullscreenMode
	// \sa SyncWindow

	SetWindowFullscreen :: proc(window: ^Window, fullscreen: c.bool) -> c.bool ---


	// Block until any pending window state is finalized.
	//
	// On asynchronous windowing systems, this acts as a synchronization barrier
	// for pending window state. It will attempt to wait until any pending window
	// state has been applied and is guaranteed to return within finite time. Note
	// that for how long it can potentially block depends on the underlying window
	// system, as window state changes may involve somewhat lengthy animations
	// that must complete before the window is in its final requested state.
	//
	// On windowing systems where changes are immediate, this does nothing.
	//
	// \param window the window for which to wait for the pending state to be
	//               applied.
	// \returns true on success or false if the operation timed out before the
	//          window was in the requested state.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowSize
	// \sa SetWindowPosition
	// \sa SetWindowFullscreen
	// \sa MinimizeWindow
	// \sa MaximizeWindow
	// \sa RestoreWindow
	// \sa HINT_VIDEO_SYNC_WINDOW_OPERATIONS

	SyncWindow :: proc(window: ^Window) -> c.bool ---


	// Return whether the window has a surface associated with it.
	//
	// \param window the window to query.
	// \returns true if there is a surface associated with the window, or false
	//          otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowSurface

	WindowHasSurface :: proc(window: ^Window) -> c.bool ---


	// Get the SDL surface associated with the window.
	//
	// A new surface will be created with the optimal format for the window, if
	// necessary. This surface will be freed when the window is destroyed. Do not
	// free this surface.
	//
	// This surface will be invalidated if the window is resized. After resizing a
	// window this function must be called again to return a valid surface.
	//
	// You may not combine this with 3D or the rendering API on this window.
	//
	// This function is affected by `HINT_FRAMEBUFFER_ACCELERATION`.
	//
	// \param window the window to query.
	// \returns the surface associated with the window, or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa DestroyWindowSurface
	// \sa WindowHasSurface
	// \sa UpdateWindowSurface
	// \sa UpdateWindowSurfaceRects

	GetWindowSurface :: proc(window: ^Window) -> ^Surface ---


	// Toggle VSync for the window surface.
	//
	// When a window surface is created, vsync defaults to
	// WINDOW_SURFACE_VSYNC_DISABLED.
	//
	// The `vsync` parameter can be 1 to synchronize present with every vertical
	// refresh, 2 to synchronize present with every second vertical refresh, etc.,
	// WINDOW_SURFACE_VSYNC_ADAPTIVE for late swap tearing (adaptive vsync),
	// or WINDOW_SURFACE_VSYNC_DISABLED to disable. Not every value is
	// supported by every driver, so you should check the return value to see
	// whether the requested setting is supported.
	//
	// \param window the window.
	// \param vsync the vertical refresh sync interval.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowSurfaceVSync

	SetWindowSurfaceVSync :: proc(window: ^Window, vsync: c.int) -> c.bool ---


	// Get VSync for the window surface.
	//
	// \param window the window to query.
	// \param vsync an int filled with the current vertical refresh sync interval.
	//              See SetWindowSurfaceVSync() for the meaning of the value.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowSurfaceVSync

	GetWindowSurfaceVSync :: proc(window: ^Window, vsync: ^c.int) -> c.bool ---


	// Copy the window surface to the screen.
	//
	// This is the function you use to reflect any changes to the surface on the
	// screen.
	//
	// This function is equivalent to the SDL 1.2 API Flip().
	//
	// \param window the window to update.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowSurface
	// \sa UpdateWindowSurfaceRects

	UpdateWindowSurface :: proc(window: ^Window) -> c.bool ---


	// Copy areas of the window surface to the screen.
	//
	// This is the function you use to reflect changes to portions of the surface
	// on the screen.
	//
	// This function is equivalent to the SDL 1.2 API UpdateRects().
	//
	// Note that this function will update _at least_ the rectangles specified,
	// but this is only intended as an optimization; in practice, this might
	// update more of the screen (or all of the screen!), depending on what method
	// SDL uses to send pixels to the system.
	//
	// \param window the window to update.
	// \param rects an array of Rect structures representing areas of the
	//              surface to copy, in pixels.
	// \param numrects the number of rectangles.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowSurface
	// \sa UpdateWindowSurface

	UpdateWindowSurfaceRects :: proc(window: ^Window, rect: [^]^Rect, numrects: c.int) -> c.bool ---


	// Destroy the surface associated with the window.
	//
	// \param window the window to update.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowSurface
	// \sa WindowHasSurface

	DestroyWindowSurface :: proc(window: ^Window) -> c.bool ---


	// Set a window's keyboard grab mode.
	//
	// Keyboard grab enables capture of system keyboard shortcuts like Alt+Tab or
	// the Meta/Super key. Note that not all system keyboard shortcuts can be
	// captured by applications (one example is Ctrl+Alt+Del on Windows).
	//
	// This is primarily intended for specialized applications such as VNC clients
	// or VM frontends. Normal games should not use keyboard grab.
	//
	// When keyboard grab is enabled, SDL will continue to handle Alt+Tab when the
	// window is full-screen to ensure the user is not trapped in your
	// application. If you have a custom keyboard shortcut to exit fullscreen
	// mode, you may suppress this behavior with
	// `HINT_ALLOW_ALT_TAB_WHILE_GRABBED`.
	//
	// If the caller enables a grab while another window is currently grabbed, the
	// other window loses its grab in favor of the caller's window.
	//
	// \param window the window for which the keyboard grab mode should be set.
	// \param grabbed this is true to grab keyboard, and false to release.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowKeyboardGrab
	// \sa SetWindowMouseGrab

	SetWindowKeyboardGrab :: proc(window: ^Window, grabbed: c.bool) -> c.bool ---


	// Set a window's mouse grab mode.
	//
	// Mouse grab confines the mouse cursor to the window.
	//
	// \param window the window for which the mouse grab mode should be set.
	// \param grabbed this is true to grab mouse, and false to release.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowMouseGrab
	// \sa SetWindowKeyboardGrab

	SetWindowMouseGrab :: proc(window: ^Window, grabbed: c.bool) -> c.bool ---


	// Get a window's keyboard grab mode.
	//
	// \param window the window to query.
	// \returns true if keyboard is grabbed, and false otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowKeyboardGrab

	GetWindowKeyboardGrab :: proc(window: ^Window) -> c.bool ---


	// Get a window's mouse grab mode.
	//
	// \param window the window to query.
	// \returns true if mouse is grabbed, and false otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowKeyboardGrab

	GetWindowMouseGrab :: proc(window: ^Window) -> c.bool ---


	// Get the window that currently has an input grab enabled.
	//
	// \returns the window if input is grabbed or NULL otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowMouseGrab
	// \sa SetWindowKeyboardGrab

	GetGrabbedWindow :: proc() -> ^Window ---


	// Confines the cursor to the specified area of a window.
	//
	// Note that this does NOT grab the cursor, it only defines the area a cursor
	// is restricted to when the window has mouse focus.
	//
	// \param window the window that will be associated with the barrier.
	// \param rect a rectangle area in window-relative coordinates. If NULL the
	//             barrier for the specified window will be destroyed.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowMouseRect
	// \sa SetWindowMouseGrab

	SetWindowMouseRect :: proc(window: ^Window, rect: ^Rect) -> c.bool ---


	// Get the mouse confinement rectangle of a window.
	//
	// \param window the window to query.
	// \returns a pointer to the mouse confinement rectangle of a window, or NULL
	//          if there isn't one.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowMouseRect

	GetWindowMouseRect :: proc(window: ^Window) -> ^Rect ---


	// Set the opacity for a window.
	//
	// The parameter `opacity` will be clamped internally between 0.0f
	// (transparent) and 1.0f (opaque).
	//
	// This function also returns false if setting the opacity isn't supported.
	//
	// \param window the window which will be made transparent or opaque.
	// \param opacity the opacity value (0.0f - transparent, 1.0f - opaque).
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetWindowOpacity

	SetWindowOpacity :: proc(window: ^Window, opacity: c.float) -> c.bool ---


	// Get the opacity of a window.
	//
	// If transparency isn't supported on this platform, opacity will be returned
	// as 1.0f without error.
	//
	// \param window the window to get the current opacity value from.
	// \returns the opacity, (0.0f - transparent, 1.0f - opaque), or -1.0f on
	//          failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowOpacity

	GetWindowOpacity :: proc(window: ^Window) -> c.float ---


	// Set the window as a child of a parent window.
	//
	// If the window is already the child of an existing window, it will be
	// reparented to the new owner. Setting the parent window to NULL unparents
	// the window and removes child window status.
	//
	// Attempting to set the parent of a window that is currently in the modal
	// state will fail. Use SetWindowModalFor() to cancel the modal status
	// before attempting to change the parent.
	//
	// Setting a parent window that is currently the sibling or descendent of the
	// child window results in undefined behavior.
	//
	// \param window the window that should become the child of a parent.
	// \param parent the new parent window for the child window.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowModal

	SetWindowParent :: proc(window: ^Window, parent: ^Window) -> c.bool ---


	// Toggle the state of the window as modal.
	//
	// To enable modal status on a window, the window must currently be the child
	// window of a parent, or toggling modal status on will fail.
	//
	// \param window the window on which to set the modal state.
	// \param modal true to toggle modal status on, false to toggle it off.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa SetWindowParent

	SetWindowModal :: proc(window: ^Window, modal: c.bool) -> c.bool ---


	// Set whether the window may have input focus.
	//
	// \param window the window to set focusable state.
	// \param focusable true to allow input focus, false to not allow input focus.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	SetWindowFocusable :: proc(window: ^Window, focusable: c.bool) -> c.bool ---


	// Display the system-level window menu.
	//
	// This default window menu is provided by the system and on some platforms
	// provides functionality for setting or changing privileged state on the
	// window, such as moving it between workspaces or displays, or toggling the
	// always-on-top property.
	//
	// On platforms or desktops where this is unsupported, this function does
	// nothing.
	//
	// \param window the window for which the menu will be displayed.
	// \param x the x coordinate of the menu, relative to the origin (top-left) of
	//          the client area.
	// \param y the y coordinate of the menu, relative to the origin (top-left) of
	//          the client area.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	ShowWindowSystemMenu :: proc(window: ^Window, x, y: c.int) -> c.bool ---


	// Provide a callback that decides if a window region has special properties.
	//
	// Normally windows are dragged and resized by decorations provided by the
	// system window manager (a title bar, borders, etc), but for some apps, it
	// makes sense to drag them from somewhere else inside the window itself; for
	// example, one might have a borderless window that wants to be draggable from
	// any part, or simulate its own title bar, etc.
	//
	// This function lets the app provide a callback that designates pieces of a
	// given window as special. This callback is run during event processing if we
	// need to tell the OS to treat a region of the window specially; the use of
	// this callback is known as "hit testing."
	//
	// Mouse input may not be delivered to your application if it is within a
	// special area; the OS will often apply that input to moving the window or
	// resizing the window and not deliver it to the application.
	//
	// Specifying NULL for a callback disables hit-testing. Hit-testing is
	// disabled by default.
	//
	// Platforms that don't support this functionality will return false
	// unconditionally, even if you're attempting to disable hit-testing.
	//
	// Your callback may fire at any time, and its firing does not indicate any
	// specific behavior (for example, on Windows, this certainly might fire when
	// the OS is deciding whether to drag your window, but it fires for lots of
	// other reasons, too, some unrelated to anything you probably care about _and
	// when the mouse isn't actually at the location it is testing_). Since this
	// can fire at any time, you should try to keep your callback efficient,
	// devoid of allocations, etc.
	//
	// \param window the window to set hit-testing on.
	// \param callback the function to call when doing a hit-test.
	// \param callback_data an app-defined void pointer passed to **callback**.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	SetWindowHitTest :: proc(window: ^Window, callback: HitTest, callback_data: rawptr) -> c.bool ---


	// Set the shape of a transparent window.
	//
	// This sets the alpha channel of a transparent window and any fully
	// transparent areas are also transparent to mouse clicks. If you are using
	// something besides the SDL render API, then you are responsible for setting
	// the alpha channel of the window yourself.
	//
	// The shape is copied inside this function, so you can free it afterwards. If
	// your shape surface changes, you should call SetWindowShape() again to
	// update the window.
	//
	// The window must have been created with the WINDOW_TRANSPARENT flag.
	//
	// \param window the window.
	// \param shape the surface representing the shape of the window, or NULL to
	//              remove any current shape.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	SetWindowShape :: proc(window: ^Window, shape: ^Surface) -> c.bool ---


	// Request a window to demand attention from the user.
	//
	// \param window the window to be flashed.
	// \param operation the operation to perform.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	FlashWindow :: proc(window: ^Window, operation: FlashOperation) -> c.bool ---


	// Destroy a window.
	//
	// Any popups or modal windows owned by the window will be recursively
	// destroyed as well.
	//
	// \param window the window to destroy.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreatePopupWindow
	// \sa CreateWindow
	// \sa CreateWindowWithProperties

	DestroyWindow :: proc(window: ^Window) ---


	// Check whether the screensaver is currently enabled.
	//
	// The screensaver is disabled by default.
	//
	// The default can also be changed using `HINT_VIDEO_ALLOW_SCREENSAVER`.
	//
	// \returns true if the screensaver is enabled, false if it is disabled.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa DisableScreenSaver
	// \sa EnableScreenSaver

	ScreenSaverEnabled :: proc() -> c.bool ---


	// Allow the screen to be blanked by a screen saver.
	//
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa DisableScreenSaver
	// \sa ScreenSaverEnabled

	EnableScreenSaver :: proc() -> c.bool ---


	// Prevent the screen from being blanked by a screen saver.
	//
	// If you disable the screensaver, it is automatically re-enabled when SDL
	// quits.
	//
	// The screensaver is disabled by default, but this may by changed by
	// HINT_VIDEO_ALLOW_SCREENSAVER.
	//
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa EnableScreenSaver
	// \sa ScreenSaverEnabled

	DisableScreenSaver :: proc() -> c.bool ---


	//  \name OpenGL support functions

	/* @{ */


	// Dynamically load an OpenGL library.
	//
	// This should be done after initializing the video driver, but before
	// creating any OpenGL windows. If no OpenGL library is loaded, the default
	// library will be loaded upon creation of the first OpenGL window.
	//
	// If you do this, you need to retrieve all of the GL functions used in your
	// program from the dynamic library using GL_GetProcAddress().
	//
	// \param path the platform dependent OpenGL library name, or NULL to open the
	//             default OpenGL library.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_GetProcAddress
	// \sa GL_UnloadLibrary

	GL_LoadLibrary :: proc(path: cstring) -> c.bool ---


	// Get an OpenGL function by name.
	//
	// If the GL library is loaded at runtime with GL_LoadLibrary(), then all
	// GL functions must be retrieved this way. Usually this is used to retrieve
	// function pointers to OpenGL extensions.
	//
	// There are some quirks to looking up OpenGL functions that require some
	// extra care from the application. If you code carefully, you can handle
	// these quirks without any platform-specific code, though:
	//
	// - On Windows, function pointers are specific to the current GL context;
	//   this means you need to have created a GL context and made it current
	//   before calling GL_GetProcAddress(). If you recreate your context or
	//   create a second context, you should assume that any existing function
	//   pointers aren't valid to use with it. This is (currently) a
	//   Windows-specific limitation, and in practice lots of drivers don't suffer
	//   this limitation, but it is still the way the wgl API is documented to
	//   work and you should expect crashes if you don't respect it. Store a copy
	//   of the function pointers that comes and goes with context lifespan.
	// - On X11, function pointers returned by this function are valid for any
	//   context, and can even be looked up before a context is created at all.
	//   This means that, for at least some common OpenGL implementations, if you
	//   look up a function that doesn't exist, you'll get a non-NULL result that
	//   is _NOT_ safe to call. You must always make sure the function is actually
	//   available for a given GL context before calling it, by checking for the
	//   existence of the appropriate extension with GL_ExtensionSupported(),
	//   or verifying that the version of OpenGL you're using offers the function
	//   as core functionality.
	// - Some OpenGL drivers, on all platforms, *will* return NULL if a function
	//   isn't supported, but you can't count on this behavior. Check for
	//   extensions you use, and if you get a NULL anyway, act as if that
	//   extension wasn't available. This is probably a bug in the driver, but you
	//   can code defensively for this scenario anyhow.
	// - Just because you're on Linux/Unix, don't assume you'll be using X11.
	//   Next-gen display servers are waiting to replace it, and may or may not
	//   make the same promises about function pointers.
	// - OpenGL function pointers must be declared `APIENTRY` as in the example
	//   code. This will ensure the proper calling convention is followed on
	//   platforms where this matters (Win32) thereby avoiding stack corruption.
	//
	// \param proc the name of an OpenGL function.
	// \returns a pointer to the named OpenGL function. The returned pointer
	//          should be cast to the appropriate function signature.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_ExtensionSupported
	// \sa GL_LoadLibrary
	// \sa GL_UnloadLibrary

	GL_GetProcAddress :: proc(procedure: cstring) -> FunctionPointer ---


	// Get an EGL library function by name.
	//
	// If an EGL library is loaded, this function allows applications to get entry
	// points for EGL functions. This is useful to provide to an EGL API and
	// extension loader.
	//
	// \param proc the name of an EGL function.
	// \returns a pointer to the named EGL function. The returned pointer should
	//          be cast to the appropriate function signature.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa EGL_GetCurrentDisplay

	EGL_GetProcAddress :: proc(procedure: cstring) -> FunctionPointer ---


	// Unload the OpenGL library previously loaded by GL_LoadLibrary().
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_LoadLibrary

	GL_UnloadLibrary :: proc() ---


	// Check if an OpenGL extension is supported for the current context.
	//
	// This function operates on the current GL context; you must have created a
	// context and it must be current before calling this function. Do not assume
	// that all contexts you create will have the same set of extensions
	// available, or that recreating an existing context will offer the same
	// extensions again.
	//
	// While it's probably not a massive overhead, this function is not an O(1)
	// operation. Check the extensions you care about after creating the GL
	// context and save that information somewhere instead of calling the function
	// every time you need to know.
	//
	// \param extension the name of the extension to check.
	// \returns true if the extension is supported, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.

	GL_ExtensionSupported :: proc(extension: cstring) -> c.bool ---


	// Reset all previously set OpenGL context attributes to their default values.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_GetAttribute
	// \sa GL_SetAttribute

	GL_ResetAttributes :: proc() ---


	// Set an OpenGL window attribute before window creation.
	//
	// This function sets the OpenGL attribute `attr` to `value`. The requested
	// attributes should be set before creating an OpenGL window. You should use
	// GL_GetAttribute() to check the values after creating the OpenGL
	// context, since the values obtained can differ from the requested ones.
	//
	// \param attr an GLattr enum value specifying the OpenGL attribute to
	//             set.
	// \param value the desired value for the attribute.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_GetAttribute
	// \sa GL_ResetAttributes

	GL_SetAttribute :: proc(attr: GLattr, value: c.int) -> c.bool ---


	// Get the actual value for an attribute from the current context.
	//
	// \param attr an GLattr enum value specifying the OpenGL attribute to
	//             get.
	// \param value a pointer filled in with the current value of `attr`.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_ResetAttributes
	// \sa GL_SetAttribute

	GL_GetAttribute :: proc(attr: GLattr, value: ^c.int) -> c.bool ---


	// Create an OpenGL context for an OpenGL window, and make it current.
	//
	// Windows users new to OpenGL should note that, for historical reasons, GL
	// functions added after OpenGL version 1.1 are not available by default.
	// Those functions must be loaded at run-time, either with an OpenGL
	// extension-handling library or with GL_GetProcAddress() and its related
	// functions.
	//
	// GLContext is opaque to the application.
	//
	// \param window the window to associate with the context.
	// \returns the OpenGL context associated with `window` or NULL on failure;
	//          call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_DestroyContext
	// \sa GL_MakeCurrent

	GL_CreateContext :: proc(window: ^Window) -> GLContext ---


	// Set up an OpenGL context for rendering into an OpenGL window.
	//
	// The context must have been created with a compatible window.
	//
	// \param window the window to associate with the context.
	// \param context the OpenGL context to associate with the window.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_CreateContext

	GL_MakeCurrent :: proc(window: ^Window, ctx: GLContext) -> c.bool ---


	// Get the currently active OpenGL window.
	//
	// \returns the currently active OpenGL window on success or NULL on failure;
	//          call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GL_GetCurrentWindow :: proc() -> ^Window ---


	// Get the currently active OpenGL context.
	//
	// \returns the currently active OpenGL context or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_MakeCurrent

	GL_GetCurrentContext :: proc() -> GLContext ---


	// Get the currently active EGL display.
	//
	// \returns the currently active EGL display or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	EGL_GetCurrentDisplay :: proc() -> EGLDisplay ---


	// Get the currently active EGL config.
	//
	// \returns the currently active EGL config or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	EGL_GetCurrentConfig :: proc() -> EGLConfig ---


	// Get the EGL surface associated with the window.
	//
	// \param window the window to query.
	// \returns the EGLSurface pointer associated with the window, or NULL on
	//          failure.
	//
	// \since This function is available since SDL 3.0.0.

	EGL_GetWindowSurface :: proc(window: ^Window) -> EGLSurface ---


	// Sets the callbacks for defining custom EGLAttrib arrays for EGL
	// initialization.
	//
	// Callbacks that aren't needed can be set to NULL.
	//
	// NOTE: These callback pointers will be reset after GL_ResetAttributes.
	//
	// \param platformAttribCallback callback for attributes to pass to
	//                               eglGetPlatformDisplay. May be NULL.
	// \param surfaceAttribCallback callback for attributes to pass to
	//                              eglCreateSurface. May be NULL.
	// \param contextAttribCallback callback for attributes to pass to
	//                              eglCreateContext. May be NULL.
	// \param userdata a pointer that is passed to the callbacks.
	//
	// \since This function is available since SDL 3.0.0.

	EGL_SetAttributeCallbacks :: proc(platformAttribCallback: EGLAttribArrayCallback, surfaceAttribCallback, contextAttribCallback: EGLIntArrayCallback, userdata: rawptr) ---


	// Set the swap interval for the current OpenGL context.
	//
	// Some systems allow specifying -1 for the interval, to enable adaptive
	// vsync. Adaptive vsync works the same as vsync, but if you've already missed
	// the vertical retrace for a given frame, it swaps buffers immediately, which
	// might be less jarring for the user during occasional framerate drops. If an
	// application requests adaptive vsync and the system does not support it,
	// this function will fail and return false. In such a case, you should
	// probably retry the call with 1 for the interval.
	//
	// Adaptive vsync is implemented for some glX drivers with
	// GLX_EXT_swap_control_tear, and for some Windows drivers with
	// WGL_EXT_swap_control_tear.
	//
	// Read more on the Khronos wiki:
	// https://www.khronos.org/opengl/wiki/Swap_Interval#Adaptive_Vsync
	//
	// \param interval 0 for immediate updates, 1 for updates synchronized with
	//                 the vertical retrace, -1 for adaptive vsync.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_GetSwapInterval

	GL_SetSwapInterval :: proc(interval: c.int) -> c.bool ---


	// Get the swap interval for the current OpenGL context.
	//
	// If the system can't determine the swap interval, or there isn't a valid
	// current context, this function will set *interval to 0 as a safe default.
	//
	// \param interval output interval value. 0 if there is no vertical retrace
	//                 synchronization, 1 if the buffer swap is synchronized with
	//                 the vertical retrace, and -1 if late swaps happen
	//                 immediately instead of waiting for the next retrace.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_SetSwapInterval

	GL_GetSwapInterval :: proc(interval: ^c.int) -> c.bool ---


	// Update a window with OpenGL rendering.
	//
	// This is used with double-buffered OpenGL contexts, which are the default.
	//
	// On macOS, make sure you bind 0 to the draw framebuffer before swapping the
	// window, otherwise nothing will happen. If you aren't using
	// glBindFramebuffer(), this is the default and you won't have to do anything
	// extra.
	//
	// \param window the window to change.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GL_SwapWindow :: proc(window: ^Window) -> c.bool ---


	// Delete an OpenGL context.
	//
	// \param context the OpenGL context to be deleted.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GL_CreateContext

	GL_DestroyContext :: proc(ctx: GLContext) -> c.bool ---
}
