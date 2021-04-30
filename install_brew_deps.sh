while read p; do
  brew install "$p"
done <brew-dependencies.txt