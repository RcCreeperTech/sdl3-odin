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


// # CategoryHaptic
//
// The SDL haptic subsystem manages haptic (force feedback) devices.
//
// The basic usage is as follows:
//
// - Initialize the subsystem (INIT_HAPTIC).
// - Open a haptic device.
// - OpenHaptic() to open from index.
// - OpenHapticFromJoystick() to open from an existing joystick.
// - Create an effect (HapticEffect).
// - Upload the effect with CreateHapticEffect().
// - Run the effect with RunHapticEffect().
// - (optional) Free the effect with DestroyHapticEffect().
// - Close the haptic device with CloseHaptic().
//
// Simple rumble example:
//
// ```c
//    Haptic *haptic = NULL;
//
//    // Open the device
//    HapticID *haptics = GetHaptics(NULL);
//    if (haptics) {
//        haptic = OpenHaptic(haptics[0]);
//        free(haptics);
//    }
//    if (haptic == NULL)
//       return;
//
//    // Initialize simple rumble
//    if (!InitHapticRumble(haptic))
//       return;
//
//    // Play effect at 50% strength for 2 seconds
//    if (!PlayHapticRumble(haptic, 0.5, 2000))
//       return;
//    Delay(2000);
//
//    // Clean up
//    CloseHaptic(haptic);
// ```
//
// Complete example:
//
// ```c
// c.bool test_haptic(Joystick *joystick)
// {
//    Haptic *haptic;
//    HapticEffect effect;
//    int effect_id;
//
//    // Open the device
//    haptic = OpenHapticFromJoystick(joystick);
//    if (haptic == NULL) return false; // Most likely joystick isn't haptic
//
//    // See if it can do sine waves
//    if ((GetHapticFeatures(haptic) & HAPTIC_SINE)==0) {
//       CloseHaptic(haptic); // No sine effect
//       return false;
//    }
//
//    // Create the effect
//    memset(&effect, 0, sizeof(HapticEffect)); // 0 is safe default
//    effect.type = HAPTIC_SINE;
//    effect.periodic.direction.type = HAPTIC_POLAR; // Polar coordinates
//    effect.periodic.direction.dir[0] = 18000; // Force comes from south
//    effect.periodic.period = 1000; // 1000 ms
//    effect.periodic.magnitude = 20000; // 20000/32767 strength
//    effect.periodic.length = 5000; // 5 seconds long
//    effect.periodic.attack_length = 1000; // Takes 1 second to get max strength
//    effect.periodic.fade_length = 1000; // Takes 1 second to fade away
//
//    // Upload the effect
//    effect_id = CreateHapticEffect(haptic, &effect);
//
//    // Test the effect
//    RunHapticEffect(haptic, effect_id, 1);
//    Delay(5000); // Wait for the effect to finish
//
//    // We destroy the effect, although closing the device also does this
//    DestroyHapticEffect(haptic, effect_id);
//
//    // Close the device
//    CloseHaptic(haptic);
//
//    return true; // Success
// }
// ```
//
// Note that the SDL haptic subsystem is not thread-safe.


/* FIXME:
//
// At the moment the magnitude variables are mixed between signed/unsigned, and
// it is also not made clear that ALL of those variables expect a max of 0x7FFF.
//
// Some platforms may have higher precision than that (Linux FF, Windows XInput)
// so we should fix the inconsistency in favor of higher possible precision,
// adjusting for platforms that use different scales.
// -flibit
*/

// The haptic structure used to identify an SDL haptic.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa OpenHaptic
// \sa OpenHapticFromJoystick
// \sa CloseHaptic

Haptic :: distinct struct {}


