#参考
# 1) 漢のzshi(22)
# 2) .zshrcの設定
#
## path
PATH=/usr/local/bin:~/bin:$PATH
export MANPATH=/usr/local/man:/usr/share/man


## export
export LANG=ja_JP.UTF-8
export SHELL=$'/bin/zsh'
export PAGER=$'less'
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib


tmux attach


## keymap
bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
bindkey "[3~" delete-char
bindkey "[1~" biginning-of-line
bindkey "[4~" end-of-line


## prompt
autoload colors
colors

local GREEN=$'%{\e[1;32m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'

case ${UID} in
0)
  PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  ;;
*)
  PROMPT=$BLUE'[%n@%m] %(!.#.$) '$DEFAULT
  RPROMPT=$GREEN'[%~]'$DEFAULT
  SPROMPT="%{${fg[red]}%}correct: %R -> %r [n,y,a,e]? %{${reset_color}%}"
  ;;
esac

# 今使っているコマンドをwindow titleにする
if [ "$TERM" = "screen" ]; then
  chpwd () { echo -n "_`dirs`\\" }
  preexec() {
    emulate -L zsh
    local -a cmd; cmd=(${(z)2})
    case $cmd[1] in
      fg)
          if (( $#cmd == 1 )); then
            cmd=(builtin jobs -l %+)
          else
            cmd=(builtin jobs -l $cmd[2])
          fi
          ;;
      %*)
          cmd=(builtin jobs -l $cmd[1])
          ;;
      cd)
          if (( $#cmd == 2 )); then
            cmd[1]=$cmd[2]
          fi
          ;;
      *)
          echo -n "k$cmd[1]:t\\"
          return
          ;;
    esac
    local -A jt; jt=(${(kv)jobtexts})
    $cmd >>(read num rest
            cmd=(${(z)${(e):-\$jt$num}})
            echo -n "k$cmd[1]:t\\") 2>/dev/null
  }
  chpwd
fi


## コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# ignore duplication
setopt hist_ignore_dups
# シェルのプロセスごとに履歴を共有
setopt share_history
# 複数の zsh を同時に使う時など history ファイルに上書きせず追加する
setopt append_history


# 補完
autoload -U compinit; compinit


## alias
setopt complete_aliases

alias ls="ls --color=auto --show-control-chars"
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias j="jobs -l"
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias less='lv'
alias vi='vim'


# 指定したコマンド名がなく、ディレクトリ名と一致した場合 cd する
setopt auto_cd
# cd でTabを押すとdir list を表示
setopt auto_pushd
# コマンドのスペルチェックをする
setopt correct
# コマンドライン全てのスペルチェックをする
setopt correct_all
# 補完候補リストを詰めて表示
setopt list_packed
# beepを鳴らさないようにする
setopt nolistbeep
# ビープ音を鳴らさないようにする
setopt NO_beep
# ディレクトリスタックに同じディレクトリを追加しないようになる
setopt pushd_ignore_dups
# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst
# カッコの対応などを自動的に補完する
setopt auto_param_keys
# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_menu
# cd をしたときにlsを実行する
function chpwd() { ls }
# sudoも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# 色付きで補完する
zstyle ':completion:*' list-colors di=34 fi=0
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# 8 ビット目を通すようになり、日本語のファイル名などを見れるようになる
setopt print_eightbit
# 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs
# 複数のリダイレクトやパイプなど、必要に応じて tee や cat の機能が使われる
setopt multios
# 色を使う
setopt prompt_subst
# history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store
# 文字列末尾に改行コードが無い場合でも表示する
unsetopt promptcr
#コピペの時rpromptを非表示する
setopt transient_rprompt
# 余分な空白は詰める
setopt hist_reduce_blanks
# 登録済コマンド行は古い方を削除
setopt hist_ignore_all_dups
# 補完候補リストの日本語を適正表示
setopt print_eight_bit
# 上書きリダイレクトの禁止
setopt no_clobber
# 未定義変数の使用の禁止
setopt no_unset                 
# 内部コマンドの echo を BSD 互換にする
setopt bsd_echo
# 既存のファイルを上書きしないようにする
setopt clobber
# 最後がディレクトリ名で終わっている場合末尾の / を自動的に取り除く
setopt auto_remove_slash
# 補完候補が複数ある時に、一覧表示する
setopt auto_list
# 補完候補が複数ある時、一覧表示 (auto_list) せず、すぐに最初の候補を補完する
#setopt menu_complete
# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt list_types
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl
# シンボリックリンクは実体を追うようになる
setopt chase_links






# サスペンド中のプロセスと同じコマンド名を実行した場合はリジュームする
#setopt auto_resume

# =command を command のパス名に展開する
#setopt equals

# ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
#setopt extended_glob

# zsh の開始・終了時刻をヒストリファイルに書き込む
#setopt extended_history

# Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
#setopt NO_flow_control

# 各コマンドが実行されるときにパスをハッシュに入れる
#setopt hash_cmds

# コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
#setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
#setopt hist_verify

# シェルが終了しても裏ジョブに HUP シグナルを送らないようにする
#setopt NO_hup

# Ctrl+D では終了しないようになる（exit, logout などを使う）
#setopt ignore_eof

# コマンドラインでも # 以降をコメントと見なす
#setopt interactive_comments

# メールスプール $MAIL が読まれていたらワーニングを表示する
#setopt mail_warning

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
#setopt mark_dirs

# ファイル名の展開で、辞書順ではなく数値的にソートされるようになる
#setopt numeric_glob_sort

# コマンド名に / が含まれているとき PATH 中のサブディレクトリを探す
#setopt path_dirs

# 戻り値が 0 以外の場合終了コードを表示する
#setopt print_exit_value

# pushd を引数なしで実行した場合 pushd $HOME と見なされる
#setopt pushd_to_home

# rm * などの際、本当に全てのファイルを消して良いかの確認しないようになる
#setopt rm_star_silent

# rm_star_silent の逆で、10 秒間反応しなくなり、頭を冷ます時間が与えられる
#setopt rm_star_wait

# for, repeat, select, if, function などで簡略文法が使えるようになる
#setopt short_loops

# デフォルトの複数行コマンドライン編集ではなく、１行編集モードになる
#setopt single_line_zle

# コマンドラインがどのように展開され実行されたかを表示するようになる
#setopt xtrace
