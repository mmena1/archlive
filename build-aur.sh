#!/bin/zsh

# Pull the packages in from a more human readable file
#packages=("${(@f)$(cat aur.list)}")
readarray -t packages <aur.list

# Clean everything up
if [[ -d ./aur-repo/packages ]]; then
	if [[ -e ./aur/repo/packages/* ]]; then
		rm -rf ./aur-repo/*
	fi
else
	mkdir ./aur-repo
	mkdir ./aur-repo/packages
fi

if [[ -d ./aur-repo/x86_64 ]]; then
	if [[ -e ./aur-repo/x86_64/* ]]; then
		rm -rf ./aur-repo/x86_64/*
	fi
else
	mkdir ./aur-repo/x86_64
fi

if [[ -d ./aur-repo/i686 ]]; then
	if [[ -e ./aur-repo/i686/* ]]; then
		rm -rf ./aur-repo/i686/*
	fi
else
	mkdir ./aur-repo/i686
fi

# Move to our working directory
cd aur-repo/packages

for p in ${packages[@]}; do
	# Grab the most recent packages
	if [ ! -f $p.tar.gz ]; then
		wget https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz

		# Unpackage the compressed packages
		tar -xvf $p.tar.gz
	fi
	# Make the Arch packages
	if [[ -d "$p" ]]; then
		cd $p
		makepkg -s --noconfirm --config ../../../makepkg64.conf && mv -f *.pkg.tar.xz ../../x86_64
		#linux32 makepkg --config ../../../makepkg32.conf && mv *.pkg.tar.xz ../../i686
		cd ..
	fi
done

# Add the Arch packages to the repositories
cd ..
if [[ ! -e ./x86_64/*.pkg.tar.xz ]]; then
	repo-add -n ./x86_64/customrepo.db.tar.gz ./x86_64/*.pkg.tar.xz
fi

if [[ ! -e ./i686/*.pkg.tar.xz ]]; then
	repo-add -n ./i686/customrepo.db.tar.gz ./i686/*.pkg.tar.xz
fi