//  \name Haptic features
//
//  Different haptic features a device can have.
HapticFeatures :: enum {
	//  \name Haptic effects
	// Constant effect supported.
	//
	// Constant haptic effect.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticCondition
	CONSTANT     = (1 << 0),


	// Sine wave effect supported.
	//
	// Periodic haptic effect that simulates sine waves.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticPeriodic
	SINE         = (1 << 1),


	// Square wave effect supported.
	//
	// Periodic haptic effect that simulates square waves.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticPeriodic
	SQUARE       = (1 << 2),


	// Triangle wave effect supported.
	//
	// Periodic haptic effect that simulates triangular waves.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticPeriodic
	TRIANGLE     = (1 << 3),


	// Sawtoothup wave effect supported.
	//
	// Periodic haptic effect that simulates saw tooth up waves.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticPeriodic
	SAWTOOTHUP   = (1 << 4),


	// Sawtoothdown wave effect supported.
	//
	// Periodic haptic effect that simulates saw tooth down waves.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticPeriodic
	SAWTOOTHDOWN = (1 << 5),


	// Ramp effect supported.
	//
	// Ramp haptic effect.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticRamp
	RAMP         = (1 << 6),


	// Spring effect supported - uses axes position.
	//
	// Condition haptic effect that simulates a spring. Effect is based on the
	// axes position.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticCondition
	SPRING       = (1 << 7),


	// Damper effect supported - uses axes velocity.
	//
	// Condition haptic effect that simulates dampening. Effect is based on the
	// axes velocity.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticCondition
	DAMPER       = (1 << 8),


	// Inertia effect supported - uses axes acceleration.
	//
	// Condition haptic effect that simulates inertia. Effect is based on the axes
	// acceleration.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticCondition
	INERTIA      = (1 << 9),


	// Friction effect supported - uses axes movement.
	//
	// Condition haptic effect that simulates friction. Effect is based on the
	// axes movement.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticCondition
	FRICTION     = (1 << 10),


	// Left/Right effect supported.
	//
	// Haptic effect for direct control over high/low frequency motors.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticLeftRight
	LEFTRIGHT    = (1 << 11),


	// Reserved for future use
	//
	// \since This macro is available since SDL 3.0.0.
	RESERVED1    = (1 << 12),
	RESERVED2    = (1 << 13),
	RESERVED3    = (1 << 14),


	// Custom effect is supported.
	//
	// User defined custom haptic effect.
	//
	// \since This macro is available since SDL 3.0.0.
	CUSTOM       = (1 << 15),

	/* Haptic effects */
	/* These last few are features the device has, not effects */

	// Device can set global gain.
	//
	// Device supports setting the global gain.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa SetHapticGain
	GAIN         = (1 << 16),


	// Device can set autocenter.
	//
	// Device supports setting autocenter.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa SetHapticAutocenter
	AUTOCENTER   = (1 << 17),


	// Device can be queried for effect status.
	//
	// Device supports querying effect status.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa GetHapticEffectStatus
	STATUS       = (1 << 18),


	// Device can be paused.
	//
	// Devices supports being paused.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa PauseHaptic
	// \sa ResumeHaptic
	PAUSE        = (1 << 19),
}


// \name Direction encodings
HapticType :: enum c.int {
	// Uses polar coordinates for the direction.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticDirection
	POLAR,


	// Uses cartesian coordinates for the direction.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticDirection
	CARTESIAN,


	// Uses spherical coordinates for the direction.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticDirection
	SPHERICAL,


	// Use this value to play an effect on the steering wheel axis.
	//
	// This provides better compatibility across platforms and devices as SDL will
	// guess the correct axis.
	//
	// \since This macro is available since SDL 3.0.0.
	//
	// \sa HapticDirection
	STEERING_AXIS,
}

// Misc defines.


// Used to play a device an infinite number of times.
//
// \since This macro is available since SDL 3.0.0.
//
// \sa RunHapticEffect

HAPTIC_INFINITY :: 4294967295


