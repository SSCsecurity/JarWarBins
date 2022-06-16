
set(pkgconf_INCLUDE_DIRS_RELEASE )
set(pkgconf_INCLUDE_DIR_RELEASE "")
set(pkgconf_INCLUDES_RELEASE )
set(pkgconf_RES_DIRS_RELEASE )
set(pkgconf_DEFINITIONS_RELEASE )
set(pkgconf_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(pkgconf_COMPILE_DEFINITIONS_RELEASE )
set(pkgconf_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(pkgconf_COMPILE_OPTIONS_C_RELEASE "")
set(pkgconf_COMPILE_OPTIONS_CXX_RELEASE "")
set(pkgconf_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(pkgconf_LIBRARIES_RELEASE "") # Will be filled later
set(pkgconf_LIBS_RELEASE "") # Same as pkgconf_LIBRARIES
set(pkgconf_SYSTEM_LIBS_RELEASE )
set(pkgconf_FRAMEWORK_DIRS_RELEASE )
set(pkgconf_FRAMEWORKS_RELEASE )
set(pkgconf_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(pkgconf_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(pkgconf_FRAMEWORKS_FOUND_RELEASE "${pkgconf_FRAMEWORKS_RELEASE}" "${pkgconf_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(pkgconf_INCLUDE_DIRS_RELEASE
                 pkgconf_INCLUDE_DIR_RELEASE
                 pkgconf_INCLUDES_RELEASE
                 pkgconf_DEFINITIONS_RELEASE
                 pkgconf_LINKER_FLAGS_RELEASE_LIST
                 pkgconf_COMPILE_DEFINITIONS_RELEASE
                 pkgconf_COMPILE_OPTIONS_RELEASE_LIST
                 pkgconf_LIBRARIES_RELEASE
                 pkgconf_LIBS_RELEASE
                 pkgconf_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to pkgconf_LIBS and pkgconf_LIBRARY_LIST
set(pkgconf_LIBRARY_LIST_RELEASE )
set(pkgconf_LIB_DIRS_RELEASE )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_pkgconf_DEPENDENCIES_RELEASE "${pkgconf_FRAMEWORKS_FOUND_RELEASE} ${pkgconf_SYSTEM_LIBS_RELEASE} ")

conan_package_library_targets("${pkgconf_LIBRARY_LIST_RELEASE}"  # libraries
                              "${pkgconf_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_pkgconf_DEPENDENCIES_RELEASE}"  # deps
                              pkgconf_LIBRARIES_RELEASE            # out_libraries
                              pkgconf_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "pkgconf")                                      # package_name

set(pkgconf_LIBS_RELEASE ${pkgconf_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${pkgconf_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND pkgconf_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND pkgconf_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${pkgconf_SYSTEM_LIBS_RELEASE})
    list(APPEND pkgconf_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND pkgconf_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(pkgconf_LIBRARIES_TARGETS_RELEASE "${pkgconf_LIBRARIES_TARGETS_RELEASE};")
set(pkgconf_LIBRARIES_RELEASE "${pkgconf_LIBRARIES_RELEASE};")

set(CMAKE_MODULE_PATH "/opt/.conan/data/pkgconf/1.7.4/_/_/package/24647d9fe8ec489125dfbae4b3ebefaf7581674c/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/opt/.conan/data/pkgconf/1.7.4/_/_/package/24647d9fe8ec489125dfbae4b3ebefaf7581674c/" ${CMAKE_PREFIX_PATH})
