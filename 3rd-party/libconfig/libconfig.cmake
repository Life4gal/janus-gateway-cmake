pkg_check_modules(LIB_LIBCONFIG QUIET REQUIRED libconfig)

janus_append_link_libraries(${LIB_LIBCONFIG_LIBRARIES})
janus_append_link_directories(${LIB_LIBCONFIG_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_LIBCONFIG_LIBRARIES}-${LIB_LIBCONFIG_VERSION})
janus_append_include_directories(${LIB_LIBCONFIG_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_LIBCONFIG_CFLAGS})
janus_append_ld_flags(${LIB_LIBCONFIG_LDFLAGS})
