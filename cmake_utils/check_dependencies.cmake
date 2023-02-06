include(${PROJECT_SOURCE_DIR}/cmake_utils/prepare_dependencies.cmake)

find_package(PkgConfig REQUIRED)

# LIB_GLIB AND LIB_GIO
include(${JANUS_3RD_PARTY_PATH}/glib/glib.cmake)
include(${JANUS_3RD_PARTY_PATH}/glib/gio.cmake)

# LIB_LIBCONFIG
include(${JANUS_3RD_PARTY_PATH}/libconfig/libconfig.cmake)

# LIB_NICE
include(${JANUS_3RD_PARTY_PATH}/nice/nice.cmake)

# LIB_JANSSON
include(${JANUS_3RD_PARTY_PATH}/jansson/jansson.cmake)

# LIB_ZLIB
include(${JANUS_3RD_PARTY_PATH}/zlib/zlib.cmake)

if (NOT JANUS_PLATFORM_IS_BSD)
	# LIB_LIBSSL
	include(${JANUS_3RD_PARTY_PATH}/libssl/libssl.cmake)
	# LIB_LIBCRYPTO
	include(${JANUS_3RD_PARTY_PATH}/libcrypto/libcrypto.cmake)
endif ()

# LIB_OPENSSL OR LIB_BORINGSSL
if (JANUS_BORINGSSL)
	message(STATUS "Trying to use BoringSSL instead of OpenSSL...")
	include(${JANUS_3RD_PARTY_PATH}/boringssl/boringssl.cmake)
else ()
	include(${JANUS_3RD_PARTY_PATH}/openssl/openssl.cmake)
endif (JANUS_BORINGSSL)

if (JANUS_DTLS_SET_TIMEOUT)
	message(STATUS "Assuming DTLSv1_set_initial_timeout_duration is available")
	janus_append_compile_definitions(HAVE_DTLS_SETTIMEOUT)
endif (JANUS_DTLS_SET_TIMEOUT)

if (JANUS_PTHREAD_MUTEX)
	message(STATUS "Will use pthread_mutex instead of GMutex")
	janus_append_compile_definitions(USE_PTHREAD_MUTEX)
endif (JANUS_PTHREAD_MUTEX)

# LIB_DL
janus_append_link_libraries(${CMAKE_DL_LIBS})
janus_append_link_libraries_name(${CMAKE_DL_LIBS})

# LIB_SRTP
include(${JANUS_3RD_PARTY_PATH}/srtp/srtp.cmake)

# LIB_USRSCTP
if (JANUS_DATA_CHANNELS)
	include(${JANUS_3RD_PARTY_PATH}/usrsctp/usrsctp.cmake)
endif (JANUS_DATA_CHANNELS)

# LIB_LIBCURL
if (JANUS_TURN_REST_API OR JANUS_HANDLER_SAMPLE)
	set(JANUS_DEPENDENCY_LIBCURL_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/libcurl/libcurl.cmake)

	if (${JANUS_DEPENDENCY_LIBCURL_USED})
		janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/events/janus_sampleevh.c)
		janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.eventhandler.sampleevh.jcfg.sample)
	endif (${JANUS_DEPENDENCY_LIBCURL_USED})
endif (JANUS_TURN_REST_API OR JANUS_HANDLER_SAMPLE)

# DOXYGEN AND DOT
if (JANUS_DOC)
	find_program(DOXYGEN_EXE NAMES doxygen)
	find_program(DOT_EXE NAMES dot)

	if (DOXYGEN_EXE-NOTFOUND AND DOT_EXE-NOTFOUND)
		message(FATAL_ERROR "doxygen or dot not found. See README.md for installation instructions or set JANUS_DOC off")
	endif (DOXYGEN_EXE-NOTFOUND AND DOT_EXE-NOTFOUND)

	# TODO: check doxygen version here...
endif (JANUS_DOC)

# LIB_LIBMICROHTTPD
if (JANUS_TRANSPORT_REST OR JANUS_TRANSPORT_REST_TRY_USE)
	set(JANUS_DEPENDENCY_LIBMICROHTTPD_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/libmicrohttpd/libmicrohttpd.cmake)

	if (${JANUS_DEPENDENCY_LIBMICROHTTPD_USED})
		janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/transports/janus_http.c)
		janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.transport.http.jcfg.sample)
	endif (${JANUS_DEPENDENCY_LIBMICROHTTPD_USED})
endif (JANUS_TRANSPORT_REST OR JANUS_TRANSPORT_REST_TRY_USE)

