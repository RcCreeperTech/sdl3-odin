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


// # CategoryRect
//
// Some helper functions for managing rectangles and 2D points, in both
// integer and floating point versions.


// The structure that defines a point (using integers).
//
// \since This struct is available since SDL 3.0.0.
//
// \sa GetRectEnclosingPoints
// \sa PointInRect

Point :: [2]c.int


// The structure that defines a point (using floating point values).
//
// \since This struct is available since SDL 3.0.0.
//
// \sa GetRectEnclosingPointsFloat
// \sa PointInRectFloat

FPoint :: [2]c.float


// A rectangle, with the origin at the upper left (using integers).
//
// \since This struct is available since SDL 3.0.0.
//
// \sa RectEmpty
// \sa RectsEqual
// \sa HasRectIntersection
// \sa GetRectIntersection
// \sa GetRectAndLineIntersection
// \sa GetRectUnion
// \sa GetRectEnclosingPoints

Rect :: struct {
	x, y: c.int,
	w, h: c.int,
}


// A rectangle, with the origin at the upper left (using floating point
// values).
//
// \since This struct is available since SDL 3.0.0.
//
// \sa RectEmptyFloat
// \sa RectsEqualFloat
// \sa RectsEqualEpsilon
// \sa HasRectIntersectionFloat
// \sa GetRectIntersectionFloat
// \sa GetRectAndLineIntersectionFloat
// \sa GetRectUnionFloat
// \sa GetRectEnclosingPointsFloat
// \sa PointInRectFloat

FRect :: struct {
	x, y: c.float,
	w, h: c.float,
}


// Convert an Rect to FRect
//
// \param rect a pointer to an Rect.
// \param frect a pointer filled in with the floating point representation of
//              `rect`.
//
// \threadsafety It is safe to call this function from any thread.
//
// \since This function is available since SDL 3.0.0.

RectToFRect :: #force_inline proc "c" (rect: Rect) -> FRect {
	return {
		x = cast(c.float)rect.x,
		y = cast(c.float)rect.y,
		w = cast(c.float)rect.w,
		h = cast(c.float)rect.h,
	}
}


// Determine whether a point resides inside a rectangle.
//
// A point is considered part of a rectangle if both `p` and `r` are not NULL,
// and `p`'s x and y coordinates are >= to the rectangle's top left corner,
// and < the rectangle's x+w and y+h. So a 1x1 rectangle considers point (0,0)
// as "inside" and (0,1) as not.
//
// Note that this is a forced-inline function in a header, and not a public
// API function available in the SDL library (which is to say, the code is
// embedded in the calling program and the linker and dynamic loader will not
// be able to find this function inside SDL itself).
//
// \param p the point to test.
// \param r the rectangle to test.
// \returns true if `p` is contained by `r`, false otherwise.
//
// \threadsafety It is safe to call this function from any thread.
//
// \since This function is available since SDL 3.0.0.

PointInRect :: #force_inline proc "c" (p: ^Point, r: ^Rect) -> c.bool {
	return(
		p != nil &&
		r != nil &&
		(p.x >= r.x) &&
		(p.x < (r.x + r.w)) &&
		(p.y >= r.y) &&
		(p.y < (r.y + r.h)) \
	)
}


// Determine whether a rectangle has no area.
//
// A rectangle is considered "empty" for this function if `r` is NULL, or if
// `r`'s width and/or height are <= 0.
//
// Note that this is a forced-inline function in a header, and not a public
// API function available in the SDL library (which is to say, the code is
// embedded in the calling program and the linker and dynamic loader will not
// be able to find this function inside SDL itself).
//
// \param r the rectangle to test.
// \returns true if the rectangle is "empty", false otherwise.
//
// \threadsafety It is safe to call this function from any thread.
//
// \since This function is available since SDL 3.0.0.

RectEmpty :: #force_inline proc "c" (r: ^Rect) -> c.bool {
	return (r == nil) || (r.w <= 0) || (r.h <= 0)
}


// Determine whether two rectangles are equal.
//
// Rectangles are considered equal if both are not NULL and each of their x,
// y, width and height match.
//
// Note that this is a forced-inline function in a header, and not a public
// API function available in the SDL library (which is to say, the code is
// embedded in the calling program and the linker and dynamic loader will not
// be able to find this function inside SDL itself).
//
// \param a the first rectangle to test.
// \param b the second rectangle to test.
// \returns true if the rectangles are equal, false otherwise.
//
// \threadsafety It is safe to call this function from any thread.
//
// \since This function is available since SDL 3.0.0.

RectsEqual :: #force_inline proc "c" (a, b: ^Rect) -> c.bool {
	return a != nil && b != nil && (a.x == b.x) && (a.y == b.y) && (a.w == b.w) && (a.h == b.h)
}


/* FRect versions... */


