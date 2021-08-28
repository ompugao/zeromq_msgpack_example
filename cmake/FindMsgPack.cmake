set(PKG_CONFIG_USE_CMAKE_PREFIX_PATH ON)
find_path(MSGPACK_INCLUDE_DIR msgpack.hpp
        PATHS /usr/local/include /usr/include)

# find_library(MSGPACK_LIBRARY
#         NAMES msgpack
#         PATHS /usr/local/lib /usr/lib)

if(MSGPACK_LIBRARY)
    set(MSGPACK_FOUND ON)
endif()

set ( MSGPACK_LIBRARIES ${MSGPACK_LIBRARY} )
set ( MSGPACK_INCLUDE_DIRS ${MSGPACK_INCLUDE_DIR} )

include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set ZMQ_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args ( MSGPACK DEFAULT_MSG MSGPACK_LIBRARIES ZeroMQ_INCLUDE_DIRS )

