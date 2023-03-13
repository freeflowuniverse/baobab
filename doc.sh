set -ex
rm -rf docs/_docs
v fmt -w baobab
pushd baobab
v doc -m -f html . -readme -comments -no-timestamp 
popd