## Setting up a HUD for Raspberry Pi

This is a step by step of how I went from a new Raspberry Pi out of the box with a Raspbian OS to a HUD style display, that can be remotely controlled. 

default user is pi, with a password of raspberry

# updates for good measure
sudo apt-get update
sudo apt-get upgrade

# install chromium
Chromium on Raspberry get's a bad wrap for being slow, and it is.  It'l also easy to install, and does what I need.
sudo apt-get install chromium-browser ttf-mscorefonts-installer

# ruby 1.9 from rbenv

http://blog.pedrocarrico.net/post/29478085586/compiling-and-installing-ruby-on-the-raspberry-pi-using

I installed ruby by compiling from source because it's what I'm used to from work.  On the Raspberry Pi it takes a couple hours and is rather painful.
I have never had much success with the prebuilt debian ruby 1.9.x packages, you milage may vary.  Here are the steps I followed to get ruby installed via rbenv.

Install all the build libraries: 
sudo apt-get install vim tmux build-essential zlib1g-dev openssl libopenssl-ruby1.9.1 libssl-dev libruby1.9.1 libreadline-dev git 

Increase the swap space, because the build is a memory hog.

sudo dd if=/dev/zero of=swapfile bs=1M count=256
sudo swapoff /var/swap
sudo mkswap swapfile
sudo swapon swapfile

Increase the size of tempfs
sudo vi /etc/default/tmpfs
TMPFS_SIZE=1G

Change the memory_split under raspi-config to CPU 224/32 VRAM using:
sudo raspi-config
http://cl.ly/image/1m3Y1m0F1w1C
http://cl.ly/image/1i2C2y1I1L3I

At this point I rebooted. 

standard rbenv setup of ruby should work now:
https://gist.github.com/2627011

cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

mkdir -p ~/.rbenv/plugins
cd ~/.rbenv/plugins
git clone git://github.com/sstephenson/ruby-build.git
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 1.9.3-p194
rbenv global 1.9.3-p194
ruby -v

install bundler, just because
gem install bundler

you can also skip ever installing rdoc and ri
echo "gem: --no-ri --no-rdoc" > ~/.gemrc

I put the TMP_SIZE back to the default 20% after that: 
sudo vi /etc/default/tmpfs

TMPFS_SIZE=20%

# setup autologin
http://elinux.org/RPi_Debian_Auto_Login

sudo vi /etc/inittab

#1:2345:respawn:/sbin/getty --noclear 38400 tty1
1:2345:respawn:/bin/login -f pi tty1 </dev/tty1 >/dev/tty1 2>&1

Auto StartX (Run LXDE)

In Terminal:
sudo vi /etc/rc.local

Scroll to the bottom and add:
su pi -c startx

vi /etc/xdg/lxsession/LXDE/autostart
@lxpanel --profile LXDE
@pcmanfm --desktop --profile LXDE
@xscreensaver -no-splash
@usr/bin/chromium-browser --app=http://localhost:4567 --incognito


