(ns sdk.web3
  (:require-macros
   [cljs.core.async.macros :refer [go go-loop]])
  (:require
   [cljs.core.async :refer [<! >! chan]]
   [taoensso.timbre :as timbre]
   [cljsjs.web3]
   [cljs-web3.bzz :as web3-bzz]
   [cljs-web3.core :as web3]
   [cljs-web3.db :as web3-db]
   [cljs-web3.eth :as web3-eth]
   [cljs-web3.async.eth :as async-eth]
   [cljs-web3.evm :as web3-evm]
   [cljs-web3.net :as web3-net]
   [cljs-web3.personal :as web3-personal]
   [cljs-web3.settings :as web3-settings]
   [cljs-web3.shh :as web3-shh]
   [cljs-web3.async.eth :as web3-eth-async]))

;; Ethereum blockchain interface
;; https://github.com/district0x/cljs-web3
;;
;; Dependencies:
;; [cljs-web3 "0.19.0-0-9"][district0x.re-frame/web3-fx "1.0.3"]

;; curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545

; (set! js/window nil)

(def web3 (web3/create-web3 "http://localhost:8545/"))

(defn callback [error result]
  (if error
    (timbre/error error)
    (timbre/info "=>" (pr-str result))))

(defn echo [ch]
  (go-loop [value (<! ch)]
    (timbre/info value)))

(defn result-handler [f]
  (fn [error result]
    (if error
      (timbre/error error)
      (do
        (timbre/info "=>" (pr-str result))
        (f result)))))

#_
(web3/version-api web3)

#_
(web3/connected? web3)

#_
(web3/sha3 "hello")

#_
(web3-personal/new-account
 web3
 "myveryprivatesecret!"
 callback)

#_
(web3-eth/accounts web3 callback)

#_
(web3-eth/default-account web3 callback)

#_
(web3-eth/coinbase web3 #(timbre/info (pr-str %)))

#_
(web3-eth/coinbase web3 callback)

#_
(web3-eth/hashrate web3 callback)

(defn coinbase-balance [callback]
  ;; not using async leads to callback hell...
  (web3-eth/coinbase
   web3
   (result-handler
    (fn [res]
     (when res
      (web3-eth/get-balance
       web3
       res
       "ether"
       (result-handler
        (fn [res]
         (web3/from-wei web3 res callback)))))))))

#_
(coinbase-balance list)

(defn fetch-coinbase-balance []
  (go
   (->> (async-eth/coinbase web3)
        (<!)
        (second)
        (async-eth/get-balance web3)
        (<!)
        (second)
        (#(web3/from-wei % "ether")))))

#_
(echo (fetch-coinbase-balance))