// Structure that represents a haptic direction.
//
// This is the direction where the force comes from, instead of the direction
// in which the force is exerted.
//
// Directions can be specified by:
//
// - HAPTIC_POLAR : Specified by polar coordinates.
// - HAPTIC_CARTESIAN : Specified by cartesian coordinates.
// - HAPTIC_SPHERICAL : Specified by spherical coordinates.
//
// Cardinal directions of the haptic device are relative to the positioning of
// the device. North is considered to be away from the user.
//
// The following diagram represents the cardinal directions:
//
// ```
//                .--.
//                |__| .-------.
//                |=.| |.-----.|
//                |--| ||     ||
//                |  | |'-----'|
//                |__|~')_____('
//                  [ COMPUTER ]
//
//
//                    North (0,-1)
//                        ^
//                        |
//                        |
//  (-1,0)  West <----[ HAPTIC ]----> East (1,0)
//                        |
//                        |
//                        v
//                     South (0,1)
//
//
//                     [ USER ]
//                       \|||/
//                       (o o)
//                 ---ooO-(_)-Ooo---
// ```
//
// If type is HAPTIC_POLAR, direction is encoded by hundredths of a degree
// starting north and turning clockwise. HAPTIC_POLAR only uses the first
// `dir` parameter. The cardinal directions would be:
//
// - North: 0 (0 degrees)
// - East: 9000 (90 degrees)
// - South: 18000 (180 degrees)
// - West: 27000 (270 degrees)
//
// If type is HAPTIC_CARTESIAN, direction is encoded by three positions (X
// axis, Y axis and Z axis (with 3 axes)). HAPTIC_CARTESIAN uses the first
// three `dir` parameters. The cardinal directions would be:
//
// - North: 0,-1, 0
// - East: 1, 0, 0
// - South: 0, 1, 0
// - West: -1, 0, 0
//
// The Z axis represents the height of the effect if supported, otherwise it's
// unused. In cartesian encoding (1, 2) would be the same as (2, 4), you can
// use any multiple you want, only the direction matters.
//
// If type is HAPTIC_SPHERICAL, direction is encoded by two rotations. The
// first two `dir` parameters are used. The `dir` parameters are as follows
// (all values are in hundredths of degrees):
//
// - Degrees from (1, 0) rotated towards (0, 1).
// - Degrees towards (0, 0, 1) (device needs at least 3 axes).
//
// Example of force coming from the south with all encodings (force coming
// from the south means the user will have to pull the stick to counteract):
//
// ```c
//  HapticDirection direction;
//
//  // Cartesian directions
//  direction.type = HAPTIC_CARTESIAN; // Using cartesian direction encoding.
//  direction.dir[0] = 0; // X position
//  direction.dir[1] = 1; // Y position
//  // Assuming the device has 2 axes, we don't need to specify third parameter.
//
//  // Polar directions
//  direction.type = HAPTIC_POLAR; // We'll be using polar direction encoding.
//  direction.dir[0] = 18000; // Polar only uses first parameter
//
//  // Spherical coordinates
//  direction.type = HAPTIC_SPHERICAL; // Spherical encoding
//  direction.dir[0] = 9000; // Since we only have two axes we don't need more parameters.
// ```
//
// \since This struct is available since SDL 3.0.0.
//
// \sa HAPTIC_POLAR
// \sa HAPTIC_CARTESIAN
// \sa HAPTIC_SPHERICAL
// \sa HAPTIC_STEERING_AXIS
// \sa HapticEffect
// \sa GetNumHapticAxes

HapticDirection :: struct {
	type: c.uint8_t, /* < The type of encoding. */
	dir:  [HapticType]c.int32_t, /* < The encoded direction. */
}


// A structure containing a template for a Constant effect.
//
// This struct is exclusively for the HAPTIC_CONSTANT effect.
//
// A constant effect applies a constant force in the specified direction to
// the joystick.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa HAPTIC_CONSTANT
// \sa HapticEffect

HapticConstant :: struct {
	/* Header */
	type:          c.uint16_t, /* < HAPTIC_CONSTANT */
	direction:     HapticDirection, /* < Direction of the effect. */

	/* Replay */
	length:        c.uint32_t, /* < Duration of the effect. */
	delay:         c.uint16_t, /* < Delay before starting the effect. */

	/* Trigger */
	button:        c.uint16_t, /* < Button that triggers the effect. */
	interval:      c.uint16_t, /* < How soon it can be triggered again after button. */

	/* Constant */
	level:         c.int16_t, /* < Strength of the constant effect. */

	/* Envelope */
	attack_length: c.uint16_t, /* < Duration of the attack. */
	attack_level:  c.uint16_t, /* < Level at the start of the attack. */
	fade_length:   c.uint16_t, /* < Duration of the fade. */
	fade_level:    c.uint16_t, /* < Level at the end of the fade. */
}


// A structure containing a template for a Periodic effect.
//
// The struct handles the following effects:
//
// - HAPTIC_SINE
// - HAPTIC_SQUARE
// - HAPTIC_TRIANGLE
// - HAPTIC_SAWTOOTHUP
// - HAPTIC_SAWTOOTHDOWN
//
// A periodic effect consists in a wave-shaped effect that repeats itself over
// time. The type determines the shape of the wave and the parameters
// determine the dimensions of the wave.
//
// Phase is given by hundredth of a degree meaning that giving the phase a
// value of 9000 will displace it 25% of its period. Here are sample values:
//
// - 0: No phase displacement.
// - 9000: Displaced 25% of its period.
// - 18000: Displaced 50% of its period.
// - 27000: Displaced 75% of its period.
// - 36000: Displaced 100% of its period, same as 0, but 0 is preferred.
//
// Examples:
//
// ```
//   HAPTIC_SINE
//     __      __      __      __
//    /  \    /  \    /  \    /
//   /    \__/    \__/    \__/
//
//   HAPTIC_SQUARE
//    __    __    __    __    __
//   |  |  |  |  |  |  |  |  |  |
//   |  |__|  |__|  |__|  |__|  |
//
//   HAPTIC_TRIANGLE
//     /\    /\    /\    /\    /\
//    /  \  /  \  /  \  /  \  /
//   /    \/    \/    \/    \/
//
//   HAPTIC_SAWTOOTHUP
//     /|  /|  /|  /|  /|  /|  /|
//    / | / | / | / | / | / | / |
//   /  |/  |/  |/  |/  |/  |/  |
//
//   HAPTIC_SAWTOOTHDOWN
//   \  |\  |\  |\  |\  |\  |\  |
//    \ | \ | \ | \ | \ | \ | \ |
//     \|  \|  \|  \|  \|  \|  \|
// ```
//
// \since This struct is available since SDL 3.0.0.
//
// \sa HAPTIC_SINE
// \sa HAPTIC_SQUARE
// \sa HAPTIC_TRIANGLE
// \sa HAPTIC_SAWTOOTHUP
// \sa HAPTIC_SAWTOOTHDOWN
// \sa HapticEffect

