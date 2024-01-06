#!/usr/bin/env bash
#
# From https://makeai.cn/master/superbench.sh Changed
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
SKYBLUE='\033[0;36m'
PLAIN='\033[0m'

# check release
if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi

# check root
[[ $EUID -ne 0 ]] && echo -e "${RED}Error:${PLAIN} This script must be run as root!" && exit 1

# check python
if  [ ! -e '/usr/bin/python' ]; then
        echo -e
        read -p "${RED}Error:${PLAIN} python is not install. You must be install python command at first.\nDo you want to install? [y/n]" is_install
        if [[ ${is_install} == "y" || ${is_install} == "Y" ]]; then
            if [ "${release}" == "centos" ]; then
                        yum -y install python
                else
                        apt-get -y install python
                fi
        else
            exit
        fi

fi

# check wget
if  [ ! -e '/usr/bin/wget' ]; then
        echo -e
        read -p "${RED}Error:${PLAIN} wget is not install. You must be install wget command at first.\nDo you want to install? [y/n]" is_install
        if [[ ${is_install} == "y" || ${is_install} == "Y" ]]; then
                if [ "${release}" == "centos" ]; then
                        yum -y install wget
                else
                        apt-get -y install wget
                fi
        else
                exit
        fi
fi

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

speed_test(){
	if [[ $1 == '' ]]; then
		temp=$(python speedtest.py --share 2>&1)
		is_down=$(echo "$temp" | grep 'Download')
		if [[ ${is_down} ]]; then
	        local REDownload=$(echo "$temp" | awk -F ':' '/Download/{print $2}')
	        local reupload=$(echo "$temp" | awk -F ':' '/Upload/{print $2}')
	        local relatency=$(echo "$temp" | awk -F ':' '/Hosted/{print $2}')
	        local nodeName=$2

	        printf "${YELLOW}%-17s${GREEN}%-18s${RED}%-20s${SKYBLUE}%-12s${PLAIN}\n" "${nodeName}" "${reupload}" "${REDownload}" "${relatency}"
		else
	        local cerror="ERROR"
		fi
	else
		temp=$(python speedtest.py --server $1 --share 2>&1)
		is_down=$(echo "$temp" | grep 'Download')
		if [[ ${is_down} ]]; then
	        local REDownload=$(echo "$temp" | awk -F ':' '/Download/{print $2}')
	        local reupload=$(echo "$temp" | awk -F ':' '/Upload/{print $2}')
	        local relatency=$(echo "$temp" | awk -F ':' '/Hosted/{print $2}')
	        temp=$(echo "$relatency" | awk -F '.' '{print $1}')
        	if [[ ${temp} -gt 1000 ]]; then
            	relatency=" 000.000 ms"
        	fi
	        local nodeName=$2

	        printf "${YELLOW}%-17s${GREEN}%-18s${RED}%-20s${SKYBLUE}%-12s${PLAIN}\n" "${nodeName}" "${reupload}" "${REDownload}" "${relatency}"
		else
	        local cerror="ERROR"
		fi
	fi
}

