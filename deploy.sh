# 确保脚本抛出遇到的错误
set -e

find notebook -name "*.md" -not -name "README.md" -exec md5sum {} \; > name_mapping.file
while read file_md5 file_path_name
do
    src=${file_path_name}
    dst=`dirname ${file_path_name}`/${file_md5}.md
    if [[ ${src} != ${dst} ]]; then
        mv ${src} ${dst}
    fi
done < name_mapping.file

# 生成静态文件
yarn b
 
# 进入生成的文件夹
cd .vuepress/public
 
# 如果是发布到自定义域名
# echo 'www.example.com' > CNAME
 
git init
git add -A
git commit -m 'deploy'
 
git push -f git@github.com:bazoookia/bazoookia.github.io.git master
 
cd -

while read file_md5 file_path_name
do
    src=`dirname ${file_path_name}`/${file_md5}.md
    dst=${file_path_name}
    if [[ ${src} != ${dst} ]]; then
        mv ${src} ${dst}
    fi
done < name_mapping.file