HapticPeriodic :: struct {
	/* Header */
	type:          c.uint16_t, /* < HAPTIC_SINE, HAPTIC_SQUARE
                             HAPTIC_TRIANGLE, HAPTIC_SAWTOOTHUP or
                             HAPTIC_SAWTOOTHDOWN */
	direction:     HapticDirection, /* < Direction of the effect. */

	/* Replay */
	length:        c.uint32_t, /* < Duration of the effect. */
	delay:         c.uint16_t, /* < Delay before starting the effect. */

	/* Trigger */
	button:        c.uint16_t, /* < Button that triggers the effect. */
	interval:      c.uint16_t, /* < How soon it can be triggered again after button. */

	/* Periodic */
	period:        c.uint16_t, /* < Period of the wave. */
	magnitude:     c.int16_t, /* < Peak value; if negative, equivalent to 180 degrees extra phase shift. */
	offset:        c.int16_t, /* < Mean value of the wave. */
	phase:         c.uint16_t, /* < Positive phase shift given by hundredth of a degree. */

	/* Envelope */
	attack_length: c.uint16_t, /* < Duration of the attack. */
	attack_level:  c.uint16_t, /*  < Level at the start of the attack. */
	fade_length:   c.uint16_t, /* < Duration of the fade. */
	fade_level:    c.uint16_t, /* < Level at the end of the fade. */
}


// A structure containing a template for a Condition effect.
//
// The struct handles the following effects:
//
// - HAPTIC_SPRING: Effect based on axes position.
// - HAPTIC_DAMPER: Effect based on axes velocity.
// - HAPTIC_INERTIA: Effect based on axes acceleration.
// - HAPTIC_FRICTION: Effect based on axes movement.
//
// Direction is handled by condition internals instead of a direction member.
// The condition effect specific members have three parameters. The first
// refers to the X axis, the second refers to the Y axis and the third refers
// to the Z axis. The right terms refer to the positive side of the axis and
// the left terms refer to the negative side of the axis. Please refer to the
// HapticDirection diagram for which side is positive and which is
// negative.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa HapticDirection
// \sa HAPTIC_SPRING
// \sa HAPTIC_DAMPER
// \sa HAPTIC_INERTIA
// \sa HAPTIC_FRICTION
// \sa HapticEffect

HapticCondition :: struct {
	/* Header */
	type:        c.uint16_t, /* < HAPTIC_SPRING, HAPTIC_DAMPER,
                                 HAPTIC_INERTIA or HAPTIC_FRICTION */
	direction:   HapticDirection, /* < Direction of the effect - Not used ATM. */

	/* Replay */
	length:      c.uint32_t, /* < Duration of the effect. */
	delay:       c.uint16_t, /* < Delay before starting the effect. */

	/* Trigger */
	button:      c.uint16_t, /* < Button that triggers the effect. */
	interval:    c.uint16_t, /* < How soon it can be triggered again after button. */

	/* Condition */
	right_sat:   [3]c.uint16_t, /* < Level when joystick is to the positive side; max 0xFFFF. */
	left_sat:    [3]c.uint16_t, /* < Level when joystick is to the negative side; max 0xFFFF. */
	right_coeff: [3]c.int16_t, /* < How fast to increase the force towards the positive side. */
	left_coeff:  [3]c.int16_t, /* < How fast to increase the force towards the negative side. */
	deadband:    [3]c.uint16_t, /* < Size of the dead zone; max 0xFFFF: whole axis-range when 0-centered. */
	center:      [3]c.int16_t, /* < Position of the dead zone. */
}


// A structure containing a template for a Ramp effect.
//
// This struct is exclusively for the HAPTIC_RAMP effect.
//
// The ramp effect starts at start strength and ends at end strength. It
// augments in linear fashion. If you use attack and fade with a ramp the
// effects get added to the ramp effect making the effect become quadratic
// instead of linear.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa HAPTIC_RAMP
// \sa HapticEffect

