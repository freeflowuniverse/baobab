set -ex

pushd manual
bash run.sh
popd



rm -rf docs/_docs
rm -rf docs/_docs/v
v fmt -w baobab
pushd baobab
v doc -m -f html . -readme -comments -no-timestamp 
popd

mv baobab/_docs docs/v/
open docs/v/index.html
open docs/index.html

