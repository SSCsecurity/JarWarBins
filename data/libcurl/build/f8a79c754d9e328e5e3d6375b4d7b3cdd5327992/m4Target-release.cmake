
set(m4_INCLUDE_DIRS_RELEASE )
set(m4_INCLUDE_DIR_RELEASE "")
set(m4_INCLUDES_RELEASE )
set(m4_RES_DIRS_RELEASE )
set(m4_DEFINITIONS_RELEASE )
set(m4_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(m4_COMPILE_DEFINITIONS_RELEASE )
set(m4_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(m4_COMPILE_OPTIONS_C_RELEASE "")
set(m4_COMPILE_OPTIONS_CXX_RELEASE "")
set(m4_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(m4_LIBRARIES_RELEASE "") # Will be filled later
set(m4_LIBS_RELEASE "") # Same as m4_LIBRARIES
set(m4_SYSTEM_LIBS_RELEASE )
set(m4_FRAMEWORK_DIRS_RELEASE )
set(m4_FRAMEWORKS_RELEASE )
set(m4_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(m4_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(m4_FRAMEWORKS_FOUND_RELEASE "${m4_FRAMEWORKS_RELEASE}" "${m4_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(m4_INCLUDE_DIRS_RELEASE
                 m4_INCLUDE_DIR_RELEASE
                 m4_INCLUDES_RELEASE
                 m4_DEFINITIONS_RELEASE
                 m4_LINKER_FLAGS_RELEASE_LIST
                 m4_COMPILE_DEFINITIONS_RELEASE
                 m4_COMPILE_OPTIONS_RELEASE_LIST
                 m4_LIBRARIES_RELEASE
                 m4_LIBS_RELEASE
                 m4_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to m4_LIBS and m4_LIBRARY_LIST
set(m4_LIBRARY_LIST_RELEASE )
set(m4_LIB_DIRS_RELEASE )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_m4_DEPENDENCIES_RELEASE "${m4_FRAMEWORKS_FOUND_RELEASE} ${m4_SYSTEM_LIBS_RELEASE} ")

conan_package_library_targets("${m4_LIBRARY_LIST_RELEASE}"  # libraries
                              "${m4_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_m4_DEPENDENCIES_RELEASE}"  # deps
                              m4_LIBRARIES_RELEASE            # out_libraries
                              m4_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "m4")                                      # package_name

set(m4_LIBS_RELEASE ${m4_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${m4_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND m4_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND m4_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${m4_SYSTEM_LIBS_RELEASE})
    list(APPEND m4_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND m4_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(m4_LIBRARIES_TARGETS_RELEASE "${m4_LIBRARIES_TARGETS_RELEASE};")
set(m4_LIBRARIES_RELEASE "${m4_LIBRARIES_RELEASE};")

set(CMAKE_MODULE_PATH "/opt/.conan/data/m4/1.4.19/_/_/package/24647d9fe8ec489125dfbae4b3ebefaf7581674c/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/opt/.conan/data/m4/1.4.19/_/_/package/24647d9fe8ec489125dfbae4b3ebefaf7581674c/" ${CMAKE_PREFIX_PATH})
