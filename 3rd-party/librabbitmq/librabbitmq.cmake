function(try_use_rabbitmq)
	if (NOT JANUS_TRANSPORT_RABBITMQ AND NOT JANUS_HANDLER_RABBITMQ)
		return()
	endif (NOT JANUS_TRANSPORT_RABBITMQ AND NOT JANUS_HANDLER_RABBITMQ)

	pkg_check_modules(LIB_LIBRABBITMQ librabbitmq)

	if (NOT LIB_LIBRABBITMQ_FOUND)
		message(FATAL_ERROR "Cannot find librabbitmq on your platform, install it first...")
	endif (NOT LIB_LIBRABBITMQ_FOUND)

	set(CACHE_LIBRABBITMQ "librabbitmq" CACHE INTERNAL "librabbitmq." FORCE)
	set(CACHE_LIBRABBITMQ_LIBRARIES ${LIB_LIBRABBITMQ_LIBRARIES} CACHE INTERNAL "librabbitmq." FORCE)
	set(CACHE_LIBRABBITMQ_DIRECTORIES ${LIB_LIBRABBITMQ_LIBRARY_DIRS} CACHE INTERNAL "librabbitmq." FORCE)
	set(CACHE_LIBRABBITMQ_LIBRARY_NAME librabbitmq-${LIB_LIBRABBITMQ_VERSION} CACHE INTERNAL "librabbitmq." FORCE)
	set(CACHE_LIBRABBITMQ_INCLUDE_DIRECTORIES ${LIB_LIBRABBITMQ_INCLUDE_DIRS} CACHE INTERNAL "librabbitmq." FORCE)
	set(CACHE_LIBRABBITMQ_COMPILE_FLAGS ${LIB_LIBRABBITMQ_CFLAGS} CACHE INTERNAL "librabbitmq." FORCE)
	set(CACHE_LIBRABBITMQ_LD_FLAGS ${LIB_LIBRABBITMQ_LDFLAGS} CACHE INTERNAL "librabbitmq." FORCE)
	
	include(CheckLibraryExists)

	CHECK_LIBRARY_EXISTS(
			librabbitmq
			amqp_error_string2
			"${LIB_LIBRABBITMQ_LIBRARY_DIRS}"
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
