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

_dounload_url="localhost"
_version="1.0-beta1"
_arch="i386"
_vpipe='vpipe-1.0-1.i386.rpm'
_vtonf_dialog='vtonf-dialog-1.0-1.i386.rpm'
_vtonf_gd='vtonf-gd-2.0.35-0.i386.rpm'
_vtonf_libjpeg='vtonf-libjpeg-6b-0.i386.rpm'
_vtonf_libpng='vtonf-libpng-1.2.18-0.i386.rpm'
_vtonf_panel='vtonf-panel-1.0-beta1.tar.gz'
_vtonf_pcre='vtonf-pcre-7.3-1.i386.rpm'
_vtonf_php='vtonf-php-5.2.0-0.i386.rpm'
_vtonf_plan='vtonf-plan-1.0-1.i386.rpm'
_vtonf_zlib='vtonf-zlib-1.2.3-1.i386.rpm'
_vtonfd='vtonfd-1.0-1.i386.rpm'

################################### The feed back  ######################################
cat <<EOF
                #################### Notice #########################

                This is the vtonf vps control panel installer program.
                Please notice, it will send a feed back email to
                feedback@vtonf.com after the successful installation
                to know about the usage stats of Vtonf.

                #####################################################
EOF

if [ -e "/etc/vtonf/version" ]; then
        echo "A vtonf installation already exist in the server please run  \"./upgrade \" for upgrading."
exit 0
fi


echo -n "Do you wish to start the installation procedure (y/n)? : "
read yes
if [[ $yes == "y" ]];then
        echo "Starting installation"
elif [[ $yes == "Y" ]];then
        echo "Starting installation"
else
        echo "Installation canceled .... "
	exit 
fi

#################################################################################
####################Testing for vtonf dialog utility###############################
if [ -e "/usr/local/vtonf/bin/dialog" ]; then
        echo " "
else
	echo "Please wait................... "
	rpm -ivh packages/$_vtonf_dialog --force >>/dev/null 2>&1
	ln -sf /usr/local/vtonf/bin/dialog /usr/local/bin/dialog
	ln -sf /usr/local/vtonf/bin/dialog /usr/bin/dialog
fi
###################Testing  for Wget command #####################################
if [ -e "/bin/wget" ]; then
        $_wget = '/bin/wget'
elif [ -e "/usr/bin/wget" ]; then
       $_wget = '/usr/bin/wget'
elif [ -e "/usr/local/bin/wget" ]; then
        $_wget = '/usr/local/bin/wget'
else
        echo "Please install wget !!"
	exit
fi
#################### Testing for  rpm command ####################################

if [ -e "/bin/rpm" ]; then
        $_rpm = '/bin/rpm'
elif [ -e "/usr/bin/rpm" ]; then
       $_rpm = '/usr/bin/rpm'
elif [ -e "/usr/local/bin/rpm" ]; then
        $_rpm = '/usr/local/bin/rpm'
else
        echo "Please install rpm !!"
        exit
fi


_dialog='/usr/local/vtonf/bin/dialog'
_dialog_title='VTONF INSTALLER'
_dialog_backtitle='VTONF - VPS SERVER CONTROL PANEL INSTALLER V1.0 beta1'
_rpm_log='/var/tmp/list.packages.1'

########### License Function ################################################### 

function licence_fun {
$_dialog --title "-----LICENSE-----" --backtitle "$_dialog_backtitle "  \
         --yesno "Copyright (C) 2008  http://www.bobcares.com/ \
    \n This program is free software: you can redistribute it and/or modify \
    \n it under the terms of the GNU General Public License as published by \
    \nthe Free Software Foundation, version 2 of the License. \
    \n  \
    \n This program is distributed in the hope that it will be useful, \
    \nbut WITHOUT ANY WARRANTY; without even the implied warranty of \
    \nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the \
    \nGNU General Public License for more details. \
    \nYou should have received a copy of the GNU General Public License \
    \nalong with this program.  If not, see <http://www.gnu.org/licenses/> \
    \n\n Do you wish to agree ?" 20 80
val=$?
case $val in
        0) start_install ;;
        *) exit 0;;
esac
}

