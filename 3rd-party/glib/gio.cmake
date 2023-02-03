include(${JANUS_3RD_PARTY_PATH}/glib/version.cmake)

pkg_check_modules(LIB_GIO QUIET REQUIRED gio-2.0>=${JANUS_GIO_VERSION})

janus_append_link_libraries(${LIB_GIO_LIBRARIES})
janus_append_link_directories(${LIB_GIO_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_GIO_LIBRARIES}-${LIB_GIO_VERSION})
janus_append_include_directories(${LIB_GIO_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_GIO_CFLAGS})
janus_append_ld_flags(${LIB_GIO_LDFLAGS})
