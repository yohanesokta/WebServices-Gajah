cmake_minimum_required(VERSION 3.15)
set(CMAKE_C_COMPILER gcc)

project(sed C)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_executable(sed sed_utils.c)
add_executable(winproc_scan win_proc_scanner.c)