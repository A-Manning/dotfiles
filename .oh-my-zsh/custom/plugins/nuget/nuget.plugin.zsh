
function nupack() {
    if [ "$#" -lt "2" ]
    then
        echo "Must provide at least 2 args.\nUsage: nupack <nuspec | project> <outputDirectory> [options].\nSee \`nuget help pack\`"
     	return 1
    else
        local Command="nuget pack $1 -OutputDirectory $2 ${@:3}"
        echo "alias: $Command"
        eval $Command
    fi
}
