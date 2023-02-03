include(${JANUS_3RD_PARTY_PATH}/glib/version.cmake)

pkg_check_modules(LIB_GLIB QUIET REQUIRED glib-2.0>=${JANUS_GLIB_VERSION})

janus_append_link_libraries(${LIB_GLIB_LIBRARIES})
janus_append_link_directories(${LIB_GLIB_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_GLIB_LIBRARIES}-${LIB_GLIB_VERSION})
janus_append_include_directories(${LIB_GLIB_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_GLIB_CFLAGS})
janus_append_ld_flags(${LIB_GLIB_LDFLAGS})