# LIB_LIBWEBSOCKETS
if (JANUS_TRANSPORT_WEBSOCKETS OR JANUS_HANDLER_WEBSOCKETS)
	set(JANUS_DEPENDENCY_LIBWEBSOCKETS_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/libwebsockets/libwebsockets.cmake)

	if (${JANUS_DEPENDENCY_LIBWEBSOCKETS_USED})
		if (JANUS_TRANSPORT_WEBSOCKETS)
			janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/transports/janus_websockets.c)
			janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.transport.websockets.jcfg.sample)
		endif (JANUS_TRANSPORT_WEBSOCKETS)

		if (JANUS_HANDLER_WEBSOCKETS)
			janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/events/janus_wsevh.c)
			janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.eventhandler.wsevh.jcfg.sample)
		endif (JANUS_HANDLER_WEBSOCKETS)
	endif (${JANUS_DEPENDENCY_LIBWEBSOCKETS_USED})
endif (JANUS_TRANSPORT_WEBSOCKETS OR JANUS_HANDLER_WEBSOCKETS)

# LIB_LIBRABBITMQ
if (JANUS_TRANSPORT_RABBITMQ OR JANUS_HANDLER_RABBITMQ)
	set(JANUS_DEPENDENCY_LIBRABBITMQ_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/librabbitmq/librabbitmq.cmake)

	if (${JANUS_DEPENDENCY_LIBRABBITMQ_USED})
		if (JANUS_TRANSPORT_RABBITMQ)
			janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/transports/janus_rabbitmq.c)
			janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.transport.rabbitmq.jcfg.sample)
		endif (JANUS_TRANSPORT_RABBITMQ)

		if (JANUS_HANDLER_RABBITMQ)
			janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/events/janus_rabbitmqevh.c)
			janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.eventhandler.rabbitmqevh.jcfg.sample)
		endif (JANUS_HANDLER_RABBITMQ)
	endif (${JANUS_DEPENDENCY_LIBRABBITMQ_USED})
endif (JANUS_TRANSPORT_RABBITMQ OR JANUS_HANDLER_RABBITMQ)

# LIB_LIBPAHO-MQTT3AS
if (JANUS_TRANSPORT_MQTT OR JANUS_HANDLER_MQTT)
	set(JANUS_DEPENDENCY_LIBPAHO-MQTT3AS_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/libpaho-mqtt3as/libpaho-mqtt3as.cmake)

	if (${JANUS_DEPENDENCY_LIBPAHO-MQTT3AS_USED})
		if (JANUS_TRANSPORT_MQTT)
			janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/transports/janus_mqtt.c)
			janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.transport.mqtt.jcfg.sample)
		endif (JANUS_TRANSPORT_MQTT)

		if (JANUS_HANDLER_MQTT)
			janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/events/janus_mqttevh.c)
			janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.eventhandler.mqttevh.jcfg.sample)
		endif (JANUS_HANDLER_MQTT)
	endif (${JANUS_DEPENDENCY_LIBPAHO-MQTT3AS_USED})
endif (JANUS_TRANSPORT_MQTT OR JANUS_HANDLER_MQTT)

# LIB_NANOMSG
if (JANUS_TRANSPORT_NANOMSG OR JANUS_HANDLER_NANOMSG)
	set(JANUS_DEPENDENCY_NANOMSG_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/nanomsg/nanomsg.cmake)

	if (${JANUS_DEPENDENCY_NANOMSG_USED})
		if (JANUS_TRANSPORT_NANOMSG)
			janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/transports/janus_nanomsg.c)
			janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.transport.nanomsg.jcfg.sample)
		endif (JANUS_TRANSPORT_NANOMSG)

		if (JANUS_HANDLER_NANOMSG)
			janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/events/janus_nanomsgevh.c)
			janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.eventhandler.nanomsgevh.jcfg.sample)
		endif (JANUS_HANDLER_NANOMSG)
	endif (${JANUS_DEPENDENCY_NANOMSG_USED})
endif (JANUS_TRANSPORT_NANOMSG OR JANUS_HANDLER_NANOMSG)

# GELF
if (JANUS_HANDLER_GELF)
	janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/events/janus_gelfevh.c)
	janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.eventhandler.gelfevh.jcfg.sample)
endif (JANUS_HANDLER_GELF)

# JSON LOGGER
if (JANUS_LOGGER_JSON)
	janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/loggers/janus_jsonlog.c)
	janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.logger.jsonlog.jcfg.sample)
endif (JANUS_LOGGER_JSON)