speed() {
	# install speedtest
	if  [ ! -e './speedtest.py' ]; then
	    wget https://raw.github.com/sivel/speedtest-cli/master/speedtest.py > /dev/null 2>&1
	fi
	chmod a+rx speedtest.py




	speed_test "17228" "中国移动集团新疆（中国伊犁）"
	speed_test "17437" "中国移动黑龙江分公司（中国哈尔滨）"
	speed_test "10742" "长春联通（中国长春）"
	speed_test "16375" "中国移动，吉林（长春，中国）"
	speed_test "9484" "中国联通（长春，中国）"
	speed_test "8928" "ZAP电信（热扥曺，巴西）"
	speed_test "5017" "中国联通辽宁分公司（中国沈阳）"
	speed_test "5145" "北京联通（中国北京）"
	speed_test "4751" "北京电信（中国北京）"
	speed_test "5505" "北京宽带网（中国北京）"
	speed_test "4713" "中国移动集团北京有限公司（中国北京）"
	speed_test "17184" "中国移动，天津（天津，CN）"
	speed_test "5475" "中国联通（天津，中国）"
	speed_test "17432" "中国MOEILE，山东分公司（青岛，CN）"
	speed_test "17223" "中国河北（石家庄，CN）"
	speed_test "17388" "中国MOEILE，山东分公司（中国临邑）"
	speed_test "16719" "中国移动通信集团公司上海有限公司（中国上海）"
	speed_test "17019" "Calelink公司，（上海，中国）"
	speed_test "5083" "中国联通上海分公司（中国上海）"
	speed_test "3633" "中国电信（上海，中国）"
	speed_test "4665" "中国移动集团上海有限公司（中国上海）"
	speed_test "16803" "中国移动通信集团公司上海有限公司（中国上海）"
	speed_test "12868" "中国联通山西分公司（中国太原）"
	speed_test "16005" "山西CMCC（太原，中国）"
	speed_test "5396" "中国电信江苏分公司（中国苏州）"
	speed_test "17320" "中国移动有限公司镇江分公司（中国镇江）"
	speed_test "6715" "中国移动集团浙江有限公司（中国宁波）"
	speed_test "6245" "宁波联通（中国宁波）"
	speed_test "13704" "中国联通（南京，中国）"
	speed_test "5446" "中国联通江苏公司（中国南京）"
	speed_test "5316" "中国电信江苏分公司（中国南京）"
	speed_test "17222" "中国移动集团新疆（中国阿勒泰）"
	speed_test "5300" "杭州、浙江联通（杭州、中国）"
	speed_test "7509" "中国电信浙江分公司（中国杭州）"
	speed_test "4647" "中国移动集团浙江有限公司（中国杭州）"
	speed_test "5131" "中国联通河南分公司（中国郑州）"
	speed_test "17145" "中国电信安徽分公司（合肥，CN）"
	speed_test "4377" "中国移动集团安徽有限公司（中国合肥）"
	speed_test "5724" "中国联通（中国合肥）"
	speed_test "17230" "中国移动通信集团内蒙古有限公司（阿拉善盟，中国）"
	speed_test "16392" "银川、中国移动、宁夏（银川、中国）"
	speed_test "5509" "中国联通宁夏分公司（中国宁夏）"
	speed_test "16395" "中国移动（武汉，中国）"
	speed_test "5485" "中国联通湖北分公司（中国武汉）"
	speed_test "5292" "中国移动集团陕西有限公司（中国西安）"
	speed_test "4863" "中国联通西安分公司（中国西安）"
	speed_test "6435" "中国电信湖北分公司（中国襄阳）"
	speed_test "12637" "中国电信襄阳分公司（中国襄阳）"
	speed_test "16171" "福州中国移动，福建（福州，中国）"
	speed_test "4884" "中国联通福建（福州，中国）"
	speed_test "8554" "新疆无线通信有限公司（中国昌吉）"
	speed_test "6144" "XJuniCOM（乌鲁木齐，中国）"
	speed_test "16858" "中国移动集团新疆（中国乌鲁木齐）"
	speed_test "16399" "中国电机股份有限公司（南昌，中国）"
	speed_test "7230" "中国江西股份有限公司（中国南昌）"
	speed_test "16294" "中国移动集团江西有限公司（中国南昌）"
	speed_test "16332" "中国移动集团江西有限公司（中国南昌）"
	speed_test "5097" "中国大学JX（中国南昌）"
	speed_test "3973" "中国电信（兰州，中国）"
	speed_test "16145" "兰州、中国移动、甘肃（兰州、中国）"
	speed_test "4690" "中国联通兰州分公司（中国兰州）"
	speed_test "6132" "中国电信（湖南，长沙，中国）"
	speed_test "4870" "长沙、湖南联通（长沙、中国）"
	speed_test "15862" "中国移动集团湖南有限公司（中国长沙）"
	speed_test "17584" "重庆行动电话公司（重庆，CN）"
	speed_test "5726" "中国联通重庆分公司（中国重庆）"
	speed_test "16983" "中国电信（重庆，CN）"
	speed_test "5530" "CCNN（重庆，中国）"
	speed_test "4575" "中国移动集团四川（中国成都）"
	speed_test "2461" "中国联通（成都，中国）"
	speed_test "4624" "中国电信（中国成都）"
	speed_test "11444" "中国电子科技大学（中国成都）"
	speed_test "5081" "深圳电信（中国深圳）"
	speed_test "14903" "俊（大埔、香港）"
	speed_test "16176" "和环球电讯有限公司（沙田、香港）"
	speed_test "17251" "中国电信GZ（广州，CN）"
	speed_test "6611" "中国移动，广东（广州，中国）"
	speed_test "13538" "俊（Kwai Chung，香港）"
	speed_test "14429" "W专业服务有限公司（新界，香港）"
	speed_test "17130" "转向架（香港）"
	speed_test "10267" "interoute VDC（香港，中国）"
	speed_test "2993" "（香港，中国）"
	speed_test "12990" "香港，中国）"
	speed_test "1536" "（香港，中国）"
	speed_test "8170" "atombase全球数据化（香港，中国）"
	speed_test "16398" "中国移动贵州（贵阳市，中国）"
	speed_test "17245" "中国移动集团（新疆喀什，中国）"
	speed_test "17227" "中国移动集团（新疆和田，China）"
	speed_test "10305" "GX（南宁电信，中国）"
	speed_test "5674" "GX联通（南宁市，中国）"
	speed_test "15863" "中国移动GX（南宁市，中国）"
	speed_test "5103" "云南（昆明，中国联通，中国）"
	speed_test "6168" "云南（昆明，中国移动，中国）"
	speed_test "5750" "lhasaunicom（拉沙，China）"


	rm -rf speedtest.py
}


