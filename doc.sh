set -ex

rm -rf docs/_docs
rm -rf docs/_docs/v

pushd manual
bash run.sh
popd

v fmt -w baobab
pushd baobab
v doc -m -f html . -readme -comments -no-timestamp 
popd

mv baobab/_docs docs/v/
