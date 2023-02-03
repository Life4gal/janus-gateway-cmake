if (JANUS_LIBSRTP2)
	# libsrtp2
	pkg_check_modules(LIB_SRTP QUIET REQUIRED libsrtp2)
	janus_append_compile_definitions(HAVE_SRTP_2)
else ()
	# libsrtp 1.5.x
	pkg_check_modules(LIB_SRTP QUIET REQUIRED libsrtp>=1.5)
endif (JANUS_LIBSRTP2)

janus_append_link_libraries(${LIB_SRTP_LIBRARIES})
janus_append_link_directories(${LIB_SRTP_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_SRTP_LIBRARIES}-${LIB_SRTP_VERSION})
janus_append_include_directories(${LIB_SRTP_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_SRTP_CFLAGS})
janus_append_ld_flags(${LIB_SRTP_LDFLAGS})
