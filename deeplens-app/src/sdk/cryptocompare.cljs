(ns sdk.cryptocompare
  (:require-macros
   [cljs.core.async.macros
    :refer [go go-loop]])
  (:require
   [cljs.core.async :as async
    :refer [chan <! >! put! close! timeout promise-chan]]
   [cljs-http.client :as http]
   [taoensso.timbre :as timbre]
   [util.chan :as chan]))

;; Getting cryptocurrency pricing, OHLC and volume data from multiple exchanges.
;; https://www.cryptocompare.com/api/#introduction

(defn fetch-crypto-prices []
  (http/get "https://min-api.cryptocompare.com/data/pricemulti"
            {:with-credentials? false
             :channel (chan 1 (map :body))
             :query-params {"fsyms" "BTC,ETH,LTC"
                            "tsyms" "USD"}}))

#_
(-> (fetch-crypto-prices)
    (chan/echo))
