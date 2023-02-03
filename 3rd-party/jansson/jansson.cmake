pkg_check_modules(LIB_JANSSON QUIET REQUIRED jansson>=2.5)

janus_append_link_libraries(${LIB_JANSSON_LIBRARIES})
janus_append_link_directories(${LIB_JANSSON_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_JANSSON_LIBRARIES}-${LIB_JANSSON_VERSION})
janus_append_include_directories(${LIB_JANSSON_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_JANSSON_CFLAGS})
janus_append_ld_flags(${LIB_JANSSON_LDFLAGS})
