function(try_use_paho_mqtt3a)
	if (NOT JANUS_TRANSPORT_MQTT AND NOT JANUS_HANDLER_MQTT)
		return()
	endif (NOT JANUS_TRANSPORT_MQTT AND NOT JANUS_HANDLER_MQTT)

	# TODO: need .pc file
	# pkg_check_modules(LIB_LIBRABBITMQ QUIET REQUIRED libpaho_mqtt3aS)

	set(LIBPAHO_MQTT3AS_PATH /usr/lib/x86_64-linux-gnu)
	set(LIB_LIBRABBITMQ_LIBRARIES libpaho_mqtt3a)
	add_library(
			${LIB_LIBRABBITMQ_LIBRARIES}
			SHARED
			IMPORTED
	)
	set_target_properties(
			${LIB_LIBRABBITMQ_LIBRARIES}
			PROPERTIES
			IMPORTED_LOCATION ${LIBPAHO_MQTT3AS_PATH}/libpago-mqtt3as.so
			IMPORTED_IMPLIB ${LIBPAHO_MQTT3AS_PATH}/libpago-mqtt3as.a
	)

	janus_append_link_libraries(${LIB_LIBRABBITMQ_LIBRARIES})
	janus_append_link_directories(${LIB_LIBRABBITMQ_LIBRARY_DIRS})
	janus_append_link_libraries_name(${LIB_LIBRABBITMQ_LIBRARIES}-${LIB_LIBRABBITMQ_VERSION})
	janus_append_include_directories(${LIB_LIBRABBITMQ_INCLUDE_DIRS})
	janus_append_compile_flags(${LIB_LIBRABBITMQ_CFLAGS})
	janus_append_ld_flags(${LIB_LIBRABBITMQ_LDFLAGS})

	set(JANUS_DEPENDENCY_LIBPAHO-MQTT3AS_USED ON PARENT_SCOPE)
endfunction(try_use_paho_mqtt3a)

try_use_paho_mqtt3a()
