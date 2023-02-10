pkg_check_modules(LIB_LIBAVFORMAT libavformat)

if (NOT LIB_LIBAVFORMAT_FOUND)
	message(FATAL_ERROR "Cannot find libavformat on your platform, install it first...")
endif (NOT LIB_LIBAVFORMAT_FOUND)

janus_append_link_libraries(${LIB_LIBAVFORMAT_LIBRARIES})
janus_append_link_directories(${LIB_LIBAVFORMAT_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_LIBAVFORMAT_LIBRARIES}-${LIB_LIBAVFORMAT_VERSION})
janus_append_include_directories(${LIB_LIBAVFORMAT_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_LIBAVFORMAT_CFLAGS})
janus_append_ld_flags(${LIB_LIBAVFORMAT_LDFLAGS})
