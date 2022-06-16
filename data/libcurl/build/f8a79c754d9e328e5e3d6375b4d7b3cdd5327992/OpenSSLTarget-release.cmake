########## MACROS ###########################################################################
#############################################################################################


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAME ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAME ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


########### VARIABLES #######################################################################
#############################################################################################


set(OpenSSL_INCLUDE_DIRS_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/include")
set(OpenSSL_INCLUDE_DIR_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/include")
set(OpenSSL_INCLUDES_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/include")
set(OpenSSL_RES_DIRS_RELEASE )
set(OpenSSL_DEFINITIONS_RELEASE )
set(OpenSSL_LINKER_FLAGS_RELEASE_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(OpenSSL_COMPILE_DEFINITIONS_RELEASE )
set(OpenSSL_COMPILE_OPTIONS_RELEASE_LIST "" "")
set(OpenSSL_COMPILE_OPTIONS_C_RELEASE "")
set(OpenSSL_COMPILE_OPTIONS_CXX_RELEASE "")
set(OpenSSL_LIBRARIES_TARGETS_RELEASE "") # Will be filled later, if CMake 3
set(OpenSSL_LIBRARIES_RELEASE "") # Will be filled later
set(OpenSSL_LIBS_RELEASE "") # Same as OpenSSL_LIBRARIES
set(OpenSSL_SYSTEM_LIBS_RELEASE dl pthread rt)
set(OpenSSL_FRAMEWORK_DIRS_RELEASE )
set(OpenSSL_FRAMEWORKS_RELEASE )
set(OpenSSL_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
set(OpenSSL_BUILD_MODULES_PATHS_RELEASE )

conan_find_apple_frameworks(OpenSSL_FRAMEWORKS_FOUND_RELEASE "${OpenSSL_FRAMEWORKS_RELEASE}" "${OpenSSL_FRAMEWORK_DIRS_RELEASE}")

mark_as_advanced(OpenSSL_INCLUDE_DIRS_RELEASE
                 OpenSSL_INCLUDE_DIR_RELEASE
                 OpenSSL_INCLUDES_RELEASE
                 OpenSSL_DEFINITIONS_RELEASE
                 OpenSSL_LINKER_FLAGS_RELEASE_LIST
                 OpenSSL_COMPILE_DEFINITIONS_RELEASE
                 OpenSSL_COMPILE_OPTIONS_RELEASE_LIST
                 OpenSSL_LIBRARIES_RELEASE
                 OpenSSL_LIBS_RELEASE
                 OpenSSL_LIBRARIES_TARGETS_RELEASE)

# Find the real .lib/.a and add them to OpenSSL_LIBS and OpenSSL_LIBRARY_LIST
set(OpenSSL_LIBRARY_LIST_RELEASE ssl crypto)
set(OpenSSL_LIB_DIRS_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_OpenSSL_DEPENDENCIES_RELEASE "${OpenSSL_FRAMEWORKS_FOUND_RELEASE} ${OpenSSL_SYSTEM_LIBS_RELEASE} ZLIB::ZLIB")

conan_package_library_targets("${OpenSSL_LIBRARY_LIST_RELEASE}"  # libraries
                              "${OpenSSL_LIB_DIRS_RELEASE}"      # package_libdir
                              "${_OpenSSL_DEPENDENCIES_RELEASE}"  # deps
                              OpenSSL_LIBRARIES_RELEASE            # out_libraries
                              OpenSSL_LIBRARIES_TARGETS_RELEASE    # out_libraries_targets
                              "_RELEASE"                          # build_type
                              "OpenSSL")                                      # package_name

set(OpenSSL_LIBS_RELEASE ${OpenSSL_LIBRARIES_RELEASE})

foreach(_FRAMEWORK ${OpenSSL_FRAMEWORKS_FOUND_RELEASE})
    list(APPEND OpenSSL_LIBRARIES_TARGETS_RELEASE ${_FRAMEWORK})
    list(APPEND OpenSSL_LIBRARIES_RELEASE ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${OpenSSL_SYSTEM_LIBS_RELEASE})
    list(APPEND OpenSSL_LIBRARIES_TARGETS_RELEASE ${_SYSTEM_LIB})
    list(APPEND OpenSSL_LIBRARIES_RELEASE ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(OpenSSL_LIBRARIES_TARGETS_RELEASE "${OpenSSL_LIBRARIES_TARGETS_RELEASE};ZLIB::ZLIB")
set(OpenSSL_LIBRARIES_RELEASE "${OpenSSL_LIBRARIES_RELEASE};ZLIB::ZLIB")

set(CMAKE_MODULE_PATH "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/"
			"/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/lib/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/"
			"/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/lib/cmake" ${CMAKE_PREFIX_PATH})

set(OpenSSL_COMPONENTS_RELEASE OpenSSL::SSL OpenSSL::Crypto)

########### COMPONENT Crypto VARIABLES #############################################

set(OpenSSL_Crypto_INCLUDE_DIRS_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/include")
set(OpenSSL_Crypto_INCLUDE_DIR_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/include")
set(OpenSSL_Crypto_INCLUDES_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/include")
set(OpenSSL_Crypto_LIB_DIRS_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/lib")
set(OpenSSL_Crypto_RES_DIRS_RELEASE )
set(OpenSSL_Crypto_DEFINITIONS_RELEASE )
set(OpenSSL_Crypto_COMPILE_DEFINITIONS_RELEASE )
set(OpenSSL_Crypto_COMPILE_OPTIONS_C_RELEASE "")
set(OpenSSL_Crypto_COMPILE_OPTIONS_CXX_RELEASE "")
set(OpenSSL_Crypto_LIBS_RELEASE crypto)
set(OpenSSL_Crypto_SYSTEM_LIBS_RELEASE dl rt pthread)
set(OpenSSL_Crypto_FRAMEWORK_DIRS_RELEASE )
set(OpenSSL_Crypto_FRAMEWORKS_RELEASE )
set(OpenSSL_Crypto_BUILD_MODULES_PATHS_RELEASE )
set(OpenSSL_Crypto_DEPENDENCIES_RELEASE ZLIB::ZLIB)
set(OpenSSL_Crypto_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT Crypto FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(OpenSSL_Crypto_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(OpenSSL_Crypto_FRAMEWORKS_FOUND_RELEASE "${OpenSSL_Crypto_FRAMEWORKS_RELEASE}" "${OpenSSL_Crypto_FRAMEWORK_DIRS_RELEASE}")

set(OpenSSL_Crypto_LIB_TARGETS_RELEASE "")
set(OpenSSL_Crypto_NOT_USED_RELEASE "")
set(OpenSSL_Crypto_LIBS_FRAMEWORKS_DEPS_RELEASE ${OpenSSL_Crypto_FRAMEWORKS_FOUND_RELEASE} ${OpenSSL_Crypto_SYSTEM_LIBS_RELEASE} ${OpenSSL_Crypto_DEPENDENCIES_RELEASE})
conan_package_library_targets("${OpenSSL_Crypto_LIBS_RELEASE}"
                              "${OpenSSL_Crypto_LIB_DIRS_RELEASE}"
                              "${OpenSSL_Crypto_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              OpenSSL_Crypto_NOT_USED_RELEASE
                              OpenSSL_Crypto_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "OpenSSL_Crypto")

set(OpenSSL_Crypto_LINK_LIBS_RELEASE ${OpenSSL_Crypto_LIB_TARGETS_RELEASE} ${OpenSSL_Crypto_LIBS_FRAMEWORKS_DEPS_RELEASE})

########### COMPONENT SSL VARIABLES #############################################

set(OpenSSL_SSL_INCLUDE_DIRS_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/include")
set(OpenSSL_SSL_INCLUDE_DIR_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/include")
set(OpenSSL_SSL_INCLUDES_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/include")
set(OpenSSL_SSL_LIB_DIRS_RELEASE "/opt/.conan/data/openssl/3.0.3/_/_/package/5ccd87090512901ae7a8c18837500511698efed7/lib")
set(OpenSSL_SSL_RES_DIRS_RELEASE )
set(OpenSSL_SSL_DEFINITIONS_RELEASE )
set(OpenSSL_SSL_COMPILE_DEFINITIONS_RELEASE )
set(OpenSSL_SSL_COMPILE_OPTIONS_C_RELEASE "")
set(OpenSSL_SSL_COMPILE_OPTIONS_CXX_RELEASE "")
set(OpenSSL_SSL_LIBS_RELEASE ssl)
set(OpenSSL_SSL_SYSTEM_LIBS_RELEASE dl pthread)
set(OpenSSL_SSL_FRAMEWORK_DIRS_RELEASE )
set(OpenSSL_SSL_FRAMEWORKS_RELEASE )
set(OpenSSL_SSL_BUILD_MODULES_PATHS_RELEASE )
set(OpenSSL_SSL_DEPENDENCIES_RELEASE OpenSSL::Crypto)
set(OpenSSL_SSL_LINKER_FLAGS_LIST_RELEASE
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>
        $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>
)

########## COMPONENT SSL FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(OpenSSL_SSL_FRAMEWORKS_FOUND_RELEASE "")
conan_find_apple_frameworks(OpenSSL_SSL_FRAMEWORKS_FOUND_RELEASE "${OpenSSL_SSL_FRAMEWORKS_RELEASE}" "${OpenSSL_SSL_FRAMEWORK_DIRS_RELEASE}")

set(OpenSSL_SSL_LIB_TARGETS_RELEASE "")
set(OpenSSL_SSL_NOT_USED_RELEASE "")
set(OpenSSL_SSL_LIBS_FRAMEWORKS_DEPS_RELEASE ${OpenSSL_SSL_FRAMEWORKS_FOUND_RELEASE} ${OpenSSL_SSL_SYSTEM_LIBS_RELEASE} ${OpenSSL_SSL_DEPENDENCIES_RELEASE})
conan_package_library_targets("${OpenSSL_SSL_LIBS_RELEASE}"
                              "${OpenSSL_SSL_LIB_DIRS_RELEASE}"
                              "${OpenSSL_SSL_LIBS_FRAMEWORKS_DEPS_RELEASE}"
                              OpenSSL_SSL_NOT_USED_RELEASE
                              OpenSSL_SSL_LIB_TARGETS_RELEASE
                              "RELEASE"
                              "OpenSSL_SSL")

set(OpenSSL_SSL_LINK_LIBS_RELEASE ${OpenSSL_SSL_LIB_TARGETS_RELEASE} ${OpenSSL_SSL_LIBS_FRAMEWORKS_DEPS_RELEASE})