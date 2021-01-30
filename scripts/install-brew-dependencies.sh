installing_casks=false

start_installing() {
  concatenated_deps=""
  concatenated_casks=""

  while read p; do
    if [[ $p == *"# brew casks"* ]]; then
      # skip comments
      installing_casks=true
      continue
    fi

    if [[ $installing_casks == true ]]; then
      concatenated_casks+="$p "
    else
      concatenated_deps+="$p "
    fi
  done <brew-dependencies.txt

  brew install $concatenated_deps
  brew install $concatenated_casks --cask
}

brew upgrade
start_installing
brew cleanup