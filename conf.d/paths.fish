function elem --argument-names value seperator
        set -e argv[1]
        set -e argv[1]
        set -l env_var $argv
        for ii in (echo $env_var | tr $seperator '\n')
                if test $ii = value
                        return 1
                end
        end

        return 0
end

if test -z "$paths_config"
    set -l config_home "$XDG_CONFIG_HOME"

    if test -z "$config_home"
        set config_home ~/.config
    end

    set -gx paths_config "$config_home/fish/paths.d"

    if test ! -d "$paths_config"
        command mkdir -p "$paths_config"
    end
end

switch "$FISH_VERSION"
################### TO BE DEPRECATED ###################
    case 2.2.0
        for file in "$paths_config"/*
            if test -d "$file"
                set -l name (command basename "$file")

                for file in "$file"/*
                    read -laz values < $file
                    set -gx $name $$name $values
                end

            else if test -f "$file"
                set -l name (command basename "$file")
                read -laz values < $file
                set -gx $name $values
            end
        end
################### TO BE DEPRECATED ###################

    case \*
        for file in "$paths_config"/*
            if test -d "$file"
                set -l name (string split -rm1 / "$file")[-1]

                set -l seperator " "
                if test -f "$file/seperator.fish"
                    read -laz seperator < "$file/seperator.fish"
                end

                for file in "$file"/*
                    if test $file = "separator.fish"
                        continue
                    end

                    cat $file | envsubst | read -laz values

                    for value in $values
                        if elem $value $$name
                            continue
                        end

                        set -gx $name "$$name$separator$value"
                    end
                end

            else if test -f "$file"
                set -l name (string split -rm1 / "$file")[-1]
                cat $file | envsubst | read -laz values
                for jj in $values
                    if elem jj $seperator $$name
                        continue
                    else
                        set -gx $name $values
                    end
                end
            end
        end
end