# JANUS_TRANSPORT_UNIX_SOCKETS
function(janus_check_unix_sockets)
	if (JANUS_TRANSPORT_UNIX_SOCKETS)
		check_c_source_compiles(
				"
			#include <stdlib.h>
               #include <sys/socket.h>
               #include <sys/un.h>
               void main() {
                 int pfd = socket(PF_UNIX, SOCK_SEQPACKET | SOCK_NONBLOCK, 0);
                 if(pfd < 0)
                   exit(1);
               }
			"

				has_unix_sockets
		)

		if (NOT ${has_unix_sockets})
			message(FATAL_ERROR "SOCK_SEQPACKET not defined in your OS. Set JANUS_TRANSPORT_UNIX_SOCKETS off")
		else ()
			janus_append_compile_definitions(HAVE_PFUNIX)

			janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/transports/janus_pfunix.c)
			janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.transport.pfunix.jcfg.sample)
		endif (NOT ${has_unix_sockets})
	endif (JANUS_TRANSPORT_UNIX_SOCKETS)
endfunction(janus_check_unix_sockets)
janus_check_unix_sockets()

# LIB_LIBSYSTEMD
if (JANUS_SYSTEMD_SOCKETS)
	include(${JANUS_3RD_PARTY_PATH}/libsystemd/libsystemd.cmake)
endif (JANUS_SYSTEMD_SOCKETS)

# LIB_OPUS
if (JANUS_PLUGIN_AUDIO_BRIDGE OR JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)
	set(JANUS_DEPENDENCY_OPUS_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/opus/opus.cmake)

	if (${JANUS_DEPENDENCY_OPUS_USED})
		janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_audiobridge.c)
		janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.audiobridge.jcfg.sample)
	endif (${JANUS_DEPENDENCY_OPUS_USED})
endif (JANUS_PLUGIN_AUDIO_BRIDGE OR JANUS_PLUGIN_AUDIO_BRIDGE_TRY_USE)

# LIB_DUKTAPE
# TODO: need .pc file
if (JANUS_PLUGIN_DUKTAPE OR JANUS_PLUGIN_DUKTAPE_TRY_USE)
	message(WARNING "FIXME DUKTAPE")

	#janus_append_extra_source_file(
	#		${JANUS_SOURCE_FILES_PATH}/plugins/janus_duktape.c
	#		${JANUS_SOURCE_FILES_PATH}/plugins/janus_duktape_extra.c
	#		${JANUS_SOURCE_FILES_PATH}/plugins/duktape-deps/duk_module_duktape.c
	#		${JANUS_SOURCE_FILES_PATH}/plugins/duktape-deps/duk_console.c

	#		${JANUS_HEADER_FILES_PATH}plugins/janus_duktape_data.h
	#		${JANUS_HEADER_FILES_PATH}plugins/janus_duktape_extra.h
	#		${JANUS_HEADER_FILES_PATH}plugins/duktape-deps/duk_module_duktape.h
	#		${JANUS_HEADER_FILES_PATH}plugins/duktape-deps/duk_console.h
	#)
	#janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.duktape.jcfg.sample)
endif (JANUS_PLUGIN_DUKTAPE OR JANUS_PLUGIN_DUKTAPE_TRY_USE)

if (JANUS_PLUGIN_ECHO_TEST)
	janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_recordplay.c)
	janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.recordplay.jcfg.sample)
endif (JANUS_PLUGIN_ECHO_TEST)

# LIB_LUA
if (JANUS_PLUGIN_LUA OR JANUS_PLUGIN_LUA_TRY_USE)
	set(JANUS_DEPENDENCY_LUA_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/lua/lua.cmake)

	if (${JANUS_DEPENDENCY_LUA_USED})
		janus_append_extra_source_file(
				${JANUS_SOURCE_FILES_PATH}/plugins/janus_lua.c
				${JANUS_SOURCE_FILES_PATH}/plugins/janus_lua_extra.c

				${JANUS_HEADER_FILES_PATH}/plugins/janus_lua_data.h
				${JANUS_HEADER_FILES_PATH}/plugins/janus_lua_extra.h
		)
		janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.lua.jcfg.sample)
	endif (${JANUS_DEPENDENCY_LUA_USED})
endif (JANUS_PLUGIN_LUA OR JANUS_PLUGIN_LUA_TRY_USE)

if (JANUS_PLUGIN_RECORD_PLAY)
	janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_echotest.c)
	janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.echotest.jcfg.sample)
endif (JANUS_PLUGIN_RECORD_PLAY)

# LIB_SOFIA-SIP-UA
if (JANUS_PLUGIN_SIP OR JANUS_PLUGIN_SIP_TRY_USE)
	set(JANUS_DEPENDENCY_SOFIA-SIP-UA_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/sofia-sip-ua/sofia-sip-ua.cmake)

	if (${JANUS_DEPENDENCY_SOFIA-SIP-UA_USED})
		janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_sip.c)
		janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.sip.jcfg.sample)
	endif (${JANUS_DEPENDENCY_SOFIA-SIP-UA_USED})
endif (JANUS_PLUGIN_SIP OR JANUS_PLUGIN_SIP_TRY_USE)

