
set(autoconf_INCLUDE_DIRS_RELEASE )
set(autoconf_INCLUDE_DIR_RELEASE "")
set(autoconf_INCLUDES_RELEASE )
set(autoconf_RES_DIRS_RELEASE )
set(autoconf_DEFINITIONS_RELEASE )
set(autoconf_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(autoconf_COMPILE_DEFINITIONS_RELEASE )
set(autoconf_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(autoconf_COMPILE_OPTIONS_C_RELEASE "")
set(autoconf_COMPILE_OPTIONS_CXX_RELEASE "")
set(autoconf_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(autoconf_LIBRARIES_RELEASE "") # Will be filled later
set(autoconf_LIBS_RELEASE "") # Same as autoconf_LIBRARIES
set(autoconf_SYSTEM_LIBS_RELEASE )
set(autoconf_FRAMEWORK_DIRS_RELEASE )
set(autoconf_FRAMEWORKS_RELEASE )
set(autoconf_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(autoconf_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(autoconf_FRAMEWORKS_FOUND_RELEASE "${autoconf_FRAMEWORKS_RELEASE}" "${autoconf_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(autoconf_INCLUDE_DIRS_RELEASE
                 autoconf_INCLUDE_DIR_RELEASE
                 autoconf_INCLUDES_RELEASE
                 autoconf_DEFINITIONS_RELEASE
                 autoconf_LINKER_FLAGS_RELEASE_LIST
                 autoconf_COMPILE_DEFINITIONS_RELEASE
                 autoconf_COMPILE_OPTIONS_RELEASE_LIST
                 autoconf_LIBRARIES_RELEASE
                 autoconf_LIBS_RELEASE
                 autoconf_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to autoconf_LIBS and autoconf_LIBRARY_LIST
set(autoconf_LIBRARY_LIST_RELEASE )
set(autoconf_LIB_DIRS_RELEASE )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_autoconf_DEPENDENCIES_RELEASE "${autoconf_FRAMEWORKS_FOUND_RELEASE} ${autoconf_SYSTEM_LIBS_RELEASE} m4::m4")

conan_package_library_targets("${autoconf_LIBRARY_LIST_RELEASE}"  # libraries
                              "${autoconf_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_autoconf_DEPENDENCIES_RELEASE}"  # deps
                              autoconf_LIBRARIES_RELEASE            # out_libraries
                              autoconf_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "autoconf")                                      # package_name

set(autoconf_LIBS_RELEASE ${autoconf_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${autoconf_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND autoconf_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND autoconf_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${autoconf_SYSTEM_LIBS_RELEASE})
    list(APPEND autoconf_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND autoconf_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(autoconf_LIBRARIES_TARGETS_RELEASE "${autoconf_LIBRARIES_TARGETS_RELEASE};m4::m4")
set(autoconf_LIBRARIES_RELEASE "${autoconf_LIBRARIES_RELEASE};m4::m4")

set(CMAKE_MODULE_PATH "/opt/.conan/data/autoconf/2.71/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/opt/.conan/data/autoconf/2.71/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})
