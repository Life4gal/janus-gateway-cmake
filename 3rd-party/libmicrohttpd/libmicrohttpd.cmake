function(try_use_mhd)
	if (NOT JANUS_TRANSPORT_REST AND NOT JANUS_TRANSPORT_REST_TRY_USE)
		return()
	endif (NOT JANUS_TRANSPORT_REST AND NOT JANUS_TRANSPORT_REST_TRY_USE)

	pkg_check_modules(LIB_LIBMICROHTTPD libmicrohttpd>=0.9.59)

	if (NOT LIB_LIBMICROHTTPD_FOUND)
		if (JANUS_TRANSPORT_REST)
			message(FATAL_ERROR "libmicrohttpd not found. See README.md for installation instructions or set JANUS_TRANSPORT_REST off")
		elseif (JANUS_TRANSPORT_REST_TRY_USE)
			return()
		endif (JANUS_TRANSPORT_REST)
	endif (NOT LIB_LIBMICROHTTPD_FOUND)

	set(CACHE_LIBMICROHTTPD "libmicrohttpd" CACHE INTERNAL "libmicrohttpd." FORCE)
	set(CACHE_LIBMICROHTTPD_LIBRARIES ${LIB_LIBMICROHTTPD_LIBRARIES} CACHE INTERNAL "libmicrohttpd." FORCE)
	set(CACHE_LIBMICROHTTPD_DIRECTORIES ${LIB_LIBMICROHTTPD_LIBRARY_DIRS} CACHE INTERNAL "libmicrohttpd." FORCE)
	set(CACHE_LIBMICROHTTPD_LIBRARY_NAME ${LIB_LIBMICROHTTPD_LIBRARIES}-${LIB_LIBMICROHTTPD_VERSION} CACHE INTERNAL "libmicrohttpd." FORCE)
	set(CACHE_LIBMICROHTTPD_INCLUDE_DIRECTORIES ${LIB_LIBMICROHTTPD_INCLUDE_DIRS} CACHE INTERNAL "libmicrohttpd." FORCE)
	set(CACHE_LIBMICROHTTPD_COMPILE_FLAGS ${LIB_LIBMICROHTTPD_CFLAGS} CACHE INTERNAL "libmicrohttpd." FORCE)
	set(CACHE_LIBMICROHTTPD_LD_FLAGS ${LIB_LIBMICROHTTPD_LDFLAGS} CACHE INTERNAL "libmicrohttpd." FORCE)
endfunction(try_use_mhd)

try_use_mhd()
