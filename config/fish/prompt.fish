# プロンプト設定はインタラクティブシェルのときのみ必要
# それ以外の場合はすぐ終了する
status --is-interactive; or exit 0

function fish_prompt
    if [ $status -eq 0 ]
        set face "( '_')"
        set colr 'green'
    else
        set face '( >o<)'
        set colr 'red'
    end

    if [ (id -u) -eq 0 ]
        set prompt '#'
    else
        set prompt '$'
    end

    printf '%s %s %s %s%s%s ' $face (set_color -b $colr) $prompt (set_color normal) (set_color $colr) (set_color normal)
end

function fish_right_prompt
    set last_status $status

    if [ -n $CMD_DURATION ]
        if [ $CMD_DURATION -lt 1000 ]
            set dur (printf '%s ms' $CMD_DURATION)
        else if [ $CMD_DURATION -lt 60000 ]
            set dur (printf '%s sec' (math -s2 $CMD_DURATION / 1000))
        else if [ $CMD_DURATION -lt 3600000 ]
            set -l min (math $CMD_DURATION / 60000)
            set -l sec (math $CMD_DURATION / 1000 '%' 60)
            set dur (printf '%s min %s sec' $min $sec)
        else
            set -l hour (math $CMD_DURATION / 3600000)
            set -l min (math $CMD_DURATION / 60000 '%' 60)
            set dur (printf '%s hour %s min' $hour $min)
        end
    end

    printf '%sexit %d after %s%s' (set_color bcc) $last_status $dur (set_color normal)
end
