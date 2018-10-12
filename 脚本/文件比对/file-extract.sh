#!/bin/sh
# 用于提取指定文件
# usage: sh ~/Documents/Work/Projetcs/DYModels/DYModels/ ~/Documents/Work/Projetcs/iOS_Models_Pod_13201/DYZB/ ~/Documents/Temp/models

src_dir=$1
dest_dir=$2
out_dir=$3
key=".*\.[h,m]"
src_files=$(find $src_dir -regex $key) # 查找源目录下所有的 oc 文件
index=0
diff_count=0 # 不同的文件数目

result_origin_dir="$out_dir/origin"   # 差异性的原始文件存放目录
result_new_dir="$out_dir/new"  # 差异性的新文件存放目录

if [ ! -d $result_origin_dir ];then
mkdir $result_origin_dir
fi

if [ ! -d $result_new_dir ];then
mkdir $result_new_dir
fi

# 找出变更过的文件
for src in $src_files
do
  let index++
  name=${src##*/} # 获取最后一个 / 之后的字符串，即文件名

  echo "[$index] Process: Syncronizing --> $name <-- ."

  result=$(echo $(find $dest_dir -name $name))
  length=${#result[@]}

  if [[ $length > 1 ]]; then
    echo "[$index] Warning: More then one file with name --> $name <-- ."
  fi

  dest=${result[0]}

  if [[ ${#dest} == 0 ]]; then
    echo "[$index] Result: --> $name <-- not found! Skipped!"
    continue
  fi

  oldMD5Output=$(md5 $src)
  oldMD5=${oldMD5Output##* }
  # echo "old md5 : $oldMD5"

  newMD5Output=$(md5 $dest)
  newMD5=${newMD5Output##* }
  # echo "new md5 : $newMD5"

  if [[ $newMD5 != $oldMD5 ]]; then
    echo "[$index] Change: syncronize --> $name <-- ."
    let diff_count+=1
    cp -f $src "$result_origin_dir/$name"
    cp -f $dest "$result_new_dir/$name"
    echo "[$index] Result: Complete syncronize --> $name <-- ."
  else
    echo "[$index] Result: Not need syncronize --> $name <-- ."
  fi

done

echo "Finished! Total $diff_count files found!"
