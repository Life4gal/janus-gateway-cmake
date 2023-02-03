function(try_use_nanomsg)
	if (NOT JANUS_TRANSPORT_NANOMSG AND NOT JANUS_HANDLER_NANOMSG)
		return()
	endif (NOT JANUS_TRANSPORT_NANOMSG AND NOT JANUS_HANDLER_NANOMSG)

	pkg_check_modules(LIB_NANOMSG QUIET REQUIRED nanomsg)

	janus_append_link_libraries(${LIB_NANOMSG_LIBRARIES})
	janus_append_link_directories(${LIB_NANOMSG_LIBRARY_DIRS})
	janus_append_link_libraries_name(${LIB_NANOMSG_LIBRARIES}-${LIB_NANOMSG_VERSION})
	janus_append_include_directories(${LIB_NANOMSG_INCLUDE_DIRS})
	janus_append_compile_flags(${LIB_NANOMSG_CFLAGS})
	janus_append_ld_flags(${LIB_NANOMSG_LDFLAGS})

	include(CheckLibraryExists)

	CHECK_LIBRARY_EXISTS(
			${LIB_NANOMSG_LIBRARIES}
			nn_socket
			${LIB_NANOMSG_LIBRARY_DIRS}
			LIB_NANOMSG_HAS_nn_socket
	)

	if (LIB_NANOMSG_HAS_nn_socket)
		if (JANUS_TRANSPORT_RABBITMQ)
			janus_append_compile_definitions(HAVE_NANOMSG)
		endif (JANUS_TRANSPORT_RABBITMQ)

		if (JANUS_HANDLER_RABBITMQ)
			janus_append_compile_definitions(HAVE_NANOMSGEVH)
		endif (JANUS_HANDLER_RABBITMQ)
	endif (LIB_NANOMSG_HAS_nn_socket)
endfunction(try_use_nanomsg)

try_use_nanomsg()
