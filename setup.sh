# Basic setup
# TODO: add some command line options to make this more versatile

# Update files
git fetch
git pull origin master

if [ -d ~/.vim ]; then
    echo "NOTICE: Found pre-existing vim directory at ~/.vim"
    read -p "Do you want to continue? [y/n]" delete_that_shizz

    if [ $delete_that_shizz = "y" ]; then
        echo "NOTICE: Overwriting vim directory at ~/.vim"
        rm -rf ~/.vim
    else
        echo "NOTICE: Nothing to do here."
        echo "NOTICE: Exiting"
        exit 0
    fi
fi

# Copy files over
cp -r .vim/ ~/

if [ -e ~/.vimrc ]; then
    echo "NOTICE: Found pre-existing vimrc at ~/.vimrc; removing"
    rm -f ~/.vimrc
fi

# Link file(s)
ln -s ~/.vim/.vimrc ~/.vimrc

echo "NOTICE: Updated and linked vimrc"