HapticRamp :: struct {
	/* Header */
	type:          c.uint16_t, /* < HAPTIC_RAMP */
	direction:     HapticDirection, /* < Direction of the effect. */

	/* Replay */
	length:        c.uint32_t, /* < Duration of the effect. */
	delay:         c.uint16_t, /* < Delay before starting the effect. */

	/* Trigger */
	button:        c.uint16_t, /* < Button that triggers the effect. */
	interval:      c.uint16_t, /* < How soon it can be triggered again after button. */

	/* Ramp */
	start:         c.int16_t, /* < Beginning strength level. */
	end:           c.int16_t, /* < Ending strength level. */

	/* Envelope */
	attack_length: c.uint16_t, /* < Duration of the attack. */
	attack_level:  c.uint16_t, /* < Level at the start of the attack. */
	fade_length:   c.uint16_t, /* < Duration of the fade. */
	fade_level:    c.uint16_t, /* < Level at the end of the fade. */
}


// A structure containing a template for a Left/Right effect.
//
// This struct is exclusively for the HAPTIC_LEFTRIGHT effect.
//
// The Left/Right effect is used to explicitly control the large and small
// motors, commonly found in modern game controllers. The small (right) motor
// is high frequency, and the large (left) motor is low frequency.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa HAPTIC_LEFTRIGHT
// \sa HapticEffect

HapticLeftRight :: struct {
	/* Header */
	type:            c.uint16_t, /* < HAPTIC_LEFTRIGHT */

	/* Replay */
	length:          c.uint32_t, /* < Duration of the effect in milliseconds. */

	/* Rumble */
	large_magnitude: c.uint16_t, /* < Control of the large controller motor. */
	small_magnitude: c.uint16_t, /* < Control of the small controller motor. */
}


// A structure containing a template for the HAPTIC_CUSTOM effect.
//
// This struct is exclusively for the HAPTIC_CUSTOM effect.
//
// A custom force feedback effect is much like a periodic effect, where the
// application can define its exact shape. You will have to allocate the data
// yourself. Data should consist of channels * samples c.uint16_t samples.
//
// If channels is one, the effect is rotated using the defined direction.
// Otherwise it uses the samples in data for the different axes.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa HAPTIC_CUSTOM
// \sa HapticEffect

HapticCustom :: struct {
	/* Header */
	type:          c.uint16_t, /* < HAPTIC_CUSTOM */
	direction:     HapticDirection, /* < Direction of the effect. */

	/* Replay */
	length:        c.uint32_t, /* < Duration of the effect. */
	delay:         c.uint16_t, /* < Delay before starting the effect. */

	/* Trigger */
	button:        c.uint16_t, /* < Button that triggers the effect. */
	interval:      c.uint16_t, /* < How soon it can be triggered again after button. */

	/* Custom */
	channels:      c.uint8_t, /* < Axes to use, minimum of one. */
	period:        c.uint16_t, /* < Sample periods. */
	samples:       c.uint16_t, /* < Amount of samples. */
	data:          ^c.uint16_t, /* < Should contain channels*samples items. */

	/* Envelope */
	attack_length: c.uint16_t, /* < Duration of the attack. */
	attack_level:  c.uint16_t, /* < Level at the start of the attack. */
	fade_length:   c.uint16_t, /* < Duration of the fade. */
	fade_level:    c.uint16_t, /* < Level at the end of the fade. */
}


// The generic template for any haptic effect.
//
// All values max at 32767 (0x7FFF). Signed values also can be negative. Time
// values unless specified otherwise are in milliseconds.
//
// You can also pass HAPTIC_INFINITY to length instead of a 0-32767 value.
// Neither delay, interval, attack_length nor fade_length support
// HAPTIC_INFINITY. Fade will also not be used since effect never ends.
//
// Additionally, the HAPTIC_RAMP effect does not support a duration of
// HAPTIC_INFINITY.
//
// Button triggers may not be supported on all devices, it is advised to not
// use them if possible. Buttons start at index 1 instead of index 0 like the
// joystick.
//
// If both attack_length and fade_level are 0, the envelope is not used,
// otherwise both values are used.
//
// Common parts:
//
// ```c
//  // Replay - All effects have this
//  c.uint32_t length;        // Duration of effect (ms).
//  c.uint16_t delay;         // Delay before starting effect.
//
//  // Trigger - All effects have this
//  c.uint16_t button;        // Button that triggers effect.
//  c.uint16_t interval;      // How soon before effect can be triggered again.
//
//  // Envelope - All effects except condition effects have this
//  c.uint16_t attack_length; // Duration of the attack (ms).
//  c.uint16_t attack_level;  // Level at the start of the attack.
//  c.uint16_t fade_length;   // Duration of the fade out (ms).
//  c.uint16_t fade_level;    // Level at the end of the fade.
// ```
//
// Here we have an example of a constant effect evolution in time:
//
// ```
//  Strength
//  ^
//  |
//  |    effect level -->  _________________
//  |                     /                 \
//  |                    /                   \
//  |                   /                     \
//  |                  /                       \
//  | attack_level --> |                        \
//  |                  |                        |  <---  fade_level
//  |
//  +--------------------------------------------------> Time
//                     [--]                 [---]
//                     attack_length        fade_length
//
//  [------------------][-----------------------]
//  delay               length
// ```
//
// Note either the attack_level or the fade_level may be above the actual
// effect level.
//
// \since This struct is available since SDL 3.0.0.
//
// \sa HapticConstant
// \sa HapticPeriodic
// \sa HapticCondition
// \sa HapticRamp
// \sa HapticLeftRight
// \sa HapticCustom

