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

	# copy files
	set(source_file_path ${dest_folder}/src)
	message(STATUS "Copying files from ${source_file_path} to ${JANUS_HEADER_FILES_PATH}/${JANUS_SOURCE_FILES_PATH}...")

	function(copy_verbose_message message)
		# message(${message})
		message(VERBOSE ${message})
	endfunction(copy_verbose_message message)

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
endfunction(download_project)

download_project()
