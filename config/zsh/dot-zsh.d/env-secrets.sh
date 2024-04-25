cachetarget=${SHELL_CACHED_SECRETS_FILE:-${HOME}/.zsh.secrets.cached}
vault=${SHELL_CACHED_SECRETS_VAULT:-Private}
itemname=${SHELL_CACHED_SECRETS_ITEM:-ENV_VARS}

function _load_or_cache_secrets {
    if [ -e $cachetarget ] ; then
        if ! stat $cachetarget | grep '\-rw-------' &> /dev/null ; then
            echo "Incorrect permissions on cached secrets file"
        fi
        source $cachetarget
    elif [[ -o interactive ]] ; then
        if read -sqt5 "x?Download and cache secrets? " ; then
            op vault list --cache &> /dev/null
            SIGNED_IN=$?
            # TODO: A new session will never be signed in, how do?
            if [ ! $SIGNED_IN -eq 0 ]  ; then
                echo
                if read -sqt5 "x?Not signed into 1password, signin? " ; then
                    echo
                    eval $(op signin)
                    op vault list --cache &> /dev/null
                    SIGNED_IN=$?
                fi
            fi

            if [ $SIGNED_IN -eq 0 ] ; then
                touch $cachetarget
                chmod 600 $cachetarget
                op item get --cache --format json --vault $vault ${itemname} | jq -r '.fields | .[] |  select(.section) | "export " + .label + "=" + .value' > $cachetarget
                source $cachetarget
            else
                echo "Not signed into 1p."
            fi
        fi
    fi
}

function clear_env_secrets {
    rm $cachetarget
}

_load_or_cache_secrets
