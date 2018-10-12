# 命令行输入 : xcodebuild --help 查看帮助
# xcodebuild [-project <projectname>] -scheme <schemeName> [-destination <destinationspecifier>]... [-configuration <configurationname>] [-arch <architecture>]... [-sdk [<sdkname>|<sdkpath>]] [-showBuildSettings] [-showdestinations] [<buildsetting>=<value>]... [<buildaction>]...
# xcodebuild -workspace <workspacename> -scheme <schemeName> [-destination <destinationspecifier>]... [-configuration <configurationname>] [-arch <architecture>]... [-sdk [<sdkname>|<sdkpath>]] [-showBuildSettings] [-showdestinations] [<buildsetting>=<value>]... [<buildaction>]...
# xcodebuild -version [-sdk [<sdkfullpath>|<sdkname>] [<infoitem>] ]
# xcodebuild -list [[-project <projectname>]|[-workspace <workspacename>]] [-json]
# xcodebuild -showsdks
# xcodebuild -exportArchive -archivePath <xcarchivepath> -exportPath <destinationpath> -exportOptionsPlist <plistpath>
# xcodebuild -exportLocalizations -localizationPath <path> -project <projectname> [-exportLanguage <targetlanguage>...]
# xcodebuild -importLocalizations -localizationPath <path> -project <projectname>
# xcodebuild -resolvePackageDependencies [-project <projectname>|-workspace <workspacename>] -clonedSourcePackagesDirPath <path>

# 注意：脚本目录和WorkSpace目录在同一个目录
# 工程名字(Target名字)
Project_Name = "Target名字,系统默认等于工程名字"
# workspace的名字
Workspace_Name = "WorkSpace名字"
# 配置环境，Release或者Debug,默认release
Configuration = "Debug"

# Bundle ID
BUNDLE_ID = "com.xxxx"

# 签名
SIGN_IDENTITY = ""
# 描述文件
PROFILE_NAME = "xxxxx-xxxx-xxx-xxxx"

# plist文件
INFO_PLIST = ""

# 开始打包
echo "xcodebuild -workspace $Workspace_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name.xcarchive clean archive build CODE_SIGN_IDENTITY=${SIGN_IDENTITY} PROVISIONING_PROFILE=${PROFILE_NAME} PRODUCT_BUNDLE_IDENTIFIER=${BUNDLE_ID}"

xcodebuild -workspace $Workspace_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name.xcarchive clean archive build CODE_SIGN_IDENTITY="${SIGN_IDENTITY}" PROVISIONING_PROFILE="${PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${BUNDLE_ID}"

echo "xcodebuild -exportArchive -archivePath build/$Project_Name.xcarchive -exportOptionsPlist ${INFO_PLIST} -exportPath ~/Desktop/$Project_Name.ipa"

xcodebuild -exportArchive -archivePath build/$Project_Name.xcarchive -exportOptionsPlist ${INFO_PLIST} -exportPath ~/Desktop/$Project_Name.ipa