// Determine whether a point resides inside a floating point rectangle.
//
// A point is considered part of a rectangle if both `p` and `r` are not NULL,
// and `p`'s x and y coordinates are >= to the rectangle's top left corner,
// and <= the rectangle's x+w and y+h. So a 1x1 rectangle considers point
// (0,0) and (0,1) as "inside" and (0,2) as not.
//
// Note that this is a forced-inline function in a header, and not a public
// API function available in the SDL library (which is to say, the code is
// embedded in the calling program and the linker and dynamic loader will not
// be able to find this function inside SDL itself).
//
// \param p the point to test.
// \param r the rectangle to test.
// \returns true if `p` is contained by `r`, false otherwise.
//
// \threadsafety It is safe to call this function from any thread.
//
// \since This function is available since SDL 3.0.0.

PointInRectFloat :: #force_inline proc "c" (p: ^FPoint, r: ^FRect) -> c.bool {
	return(
		p != nil &&
		r != nil &&
		(p.x >= r.x) &&
		(p.x <= (r.x + r.w)) &&
		(p.y >= r.y) &&
		(p.y <= (r.y + r.h)) \
	)
}


// Determine whether a floating point rectangle can contain any point.
//
// A rectangle is considered "empty" for this function if `r` is NULL, or if
// `r`'s width and/or height are < 0.0f.
//
// Note that this is a forced-inline function in a header, and not a public
// API function available in the SDL library (which is to say, the code is
// embedded in the calling program and the linker and dynamic loader will not
// be able to find this function inside SDL itself).
//
// \param r the rectangle to test.
// \returns true if the rectangle is "empty", false otherwise.
//
// \threadsafety It is safe to call this function from any thread.
//
// \since This function is available since SDL 3.0.0.

RectEmptyFloat :: #force_inline proc "c" (r: ^FRect) -> c.bool {
	return (r == nil) || (r.w < 0.0) || (r.h < 0.0)
}


// Determine whether two floating point rectangles are equal, within some
// given epsilon.
//
// Rectangles are considered equal if both are not NULL and each of their x,
// y, width and height are within `epsilon` of each other. If you don't know
// what value to use for `epsilon`, you should call the RectsEqualFloat
// function instead.
//
// Note that this is a forced-inline function in a header, and not a public
// API function available in the SDL library (which is to say, the code is
// embedded in the calling program and the linker and dynamic loader will not
// be able to find this function inside SDL itself).
//
// \param a the first rectangle to test.
// \param b the second rectangle to test.
// \param epsilon the epsilon value for comparison.
// \returns true if the rectangles are equal, false otherwise.
//
// \threadsafety It is safe to call this function from any thread.
//
// \since This function is available since SDL 3.0.0.
//
// \sa RectsEqualFloat

RectsEqualEpsilon :: #force_inline proc "c" (a, b: ^FRect, epsilon: c.float) -> c.bool {
	return(
		a != nil &&
		b != nil &&
		((a == b) ||
				((fabsf(a.x - b.x) <= epsilon) &&
						(fabsf(a.y - b.y) <= epsilon) &&
						(fabsf(a.w - b.w) <= epsilon) &&
						(fabsf(a.h - b.h) <= epsilon))) \
	)

}


// Determine whether two floating point rectangles are equal, within a default
// epsilon.
//
// Rectangles are considered equal if both are not NULL and each of their x,
// y, width and height are within FLT_EPSILON of each other. This is often
// a reasonable way to compare two floating point rectangles and deal with the
// slight precision variations in floating point calculations that tend to pop
// up.
//
// Note that this is a forced-inline function in a header, and not a public
// API function available in the SDL library (which is to say, the code is
// embedded in the calling program and the linker and dynamic loader will not
// be able to find this function inside SDL itself).
//
// \param a the first rectangle to test.
// \param b the second rectangle to test.
// \returns true if the rectangles are equal, false otherwise.
//
// \threadsafety It is safe to call this function from any thread.
//
// \since This function is available since SDL 3.0.0.
//
// \sa RectsEqualEpsilon

