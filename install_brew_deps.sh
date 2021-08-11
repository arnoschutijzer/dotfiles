brew tap beeftornado/rmtree

while read p; do
  brew install "$p"
done < "$(pwd)"/configuration/brew-dependencies.txt
