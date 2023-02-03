pkg_check_modules(LIB_LIBAVUTIL QUIET REQUIRED libavutil)

janus_append_link_libraries(${LIB_LIBAVUTIL_LIBRARIES})
janus_append_link_directories(${LIB_LIBAVUTIL_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_LIBAVUTIL_LIBRARIES}-${LIB_LIBAVUTIL_VERSION})
janus_append_include_directories(${LIB_LIBAVUTIL_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_LIBAVUTIL_CFLAGS})
janus_append_ld_flags(${LIB_LIBAVUTIL_LDFLAGS})
