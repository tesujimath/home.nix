(print "init.fnl arguments received:" ...)
(local args (. [...] 1))
(local fennel (. args :fennel))
(local hs (. args :hs))
(local hs_fennel_libdir (. args :hs_fennel_libdir))

(each [file (hs.fs.dir hs_fennel_libdir)]
  (if (string.match file "%.fnl$")
      (fennel.dofile (.. hs_fennel_libdir "/" file) {} { "hs" hs })))

(hs.alert.show "Hammerspoon Fennel config loaded")