RectsEqualFloat :: #force_inline proc "c" (a, b: ^FRect) -> c.bool {
	return RectsEqualEpsilon(a, b, FLT_EPSILON)
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Determine whether two rectangles intersect.
	//
	// If either pointer is NULL the function will return false.
	//
	// \param A an Rect structure representing the first rectangle.
	// \param B an Rect structure representing the second rectangle.
	// \returns true if there is an intersection, false otherwise.
	//
	// \threadsafety It is safe to call this function from any thread.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRectIntersection

	HasRectIntersection :: proc(A, B: ^Rect) -> c.bool ---


	// Calculate the intersection of two rectangles.
	//
	// If `result` is NULL then this function will return false.
	//
	// \param A an Rect structure representing the first rectangle.
	// \param B an Rect structure representing the second rectangle.
	// \param result an Rect structure filled in with the intersection of
	//               rectangles `A` and `B`.
	// \returns true if there is an intersection, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa HasRectIntersection

	GetRectIntersection :: proc(A, B, result: ^Rect) -> c.bool ---


	// Calculate the union of two rectangles.
	//
	// \param A an Rect structure representing the first rectangle.
	// \param B an Rect structure representing the second rectangle.
	// \param result an Rect structure filled in with the union of rectangles
	//               `A` and `B`.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GetRectUnion :: proc(A, B, result: ^Rect) -> c.bool ---


	// Calculate a minimal rectangle enclosing a set of points.
	//
	// If `clip` is not NULL then only points inside of the clipping rectangle are
	// considered.
	//
	// \param points an array of Point structures representing points to be
	//               enclosed.
	// \param count the number of structures in the `points` array.
	// \param clip an Rect used for clipping or NULL to enclose all points.
	// \param result an Rect structure filled in with the minimal enclosing
	//               rectangle.
	// \returns true if any points were enclosed or false if all the points were
	//          outside of the clipping rectangle.
	//
	// \since This function is available since SDL 3.0.0.

	GetRectEnclosingPoints :: proc(points: [^]Point, count: c.int, clip, result: ^Rect) -> c.bool ---


	// Calculate the intersection of a rectangle and line segment.
	//
	// This function is used to clip a line segment to a rectangle. A line segment
	// contained entirely within the rectangle or that does not intersect will
	// remain unchanged. A line segment that crosses the rectangle at either or
	// both ends will be clipped to the boundary of the rectangle and the new
	// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
	//
	// \param rect an Rect structure representing the rectangle to intersect.
	// \param X1 a pointer to the starting X-coordinate of the line.
	// \param Y1 a pointer to the starting Y-coordinate of the line.
	// \param X2 a pointer to the ending X-coordinate of the line.
	// \param Y2 a pointer to the ending Y-coordinate of the line.
	// \returns true if there is an intersection, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.

	GetRectAndLineIntersection :: proc(rect: ^Rect, X1, Y1, X2, Y2: ^c.int) -> c.bool ---


	// Determine whether two rectangles intersect with float precision.
	//
	// If either pointer is NULL the function will return false.
	//
	// \param A an FRect structure representing the first rectangle.
	// \param B an FRect structure representing the second rectangle.
	// \returns true if there is an intersection, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetRectIntersection

	HasRectIntersectionFloat :: proc(A, B: ^FRect) -> c.bool ---


	// Calculate the intersection of two rectangles with float precision.
	//
	// If `result` is NULL then this function will return false.
	//
	// \param A an FRect structure representing the first rectangle.
	// \param B an FRect structure representing the second rectangle.
	// \param result an FRect structure filled in with the intersection of
	//               rectangles `A` and `B`.
	// \returns true if there is an intersection, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa HasRectIntersectionFloat

	GetRectIntersectionFloat :: proc(A, B, result: ^FRect) -> c.bool ---


	// Calculate the union of two rectangles with float precision.
	//
	// \param A an FRect structure representing the first rectangle.
	// \param B an FRect structure representing the second rectangle.
	// \param result an FRect structure filled in with the union of rectangles
	//               `A` and `B`.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GetRectUnionFloat :: proc(A, B, result: ^FRect) -> c.bool ---


	// Calculate a minimal rectangle enclosing a set of points with float
	// precision.
	//
	// If `clip` is not NULL then only points inside of the clipping rectangle are
	// considered.
	//
	// \param points an array of FPoint structures representing points to be
	//               enclosed.
	// \param count the number of structures in the `points` array.
	// \param clip an FRect used for clipping or NULL to enclose all points.
	// \param result an FRect structure filled in with the minimal enclosing
	//               rectangle.
	// \returns true if any points were enclosed or false if all the points were
	//          outside of the clipping rectangle.
	//
	// \since This function is available since SDL 3.0.0.

	GetRectEnclosingPointsFloat :: proc(points: [^]FPoint, count: c.int, clip, result: ^FRect) -> c.bool ---


	// Calculate the intersection of a rectangle and line segment with float
	// precision.
	//
	// This function is used to clip a line segment to a rectangle. A line segment
	// contained entirely within the rectangle or that does not intersect will
	// remain unchanged. A line segment that crosses the rectangle at either or
	// both ends will be clipped to the boundary of the rectangle and the new
	// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
	//
	// \param rect an FRect structure representing the rectangle to intersect.
	// \param X1 a pointer to the starting X-coordinate of the line.
	// \param Y1 a pointer to the starting Y-coordinate of the line.
	// \param X2 a pointer to the ending X-coordinate of the line.
	// \param Y2 a pointer to the ending Y-coordinate of the line.
	// \returns true if there is an intersection, false otherwise.
	//
	// \since This function is available since SDL 3.0.0.

	GetRectAndLineIntersectionFloat :: proc(rect: ^FRect, X1, Y1, X2, Y2: ^c.float) -> c.bool ---
}
