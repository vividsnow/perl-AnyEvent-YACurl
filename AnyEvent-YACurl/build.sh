set -eo pipefail

CURLVER=7.73.0
CARESVER=1.16.1
NGHTTP2VER=1.41.0

rm -rf nghttp2-$NGHTTP2VER nghttp2-lib nghttp2-src
rm -rf curl-$CURLVER curl-src curl-lib
rm -rf c-ares-$CARESVER c-ares-src c-ares-lib

tar -xf nghttp2-$NGHTTP2VER.tar.gz
mv nghttp2-$NGHTTP2VER nghttp2-src

tar -xf curl-$CURLVER.tar.gz
mv curl-$CURLVER curl-src

tar -xf c-ares-$CARESVER.tar.gz
mv c-ares-$CARESVER c-ares-src

for file in patch/*; do
    patch -p1 < $file
done

pushd curl-src/docs/libcurl
perl symbols.pl > symbols.h
popd

perl sync-symbols.pl

# Clean stuff we don't need if they cause trouble
rm -rf nghttp2-src/third-party/mruby
find curl-src nghttp2-src -name \*.pm -delete
find curl-src nghttp2-src -name \*.rb -delete
find curl-src nghttp2-src -name \*.py -delete

cp MANIFEST.pre MANIFEST
find curl-src -type f >> MANIFEST
find nghttp2-src -type f >> MANIFEST
find c-ares-src -type f >> MANIFEST
