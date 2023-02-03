pkg_check_modules(LIB_LIBCURL QUIET libcurl)

if (NOT LIB_LIBCURL_FOUND)
	if (JANUS_TURN_REST_API)
		message(FATAL_ERROR "libcurl not found. See README.md for installation instructions or set JANUS_TURN_REST_API off")
	endif (JANUS_TURN_REST_API)

	if (JANUS_HANDLER_SAMPLE)
		message(FATAL_ERROR "libcurl not found. See README.md for installation instructions or set JANUS_HANDLER_SAMPLE off")
	endif (JANUS_HANDLER_SAMPLE)

	message(FATAL_ERROR "Unexpected branch here...")
endif (NOT LIB_LIBCURL_FOUND)

if (JANUS_TURN_REST_API)
	janus_append_compile_definitions(HAVE_TURNRESTAPI)
endif (JANUS_TURN_REST_API)

if (JANUS_HANDLER_SAMPLE)
	janus_append_compile_definitions(HAVE_SAMPLEEVH)
endif (JANUS_HANDLER_SAMPLE)

janus_append_link_libraries(${LIB_LIBCURL_LIBRARIES})
janus_append_link_directories(${LIB_LIBCURL_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_LIBCURL_LIBRARIES}-${LIB_LIBCURL_VERSION})
janus_append_include_directories(${LIB_LIBCURL_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_LIBCURL_CFLAGS})
janus_append_ld_flags(${LIB_LIBCURL_LDFLAGS})
