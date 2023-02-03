function(try_use_rabbitmq)
	if (NOT JANUS_TRANSPORT_RABBITMQ AND NOT JANUS_HANDLER_RABBITMQ)
		return()
	endif (NOT JANUS_TRANSPORT_RABBITMQ AND NOT JANUS_HANDLER_RABBITMQ)

	pkg_check_modules(LIB_LIBRABBITMQ QUIET REQUIRED librabbitmq)

	janus_append_link_libraries(${LIB_LIBRABBITMQ_LIBRARIES})
	janus_append_link_directories(${LIB_LIBRABBITMQ_LIBRARY_DIRS})
	janus_append_link_libraries_name(${LIB_LIBRABBITMQ_LIBRARIES}-${LIB_LIBRABBITMQ_VERSION})
	janus_append_include_directories(${LIB_LIBRABBITMQ_INCLUDE_DIRS})
	janus_append_compile_flags(${LIB_LIBRABBITMQ_CFLAGS})
	janus_append_ld_flags(${LIB_LIBRABBITMQ_LDFLAGS})

	include(CheckLibraryExists)

	CHECK_LIBRARY_EXISTS(
			${LIB_LIBRABBITMQ_LIBRARIES}
			amqp_error_string2
			${LIB_LIBRABBITMQ_LIBRARY_DIRS}
			LIB_LIBRABBITMQ_HAS_amqp_error_string2
	)

	if (LIB_LIBRABBITMQ_HAS_amqp_error_string2)
		if (JANUS_TRANSPORT_RABBITMQ)
			janus_append_compile_definitions(HAVE_RABBITMQ)
		endif (JANUS_TRANSPORT_RABBITMQ)

		if (JANUS_HANDLER_RABBITMQ)
			janus_append_compile_definitions(HAVE_RABBITMQEVH)
		endif (JANUS_HANDLER_RABBITMQ)
	endif (LIB_LIBRABBITMQ_HAS_amqp_error_string2)
endfunction(try_use_rabbitmq)

try_use_rabbitmq()
