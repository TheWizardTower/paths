function elem --argument-names value separator env_var
        set -e argv[2]
        set -e argv[1]
        set -l env_var $argv
        for ii in (echo $env_var | tr "$separator" '\n')
                if test $ii = $value
                        return 0
                end
        end

        return 1
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
            set -l separator " "
            if test -f "$file/separator.fish"
                read -laz separator < "$file/separator.fish"
            end

            if test -d "$file"
                set -l name (string split -rm1 / "$file")[-1]

                for file in "$file"/*
                    if echo $file | grep -q "separator.fish"
                        continue
                    end

                    cat $file | envsubst | read -laz values

                    for value in $values
                        if elem "$value" "$separator" $$name
                            continue
                        end

                        if test $separator = " "
                            set -gx $name $$name $value
                        else
                            set -gx $name (printf "%s%s%s" $$name "$separator" $value)
                        end
                    end
                end

            else if test -f "$file"
                set -l name (string split -rm1 / "$file")[-1]
                cat $file | envsubst | read -laz values
                for jj in $values
                    if elem "$jj" "$separator" $$name
                        continue
                    else
                        set -gx $name $values
                    end
                end
            end
        end
end


