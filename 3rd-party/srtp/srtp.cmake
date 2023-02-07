if (JANUS_LIBSRTP2)
	# libsrtp2
	pkg_check_modules(LIB_SRTP QUIET REQUIRED libsrtp2)
else ()
	# libsrtp 1.5.x
	pkg_check_modules(LIB_SRTP QUIET REQUIRED libsrtp>=1.5)
endif (JANUS_LIBSRTP2)

set(CACHE_SRTP "libsrtp" CACHE INTERNAL "libsrtp." FORCE)
set(CACHE_SRTP_LIBRARIES ${LIB_SRTP_LIBRARIES} CACHE INTERNAL "libsrtp." FORCE)
set(CACHE_SRTP_DIRECTORIES ${LIB_SRTP_LIBRARY_DIRS} CACHE INTERNAL "libsrtp." FORCE)
set(CACHE_SRTP_LIBRARY_NAME ${LIB_SRTP_LIBRARIES}-${LIB_SRTP_VERSION} CACHE INTERNAL "libsrtp." FORCE)
set(CACHE_SRTP_INCLUDE_DIRECTORIES ${LIB_SRTP_INCLUDE_DIRS} CACHE INTERNAL "libsrtp." FORCE)
set(CACHE_SRTP_COMPILE_FLAGS ${LIB_SRTP_CFLAGS} CACHE INTERNAL "libsrtp." FORCE)
set(CACHE_SRTP_LD_FLAGS ${LIB_SRTP_LDFLAGS} CACHE INTERNAL "libsrtp." FORCE)

if (JANUS_LIBSRTP2)
	set(CACHE_SRTP_COMPILE_FLAGS ${CACHE_SRTP_COMPILE_FLAGS} "-DHAVE_SRTP_2" CACHE INTERNAL "libsrtp." FORCE)
endif (JANUS_LIBSRTP2)
