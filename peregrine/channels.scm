(list  (channel
        (name 'boisestate-variants)
        (url "https://github.com/bsurc/guix.git")
        (branch "main"))
      (channel
        (name 'guix-cran)
        (url "https://github.com/guix-science/guix-cran.git")
        (branch "master")
        (commit
          "466d876bcc15a1a6c2053eb150548f7f471f75b7"))
      (channel
        (name 'guix-science)
        (url "https://github.com/guix-science/guix-science.git")
        (branch "master")
        (commit
          "7c6ca7e1c19c92bfe5e6add688662e08b07db2bf")
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
          "d616e85ac8a380d5126da3184f7037c20866c884")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))
