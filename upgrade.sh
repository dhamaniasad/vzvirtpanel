#!/bin/bash
#  The VTONF Control Panel
#  Copyright (C) 2008 bobcares.com . All rights reserved.

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; version 2 of the License.
#
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
pathc_1='df.patch'
pathc_2='setnameservers.php.patch'
pathc_3='help.php.patch'
package_add_1='vtonf-plan-1.0-1.i386.rpm'
version='1.0-beta1'
export p_w_d=`pwd`
cat <<eof
                #################### notice #########################

                this is the vtonf vps control panel upgrade program.
                please notice, it will send a feed back email to
                feedback@vtonf.com after the upgrade.
                to know about the usage stats of vtonf.

                #####################################################
eof

echo -n "do you wish to start  (y/n)? : "
read yes

if [ -e "/etc/vtonf/version" ]; then
        echo " "
else
        echo "there is not a vtonf server please use the vtonfinstaller to start the installation"
	exit 0
fi


if [[ $yes == "y" ]];then
        echo "starting installation"
elif [[ $yes == "y" ]];then
        echo "starting installation ..."
else
        echo "installation canceled .... "
        exit
fi

rpm -ivh packages/$package_add_1 --nodeps --force

gunzip patch/$pathc_1.gz
cp -vf patch/$pathc_1 /usr/local/vtonf/vtonf/scripts/
cd /usr/local/vtonf/vtonf/scripts/
patch -p0 < $pathc_1
rm -rf $pathc_1
cd $p_w_d

gunzip patch/$pathc_2.gz
cp -f patch/$pathc_2 /usr/local/vtonf/vtonf/nmgnt/
cd /usr/local/vtonf/vtonf/nmgnt/
patch -p0 < $pathc_2
rm -rf $pathc_2
cd $p_w_d

gunzip patch/$pathc_3.gz
cp -f patch/$pathc_3 /usr/local/vtonf/vtonf/services/
cd /usr/local/vtonf/vtonf/services/
patch -p0 < $pathc_3
rm -rf $pathc_3
cd $p_w_d



echo "$version" > /etc/vtonf/version  
echo "The vtonf control panel is upgarded to $version"
echo -n "Sending feedback ... "
echo " Vtonf installed / upgraded on `date` " | mail -s "The vtonf notification" feedback@vtonf.com
echo "done" 


