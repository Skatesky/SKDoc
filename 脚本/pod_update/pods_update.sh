
echo '$0: '$0
# echo 'dirname $0 : ' dirname $0

pods_with_commit=$(ruby `dirname $0`/print_commit_pods.rb Podfile)

pod_command="pod update $pods_with_commit --no-repo-update"

if [ "$pods_with_commit" = "" ]; then
echo "pod install..."
pod install
else
pod_command="pod update $pods_with_commit --no-repo-update"
echo "pod update..."
echo $pod_command
eval $pod_command
fi