function start_install {
	{
	  rpm -qa >$_rpm_log
	}|dialog --title "$_dialog_title" --backtitle "$_dialog_backtitle "  \
                  --infobox "Please wait ,while Creating  the list of Operating system packages" 7 50
	{
	for i in $(seq 1 100);
	do
	echo $i
	sleep 0.01
	done
	}|dialog --title "$_dialog_title" --backtitle "$_dialog_backtitle "  \
		 --shadow --gauge "Checking Operating system packages" 6 70 0
 coreutils_fun;
}
function coreutils_fun {
dialog --title "Checking coreutils" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking Core Utils" 3 40                
if grep -iq coreutils  $_rpm_log  ;then
	{ sleep 1
        _core_result='Yes'
        echo " ";
        }|dialog --title "Checking coreutils" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking Core Utils ... Yes" 3 40
else
	{ _core_result='No'
	  Sleep 1
 	 echo "";
        }|dialog --title "Checking coreutils" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking Core Utils ... NO \n Please install coreutils " 4 40 ; exit 0 
fi
grep_fun ;

}
function grep_fun {

if grep -iq grep  $_rpm_log  ;then
        { sleep 1
        echo " ";
        }|dialog --title "Checking Grep" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking Grep ... Yes" 3 40
else
        { 
          Sleep 1
         echo "";
        }|dialog --title "Checking Grep" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking Grep ... NO \n Please install Grep " 4 40 ; exit 0
fi
awk_fun;

}

function awk_fun {

if grep -iq awk  $_rpm_log  ;then
        { sleep 1
        echo " ";
        }|dialog --title "Checking awk" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking awk ... Yes" 3 40
else
        { 
          Sleep 1
         echo "";
        }|dialog --title "Checking awk" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking awk ... NO \n Please install awk " 4 40 ; exit 0
fi
vzctl_fun;

}

function vzctl_fun {

if grep -iq vzctl $_rpm_log  ;then
        { sleep 1
        echo " ";
        }|dialog --title "Checking For OpenVZ" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking OPenVZ ... Yes" 3 40
else
        { 
          Sleep 1
         echo "";
        }|dialog --title "Checking OpenVZ" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking OpenVZ ... NO \n This is not an OpenVZ Server " 4 40 ; exit 0
fi
vzpkg_fun;

}

function vzpkg_fun {

if grep -iq vzpkg  $_rpm_log  ;then
        { sleep 1
        echo " ";
        }|dialog --title "Checking For vzpkg" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking vzpkg ... Yes" 3 40
else
        {
          Sleep 1
         echo "";
        }|dialog --title "Checking vzpkg" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking vzpkg ... NO \n Please install vzpkg " 4 40 ; exit 0
fi

vzquota_fun;
}

function vzquota_fun {

if grep -iq vzquota  $_rpm_log  ;then
        { sleep 1
        echo " ";
        }|dialog --title "Checking For vzquota" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking vzquota ... Yes" 3 40
else
        { 
          Sleep 1
         echo "";
        }|dialog --title "Checking vzquota" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking vzquota ... NO \n Please install vzquota " 4 40 ; exit 0
fi
expect_fun;
}

function expect_fun {

if grep -iq expect  $_rpm_log  ;then
	{ sleep 1
        echo " ";
        }|dialog --title "Checking For expect" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking expect  ... Yes" 3 40
else
	{
          sleep 1
         echo "";
        }|dialog --title "Checking expect" --backtitle "$_dialog_backtitle "  \
                 --infobox " Checking expect ... NO \n Please install expect " 4 40 ; exit 0
fi
}
 





##########main body######################
clear
 $_dialog --title "$_dialog_title" --backtitle "$_dialog_backtitle "  \
	 --yesno "This  program will install vtonf control panel.\n  Do you wish to continue?" 7 60 
val=$?
case $val in 
	0) licence_fun ;;
	*) exit 0;;
esac

################# Creating Vtonf user ###############################
	{
	export _vtonf_pa=`mkpasswd -l 35`
	useradd vtonf -d /home/vtonf -s /bin/bash -p $_vtonf_pa >/dev/null 2>&1
	}|dialog --title "Creating Vtonf User " --backtitle "$_dialog_backtitle "  \
                 --infobox "Creating Vtonf User  ... Done " 3 40
##################

######################### vpipe #####################################
	{
	sleep 1
 	rpm -ivh packages/$_vpipe --force --nodeps >/dev/null 2>&1
	}|dialog --title "Installing VPIPE " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing VPIPE  ... Done " 3 40


######################### GD #####################################
        {
        sleep 1
        rpm -ivh packages/$_vtonf_gd --force --nodeps >/dev/null 2>&1
        }|dialog --title "Installing vtonf-gd " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing vtonf-gd  ... Done " 3 40

######################### Jpeg #####################################
        {
        sleep 1
        rpm -ivh packages/$_vtonf_libjpeg --force --nodeps >/dev/null 2>&1
        }|dialog --title "Installing vtonf-jpeg " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing vtonf-jpeg  ... Done " 3 40


######################### Png #####################################
        {
        sleep 1
        rpm -ivh packages/$_vtonf_libpng --force --nodeps >/dev/null 2>&1
        }|dialog --title "Installing vtonf-png " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing vtonf-png  ... Done " 3 40



