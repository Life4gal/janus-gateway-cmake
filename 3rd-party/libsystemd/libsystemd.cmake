pkg_check_modules(LIB_LIBSYSTEMD QUIET REQUIRED libsystemd)

janus_append_link_libraries(${LIB_LIBSYSTEMD_LIBRARIES})
janus_append_link_directories(${LIB_LIBSYSTEMD_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_LIBSYSTEMD_LIBRARIES}-${LIB_LIBSYSTEMD_VERSION})
janus_append_include_directories(${LIB_LIBSYSTEMD_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_LIBSYSTEMD_CFLAGS})
janus_append_ld_flags(${LIB_LIBSYSTEMD_LDFLAGS})

janus_append_compile_definitions(HAVE_LIBSYSTEMD)
