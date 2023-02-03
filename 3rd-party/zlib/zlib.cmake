pkg_check_modules(LIB_ZLIB QUIET REQUIRED zlib)

janus_append_link_libraries(${LIB_ZLIB_LIBRARIES})
janus_append_link_directories(${LIB_ZLIB_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_ZLIB_LIBRARIES}-${LIB_ZLIB_VERSION})
janus_append_include_directories(${LIB_ZLIB_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_ZLIB_CFLAGS})
janus_append_ld_flags(${LIB_ZLIB_LDFLAGS})