io_test() {
    (LANG=C dd if=/dev/zero of=test_$$ bs=$1 count=$2 conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

calc_disk() {
    local total_size=0
    local array=$@
    for size in ${array[@]}
    do
        [ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
        [ "`echo ${size:(-1)}`" == "K" ] && size=0
        [ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
        [ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
        [ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
        total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
    done
    echo ${total_size}
}

power_time() {

	result=$(smartctl -a $(result=$(cat /proc/mounts) && echo $(echo "$result" | awk '/data=ordered/{print $1}') | awk '{print $1}') 2>&1) && power_time=$(echo "$result" | awk '/Power_On/{print $10}') && echo "$power_time"
}

install_smart() {
	# install smartctl
	if  [ ! -e '/usr/sbin/smartctl' ]; then
	    if [ "${release}" == "centos" ]; then
	        yum -y install smartmontools > /dev/null 2>&1
	    else
	        apt-get -y install smartmontools > /dev/null 2>&1
	    fi
	fi
}

start=$(date +%s)

cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
tram=$( free -m | awk '/Mem/ {print $2}' )
uram=$( free -m | awk '/Mem/ {print $3}' )
swap=$( free -m | awk '/Swap/ {print $2}' )
uswap=$( free -m | awk '/Swap/ {print $3}' )
up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days %d hour %d min\n",a,b,c)}' /proc/uptime )
load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
opsy=$( get_opsy )
arch=$( uname -m )
lbit=$( getconf LONG_BIT )
kern=$( uname -r )
ipv6=$( wget -qO- -t1 -T2 ipv6.icanhazip.com )
disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' ))
disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
disk_total_size=$( calc_disk ${disk_size1[@]} )
disk_used_size=$( calc_disk ${disk_size2[@]} )
ptime=$(power_time)


clear
next
echo -e "CPU model            : ${SKYBLUE}$cname${PLAIN}"
echo -e "Number of cores      : ${SKYBLUE}$cores${PLAIN}"
echo -e "CPU frequency        : ${SKYBLUE}$freq MHz${PLAIN}"
echo -e "Total size of Disk   : ${SKYBLUE}$disk_total_size GB ($disk_used_size GB Used)${PLAIN}"
echo -e "Total amount of Mem  : ${SKYBLUE}$tram MB ($uram MB Used)${PLAIN}"
echo -e "Total amount of Swap : ${SKYBLUE}$swap MB ($uswap MB Used)${PLAIN}"
echo -e "System uptime        : ${SKYBLUE}$up${PLAIN}"
echo -e "Load average         : ${SKYBLUE}$load${PLAIN}"
echo -e "OS                   : ${SKYBLUE}$opsy${PLAIN}"
echo -e "Arch                 : ${SKYBLUE}$arch ($lbit Bit)${PLAIN}"
echo -e "Kernel               : ${SKYBLUE}$kern${PLAIN}"
echo -ne "Virt                 : "

# install virt-what
if  [ ! -e '/usr/sbin/virt-what' ]; then
    if [ "${release}" == "centos" ]; then
    	yum update > /dev/null 2>&1
        yum -y install virt-what > /dev/null 2>&1
    else
    	apt-get update > /dev/null 2>&1
        apt-get -y install virt-what > /dev/null 2>&1
    fi
fi
virtua=$(virt-what) 2>/dev/null

if [[ ${virtua} ]]; then
	echo -e "${SKYBLUE}$virtua${PLAIN}"
else
	echo -e "${SKYBLUE}No Virt${PLAIN}"
	echo -ne "Power time of disk   : "
	install_smart
	echo -e "${SKYBLUE}$ptime Hours${PLAIN}"
fi
next
echo -n "I/O speed( 32M )     : "
io1=$( io_test 32k 1k )
echo -e "${YELLOW}$io1${PLAIN}"
echo -n "I/O speed( 256M )    : "
io2=$( io_test 64k 4k )
echo -e "${YELLOW}$io2${PLAIN}"
echo -n "I/O speed( 2G )      : "
io3=$( io_test 64k 32k )
echo -e "${YELLOW}$io3${PLAIN}"
ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
[ "`echo $io1 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw1=$( awk 'BEGIN{print '$ioraw1' * 1024}' )
ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
[ "`echo $io2 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw2=$( awk 'BEGIN{print '$ioraw2' * 1024}' )
ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
[ "`echo $io3 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw3=$( awk 'BEGIN{print '$ioraw3' * 1024}' )
ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
ioavg=$( awk 'BEGIN{printf "%.1f", '$ioall' / 3}' )
echo -e "Average I/O speed    : ${YELLOW}$ioavg MB/s${PLAIN}"
next
printf "%-18s%-18s%-20s%-12s\n" "Node Name" "Upload Speed" "Download Speed" "Latency"
speed && next
end=$(date +%s)
time=$(( $end - $start ))
if [[ $time -gt 60 ]]; then
	min=$(expr $time / 60)
	sec=$(expr $time % 60)
	echo -ne "Total time   : ${min} min ${sec} sec"
else
	echo -ne "Total time   : ${time} sec"
fi
echo -ne "\nCurrent time : "
echo $(date +%Y-%m-%d" "%H:%M:%S)
echo "Finished！"
next
