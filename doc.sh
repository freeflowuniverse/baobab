set -ex
rm -rf docs/_docs
v fmt -w baobab
pushd baobab
v doc -m -f html . -readme -comments -no-timestamp 
popd
mv baobab/_docs docs
open docs/index.html

# open https://threefoldfoundation.github.io/dao_research/liqpool/docs/liquidity.html