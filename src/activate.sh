# Activations script for add the lwtk module to the lua path when
# building lwtk using the Makefile.
# Source this into interactive shell by invoking ". activates.sh" from this directory
# This is not necessary if lwtk is installed, e.g. via luarocks.

###################################################
if [ -n "$MSYSTEM" ]; then
###################################################
path_to_unix()
{
  cygpath -up $1
}

path_to_dos()
{
    cygpath -wp $1
}

so_ext=dll

###################################################
else
###################################################
path_to_unix()
{
    echo $1|sed 's/;/:/g'
}

path_to_dos()
{
    echo $1|sed 's/:/;/g'
}

so_ext=so

###################################################
fi
###################################################

this_dir=$(pwd)

lualwtk_dir=$(cd "$this_dir"/..; pwd)

if [ ! -e "$lualwtk_dir/src/activate.sh" -o ! -e "$lualwtk_dir/src/lwtk/init.lua" ]; then

    echo '**** ERROR: ". activate.sh" must be invoked from "src" directory ***'

else

    echo "Setting lua paths for: $lualwtk_dir"

    add_lua_path="$lualwtk_dir/src/?.lua:$lualwtk_dir/src/?/init.lua"
    add_lua_cpath="$lualwtk_dir/src/build"

    # unset LUA_PATH_5_4 LUA_CPATH_5_4 LUA_PATH_5_3 LUA_CPATH_5_3 LUA_PATH_5_2 LUA_CPATH_5_2 LUA_PATH LUA_CPATH

    default_version=""
    if which lua > /dev/null 2>&1; then
        default_version=$(lua -e 'v=_VERSION:gsub("^Lua ","");print(v)')
    fi
    
    if [ -n "$default_version" ]; then
        if [ "$default_version" != "5.1" ]; then
            echo "Setting path for lua (version=$default_version)"
            lua_path_vers=$(echo $default_version|sed 's/\./_/')
            eval "export LUA_PATH_$lua_path_vers=\"$(path_to_dos $add_lua_path:$(path_to_unix $(lua -e 'print(package.path)')))\""
            eval "export LUA_CPATH_$lua_path_vers=\"$(path_to_dos $add_lua_cpath/lua$default_version/?.$so_ext:$(path_to_unix $(lua -e 'print(package.cpath)')))\""
        fi
    fi

    for vers in 5.4 5.3 5.2 5.1; do
        lua_cmd=""
        if which lua$vers > /dev/null 2>&1; then
            lua_cmd="lua$vers"
        elif which lua-$vers > /dev/null 2>&1; then
            lua_cmd="lua-$vers"
        fi
        if [ -n "$lua_cmd" ]; then
            lua_version=$($lua_cmd -e 'v=_VERSION:gsub("^Lua ","");print(v)')
            if [ "$lua_version" != "$default_version" ]; then
                echo "Setting path for $lua_cmd (version=$lua_version)"
                if [ "$lua_version" = "5.1" ]; then
                    export LUA_PATH=$(path_to_dos "$add_lua_path:$(path_to_unix $($lua_cmd -e 'print(package.path)'))")
                    export LUA_CPATH=$(path_to_dos "$add_lua_cpath/lua5.1/?.$so_ext:$(path_to_unix $($lua_cmd -e 'print(package.cpath)'))")
                else
                    lua_path_vers=$(echo $lua_version|sed 's/\./_/')
                    eval "export LUA_PATH_$lua_path_vers=\"$(path_to_dos $add_lua_path:$(path_to_unix $($lua_cmd -e 'print(package.path)')))\""
                    eval "export LUA_CPATH_$lua_path_vers=\"$(path_to_dos $add_lua_cpath/lua$lua_version/?.$so_ext:$(path_to_unix $($lua_cmd -e 'print(package.cpath)')))\""
                fi
            fi
        fi
    done
    
    if [ -n "$default_version" ]; then
        if [ "$default_version" = "5.1" ]; then
            echo "Setting path for lua (version=$default_version)"
            export LUA_PATH="$(path_to_dos $add_lua_path:$(path_to_unix $(lua -e 'print(package.path)')))"
            export LUA_CPATH="$(path_to_dos $add_lua_cpath/lua5.1/?.$so_ext:$(path_to_unix $(lua -e 'print(package.cpath)')))"
        fi
    fi
fi

unset lua_cmd this_dir lualwtk_dir add_lua_path add_lua_cpath lua_version lua_path_vers vers default_version \
      path_to_unix path_to_dos so_ext

