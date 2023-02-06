function(try_use_mhd)
	if (NOT JANUS_TRANSPORT_REST AND NOT JANUS_TRANSPORT_REST_TRY_USE)
		return()
	endif (NOT JANUS_TRANSPORT_REST AND NOT JANUS_TRANSPORT_REST_TRY_USE)

	pkg_check_modules(LIB_LIBMICROHTTPD QUIET libmicrohttpd>=0.9.59)

	if (NOT ${LIB_LIBMICROHTTPD_FOUND})
		if (JANUS_TRANSPORT_REST)
			message(FATAL_ERROR "libmicrohttpd not found. See README.md for installation instructions or set JANUS_TRANSPORT_REST off")
		elseif (JANUS_TRANSPORT_REST_TRY_USE)
			return()
		endif (JANUS_TRANSPORT_REST)
	endif (NOT ${LIB_LIBMICROHTTPD_FOUND})

	janus_append_link_libraries(${LIB_LIBMICROHTTPD_LIBRARIES})
	janus_append_link_directories(${LIB_LIBMICROHTTPD_LIBRARY_DIRS})
	janus_append_link_libraries_name(${LIB_LIBMICROHTTPD_LIBRARIES}-${LIB_LIBMICROHTTPD_VERSION})
	janus_append_include_directories(${LIB_LIBMICROHTTPD_INCLUDE_DIRS})
	janus_append_compile_flags(${LIB_LIBMICROHTTPD_CFLAGS})
	janus_append_ld_flags(${LIB_LIBMICROHTTPD_LDFLAGS})

	set(JANUS_DEPENDENCY_LIBMICROHTTPD_USED ON PARENT_SCOPE)
endfunction(try_use_mhd)

try_use_mhd()
