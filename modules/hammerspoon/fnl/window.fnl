(print "window.fnl arguments received:" ...)
(local args (. [...] 1))
(local hs (. args :hs))

;; Simple hotkey to move focused window to left half of the screen
(hs.hotkey.bind [:ctrl :alt] :H
                (fn []
                  (let [win (hs.window.focusedWindow)]
                    (when win
                      (win:moveToUnit hs.layout.left50)))))
