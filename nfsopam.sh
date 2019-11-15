#! /usr/bin/env bash

# make opam usable (faster) even if your $OPAMROOT is on top of NFS
# by using /tmp (usually a local disk) for most operations

set -x # debug

# determine the $OPAMROOT
for i in $(seq $#); do
    case ${!i} in
	--root=*)
	    OPAMROOT=${!i#*=};;
	--root)
	    (( i += 1 ))
	    OPAMROOT=${!i};;
    esac
done
OPAMROOT=${OPAMROOT:-$HOME/.opam}

# sync $OPAMROOT to local disk
opam clean
tmp_dot_opam=/tmp/${USER}_dot_opam
rsync -qa $OPAMROOT/ $tmp_dot_opam
mv -f $OPAMROOT $OPAMROOT.old

# use it
ln -s $tmp_dot_opam $OPAMROOT

# really call opam
opam "$@"

# sync back to home on NFS
opam clean
\rm $OPAMROOT
mv $OPAMROOT.old $OPAMROOT
rsync -qa $tmp_dot_opam/ $OPAMROOT
