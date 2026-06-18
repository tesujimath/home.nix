(local coroutine (require :coroutine))
(local jeejah (require :jeejah))

(fn hello [] "Hello Fennel in Spacehammer world!"
  (hs.alert.show "Simon was here in sjg-repl Fennel module 6"))

(local repl-coro-freq 0.05)

(fn start-jeejah [] "Start JeeJah REPL"
  (let [repl-coro (coroutine.create (fn [] (jeejah.start {})))
        repl-spin (fn [] (coroutine.resume repl-coro))
        repl-chk (fn [] (not= (coroutine.status repl-coro) "dead"))]
    (hs.alert.show "Starting Jeejah")
    (hs.timer.doWhile repl-chk repl-spin repl-coro-freq)
    (hs.alert.show "Started Jeejah")))



(require :hs.ipc)
(local fennel (require :fennel))

(fn install_fennel_repl []
  (let [coro (coroutine.create fennel.repl.repl)]
    (coroutine.resume coro {:readChunk (fn []
                                         (let [input (coroutine.yield)]
                                           (.. input "\n")))
                            :onValues (fn [xs]
                                        (print (table.concat xs "\t")))
                            :onError (fn [_ msg]
                                       (print msg))})
    (set hs._consoleInputPreparser (fn [s]
                                     (coroutine.resume coro s)
                                     ""))))


{: hello
 : start-jeejah
 : install_fennel_repl}
