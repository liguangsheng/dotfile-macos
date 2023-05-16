function bootstrap_symlink() {
    local source_path="$1"
    local target_path="$2"
    local backup_dir="$HOME/.cache/dotbackup"

    # 判断目标路径是否存在
    if [ -e "$target_path" ]; then
        # 判断目标路径是否是软链接
        if [ -L "$target_path" ]; then
            # 获取软链接指向的实际路径
            local current_target=$(readlink -f "$target_path")

            # 判断软链接的指向是否与源路径相同
            if [ "$current_target" = "$source_path" ]; then
                echo "软链接路径已经指向源路径，无需操作，$source_path -> $target_path"
                return
            fi
        fi

        # 创建备份目录
        mkdir -p "$backup_dir"

        # 生成备份文件名
        local backup_file="${backup_dir}/$(basename "$target_path")_$(date +%Y%m%d%H%M%S)"

        # 备份已存在的目标文件/目录
        mv "$target_path" "$backup_file"
        echo "已备份目标文件/目录，$target_path -> $backup_file"
    fi

    # 创建软链接
    ln -s "$source_path" "$target_path"
    echo "创建软链接成功"
}

bootstrap_symlink "$HOME/dotfiles-macos/vim/.vimrc" "$HOME/.vimrc"
bootstrap_symlink "$HOME/dotfiles-macos/zsh/.zshrc" "$HOME/.zshrc"
bootstrap_symlink "$HOME/dotfiles-macos/zsh/.zimrc" "$HOME/.zimrc"
bootstrap_symlink "$HOME/dotfiles-macos/nvim" "$HOME/.config/nvim"
bootstrap_symlink "$HOME/dotfiles-macos/starship/starship.toml" "$HOME/.config/starship.toml"

function bootstrap_font() {
    local url="$1"
    local temp_dir=$(mktemp -d)
    local target_dir="/Library/Fonts"

    local filename=$(basename "$url")  # 获取URL的basename
    local folder_name=${filename%.*}  # 获取文件名的basename作为文件夹名

    # 检查目标文件夹是否存在
    if [[ -d "$target_dir/$folder_name" ]]; then
        echo "字体 $folder_name 已存在，无需操作"
        return
    fi

    # 下载压缩包到临时目录
    wget "$url" -P "$temp_dir"

    # 解压压缩包到目标目录
    unzip "$temp_dir/$filename" -d "$target_dir/$folder_name"

    # 清理临时目录
    rm -rf "$temp_dir"

    echo "字体已下载并解压到 $target_dir/$folder_name"
}

bootstrap_font https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
bootstrap_font https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Ubuntu.zip
bootstrap_font https://github.com/lxgw/LxgwWenKai/releases/download/v1.300/lxgw-wenkai-v1.300.zip


echo "bootstrap git config"
git config --global alias.aa 'add -all'
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.cm 'commit -m'
git config --global alias.co checkout
git config --global alias.df 'diff'
git config --global alias.last 'log -1 HEAD --stat'
git config --global alias.ll 'log --oneline'
git config --global alias.pr 'pull --rebase'
git config --global alias.rh 'reset --hard'
git config --global alias.rv 'remote -v'
git config --global alias.sb 'status -sb'
git config --global alias.se '!git rev-list --all | xargs git grep -F'
git config --global alias.st status
git config --global core.autocrlf false
git config --global credential.helper store
git config --global help.autocorrect 20
git config --global init.defaultBranch main
git config --global pull.ff only
git config --global push.autoSetupRemote true
git config --global user.name liguangsheng
echo "bootstrap git config finished"
