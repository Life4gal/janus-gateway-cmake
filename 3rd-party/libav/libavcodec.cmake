pkg_check_modules(LIB_LIBAVCODEC libavcodec)

if (NOT LIB_LIBAVCODEC_FOUND)
	message(FATAL_ERROR "Cannot find libavcodec on your platform, install it first...")
endif (NOT LIB_LIBAVCODEC_FOUND)

janus_append_link_libraries(${LIB_LIBAVCODEC_LIBRARIES})
janus_append_link_directories(${LIB_LIBAVCODEC_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_LIBAVCODEC_LIBRARIES}-${LIB_LIBAVCODEC_VERSION})
janus_append_include_directories(${LIB_LIBAVCODEC_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_LIBAVCODEC_CFLAGS})
janus_append_ld_flags(${LIB_LIBAVCODEC_LDFLAGS})
