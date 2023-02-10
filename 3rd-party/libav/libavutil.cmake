pkg_check_modules(LIB_LIBAVUTIL libavutil)

if (NOT LIB_LIBAVUTIL_FOUND)
	message(FATAL_ERROR "Cannot find libavutil on your platform, install it first...")
endif (NOT LIB_LIBAVUTIL_FOUND)

janus_append_link_libraries(${LIB_LIBAVUTIL_LIBRARIES})
janus_append_link_directories(${LIB_LIBAVUTIL_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_LIBAVUTIL_LIBRARIES}-${LIB_LIBAVUTIL_VERSION})
janus_append_include_directories(${LIB_LIBAVUTIL_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_LIBAVUTIL_CFLAGS})
janus_append_ld_flags(${LIB_LIBAVUTIL_LDFLAGS})
