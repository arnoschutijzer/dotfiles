#!/bin/zsh

# Settings
mise settings unset idiomatic_version_file_enable_tools
mise settings add idiomatic_version_file_enable_tools node
mise settings add idiomatic_version_file_enable_tools terraform
mise settings add idiomatic_version_file_enable_tools java
mise settings set auto_install true

# Global tools
mise use --global node@22
mise use --global java@17
mise use --global maven@3
mise use --global terraform@1.14.7
