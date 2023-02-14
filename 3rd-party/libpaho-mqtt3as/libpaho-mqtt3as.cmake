function(try_use_paho_mqtt3a)
	if (NOT JANUS_TRANSPORT_MQTT AND NOT JANUS_HANDLER_MQTT)
		return()
	endif (NOT JANUS_TRANSPORT_MQTT AND NOT JANUS_HANDLER_MQTT)

	# TODO: need .pc file
	pkg_check_modules(LIB_PAHO_MQTT3AS QUIET libpaho-mqtt3as)

	if (NOT LIB_LIBPAHO_MQTT3AS_FOUND)
		find_system_library(
				paho-mqtt3as
				POST

				VARIABLE_NAME PAHO_MQTT3AS
		)

		if (NOT ${LIB_PAHO_MQTT3AS_FOUND})
			message(FATAL_ERROR "LIBPAHO_MQTT3AS not found. See README.md for installation instructions or set JANUS_TRANSPORT_MQTT and JANUS_HANDLER_MQTT off")
		else()
			
		endif (NOT ${LIB_PAHO_MQTT3AS_FOUND})
	endif ()

	set(CACHE_PAHO_MQTT3AS "libpaho-mqtt3as" CACHE INTERNAL "libpaho-mqtt3as." FORCE)
	set(CACHE_PAHO_MQTT3AS_LIBRARIES ${LIB_PAHO_MQTT3AS_LIBRARIES} CACHE INTERNAL "libpaho-mqtt3as." FORCE)
	set(CACHE_PAHO_MQTT3AS_DIRECTORIES ${LIB_PAHO_MQTT3AS_LIBRARY_DIRS} CACHE INTERNAL "libpaho-mqtt3as." FORCE)
	set(CACHE_PAHO_MQTT3AS_LIBRARY_NAME libpaho-mqtt3as-${LIB_PAHO_MQTT3AS_VERSION} CACHE INTERNAL "libpaho-mqtt3as." FORCE)
	set(CACHE_PAHO_MQTT3AS_INCLUDE_DIRECTORIES ${LIB_PAHO_MQTT3AS_INCLUDE_DIRS} CACHE INTERNAL "libpaho-mqtt3as." FORCE)
	set(CACHE_PAHO_MQTT3AS_COMPILE_FLAGS ${LIB_PAHO_MQTT3AS_CFLAGS} CACHE INTERNAL "libpaho-mqtt3as." FORCE)
	set(CACHE_PAHO_MQTT3AS_LD_FLAGS ${LIB_PAHO_MQTT3AS_LDFLAGS} CACHE INTERNAL "libpaho-mqtt3as." FORCE)
endfunction(try_use_paho_mqtt3a)

try_use_paho_mqtt3a()