HapticEffect :: struct #raw_union {
	/* Common for all force feedback effects */
	type:      c.uint16_t, /* < Effect type. */
	constant:  HapticConstant, /* < Constant effect. */
	periodic:  HapticPeriodic, /* < Periodic effect. */
	condition: HapticCondition, /* < Condition effect. */
	ramp:      HapticRamp, /* < Ramp effect. */
	leftright: HapticLeftRight, /* < Left/Right effect. */
	custom:    HapticCustom, /* < Custom effect. */
}


// This is a unique ID for a haptic device for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// If the haptic device is disconnected and reconnected, it will get a new ID.
//
// The value 0 is an invalid ID.
//
// \since This datatype is available since SDL 3.0.0.

HapticID :: distinct c.uint32_t


/* Function prototypes */
@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get a list of currently connected haptic devices.
	//
	// \param count a pointer filled in with the number of haptic devices
	//              returned, may be NULL.
	// \returns a 0 terminated array of haptic device instance IDs or NULL on
	//          failure; call GetError() for more information. This should be
	//          freed with free() when it is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa OpenHaptic

	GetHaptics :: proc(count: ^c.int) -> ^HapticID ---


	// Get the implementation dependent name of a haptic device.
	//
	// This can be called before any haptic devices are opened.
	//
	// \param instance_id the haptic device instance ID.
	// \returns the name of the selected haptic device. If no name can be found,
	//          this function returns NULL; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetHapticName
	// \sa OpenHaptic

	GetHapticNameForID :: proc(instance_id: HapticID) -> cstring ---


	// Open a haptic device for use.
	//
	// The index passed as an argument refers to the N'th haptic device on this
	// system.
	//
	// When opening a haptic device, its gain will be set to maximum and
	// autocenter will be disabled. To modify these values use SetHapticGain()
	// and SetHapticAutocenter().
	//
	// \param instance_id the haptic device instance ID.
	// \returns the device identifier or NULL on failure; call GetError() for
	//          more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseHaptic
	// \sa GetHaptics
	// \sa OpenHapticFromJoystick
	// \sa OpenHapticFromMouse
	// \sa SetHapticAutocenter
	// \sa SetHapticGain

	OpenHaptic :: proc(instance_id: HapticID) -> ^Haptic ---


	// Get the Haptic associated with an instance ID, if it has been opened.
	//
	// \param instance_id the instance ID to get the Haptic for.
	// \returns an Haptic on success or NULL on failure or if it hasn't been
	//          opened yet; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetHapticFromID :: proc(instance_id: HapticID) -> ^Haptic ---


	// Get the instance ID of an opened haptic device.
	//
	// \param haptic the Haptic device to query.
	// \returns the instance ID of the specified haptic device on success or 0 on
	//          failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetHapticID :: proc(haptic: ^Haptic) -> HapticID ---


	// Get the implementation dependent name of a haptic device.
	//
	// \param haptic the Haptic obtained from OpenJoystick().
	// \returns the name of the selected haptic device. If no name can be found,
	//          this function returns NULL; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetHapticNameForID

	GetHapticName :: proc(haptic: ^Haptic) -> cstring ---


	// Query whether or not the current mouse has haptic capabilities.
	//
	// \returns true if the mouse is haptic or false if it isn't.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa OpenHapticFromMouse

	IsMouseHaptic :: proc() -> c.bool ---


	// Try to open a haptic device from the current mouse.
	//
	// \returns the haptic device identifier or NULL on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseHaptic
	// \sa IsMouseHaptic

	OpenHapticFromMouse :: proc() -> ^Haptic ---


	// Query if a joystick has haptic features.
	//
	// \param joystick the Joystick to test for haptic capabilities.
	// \returns true if the joystick is haptic or false if it isn't.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa OpenHapticFromJoystick

	IsJoystickHaptic :: proc(joystick: ^Joystick) -> c.bool ---


	// Open a haptic device for use from a joystick device.
	//
	// You must still close the haptic device separately. It will not be closed
	// with the joystick.
	//
	// When opened from a joystick you should first close the haptic device before
	// closing the joystick device. If not, on some implementations the haptic
	// device will also get unallocated and you'll be unable to use force feedback
	// on that device.
	//
	// \param joystick the Joystick to create a haptic device from.
	// \returns a valid haptic device identifier on success or NULL on failure;
	//          call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CloseHaptic
	// \sa IsJoystickHaptic

	OpenHapticFromJoystick :: proc(joystick: ^Joystick) -> ^Haptic ---


	// Close a haptic device previously opened with OpenHaptic().
	//
	// \param haptic the Haptic device to close.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa OpenHaptic

	CloseHaptic :: proc(haptic: ^Haptic) ---


	// Get the number of effects a haptic device can store.
	//
	// On some platforms this isn't fully supported, and therefore is an
	// approximation. Always check to see if your created effect was actually
	// created and do not rely solely on GetMaxHapticEffects().
	//
	// \param haptic the Haptic device to query.
	// \returns the number of effects the haptic device can store or a negative
	//          error code on failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetMaxHapticEffectsPlaying
	// \sa GetHapticFeatures

	GetMaxHapticEffects :: proc(haptic: ^Haptic) -> c.int ---


	// Get the number of effects a haptic device can play at the same time.
	//
	// This is not supported on all platforms, but will always return a value.
	//
	// \param haptic the Haptic device to query maximum playing effects.
	// \returns the number of effects the haptic device can play at the same time
	//          or -1 on failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetMaxHapticEffects
	// \sa GetHapticFeatures

	GetMaxHapticEffectsPlaying :: proc(haptic: ^Haptic) -> c.int ---


	// Get the haptic device's supported features in bitwise manner.
	//
	// \param haptic the Haptic device to query.
	// \returns a list of supported haptic features in bitwise manner (OR'd), or 0
	//          on failure; call GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa HapticEffectSupported
	// \sa GetMaxHapticEffects

	GetHapticFeatures :: proc(haptic: ^Haptic) -> c.uint32_t ---


	// Get the number of haptic axes the device has.
	//
	// The number of haptic axes might be useful if working with the
	// HapticDirection effect.
	//
	// \param haptic the Haptic device to query.
	// \returns the number of axes on success or -1 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetNumHapticAxes :: proc(haptic: ^Haptic) -> c.int ---


	// Check to see if an effect is supported by a haptic device.
	//
	// \param haptic the Haptic device to query.
	// \param effect the desired effect to query.
	// \returns true if the effect is supported or false if it isn't.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateHapticEffect
	// \sa GetHapticFeatures

	HapticEffectSupported :: proc(haptic: ^Haptic, effect: ^HapticEffect) -> c.bool ---


	// Create a new haptic effect on a specified device.
	//
	// \param haptic an Haptic device to create the effect on.
	// \param effect an HapticEffect structure containing the properties of
	//               the effect to create.
	// \returns the ID of the effect on success or -1 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa DestroyHapticEffect
	// \sa RunHapticEffect
	// \sa UpdateHapticEffect

	CreateHapticEffect :: proc(haptic: ^Haptic, effect: ^HapticEffect) -> c.int ---


	// Update the properties of an effect.
	//
	// Can be used dynamically, although behavior when dynamically changing
	// direction may be strange. Specifically the effect may re-upload itself and
	// start playing from the start. You also cannot change the type either when
	// running UpdateHapticEffect().
	//
	// \param haptic the Haptic device that has the effect.
	// \param effect the identifier of the effect to update.
	// \param data an HapticEffect structure containing the new effect
	//             properties to use.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateHapticEffect
	// \sa RunHapticEffect

	UpdateHapticEffect :: proc(haptic: ^Haptic, effect: c.int, data: ^HapticEffect) -> c.bool ---


	// Run the haptic effect on its associated haptic device.
	//
	// To repeat the effect over and over indefinitely, set `iterations` to
	// `HAPTIC_INFINITY`. (Repeats the envelope - attack and fade.) To make
	// one instance of the effect last indefinitely (so the effect does not fade),
	// set the effect's `length` in its structure/union to `HAPTIC_INFINITY`
	// instead.
	//
	// \param haptic the Haptic device to run the effect on.
	// \param effect the ID of the haptic effect to run.
	// \param iterations the number of iterations to run the effect; use
	//                   `HAPTIC_INFINITY` to repeat forever.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetHapticEffectStatus
	// \sa StopHapticEffect
	// \sa StopHapticEffects

	RunHapticEffect :: proc(haptic: ^Haptic, effect: c.int, iterations: c.uint32_t) -> c.bool ---


	// Stop the haptic effect on its associated haptic device.
	//
	// \param haptic the Haptic device to stop the effect on.
	// \param effect the ID of the haptic effect to stop.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RunHapticEffect
	// \sa StopHapticEffects

	StopHapticEffect :: proc(haptic: ^Haptic, effect: c.int) -> c.bool ---


	// Destroy a haptic effect on the device.
	//
	// This will stop the effect if it's running. Effects are automatically
	// destroyed when the device is closed.
	//
	// \param haptic the Haptic device to destroy the effect on.
	// \param effect the ID of the haptic effect to destroy.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa CreateHapticEffect

	DestroyHapticEffect :: proc(haptic: ^Haptic, effect: c.int) ---


	// Get the status of the current effect on the specified haptic device.
	//
	// Device must support the HAPTIC_STATUS feature.
	//
	// \param haptic the Haptic device to query for the effect status on.
	// \param effect the ID of the haptic effect to query its status.
	// \returns true if it is playing, false if it isn't playing or haptic status
	//          isn't supported.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetHapticFeatures

	GetHapticEffectStatus :: proc(haptic: ^Haptic, effect: c.int) -> c.bool ---


	// Set the global gain of the specified haptic device.
	//
	// Device must support the HAPTIC_GAIN feature.
	//
	// The user may specify the maximum gain by setting the environment variable
	// `HAPTIC_GAIN_MAX` which should be between 0 and 100. All calls to
	// SetHapticGain() will scale linearly using `HAPTIC_GAIN_MAX` as the
	// maximum.
	//
	// \param haptic the Haptic device to set the gain on.
	// \param gain value to set the gain to, should be between 0 and 100 (0 -
	//             100).
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetHapticFeatures

	SetHapticGain :: proc(haptic: ^Haptic, gain: c.int) -> c.bool ---


	// Set the global autocenter of the device.
	//
	// Autocenter should be between 0 and 100. Setting it to 0 will disable
	// autocentering.
	//
	// Device must support the HAPTIC_AUTOCENTER feature.
	//
	// \param haptic the Haptic device to set autocentering on.
	// \param autocenter value to set autocenter to (0-100).
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa GetHapticFeatures

	SetHapticAutocenter :: proc(haptic: ^Haptic, autocenter: c.int) -> c.bool ---


	// Pause a haptic device.
	//
	// Device must support the `HAPTIC_PAUSE` feature. Call ResumeHaptic()
	// to resume playback.
	//
	// Do not modify the effects nor add new ones while the device is paused. That
	// can cause all sorts of weird errors.
	//
	// \param haptic the Haptic device to pause.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa ResumeHaptic

	PauseHaptic :: proc(haptic: ^Haptic) -> c.bool ---


	// Resume a haptic device.
	//
	// Call to unpause after PauseHaptic().
	//
	// \param haptic the Haptic device to unpause.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa PauseHaptic

	ResumeHaptic :: proc(haptic: ^Haptic) -> c.bool ---


	// Stop all the currently playing effects on a haptic device.
	//
	// \param haptic the Haptic device to stop.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa RunHapticEffect
	// \sa StopHapticEffects

	StopHapticEffects :: proc(haptic: ^Haptic) -> c.bool ---


	// Check whether rumble is supported on a haptic device.
	//
	// \param haptic haptic device to check for rumble support.
	// \returns true if the effect is supported or false if it isn't.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa InitHapticRumble

	HapticRumbleSupported :: proc(haptic: ^Haptic) -> c.bool ---


	// Initialize a haptic device for simple rumble playback.
	//
	// \param haptic the haptic device to initialize for simple rumble playback.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa PlayHapticRumble
	// \sa StopHapticRumble
	// \sa HapticRumbleSupported

	InitHapticRumble :: proc(haptic: ^Haptic) -> c.bool ---


	// Run a simple rumble effect on a haptic device.
	//
	// \param haptic the haptic device to play the rumble effect on.
	// \param strength strength of the rumble to play as a 0-1 float value.
	// \param length length of the rumble to play in milliseconds.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa InitHapticRumble
	// \sa StopHapticRumble

	PlayHapticRumble :: proc(haptic: ^Haptic, strength: c.float, length: c.uint32_t) -> c.bool ---


	// Stop the simple rumble on a haptic device.
	//
	// \param haptic the haptic device to stop the rumble effect on.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.
	//
	// \sa PlayHapticRumble

	StopHapticRumble :: proc(haptic: ^Haptic) -> c.bool ---
}
