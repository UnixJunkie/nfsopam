#!/bin/bash

# make opam usable (faster) even if your $HOME is on top of NFS
# by using /tmp (usually a local disk) for most operations

set -x # debug

# sync ~/.opam to local disk
opam clean
tmp_dot_opam=/tmp/${USER}_dot_opam
rsync -q ~/.opam/* $tmp_dot_opam
mv -f ~/.opam ~/.opam.old

# use it
ln -s $tmp_dot_opam ~/.opam

# really call opam
opam "$@"

# sync back to home on NFS
opam clean
\rm ~/.opam
mv ~/.opam.old ~/.opam
rsync -q $tmp_dot_opam/* ~/.opam
