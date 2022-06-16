
set(automake_INCLUDE_DIRS_RELEASE )
set(automake_INCLUDE_DIR_RELEASE "")
set(automake_INCLUDES_RELEASE )
set(automake_RES_DIRS_RELEASE "/opt/.conan/data/automake/1.16.5/_/_/package/6b8c0d8c1a3bf5599cac08c84e874bdb5f2c2329/res")
set(automake_DEFINITIONS_RELEASE )
set(automake_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(automake_COMPILE_DEFINITIONS_RELEASE )
set(automake_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(automake_COMPILE_OPTIONS_C_RELEASE "")
set(automake_COMPILE_OPTIONS_CXX_RELEASE "")
set(automake_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(automake_LIBRARIES_RELEASE "") # Will be filled later
set(automake_LIBS_RELEASE "") # Same as automake_LIBRARIES
set(automake_SYSTEM_LIBS_RELEASE )
set(automake_FRAMEWORK_DIRS_RELEASE )
set(automake_FRAMEWORKS_RELEASE )
set(automake_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(automake_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(automake_FRAMEWORKS_FOUND_RELEASE "${automake_FRAMEWORKS_RELEASE}" "${automake_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(automake_INCLUDE_DIRS_RELEASE
                 automake_INCLUDE_DIR_RELEASE
                 automake_INCLUDES_RELEASE
                 automake_DEFINITIONS_RELEASE
                 automake_LINKER_FLAGS_RELEASE_LIST
                 automake_COMPILE_DEFINITIONS_RELEASE
                 automake_COMPILE_OPTIONS_RELEASE_LIST
                 automake_LIBRARIES_RELEASE
                 automake_LIBS_RELEASE
                 automake_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to automake_LIBS and automake_LIBRARY_LIST
set(automake_LIBRARY_LIST_RELEASE )
set(automake_LIB_DIRS_RELEASE )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_automake_DEPENDENCIES_RELEASE "${automake_FRAMEWORKS_FOUND_RELEASE} ${automake_SYSTEM_LIBS_RELEASE} autoconf::autoconf")

conan_package_library_targets("${automake_LIBRARY_LIST_RELEASE}"  # libraries
                              "${automake_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_automake_DEPENDENCIES_RELEASE}"  # deps
                              automake_LIBRARIES_RELEASE            # out_libraries
                              automake_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "automake")                                      # package_name

set(automake_LIBS_RELEASE ${automake_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${automake_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND automake_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND automake_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${automake_SYSTEM_LIBS_RELEASE})
    list(APPEND automake_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND automake_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(automake_LIBRARIES_TARGETS_RELEASE "${automake_LIBRARIES_TARGETS_RELEASE};autoconf::autoconf")
set(automake_LIBRARIES_RELEASE "${automake_LIBRARIES_RELEASE};autoconf::autoconf")

set(CMAKE_MODULE_PATH "/opt/.conan/data/automake/1.16.5/_/_/package/6b8c0d8c1a3bf5599cac08c84e874bdb5f2c2329/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/opt/.conan/data/automake/1.16.5/_/_/package/6b8c0d8c1a3bf5599cac08c84e874bdb5f2c2329/" ${CMAKE_PREFIX_PATH})
