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


// # CategorySensor
//
// SDL sensor management.
//
// In order to use these functions, Init() must have been called with the
// INIT_SENSOR flag. This causes SDL to scan the system for sensors, and
// load appropriate drivers.


Sensor :: distinct struct {}


// This is a unique ID for a sensor for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// The value 0 is an invalid ID.
//
// \since This datatype is available since SDL 3.0.0.

SensorID :: distinct c.uint32_t


// A constant to represent standard gravity for accelerometer sensors.
//
// The accelerometer returns the current acceleration in SI meters per second
// squared. This measurement includes the force of gravity, so a device at
// rest will have an value of STANDARD_GRAVITY away from the center of the
// earth, which is a positive Y value.
//
// \since This macro is available since SDL 3.0.0.

STANDARD_GRAVITY :: 9.80665


// The different sensors defined by SDL.
//
// Additional sensors may be available, using platform dependent semantics.
//
// Here are the additional Android sensors:
//
// https://developer.android.com/reference/android/hardware/SensorEvent.html#values
//
// Accelerometer sensor notes:
//
// The accelerometer returns the current acceleration in SI meters per second
// squared. This measurement includes the force of gravity, so a device at
// rest will have an value of STANDARD_GRAVITY away from the center of the
// earth, which is a positive Y value.
//
// - `values[0]`: Acceleration on the x axis
// - `values[1]`: Acceleration on the y axis
// - `values[2]`: Acceleration on the z axis
//
// For phones and tablets held in natural orientation and game controllers
// held in front of you, the axes are defined as follows:
//
// - -X ... +X : left ... right
// - -Y ... +Y : bottom ... top
// - -Z ... +Z : farther ... closer
//
// The accelerometer axis data is not changed when the device is rotated.
//
// Gyroscope sensor notes:
//
// The gyroscope returns the current rate of rotation in radians per second.
// The rotation is positive in the counter-clockwise direction. That is, an
// observer looking from a positive location on one of the axes would see
// positive rotation on that axis when it appeared to be rotating
// counter-clockwise.
//
// - `values[0]`: Angular speed around the x axis (pitch)
// - `values[1]`: Angular speed around the y axis (yaw)
// - `values[2]`: Angular speed around the z axis (roll)
//
// For phones and tablets held in natural orientation and game controllers
// held in front of you, the axes are defined as follows:
//
// - -X ... +X : left ... right
// - -Y ... +Y : bottom ... top
// - -Z ... +Z : farther ... closer
//
// The gyroscope axis data is not changed when the device is rotated.
//
// \since This enum is available since SDL 3.0.0.
//
// \sa GetCurrentDisplayOrientation

SensorType :: enum c.int {
	INVALID = -1, /**< Returned for an invalid sensor */
	UNKNOWN, /**< Unknown sensor type */
	ACCEL, /**< Accelerometer */
	GYRO, /**< Gyroscope */
	ACCEL_L, /**< Accelerometer for left Joy-Con controller and Wii nunchuk */
	GYRO_L, /**< Gyroscope for left Joy-Con controller */
	ACCEL_R, /**< Accelerometer for right Joy-Con controller */
	GYRO_R, /**< Gyroscope for right Joy-Con controller */
}


/* Function prototypes */


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {

	// Get a list of currently connected sensors.
	//
	// \param count a pointer filled in with the number of sensors returned, may
	//              be NULL.
	// \returns a 0 terminated array of sensor instance IDs or NULL on failure;
	//          call GetError() for more information. This should be freed
	//          with free() when it is no longer needed.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensors :: proc(count: ^c.int) -> ^SensorID ---


	// Get the implementation dependent name of a sensor.
	//
	// This can be called before any sensors are opened.
	//
	// \param instance_id the sensor instance ID.
	// \returns the sensor name, or NULL if `instance_id` is not valid.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorNameForID :: proc(instance_id: SensorID) -> cstring ---


	// Get the type of a sensor.
	//
	// This can be called before any sensors are opened.
	//
	// \param instance_id the sensor instance ID.
	// \returns the SensorType, or `SENSOR_INVALID` if `instance_id` is
	//          not valid.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorTypeForID :: proc(instance_id: SensorID) -> SensorType ---


	// Get the platform dependent type of a sensor.
	//
	// This can be called before any sensors are opened.
	//
	// \param instance_id the sensor instance ID.
	// \returns the sensor platform dependent type, or -1 if `instance_id` is not
	//          valid.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorNonPortableTypeForID :: proc(instance_id: SensorID) -> c.int ---


	// Open a sensor for use.
	//
	// \param instance_id the sensor instance ID.
	// \returns an Sensor object or NULL on failure; call GetError() for
	//          more information.
	//
	// \since This function is available since SDL 3.0.0.

	OpenSensor :: proc(instance_id: SensorID) -> ^Sensor ---


	// Return the Sensor associated with an instance ID.
	//
	// \param instance_id the sensor instance ID.
	// \returns an Sensor object or NULL on failure; call GetError() for
	//          more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorFromID :: proc(instance_id: SensorID) -> ^Sensor ---


	// Get the properties associated with a sensor.
	//
	// \param sensor the Sensor object.
	// \returns a valid property ID on success or 0 on failure; call
	//          GetError() for more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorProperties :: proc(sensor: ^Sensor) -> PropertiesID ---


	// Get the implementation dependent name of a sensor.
	//
	// \param sensor the Sensor object.
	// \returns the sensor name or NULL on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorName :: proc(sensor: ^Sensor) -> cstring ---


	// Get the type of a sensor.
	//
	// \param sensor the Sensor object to inspect.
	// \returns the SensorType type, or `SENSOR_INVALID` if `sensor` is
	//          NULL.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorType :: proc(sensor: ^Sensor) -> SensorType ---


	// Get the platform dependent type of a sensor.
	//
	// \param sensor the Sensor object to inspect.
	// \returns the sensor platform dependent type, or -1 if `sensor` is NULL.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorNonPortableType :: proc(sensor: ^Sensor) -> c.int ---


	// Get the instance ID of a sensor.
	//
	// \param sensor the Sensor object to inspect.
	// \returns the sensor instance ID, or 0 on failure; call GetError() for
	//          more information.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorID :: proc(sensor: ^Sensor) -> SensorID ---


	// Get the current state of an opened sensor.
	//
	// The number of values and interpretation of the data is sensor dependent.
	//
	// \param sensor the Sensor object to query.
	// \param data a pointer filled with the current sensor state.
	// \param num_values the number of values to write to data.
	// \returns true on success or false on failure; call GetError() for more
	//          information.
	//
	// \since This function is available since SDL 3.0.0.

	GetSensorData :: proc(sensor: ^Sensor, data: [^]c.float, num_values: c.int) -> c.bool ---


	// Close a sensor previously opened with OpenSensor().
	//
	// \param sensor the Sensor object to close.
	//
	// \since This function is available since SDL 3.0.0.

	CloseSensor :: proc(sensor: ^Sensor) ---


	// Update the current state of the open sensors.
	//
	// This is called automatically by the event loop if sensor events are
	// enabled.
	//
	// This needs to be called from the thread that initialized the sensor
	// subsystem.
	//
	// \since This function is available since SDL 3.0.0.

	UpdateSensors :: proc() ---

}
