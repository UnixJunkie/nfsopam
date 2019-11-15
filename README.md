# nfsopam
wrapper shell script to run opam faster when your $HOME is served via NFS

Make opam run faster even if your $HOME is on top of NFS by using /tmp
(i.e. the local disk) for most operations.
The opam root (~/.opam by default) is first rsynced to the local disk,
then synchronized back to its original location once opam has finished.
