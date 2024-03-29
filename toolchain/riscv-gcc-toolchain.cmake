if(NOT TOOLCHAIN_PREFIX)
    SET(TOOLCHAIN_PREFIX "/usr")
    MESSAGE(STATUS "No TOOLCHAIN_PREFIX specified, using default: " ${TOOLCHAIN_PREFIX})
endif()

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}/bin/riscv-none-elf-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}/bin/riscv-none-elf-g++)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}/bin/riscv-none-elf-gcc)
set(CMAKE_AR ${TOOLCHAIN_PREFIX}/bin/riscv-none-elf-ar)
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}/bin/riscv-none-elf-objcopy)
set(CMAKE_OBJDUMP ${TOOLCHAIN_PREFIX}/bin/riscv-none-elf-objdump)
set(SIZE ${TOOLCHAIN_PREFIX}/bin/riscv-none-elf-size)

add_compile_options(-march=rv32imac -mabi=ilp32)
add_compile_options(-ffunction-sections -fdata-sections -fno-common -fmessage-length=0)
add_compile_options($<$<COMPILE_LANGUAGE:ASM>:-x$<SEMICOLON>assembler-with-cpp>)

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    message(STATUS "Maximum optimization for speed")
    add_compile_options(-Ofast)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    message(STATUS "Maximum optimization for speed, debug info included")
    add_compile_options(-Ofast -g)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    message(STATUS "Maximum optimization for size")
    add_compile_options(-Os)
else ()
    message(STATUS "Minimal optimization, debug info included")
    add_compile_options(-Og -g)
endif ()

add_link_options(-Wl,-gc-sections,--print-memory-usage,-Map=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map)
add_link_options(-march=rv32imac -mabi=ilp32 -nostartfiles)
add_link_options(-T ${LINKER_SCRIPT})