brew tap beeftornado/rmtree
brew tap bridgecrewio/airiam https://github.com/bridgecrewio/airiam

while read p; do
  brew install "$p"
done < "$(pwd)"/configuration/brew-dependencies.txt
