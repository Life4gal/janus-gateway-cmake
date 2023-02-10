pkg_check_modules(LIB_USRSCTP QUIET usrsctp)

if (NOT ${LIB_USRSCTP_FOUND})
	message(FATAL_ERROR "Cannot find usrsctp on your platform, install it first...")
endif (NOT ${LIB_USRSCTP_FOUND})

janus_append_link_libraries(${LIB_USRSCTP_LIBRARIES})
janus_append_link_directories(${LIB_USRSCTP_LIBRARY_DIRS})
janus_append_link_libraries_name(${LIB_USRSCTP_LIBRARIES}-${LIB_USRSCTP_VERSION})
janus_append_include_directories(${LIB_USRSCTP_INCLUDE_DIRS})
janus_append_compile_flags(${LIB_USRSCTP_CFLAGS})
janus_append_ld_flags(${LIB_USRSCTP_LDFLAGS})

include(CheckLibraryExists)

CHECK_LIBRARY_EXISTS(
		${LIB_USRSCTP_LIBRARIES}
		usrsctp_finish
		${LIB_USRSCTP_LIBRARY_DIRS}
		LIB_USRSCTP_HAS_usrsctp_finish
)
if (LIB_USRSCTP_HAS_usrsctp_finish)
	janus_append_compile_definitions(HAVE_SCTP)
else ()
	message(WARNING "usrsctp version does not have usrsctp_finish")
endif (LIB_USRSCTP_HAS_usrsctp_finish)