######################### Zlib #####################################
        {
        sleep 1
        rpm -ivh packages/$_vtonf_zlib --force --nodeps >/dev/null 2>&1
        }|dialog --title "Installing vtonf-zlib " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing vtonf-zlib  ... Done " 3 40


######################### Pcre #####################################
        {
        sleep 1
        rpm -ivh packages/$_vtonf_pcre --force --nodeps >/dev/null 2>&1
        }|dialog --title "Installing vtonf-pcre " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing vtonf-pcre  ... Done " 3 40


######################### Php #####################################
        {
        sleep 1
        rpm -ivh packages/$_vtonf_php --force --nodeps >/dev/null 2>&1
        }|dialog --title "Installing vtonf-php " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing vtonf-php  ... Done " 3 40


######################### vtonfd #####################################
        {
        sleep 1
        rpm -ivh packages/$_vtonfd --force --nodeps >/dev/null 2>&1
	yum install libssl.so.4 -y
        }|dialog --title "Installing vtonfd " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing vtonfd  ... Done " 3 40


######################### vtonf-panel #####################################
        {
        sleep 1
        tar -xzf packages/$_vtonf_panel
	mkdir -p /usr/local/vtonf/vtonf/
	cp -arf vtonf-panel-1.0-beta1/vtonf/ /usr/local/vtonf/
	cp -arf vtonf-panel-1.0-beta1/etc/vtonf/ /etc/
	rm -rf vtonf-panel-1.0-beta1/
        }|dialog --title "Installing vtonf-panel " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing vtonf-panel  ... Done " 3 40

######################### Plan #####################################
        {
        sleep 1
        rpm -ivh packages/$_vtonf_plan --force --nodeps >/dev/null 2>&1
        }|dialog --title "Installing Plans " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing Plans  ... Done " 3 40

######################### Centos4 Minimal template #####################################
        {
        sleep 1
	mkdir -p /vz/template/cache >/dev/null 2>&1
	cp -f packages/centos-4-i386-minimal.tar.gz /vz/template/cache/ 
        }|dialog --title "Installing Centos4 Minimal template  " --backtitle "$_dialog_backtitle "  \
                 --infobox "Installing Centos4 Minimal template  ... Done " 3 40


############################changing permission###################
	dialog --title "Changing Permissions..." --backtitle "$_dialog_backtitle "  \
                 --infobox " Please wait ...." 3 40
	{
	chown -R vtonf.vtonf /etc/vtonf/
	chown -R vtonf.vtonf /usr/local/vtonf/vtonf/
	chmod -R 700 /usr/local/vtonf/vtonf/scripts/*
	}|dialog --title "Changing Permissions " --backtitle "$_dialog_backtitle "  \
                 --infobox "Changing Permissions  ... Done " 3 40

#############################Vtonf login name and password###############
	dialog --title "Creating Vtonf Login Name And Password" --backtitle "$_dialog_backtitle "  \
		--inputbox "Enter Vtonf Login Name " 0 0 2> /tmp/u.tmp.$$
		retval=$?
		_username=`cat /tmp/u.tmp.$$`
		rm -rf /tmp/u.tmp.$$
	dialog --title "Creating Vtonf Login Name And Password" --backtitle "$_dialog_backtitle " \
		 --inputbox   "Enter Vtonf Pssword " 0 0 2> /tmp/p.tmp.$$
		 _passwd=`cat /tmp/p.tmp.$$`
		 rm -rf /tmp/p.tmp.$$
	
		 if [[ $_username = "" ]];then
		         _username='vtadmin'
		 fi
		 if [[ $_passwd = "" ]];then
		         _passwd='changeme'
		 fi
		 echo $_username:$_passwd >/etc/vtonf/.vtonf.shadow

#########################Reseting Default Configuration###########
	dialog --title "Resetting Default Configurations" --backtitle "$_dialog_backtitle "  \
                 --infobox " Please wait ...." 3 40
	{
	/usr/local/vtonf/vtonf/scripts/updatesettings
	}|dialog --title "Resetting Default Configurations " --backtitle "$_dialog_backtitle "  \
                 --infobox "Finishing Configurations ... Done " 3 40

#################################Restarting #######################
rm -rf /usr/local/vtonf/vtonf/tmp/*
/etc/init.d/vtonfd start
/etc/init.d/vtonfd restart
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo -n "Sending feedback ... "
echo " Vtonf installed on `date` " | mail -s "The vtonf notification" feedback@vtonf.com
echo "done"
echo "Vtonf control panel installation completed. Please login to the control panel from the following information"
echo "http://`hostname -i`:8001/"
echo "Login Name : $_username"
echo "Password : $_passwd"
echo ""
echo ""

cat <<EOF

	Visit our forum : http://www.vtonf.com/forum/index.php

	Get support : http://www.vtonf.com/support.html

EOF
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