if (JANUS_PLUGIN_NO_SIP)
	janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_nosip.c)
	janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.nosip.jcfg.sample)
endif (JANUS_PLUGIN_NO_SIP)

if (JANUS_PLUGIN_STREAMING)
	janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_streaming.c)
	janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.streaming.jcfg.sample)
endif (JANUS_PLUGIN_STREAMING)

if (JANUS_PLUGIN_TEXT_ROOM)
	janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_textroom.c)
	janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.textroom.jcfg.sample)
endif (JANUS_PLUGIN_TEXT_ROOM)

if (JANUS_PLUGIN_VIDEO_CALL)
	janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_videocall.c)
	janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.videocall.jcfg.sample)
endif (JANUS_PLUGIN_VIDEO_CALL)

if (JANUS_PLUGIN_VIDEO_ROOM)
	janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_videoroom.c)
	janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.videoroom.jcfg.sample)
endif (JANUS_PLUGIN_VIDEO_ROOM)

# LIB_OGG
if (JANUS_PLUGIN_VOICE_MAIL OR JANUS_PLUGIN_VOICE_MAIL_TRY_USE)
	set(JANUS_DEPENDENCY_OGG_USED OFF)
	include(${JANUS_3RD_PARTY_PATH}/ogg/ogg.cmake)

	if (${JANUS_DEPENDENCY_OGG_USED})
		janus_append_extra_source_file(${JANUS_SOURCE_FILES_PATH}/plugins/janus_voicemail.c)
		janus_append_config_file(${JANUS_CONF_FILES_PATH}/janus.plugin.voicemail.jcfg.sample)
	endif (${JANUS_DEPENDENCY_OGG_USED})
endif (JANUS_PLUGIN_VOICE_MAIL OR JANUS_PLUGIN_VOICE_MAIL_TRY_USE)

# JS MODULE
if (JANUS_JS_MODULE_ES OR JANUS_JS_MODULE_UMD OR JANUS_JS_MODULE_IIFE OR JANUS_JS_MODULE_COMMON)
	find_program(NPM_EXE NAMES npm)

	if (NPM_EXE-NOTFOUND)
		message(FATAL_ERROR "npm not found.")
	endif (NPM_EXE-NOTFOUND)

	# TODO: check doxygen version here...
endif (JANUS_JS_MODULE_ES OR JANUS_JS_MODULE_UMD OR JANUS_JS_MODULE_IIFE OR JANUS_JS_MODULE_COMMON)

# Post-processing
if (JANUS_POST_PROCESSING)
	# include(${JANUS_3RD_PARTY_PATH}/glib/glib.cmake)
	# include(${JANUS_3RD_PARTY_PATH}/jansson/jansson.cmake)
	# include(${JANUS_3RD_PARTY_PATH}/libssl/libssl.cmake)
	# include(${JANUS_3RD_PARTY_PATH}/libcrypto/libcrypto.cmake)
	# include(${JANUS_3RD_PARTY_PATH}/zlib/zlib.cmake)
	# include(${JANUS_3RD_PARTY_PATH}/ogg/ogg.cmake)

	include(${JANUS_3RD_PARTY_PATH}/libav/libavutil.cmake)
	include(${JANUS_3RD_PARTY_PATH}/libav/libavcodec.cmake)
	include(${JANUS_3RD_PARTY_PATH}/libav/libavformat.cmake)
endif (JANUS_POST_PROCESSING)

# LIB_LIBPCAP
set(JANUS_ENABLE_PCAP2MJR OFF)
function(janus_check_libpcap)
	pkg_check_modules(LIB_LIBPCAP QUIET libpcap)

	if (${LIB_LIBPCAP_FOUND})
		janus_append_compile_definitions(HAVE_LIBPCAP)
		set(JANUS_ENABLE_PCAP2MJR ON PARENT_SCOPE)
	endif (${LIB_LIBPCAP_FOUND})
endfunction(janus_check_libpcap)
janus_check_libpcap()

# TODO: janus-pp-rec and mjr2pcap


# copy config file
file(MAKE_DIRECTORY ${JANUS_INSTALL_CONFIG_DIR})
foreach (file ${JANUS_CONF_FILES})
	file(RELATIVE_PATH relative_conf_file "${JANUS_CONF_FILES_PATH}" "${file}")

	# xxx.sample -> xxx
	string(REGEX REPLACE "^.*/(.*)[.]sample$" "//1" basename ${relative_conf_file})
	file(COPY_FILE ${file} ${JANUS_INSTALL_CONFIG_DIR}/${relative_conf_file})
	file(COPY_FILE ${file} ${JANUS_INSTALL_CONFIG_DIR}/${basename})
endforeach (file ${JANUS_CONF_FILES})
