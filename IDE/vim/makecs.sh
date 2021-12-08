MY_PATH=$PWD
echo "project path : ${MY_PATH}"

find $MY_PATH -name "*.h" -o -name "*.c" -o -name "*.s" -o -name "*.S" -o -name "*.cpp" -o -name "*.ld" -o -name "*.lds"> cscope.files

cscope -bkq -i cscope.files

if [ $# == 0 ];then
	ctags -R -L cscope.files
	exit
fi

if [ $1 == '-a' ];then
	echo "ctags contain extra"
	ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -L cscope.files
elif [ $1 == '-q' ];then
	echo "Quickly build, whitout ctags"
else
	ctags -R -L cscope.files
fi
