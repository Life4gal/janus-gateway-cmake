cmake_minimum_required(VERSION 3.20)

set(
		JANUS_MAJOR_VERSION
		1
)

set(
		JANUS_MINOR_VERSION
		1
)

set(
		JANUS_PATCH_VERSION
		0
)

set(
		JANUS_VERSION
		${JANUS_MAJOR_VERSION}.${JANUS_MINOR_VERSION}.${JANUS_PATCH_VERSION}
)

math(EXPR JANUS_VERSION_NUMBER "${JANUS_MAJOR_VERSION} * 1000 + ${JANUS_MINOR_VERSION} * 100 + ${JANUS_PATCH_VERSION} * 10" OUTPUT_FORMAT DECIMAL)

# Determine if our project is built as a subproject (using add_subdirectory)
# or if it is the master project.
set(JANUS_MASTER_PROJECT OFF)
if (CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
	set(JANUS_MASTER_PROJECT ON)
else ()
endif (CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake_utils/doc_var.cmake)

# Set the default CMAKE_BUILD_TYPE to RelWithDebInfo.
# This should be done before the project command since the latter can set
# CMAKE_BUILD_TYPE itself.
if (JANUS_MASTER_PROJECT AND NOT CMAKE_BUILD_TYPE)
	doc_var(
			CMAKE_BUILD_TYPE
			RelWithDebInfo
			STRING
			"Choose the type of build, options are: None(CMAKE_CXX_FLAGS or "
			"CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel."
	)
endif ()

project(
		janus
		VERSION ${JANUS_VERSION}
		DESCRIPTION https://janus.conf.meetecho.com
		HOMEPAGE_URL https://github.com/meetecho/janus-gateway
		LANGUAGES C
)

set(JANUS_EXE_MAIN_NAME ${PROJECT_NAME})
set(JANUS_EXE_CFGCONV_NAME ${PROJECT_NAME}-cfgconv)

if (${JANUS_MASTER_PROJECT})
	message(STATUS "Our project [${PROJECT_NAME}] is the main-project. CMAKE VERSION: ${CMAKE_VERSION}. Compiler ID: ${CMAKE_CXX_COMPILER_ID}. Platform: ${CMAKE_SYSTEM_NAME}.")
else ()
	message(STATUS "Our project [${PROJECT_NAME}] is the sub-project. CMAKE VERSION: ${CMAKE_VERSION}. Compiler ID: ${CMAKE_CXX_COMPILER_ID}. Platform: ${CMAKE_SYSTEM_NAME}.")
endif (${JANUS_MASTER_PROJECT})
message(STATUS "${PROJECT_NAME} VERSION: ${JANUS_VERSION}")
message(STATUS "${PROJECT_NAME} BUILD TYPE: ${CMAKE_BUILD_TYPE}")

include(GNUInstallDirs)
include(CheckCXXCompilerFlag)

set(JANUS_3RD_PARTY_PATH ${PROJECT_SOURCE_DIR}/3rd-party)

if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
	set(JANUS_PLATFORM_LINUX ON)
	set(JANUS_PLATFORM JANUS_PLATFORM_LINUX)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
	set(JANUS_PLATFORM_MACOS ON)
	set(JANUS_PLATFORM JANUS_PLATFORM_MACOS)
else ()
	string(REGEX MATCH "^.*BSD" JANUS_PLATFORM_BSD_MATCH_RESULT ${CMAKE_SYSTEM_NAME})
	if (JANUS_PLATFORM_BSD_MATCH_RESULT)
		set(JANUS_PLATFORM_${CMAKE_SYSTEM_NAME} ON)
		set(JANUS_PLATFORM JANUS_PLATFORM_${CMAKE_SYSTEM_NAME})

		# extra for *BSD
		set(JANUS_PLATFORM_IS_BSD ON)
	else ()
		message(FATAL_ERROR "Unsupported Platform: ${CMAKE_SYSTEM_NAME}")
	endif (JANUS_PLATFORM_BSD_MATCH_RESULT)
endif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")

doc_var(
		JANUS_INSTALL_HEADERS
		${CMAKE_INSTALL_INCLUDEDIR}
		STRING
		"Installation directory for include files, a relative path that "
		"will be joined with ${CMAKE_INSTALL_PREFIX} or an absolute path."
)

#message("--> ${CMAKE_INSTALL_FULL_BINDIR}")
#message("--> ${CMAKE_INSTALL_FULL_LIBEXECDIR}")
#message("--> ${CMAKE_INSTALL_FULL_SYSCONFDIR}")
#message("--> ${CMAKE_INSTALL_FULL_LIBDIR}")
#message("--> ${CMAKE_INSTALL_FULL_INCLUDEDIR}")
#message("--> ${CMAKE_INSTALL_FULL_DATADIR}")
#message("--> ${CMAKE_INSTALL_FULL_DATADIR}")

# TODO:
set(JANUS_INSTALL_BIN_DIR ${CMAKE_INSTALL_FULL_BINDIR}/janus/bin)
set(JANUS_INSTALL_CONFIG_DIR ${CMAKE_INSTALL_FULL_SYSCONFDIR}/janus)
set(JANUS_INSTALL_DEMOS_DIR ${CMAKE_INSTALL_FULL_DATADIR}/janus/demos)
set(JANUS_INSTALL_PLUGIN_DIR ${CMAKE_INSTALL_FULL_LIBDIR}/janus/plugins)
set(JANUS_INSTALL_TRANSPORT_DIR ${CMAKE_INSTALL_FULL_LIBDIR}/janus/transports)
set(JANUS_INSTALL_EVENT_DIR ${CMAKE_INSTALL_FULL_LIBDIR}/janus/events)
set(JANUS_INSTALL_LOGGER_DIR ${CMAKE_INSTALL_FULL_LIBDIR}/janus/loggers)
set(JANUS_INSTALL_STREAM_DIR ${CMAKE_INSTALL_FULL_DATADIR}/janus/streams)
set(JANUS_INSTALL_RECORDING_DIR ${CMAKE_INSTALL_FULL_DATADIR}/janus/recordings)
set(JANUS_INSTALL_LUA_DIR ${CMAKE_INSTALL_FULL_DATADIR}/janus/lua)
set(JANUS_INSTALL_DUKTAPE_DIR ${CMAKE_INSTALL_FULL_DATADIR}/janus/duktape)

set(JANUS_HEADER_FILES_PATH ${PROJECT_SOURCE_DIR}/include)

set(JANUS_SOURCE_FILES_PATH ${PROJECT_SOURCE_DIR}/src)

SET(JANUS_CONF_FILES_PATH ${PROJECT_SOURCE_DIR}/conf)

# TODO: option only allows `TRUE`/`FALSE`, but not `maybe`
#   If xxx is `OFF` and xxx_TRY_USE is `ON` then `target-library` will be attempted (skipped if not found).
#   If xxx is `ON` and `target-library` cannot be found then compilation will stop.

option(JANUS_DOC "Enable building documentation." OFF)
option(JANUS_DATA_CHANNELS "Disable DataChannels." ON)
option(JANUS_BORINGSSL "Use BoringSSL instead of OpenSSL." OFF)
option(JANUS_LIBSRTP2 "Use libsrtp 2.0.x instead of libsrtp 1.5.x." ON)
option(JANUS_DISABLE_ASE_GCM "Disable AES-GCM support in libsrtp(2)" OFF)
option(JANUS_DTLS_SET_TIMEOUT "Use DTLSv1_set_initial_timeout_duration (only available in recent BoringSSL versions)" OFF)
option(JANUS_PTHREAD_MUTEX "Use pthread_mutex instead of GMutex (see #1397)" ON)
option(JANUS_TURN_REST_API "Disable TURN REST API client (via libcurl)" ON)

# plugins
option(JANUS_PLUGIN_AUDIO_BRIDGE "" OFF)
option(JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE "" ON)

option(JANUS_PLUGIN_DUKTAPE "" OFF)
option(JANUS_PLUGIN_DUKTAPE_TRY_USE "" ON)

option(JANUS_PLUGIN_ECHO_TEST "" OFF)

option(JANUS_PLUGIN_LUA "" OFF)
option(JANUS_PLUGIN_LUA_TRY_USE "" ON)

option(JANUS_PLUGIN_RECORD_PLAY "" OFF)

option(JANUS_PLUGIN_SIP "" OFF)
option(JANUS_PLUGIN_SIP_TRY_USE "" ON)

option(JANUS_PLUGIN_NO_SIP "" OFF)
option(JANUS_PLUGIN_STREAMING "" OFF)
option(JANUS_PLUGIN_TEXT_ROOM "" OFF)
option(JANUS_PLUGIN_VIDEO_CALL "" OFF)
option(JANUS_PLUGIN_VIDEO_ROOM "" OFF)

option(JANUS_PLUGIN_VOICE_MAIL "" OFF)
option(JANUS_PLUGIN_VOICE_MAIL_TRY_USE "" ON)

# transport
option(JANUS_TRANSPORT_REST "Enable REST (HTTP/HTTPS) support" OFF)
option(JANUS_TRANSPORT_REST_TRY_USE "Try to enable REST (HTTP/HTTPS) support" ON)

option(JANUS_TRANSPORT_WEBSOCKETS "Enable WebSockets support" OFF)
option(JANUS_TRANSPORT_RABBITMQ "Enable RabbitMQ integration" OFF)
option(JANUS_TRANSPORT_MQTT "Enable MQTT integration" OFF)
option(JANUS_TRANSPORT_NANOMSG "Enable Nanomsg integration" OFF)
option(JANUS_TRANSPORT_UNIX_SOCKETS "Enable Unix Sockets integration" OFF)

# handler
option(JANUS_HANDLER_SAMPLE "Enable sample event handler (HTTP POST)" OFF)
option(JANUS_HANDLER_WEBSOCKETS "Enable WebSockets event handler" OFF)
option(JANUS_HANDLER_RABBITMQ "Enable RabbitMQ event handler" OFF)
option(JANUS_HANDLER_MQTT "Enable MQTT event handler" OFF)
option(JANUS_HANDLER_NANOMSG "Enable Nanomsg event handler" OFF)
option(JANUS_HANDLER_GELF "Enable gelf event handler" OFF)

# logger
option(JANUS_LOGGER_JSON "Enable external JSON file logger" OFF)

# js module
option(JANUS_JS_MODULE_ES "Generate an ECMAScript style module from janus.js" ON)
option(JANUS_JS_MODULE_UMD "Generate an UMD style module from janus.js" ON)
option(JANUS_JS_MODULE_IIFE "Generate an IIFE style wrapper around janus.js" ON)
option(JANUS_JS_MODULE_COMMON "Generate an CommonJS style module from janus.js" ON)

option(JANUS_SYSTEMD_SOCKETS "Enable Systemd Unix Sockets management" OFF)

option(JANUS_POST_PROCESSING "Enable building post-processing utility" OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Macros about the compiler.
set(JANUS_COMPILER_ID ${CMAKE_C_COMPILER_ID})
set(JANUS_COMPILER_VERSION ${CMAKE_C_COMPILER_VERSION})
set(JANUS_COMPILER_NAME ${JANUS_COMPILER_ID}.${JANUS_COMPILER_VERSION})

if (JANUS_MASTER_PROJECT AND NOT DEFINED CMAKE_CXX_VISIBILITY_PRESET)
	doc_var(
			CMAKE_CXX_VISIBILITY_PRESET
			hidden
			STRING
			"Preset for the export of private symbols"
	)
	set_property(
			CACHE CMAKE_CXX_VISIBILITY_PRESET
			PROPERTY STRINGS
			hidden default
	)
endif (JANUS_MASTER_PROJECT AND NOT DEFINED CMAKE_CXX_VISIBILITY_PRESET)

# The only purpose of this library is to act as a top-level dependency for extra libraries,
# so that as long as our main program depends on this library,
# the extra libraries are guaranteed to be compiled with the main program.
# (No need for the user to compile it manually)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/nothing_here_and_nobody_care)
file(WRITE ${CMAKE_BINARY_DIR}/nothing_here_and_nobody_care/janus_dummy_lib_do_not_build_it.c)
add_library(
		janus_dummy_lib_do_not_build_it
		${JANUS_SOURCE_FILES_PATH}/janus_dummy_lib_do_not_build_it.c
)
set_target_properties(
		janus_dummy_lib_do_not_build_it
		PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/nothing_here_and_nobody_care
)

include(${PROJECT_SOURCE_DIR}/cmake_utils/download_project.cmake)
include(${PROJECT_SOURCE_DIR}/cmake_utils/check_dependencies.cmake)
# TODO: Originally, the project's source and header files were in the same directory, but we separated them and needed a way for the source files to find the header files correctly.
#   1.Change back to the original way of putting source files and header files in the same directory.
#   2.Modify `#include "xxx.h"` to `#include <xxx_category/xxx.h>`.
# To reduce the workload, we should be able to 'automatically' change the desired file based on the 'option' used by the user.
# note: Do it after we `check_dependencies`.
include(${PROJECT_SOURCE_DIR}/cmake_utils/prepare_header_path.cmake)

janus_append_compile_flags(
		-fPIC
		-fstack-protector-all
		-fstrict-aliasing
		-ggdb3
		-pthread
		-Wall
		-Warray-bounds
		-Wextra
		-Wformat-nonliteral
		-Wformat-security
		-Wformat=2
		-Winit-self
		-Wlarger-than=65537
		-Wmissing-declarations
		-Wmissing-format-attribute
		-Wmissing-include-dirs
		-Wmissing-noreturn
		-Wmissing-prototypes
		-Wnested-externs
		-Wold-style-definition
		-Wpacked
		-Wpointer-arith
		-Wsign-compare
		-Wstrict-prototypes
		-Wswitch-default
		-Wunused
		-Wno-unused-parameter
		-Wno-unused-result
		-Wwrite-strings
		-Werror=implicit-function-declaration
)

if (JANUS_COMPILER_ID MATCHES gcc)
	janus_append_compile_flags(
			-Wcast-align
			-Wno-initializer-overrides
			-Wno-override-init
			-Wunsafe-loop-optimizations
			-Wunused-but-set-variable
	)
elseif (JANUS_COMPILER_ID MATCHES clang)
	janus_append_compile_flags(
			-Wcast-align
			-Wno-initializer-overrides
	)
endif (JANUS_COMPILER_ID MATCHES gcc)

if (JANUS_PLATFORM_MACOS)
	janus_append_ld_flags(
			-Wl,-export_dynamic
			# TODO
			-L/usr/local/lib -L/usr/local/opt/openssl/lib -L/opt/local/lib -L/usr/local/libsrtp/lib
	)
elseif (JANUS_PLATFORM_IS_BSD)
	janus_append_ld_flags(
			-Xlinker --export-dynamic
			# TODO
			-L/usr/lib/openssl -lcrypto -lssl -L/usr/local/lib
	)
else ()
	janus_append_ld_flags(
			-Wl,--export-dynamic
	)
endif (JANUS_PLATFORM_MACOS)

# generate version.c
find_program(GIT_EXE NAMES git REQUIRED)
find_program(DATE_EXE NAMES date REQUIRED)
find_program(PKGCONFIG_EXE NAMES pkg-config REQUIRED)

execute_process(
		COMMAND ${GIT_EXE} rev-parse HEAD
		RESULT_VARIABLE git_result
		OUTPUT_VARIABLE git_sha

		# COMMAND_ECHO STDERR
		# ECHO_OUTPUT_VARIABLE
		# ECHO_ERROR_VARIABLE
		# COMMAND_ERROR_IS_FATAL ANY
)
string(REPLACE "\n" "" git_sha ${git_sha})
#message("result: ${git_result}\n sha: ${git_sha}")

execute_process(
		COMMAND ${DATE_EXE}
		RESULT_VARIABLE date_result
		OUTPUT_VARIABLE date_time

		# COMMAND_ECHO STDERR
		# ECHO_OUTPUT_VARIABLE
		# ECHO_ERROR_VARIABLE
		# COMMAND_ERROR_IS_FATAL ANY
)
string(REPLACE "\n" "" date_time ${date_time})
#message("result: ${date_result}\n time: ${date_time}")

execute_process(
		COMMAND ${PKGCONFIG_EXE} --modversion nice
		RESULT_VARIABLE pkgconfig_result
		OUTPUT_VARIABLE pkgconfig_nice_version

		# COMMAND_ECHO STDERR
		# ECHO_OUTPUT_VARIABLE
		# ECHO_ERROR_VARIABLE
		# COMMAND_ERROR_IS_FATAL ANY
)
string(REPLACE "\n" "" pkgconfig_nice_version ${pkgconfig_nice_version})
#message("result: ${pkgconfig_result}\n nice version: ${pkgconfig_nice_version}")

file(
		WRITE
		${JANUS_SOURCE_FILES_PATH}/version.c

		"#include \"version.h\"\n"
		"const char *janus_build_git_sha = \"${git_sha}\";\n"
		"const char *janus_build_git_time = \"${date_time}\";\n"
		"int janus_version = ${JANUS_VERSION_NUMBER};\n"
		"const char *janus_version_string = \"${JANUS_VERSION}\";\n"
		"const char *libnice_version_string = \"${pkgconfig_nice_version}\";\n"
)

set(
		JANUS_HEADER_FILES

		${JANUS_HEADER_FILES_PATH}/apierror.h
		${JANUS_HEADER_FILES_PATH}/auth.h
		${JANUS_HEADER_FILES_PATH}/config.h
		${JANUS_HEADER_FILES_PATH}/debug.h
		${JANUS_HEADER_FILES_PATH}/dtls.h
		${JANUS_HEADER_FILES_PATH}/dtls-bio.h
		${JANUS_HEADER_FILES_PATH}/events.h
		${JANUS_HEADER_FILES_PATH}/ice.h
		${JANUS_HEADER_FILES_PATH}/janus.h
		${JANUS_HEADER_FILES_PATH}/log.h
		${JANUS_HEADER_FILES_PATH}/mutex.h
		${JANUS_HEADER_FILES_PATH}/options.h
		${JANUS_HEADER_FILES_PATH}/record.h
		${JANUS_HEADER_FILES_PATH}/refcount.h
		${JANUS_HEADER_FILES_PATH}/rtcp.h
		${JANUS_HEADER_FILES_PATH}/rtp.h
		${JANUS_HEADER_FILES_PATH}/rtpsrtp.h
		${JANUS_HEADER_FILES_PATH}/sctp.h
		${JANUS_HEADER_FILES_PATH}/sdp.h
		${JANUS_HEADER_FILES_PATH}/sdp-utils.h
		${JANUS_HEADER_FILES_PATH}/ip-utils.h
		${JANUS_HEADER_FILES_PATH}/turnrest.h
		${JANUS_HEADER_FILES_PATH}/utils.h
		${JANUS_HEADER_FILES_PATH}/version.h
		${JANUS_HEADER_FILES_PATH}/text2pcap.h

		${JANUS_HEADER_FILES_PATH}/plugins/plugin.h

		${JANUS_HEADER_FILES_PATH}/transports/transport.h

		${JANUS_HEADER_FILES_PATH}/events/eventhandler.h

		${JANUS_HEADER_FILES_PATH}/loggers/logger.h
)

set(
		JANUS_SOURCE_FILES

		${JANUS_SOURCE_FILES_PATH}/apierror.c
		${JANUS_SOURCE_FILES_PATH}/auth.c
		${JANUS_SOURCE_FILES_PATH}/config.c
		${JANUS_SOURCE_FILES_PATH}/dtls.c
		${JANUS_SOURCE_FILES_PATH}/dtls-bio.c
		${JANUS_SOURCE_FILES_PATH}/events.c
		${JANUS_SOURCE_FILES_PATH}/ice.c
		${JANUS_SOURCE_FILES_PATH}/janus.c
		${JANUS_SOURCE_FILES_PATH}/log.c
		${JANUS_SOURCE_FILES_PATH}/options.c
		${JANUS_SOURCE_FILES_PATH}/record.c
		${JANUS_SOURCE_FILES_PATH}/rtcp.c
		${JANUS_SOURCE_FILES_PATH}/rtp.c
		${JANUS_SOURCE_FILES_PATH}/sctp.c
		${JANUS_SOURCE_FILES_PATH}/sdp.c
		${JANUS_SOURCE_FILES_PATH}/sdp-utils.c
		${JANUS_SOURCE_FILES_PATH}/ip-utils.c
		${JANUS_SOURCE_FILES_PATH}/turnrest.c
		${JANUS_SOURCE_FILES_PATH}/utils.c
		${JANUS_SOURCE_FILES_PATH}/version.c
		${JANUS_SOURCE_FILES_PATH}/text2pcap.c

		${JANUS_SOURCE_FILES_PATH}/plugins/plugin.c

		${JANUS_SOURCE_FILES_PATH}/transports/transport.c

		${JANUS_SOURCE_FILES_PATH}/turnrest.c
)

set(
		JANUS_CFGCONV_HEADER_FILES
)

set(
		JANUS_CFGCONV_SOURCE_FILES

		${JANUS_SOURCE_FILES_PATH}/janus-cfgconv.c
		${JANUS_SOURCE_FILES_PATH}/config.c
		${JANUS_SOURCE_FILES_PATH}/log.c
		${JANUS_SOURCE_FILES_PATH}/utils.c
		${JANUS_SOURCE_FILES_PATH}/version.c
)

# EXECUTABLE

# MAIN EXECUTABLE
add_executable(
		${PROJECT_NAME}

		${JANUS_HEADER_FILES}
		${JANUS_SOURCE_FILES}
		${JANUS_EXTRA_SOURCE_FILES}
)
add_dependencies(
		${PROJECT_NAME}
		janus_dummy_lib_do_not_build_it
)
set_target_properties(
		${PROJECT_NAME}
		PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY ${JANUS_INSTALL_BIN_DIR}
)

# cfg conv
add_executable(
		${PROJECT_NAME}-cfgconv

		${JANUS_CFGCONV_HEADER_FILES}
		${JANUS_CFGCONV_SOURCE_FILES}
)
add_dependencies(
		${PROJECT_NAME}-cfgconv
		janus_dummy_lib_do_not_build_it
)
set_target_properties(
		${PROJECT_NAME}-cfgconv
		PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY ${JANUS_INSTALL_BIN_DIR}
)

# SET FLAGS
target_compile_options(
		${PROJECT_NAME}
		PRIVATE

		${JANUS_COMPILE_FLAGS}
)

# SET DEFINITIONS
target_compile_definitions(
		${PROJECT_NAME}
		PRIVATE

		${JANUS_COMPILE_DEFINITIONS}

		# GNU extensions
		# such as: strcasestr
		_GNU_SOURCE

		# clang-format off
		# @formatter:off
		CONFDIR="${JANUS_INSTALL_CONFIG_DIR}"
		PLUGINDIR="${JANUS_INSTALL_PLUGIN_DIR}"
		TRANSPORTDIR="${JANUS_INSTALL_TRANSPORT_DIR}"
		EVENTDIR="${JANUS_INSTALL_EVENT_DIR}"
		LOGGERDIR="${JANUS_INSTALL_LOGGER_DIR}"
		# @formatter:on
		# clang-format on
)

# SET INCLUDE DIRECTORY
target_include_directories(
		${PROJECT_NAME}
		PUBLIC

		$<BUILD_INTERFACE:${JANUS_HEADER_FILES_PATH}>
		$<INSTALL_INTERFACE:${JANUS_INSTALL_HEADERS}/${PROJECT_NAME}-${PROJECT_VERSION}>
)

target_link_options(
		${PROJECT_NAME}
		PRIVATE

		${JANUS_LD_FLAGS}
)

# LINK 3rd-PARTY LIBRARIES
target_link_directories(
		${PROJECT_NAME}
		PRIVATE

		${JANUS_LINK_DIRECTORIES}
)

target_link_libraries(
		${PROJECT_NAME}
		PRIVATE

		${JANUS_LINK_LIBRARIES}
)

target_include_directories(
		${PROJECT_NAME}
		PRIVATE

		${JANUS_INCLUDE_DIRECTORIES}
)

#janus_print_all_dependencies_info()

message(STATUS "=======================================")
message(STATUS "[${PROJECT_NAME}] DEPENDENCIES:")
foreach (library IN LISTS JANUS_LINK_LIBRARIES_NAME)
	message(STATUS "-->\t\t ${library}")
endforeach (library IN LISTS JANUS_LINK_LIBRARIES_NAME)
message(STATUS "=======================================")

# DOCUMENTS
if (JANUS_DOC)
	# TODO
endif (JANUS_DOC)

# TESTS
if (JANUS_TEST)
	enable_testing()
	# TODO
endif (JANUS_TEST)
