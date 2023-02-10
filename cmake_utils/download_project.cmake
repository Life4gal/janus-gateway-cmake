function(download_project)
	set(archive_version ${PROJECT_VERSION})
	set(archive_name janus-gateway)
	set(archive_name_with_postfix ${archive_name}-${archive_version}.zip)

	set(archive_url ${PROJECT_HOMEPAGE_URL}/archive/refs/tags/v${archive_version}.zip)

	set(dest_path ${CMAKE_BINARY_DIR}/temp_project_download)
	file(MAKE_DIRECTORY ${dest_path})

	set(dest_folder ${dest_path}/${archive_name}-${archive_version})
	set(dest_archive ${dest_path}/${archive_name_with_postfix})

	# download
	if (NOT EXISTS ${dest_archive})
		message(STATUS "The file ${archive_name_with_postfix} is not exists, downloading...(dest: ${dest_archive})")

		# download
		file(
				DOWNLOAD
				${archive_url}
				${dest_archive}
				SHOW_PROGRESS
				STATUS download_result
		)

		list(GET download_result 0 download_error_code)
		list(GET download_result 1 download_error_string)
		if (NOT download_error_code EQUAL 0)
			if (EXISTS ${dest_archive})
				file(REMOVE ${dest_archive})
			endif (EXISTS ${dest_archive})

			message(FATAL_ERROR "Cannot download ${archive_name_with_postfix} ! --> ${download_error_string}")
		endif (NOT download_error_code EQUAL 0)
	else ()
		message(STATUS "The archive ${archive_name_with_postfix} is exists(${dest_archive}), no need to download...")
	endif (NOT EXISTS ${dest_archive})

	# extract
	message(STATUS "Extracting archive ${dest_archive} to ${dest_path}...")
	if (NOT EXISTS ${dest_folder})
		file(
				ARCHIVE_EXTRACT
				INPUT ${dest_archive}
				DESTINATION ${dest_path}
		)
	else ()
		message(STATUS "The target folder(${dest_folder}) already exists, no need to extract archive. (Please delete the original folder if you need to update)")
		return()
	endif (NOT EXISTS ${dest_folder})

	function(copy_verbose_message message)
		# message(${message})
		message(VERBOSE ${message})
	endfunction(copy_verbose_message message)

	# =============================================
	# COPY
	# =============================================

	# TODO: How do we notify `prepare_header_path.cmake` to reprocess all files if a user deletes the folder and wants us to update all source files?
	set(JANUS_PROJECT_FILES_RECOPY_FROM_SOURCE ON CACHE INTERNAL "Indicates that the current source file has been overwritten and that the necessary processing needs to be done again." FORCE)

	# =============================================
	# HEADERS & SOURCES & PLUGINS
	# =============================================

	set(source_file_path ${dest_folder}/src)
	message(STATUS "Copying files from ${source_file_path} to ${JANUS_HEADER_FILES_PATH} and ${JANUS_SOURCE_FILES_PATH}...")

	file(
			GLOB_RECURSE
			HEADER_FILES
			CONFIGURE_DEPENDS

			${source_file_path}/*.h
	)
	copy_verbose_message("The header files to be copied: ${HEADER_FILES}")

	file(
			GLOB_RECURSE
			SOURCE_FILES
			CONFIGURE_DEPENDS

			${source_file_path}/*.c
	)
	copy_verbose_message("The source files to be copied: ${SOURCE_FILES}")

	# plugin data files
	file(
			GLOB_RECURSE
			PLUGIN_DATA_FILES
			CONFIGURE_DEPENDS

			${source_file_path}/plugins/*.*
	)
	list(FILTER PLUGIN_DATA_FILES EXCLUDE REGEX "^.*[.][h|c]$")

	foreach (header_file IN LISTS HEADER_FILES)
		file(RELATIVE_PATH relative_header_file ${source_file_path} ${header_file})

		copy_verbose_message("Copying file from [${header_file}] to [${JANUS_HEADER_FILES_PATH}/${relative_header_file}]...")
		configure_file(
				${header_file}
				${JANUS_HEADER_FILES_PATH}/${relative_header_file}
				COPYONLY
		)
	endforeach (header_file IN LISTS HEADER_FILES)

	foreach (source_file IN LISTS SOURCE_FILES)
		file(RELATIVE_PATH relative_source_file ${source_file_path} ${source_file})

		copy_verbose_message("Copying file from [${source_file}] to [${JANUS_SOURCE_FILES_PATH}/${relative_source_file}]...")
		configure_file(
				${source_file}
				${JANUS_SOURCE_FILES_PATH}/${relative_source_file}
				COPYONLY
		)
	endforeach (source_file IN LISTS SOURCE_FILES)

	foreach (plugin_data_file IN LISTS PLUGIN_DATA_FILES)
		file(RELATIVE_PATH relative_plugin_data_file ${source_file_path} ${plugin_data_file})

		copy_verbose_message("Copying file from [${plugin_data_file}] to [${JANUS_SOURCE_FILES_PATH}/${relative_plugin_data_file}]...")
		configure_file(
				${plugin_data_file}
				${JANUS_SOURCE_FILES_PATH}/${relative_plugin_data_file}
				COPYONLY
		)
	endforeach (plugin_data_file IN LISTS PLUGIN_DATA_FILES)

	# =============================================
	# CONFIGS
	# =============================================

	set(conf_file_path ${dest_folder}/conf)
	message(STATUS "Copying files from ${conf_file_path} to ${JANUS_CONF_FILES_PATH}...")

	file(
			GLOB_RECURSE
			CONF_FILES
			CONFIGURE_DEPENDS

			${conf_file_path}/*.*
	)
	copy_verbose_message("The config files to be copied: ${CONF_FILES}")

	foreach (conf_file IN LISTS CONF_FILES)
		file(RELATIVE_PATH relative_conf_file ${conf_file_path} ${conf_file})

		string(REGEX MATCH "^(.*).in$" file_is_in ${relative_conf_file})
		if (file_is_in)
			# message("0: [${CMAKE_MATCH_0}] | 1: [${CMAKE_MATCH_1}] | 2: [${CMAKE_MATCH_2}]")
			set(real_conf_file ${CMAKE_MATCH_1})

			# TODO: The file `janus.jcfg.sample.in` does not seem to be read correctly. Line `"[\x1b[32mjanus\x1b[0m] " would show a green "janus"` and everything after it is treated as the same line.
			if (${real_conf_file} MATCHES "janus.jcfg.sample")
				# Consider the entire file content as a string.
				file(STRINGS ${conf_file} file_content NEWLINE_CONSUME)

				string(REPLACE "@confdir@" "${JANUS_INSTALL_CONFIG_DIR}" file_content "${file_content}")
				string(REPLACE "@demosdir@" "${JANUS_INSTALL_DEMOS_DIR}" file_content "${file_content}")
				string(REPLACE "@plugindir@" "${JANUS_INSTALL_PLUGIN_DIR}" file_content "${file_content}")
				string(REPLACE "@transportdir@" "${JANUS_INSTALL_TRANSPORT_DIR}" file_content "${file_content}")
				string(REPLACE "@eventdir@" "${JANUS_INSTALL_EVENT_DIR}" file_content "${file_content}")
				string(REPLACE "@loggerdir@" "${JANUS_INSTALL_LOGGER_DIR}" file_content "${file_content}")
				string(REPLACE "@streamdir@" "${JANUS_INSTALL_STREAM_DIR}" file_content "${file_content}")
				string(REPLACE "@recordingsdir@" "${JANUS_INSTALL_RECORDING_DIR}" file_content "${file_content}")
				string(REPLACE "@luadir@" "${JANUS_INSTALL_LUA_DIR}" file_content "${file_content}")
				string(REPLACE "@duktapedir@" "${JANUS_INSTALL_DUKTAPE_DIR}" file_content "${file_content}")

				file(WRITE ${conf_file} ${file_content})

				# copy real file
				copy_verbose_message("Copying file from [${conf_file}] to [${JANUS_CONF_FILES_PATH}/${real_conf_file}]...")
				configure_file(
						${conf_file}
						${JANUS_CONF_FILES_PATH}/${real_conf_file}
						COPYONLY
				)

				continue()
			endif (${real_conf_file} MATCHES "janus.jcfg.sample")

			# generate temp file for write
			set(temp_file_path "${conf_file_path}/${real_conf_file}.generated")
			file(WRITE ${temp_file_path})

			# read content
			file(STRINGS ${conf_file} file_content)

			# @*dir@ --> real path
			foreach (line IN LISTS file_content)
				string(REGEX MATCH "^[^@]*@([^@]*)@.*$" this_line_matched "${line}")
				if (this_line_matched)
					# message("0: [${CMAKE_MATCH_0}] | 1: [${CMAKE_MATCH_1}] | 2: [${CMAKE_MATCH_2}]")
					set(this_line_placeholder ${CMAKE_MATCH_1})

					if (${this_line_placeholder} MATCHES "confdir")
						set(REAL_PATH ${JANUS_INSTALL_CONFIG_DIR})
					elseif (${this_line_placeholder} MATCHES "demosdir")
						set(REAL_PATH ${JANUS_INSTALL_DEMOS_DIR})
					elseif (${this_line_placeholder} MATCHES "plugindir")
						set(REAL_PATH ${JANUS_INSTALL_PLUGIN_DIR})
					elseif (${this_line_placeholder} MATCHES "transportdir")
						set(REAL_PATH ${JANUS_INSTALL_TRANSPORT_DIR})
					elseif (${this_line_placeholder} MATCHES "eventdir")
						set(REAL_PATH ${JANUS_INSTALL_EVENT_DIR})
					elseif (${this_line_placeholder} MATCHES "loggerdir")
						set(REAL_PATH ${JANUS_INSTALL_LOGGER_DIR})
					elseif (${this_line_placeholder} MATCHES "streamdir")
						set(REAL_PATH ${JANUS_INSTALL_STREAM_DIR})
					elseif (${this_line_placeholder} MATCHES "recordingsdir")
						set(REAL_PATH ${JANUS_INSTALL_RECORDING_DIR})
					elseif (${this_line_placeholder} MATCHES "luadir")
						set(REAL_PATH ${JANUS_INSTALL_LUA_DIR})
					elseif (${this_line_placeholder} MATCHES "duktapedir")
						set(REAL_PATH ${JANUS_INSTALL_DUKTAPE_DIR})
					else ()
						# remove folder for next generation.
						file(REMOVE_RECURSE ${dest_folder})
						message(FATAL_ERROR "FIXME: unknown placeholder --> [${this_line_placeholder}] at line [${line}] in file [${relative_conf_file}]")
					endif (${this_line_placeholder} MATCHES "confdir")

					string(REGEX REPLACE "^([^@]*)@([^@]*)@(.*)$" "\\1${REAL_PATH}\\3" out_line "${line}")

					file(APPEND ${temp_file_path} "${out_line}\n")
				else ()
					# just append
					file(APPEND ${temp_file_path} "${line}\n")
				endif (this_line_matched)
			endforeach (line IN LISTS file_content)

			# replace original file
			# note: Here we need to replace the original configuration file,
			#   and then use configure_file to make it establish dependencies,
			#   so that once the original configuration file changes,
			#   the copied past configuration file will also change accordingly.
			file(RENAME ${temp_file_path} ${conf_file})

			# copy real file
			copy_verbose_message("Copying file from [${conf_file}] to [${JANUS_CONF_FILES_PATH}/${real_conf_file}]...")
			configure_file(
					${conf_file}
					${JANUS_CONF_FILES_PATH}/${real_conf_file}
					COPYONLY
			)
		else ()
			copy_verbose_message("Copying file from [${conf_file}] to [${JANUS_CONF_FILES_PATH}/${relative_conf_file}]...")
			configure_file(
					${conf_file}
					${JANUS_CONF_FILES_PATH}/${relative_conf_file}
					COPYONLY
			)
		endif (file_is_in)
	endforeach (conf_file IN LISTS CONF_FILES)

	# =============================================
	# DEMO
	# =============================================

	set(html_file_path ${dest_folder}/html)
	message(STATUS "Copying files from ${html_file_path} to ${JANUS_INSTALL_DEMOS_DIR}...")

	# demo files
	file(
			GLOB_RECURSE
			DEMO_FILES
			CONFIGURE_DEPENDS

			${html_file_path}/*.*
	)
	foreach (demo_file IN LISTS DEMO_FILES)
		file(RELATIVE_PATH relative_demo_file ${html_file_path} ${demo_file})

		copy_verbose_message("Copying file from [${demo_file}] to [${JANUS_INSTALL_DEMOS_DIR}/${relative_demo_file}]...")
		configure_file(
				${demo_file}
				${JANUS_INSTALL_DEMOS_DIR}/${relative_demo_file}
				COPYONLY
		)
	endforeach (demo_file IN LISTS DEMO_FILES)

endfunction(download_project)

download_project()
