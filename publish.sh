git add .
git commit -m "new post"
git push origin master
# export HEXO_ALGOLIA_INDEXING_KEY=aed9efacc66cdcd0647b6fe1e4808317
# hexo clean
hexo g
# hexo algolia
# gulp compressImage
gulp compressCss
# gulp publish
hexo d
