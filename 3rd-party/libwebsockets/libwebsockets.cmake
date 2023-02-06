function(try_use_websockets)
	if (NOT JANUS_TRANSPORT_WEBSOCKETS AND NOT JANUS_HANDLER_WEBSOCKETS)
		return()
	endif (NOT JANUS_TRANSPORT_WEBSOCKETS AND NOT JANUS_HANDLER_WEBSOCKETS)

	pkg_check_modules(LIB_LIBWEBSOCKET QUIET REQUIRED libwebsockets)

	janus_append_link_libraries(${LIB_LIBWEBSCOKETS_LIBRARIES})
	janus_append_link_directories(${LIB_LIBWEBSCOKETS_LIBRARY_DIRS})
	janus_append_link_libraries_name(${LIB_LIBWEBSCOKETS_LIBRARIES}-${LIB_LIBWEBSCOKETS_VERSION})
	janus_append_include_directories(${LIB_LIBWEBSCOKETS_INCLUDE_DIRS})
	janus_append_compile_flags(${LIB_LIBWEBSCOKETS_CFLAGS})
	janus_append_ld_flags(${LIB_LIBWEBSCOKETS_LDFLAGS})

	set(JANUS_DEPENDENCY_LIBWEBSOCKETS_USED ON PARENT_SCOPE)

	include(CheckLibraryExists)

	CHECK_LIBRARY_EXISTS(
			${LIB_LIBWEBSCOKETS_LIBRARIES}
			lws_create_vhost
			${LIB_LIBWEBSCOKETS_LIBRARY_DIRS}
			LIB_LIBWEBSCOKETS_HAS_lws_create_vhost
	)

	if (LIB_LIBWEBSCOKETS_HAS_lws_create_vhost)
		if (JANUS_TRANSPORT_WEBSOCKETS)
			janus_append_compile_definitions(HAVE_WEBSOCKETS)

			CHECK_LIBRARY_EXISTS(
					${LIB_LIBWEBSCOKETS_LIBRARIES}
					lws_get_peer_simple
					${LIB_LIBWEBSCOKETS_LIBRARY_DIRS}
					LIB_LIBWEBSCOKETS_HAS_lws_get_peer_simple
			)

			if (LIB_LIBWEBSCOKETS_HAS_lws_get_peer_simple)
				janus_append_compile_definitions(HAVE_LIBWEBSOCKETS_PEER_SIMPLE)
			endif (LIB_LIBWEBSCOKETS_HAS_lws_get_peer_simple)
		endif (JANUS_TRANSPORT_WEBSOCKETS)

		if (JANUS_HANDLER_WEBSOCKETS)
			janus_append_compile_definitions(HAVE_WSEVH)
		endif (JANUS_HANDLER_WEBSOCKETS)
	endif (LIB_LIBWEBSCOKETS_HAS_lws_create_vhost)
endfunction(try_use_websockets)

try_use_websockets()
