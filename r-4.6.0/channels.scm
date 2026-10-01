(list (channel
       (name 'guix-cran)
       (url "https://github.com/guix-science/guix-cran.git")
       (branch "master")
       (commit "ddc801e45eadbd55a83cc5076d375b2cae08a7bb"))
      (channel
       (name 'guix-hpc)
       (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
       (branch "master")
       (commit "736e1e54a455b42633a7aed33b1f9400800493a6"))
      (channel
       (name 'guix-bioc)
       (url "https://github.com/guix-science/guix-bioc.git")
       (branch "master")
       (commit "efa3f927fa279abcde9b735f2a0583395145431f"))
      (channel
       (name 'guix)
       (url "https://git.guix.gnu.org/guix.git")
       (branch "master")
       (commit "42ab6a3899550800002531b4603e59fa5c90a37d")
       (introduction
        (make-channel-introduction
         "9edb3f66fd807b096b48283debdcddccfea34bad"
         (openpgp-fingerprint
          "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
      (channel
       (name 'guix-science)
       (url "https://codeberg.org/guix-science/guix-science.git")
       (branch "master")
       (commit "b4ba7cd1d7b7271b4825f033b20a4d0281796062")
       (introduction
        (make-channel-introduction
         "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
         (openpgp-fingerprint
          "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446")))))
