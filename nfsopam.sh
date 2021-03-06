#! /usr/bin/env bash

# make opam usable (faster) even if your $OPAMROOT is on top of NFS
# by using /tmp (usually a local disk) for most operations

#set -x # debug

# determine the opam's root
OPAMROOT=${OPAMROOT:-$HOME/.opam} # env. var. or default

# sync $OPAMROOT to local disk
opam clean
tmp_dot_opam=/tmp/${USER}_dot_opam
echo "nfsopam: rsync to /tmp ..."
rsync -a --info=progress2 $OPAMROOT/ $tmp_dot_opam
mv -f $OPAMROOT $OPAMROOT.old

# use it
ln -s $tmp_dot_opam $OPAMROOT

# really call opam
opam "$@"

# sync back to home on NFS
opam clean
\rm $OPAMROOT
mv $OPAMROOT.old $OPAMROOT
echo "nfsopam: rsync from /tmp..."
rsync -a --info=progress2 $tmp_dot_opam/ $OPAMROOT
