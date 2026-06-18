(local coroutine (require :coroutine))
(local jeejah (require :jeejah))

(fn hello [] "Hello Fennel in Spacehammer world!"
  (hs.alert.show "Simon was here in sjg-repl Fennel module 4"))

(local repl-coro-freq 0.05)

(fn start [] "Start JeeJah REPL"
  (let [repl-coro (coroutine.create (fn [] (jeejah.start {})))
        repl-spin (fn [] (coroutine.resume repl-coro))
        repl-chk (fn [] (not= (coroutine.status repl-coro) "dead"))]
    (hs.alert.show "Starting Jeejah")
    (hs.timer.doWhile repl-chk repl-spin repl-coro-freq)
    (hs.alert.show "Started Jeejah")))

{:hello hello
 :start start}
