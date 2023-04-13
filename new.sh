work_dir=$1
file_name=$2
suffix=${work_dir##*/}

category=
case ${suffix} in
    essay)
        category='荣斋随笔'
        ;;
    *)
        category=${suffix}
esac

cat > ${work_dir}/${file_name}.md << EOF
---
title: ${file_name}
date: $(date +%F\ %T)
categories: ${category}
author: 童荣
tags:
---
EOF


