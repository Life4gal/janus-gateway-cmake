function(try_use_websockets)
	if (NOT JANUS_TRANSPORT_WEBSOCKETS AND NOT JANUS_HANDLER_WEBSOCKETS)
		return()
	endif (NOT JANUS_TRANSPORT_WEBSOCKETS AND NOT JANUS_HANDLER_WEBSOCKETS)

	pkg_check_modules(LIB_LIBWEBSOCKETS libwebsockets)

	if (NOT LIB_LIBWEBSOCKETS_FOUND)
		message(FATAL_ERROR "Cannot find libwebsockets on your platform, install it first...")
	endif (NOT LIB_LIBWEBSOCKETS_FOUND)

	set(CACHE_LIBWEBSOCKETS "libwebsockets" CACHE INTERNAL "libwebsockets." FORCE)
	set(CACHE_LIBWEBSOCKETS_LIBRARIES ${LIB_LIBWEBSOCKETS_LIBRARIES} CACHE INTERNAL "libwebsockets." FORCE)
	set(CACHE_LIBWEBSOCKETS_DIRECTORIES ${LIB_LIBWEBSOCKETS_LIBRARY_DIRS} CACHE INTERNAL "libwebsockets." FORCE)
	set(CACHE_LIBWEBSOCKETS_LIBRARY_NAME ${LIB_LIBWEBSOCKETS_LIBRARIES}-${LIB_LIBWEBSOCKETS_VERSION} CACHE INTERNAL "libwebsockets." FORCE)
	set(CACHE_LIBWEBSOCKETS_INCLUDE_DIRECTORIES ${LIB_LIBWEBSOCKETS_INCLUDE_DIRS} CACHE INTERNAL "libwebsockets." FORCE)
	set(CACHE_LIBWEBSOCKETS_COMPILE_FLAGS ${LIB_LIBWEBSOCKETS_CFLAGS} CACHE INTERNAL "libwebsockets." FORCE)
	set(CACHE_LIBWEBSOCKETS_LD_FLAGS ${LIB_LIBWEBSOCKETS_LDFLAGS} CACHE INTERNAL "libwebsockets." FORCE)
	
	include(CheckLibraryExists)

	CHECK_LIBRARY_EXISTS(
			libwebsockets
			lws_create_vhost
			"${LIB_LIBWEBSOCKETS_LIBRARY_DIRS}"
			LIB_LIBWEBSOCKETS_HAS_lws_create_vhost
	)

	if (LIB_LIBWEBSOCKETS_HAS_lws_create_vhost)
		if (JANUS_TRANSPORT_WEBSOCKETS)
			janus_append_compile_definitions(HAVE_WEBSOCKETS)

			CHECK_LIBRARY_EXISTS(
					libwebsockets
					lws_get_peer_simple
					"${LIB_LIBWEBSOCKETS_LIBRARY_DIRS}"
					LIB_LIBWEBSOCKETS_HAS_lws_get_peer_simple
			)

			if (LIB_LIBWEBSOCKETS_HAS_lws_get_peer_simple)
				janus_append_compile_definitions(HAVE_LIBWEBSOCKETS_PEER_SIMPLE)
			endif (LIB_LIBWEBSOCKETS_HAS_lws_get_peer_simple)
		endif (JANUS_TRANSPORT_WEBSOCKETS)

		if (JANUS_HANDLER_WEBSOCKETS)
			janus_append_compile_definitions(HAVE_WSEVH)
		endif (JANUS_HANDLER_WEBSOCKETS)
	endif (LIB_LIBWEBSOCKETS_HAS_lws_create_vhost)
endfunction(try_use_websockets)

try_use_websockets()
