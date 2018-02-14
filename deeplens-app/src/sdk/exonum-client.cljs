(ns api.exonum-client)

;; See https://github.com/exonum/exonum-client
;; NPM dependencies:
;; [exonum-client "0.3.0"][keythereum "1.0.2"][solc "0.4.19"]

(def Exonum (js/require "exonum-client"))

#_
(.hash Exonum #js[0 255 16 8])

(defn new-type [params]
  (.newType Exonum (clj->js params)))

(defn new-message [params]
  (.newMessage Exonum (clj->js params)))

(def User
  (new-type {:size 9
             :fields {:name {:type Exonum.String :size 8 :from 0 :to 8}
                      :age {:type Exonum.Int8 :size 1 :from 8 :to 9}}}))

(def user-data {:name "Tom" :age 34})

(defn serialize-user [data]
  (.serialize User (clj->js data)))

#_
(serialize-user user-data)

(defn hash-user [data]
  (.hash Exonum (clj->js data) User))

#_
(hash-user user-data)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRYPTOCURRENCY

(defn Payment [{:keys [amount from to] :as transaction}]
  (new-message {:size 72
                :fields {:from {:type Exonum.Hash :size 32 :from 0 :to 32}
                         :to {:type Exonum.Hash :size 32 :from 32 :to 64}
                         :amount {:type Exonum.Uint64 :size 8 :from 64 :to 72}}}))
