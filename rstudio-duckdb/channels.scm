(list (channel
        (name 'guix-cran)
        (url "https://github.com/guix-science/guix-cran.git")
        (branch "master")
        (commit
          "f1676a22dadb99972874432cce3af4216cee4637"))
      (channel
        (name 'guix-hpc)
        (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
        (branch "master")
        (commit
          "b9f9d59f2d9e5c7c07dc3b18363fccfcbde3e775"))
      (channel
        (name 'guix-bioc)
        (url "https://github.com/guix-science/guix-bioc.git")
        (branch "master")
        (commit
          "ef7e9ed83ace31bbab5a8ffa71f94d30fed82fe8"))
      (channel
        (name 'guix-science)
        (url "https://github.com/guix-science/guix-science.git")
        (branch "master")
        (commit
          "df4649af69966b433113a9dd53b81b446786a0ff")
        (introduction
          (make-channel-introduction
            "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
            (openpgp-fingerprint
              "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
      (channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        (branch "master")
        (commit
          "7fa9df431e9423e2b79c8c520de1d0ef7aed910d")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))
