(list (channel
        (name 'guix-cran)
        (url "https://github.com/guix-science/guix-cran.git")
        (branch "master")
        (commit
          "963e4b0d66834f0f1bf3fc4b6b7b4bf323266359"))
      (channel
        (name 'guix-hpc)
        (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
        (branch "master")
        (commit
          "971f60b2854afb8b7dff77096c0f0f3149ee5070"))
      (channel
        (name 'guix-bioc)
        (url "https://github.com/guix-science/guix-bioc.git")
        (branch "master")
        (commit
          "5a63fc722773efa87cb56e89dc88804726b95728"))
      ;(channel
      ;  (name 'jgbabyn-guix-misc)
      ;  (url "https://github.com/jgbabyn/guix-misc.git")
      ;  (branch "main")
      ;  (commit
      ;    "3af426959e245e644ac9d2e281f50ffd3339e74c"))
      (channel
        (name 'guix-science)
        (url "https://codeberg.org/guix-science/guix-science.git")
        (branch "master")
        (commit
          "7304e37d4d664f27a18577e388c91413878d62fc")
        (introduction
          (make-channel-introduction
            "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
            (openpgp-fingerprint
              "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
      (channel
        (name 'guix-science-nonfree)
        (url "https://codeberg.org/guix-science/guix-science-nonfree.git")
        (branch "master")
        (commit
          "0505db27f162053bc917f527ec4026bec9031dff")
        (introduction
          (make-channel-introduction
            "58661b110325fd5d9b40e6f0177cc486a615817e"
            (openpgp-fingerprint
              "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
      (channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        (branch "master")
        (commit
          "b10ce47d8be5b6c15987f4e1d93b3bd71b1eb220")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
      (channel
        (name 'guix-past)
        (url "https://codeberg.org/guix-science/guix-past.git")
        (branch "master")
        (commit
          "f99ada4123de1eadf668d34dac2d726407634549")
        (introduction
          (make-channel-introduction
            "0c119db2ea86a389769f4d2b9c6f5c41c027e336"
            (openpgp-fingerprint
              "3CE4 6455 8A84 FDC6 9DB4  0CFB 090B 1199 3D9A EBB5")))))
