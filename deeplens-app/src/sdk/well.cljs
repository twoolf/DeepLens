(ns api.well
  (:require-macros
   [cljs.core.async.macros :refer [go go-loop]])
  (:require
   [cljs-http.client :as http]
   [cljs.core.async :refer [<! chan]]
   [util.chan :as chan]))

;; API Reference
;; https://well-api.joinwell.com/docs/

(def api-root "https://well-api.joinwell.com/api/")

(defn endpoint [& path]
  (apply str api-root path))

(defn provider-home []
  (http/get (endpoint "provider/home")
            {; :with-credentials false
             :headers {"Accept" "application/json"}}))
#_
(chan/echo (provider-home))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn fetch-auth [{:keys [email password partnerid]
                   :as params}]
  (http/post (endpoint "auth")
             {:json-params params}))
#_
(->
 (fetch-auth {:email "provider@demo.com"
              :password "password"
              :partnerid 4})
 (chan/echo))

#_
(def oauth-token ;; can be retrieved with fetch-auth
  "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dlbGwtYXBpLmpvaW53ZWxsLmNvbS9hcGkvYXV0aCIsImlhdCI6MTUxNTg4NzgzNSwiZXhwIjoxNTE1ODk1MDM1LCJuYmYiOjE1MTU4ODc4MzUsImp0aSI6Im9Mb0JRcmx4eTl6aWpWVGIiLCJzdWIiOjF9.rQjjBp1tWyxUnwLYZcFZo57EcBPqJ4h01prfvogtT8M")

#_
(def oauth-token
  "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dlbGwtYXBpLmpvaW53ZWxsLmNvbS9hcGkvYXV0aCIsImlhdCI6MTUxNTgyODg0MSwiZXhwIjoxNTE1ODM2MDQxLCJuYmYiOjE1MTU4Mjg4NDEsImp0aSI6InpDQjBvdWNmTkVySzZNQnEiLCJzdWIiOjF9.muZJ_8LcI6uQgpISKQASmz-dFlYHDdbCptosXg4JaMQ")

(def oauth-token "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dlbGwtYXBpLmpvaW53ZWxsLmNvbS9hcGkvYXV0aCIsImlhdCI6MTUxNTk3MTg3OCwiZXhwIjoxNTE1OTc5MDc4LCJuYmYiOjE1MTU5NzE4NzgsImp0aSI6IjRmWkN0aVYzU1RDTndMM04iLCJzdWIiOjF9.--xgljOtQ7fG8L9hWnS3CAVC94ltNy798XJJMDiJWzc")

(def user-id "1")
(def partner-id "4")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PROVIDER API

(defn fetch-patients-list []
  (http/get (endpoint "provider/getAllPatient")
            {:with-credentials? false
             :oauth-token oauth-token
             :json-params nil}))

#_
(-> (fetch-patients-list)
    (chan/echo))

(defn fetch-patient [id]
  (http/get (endpoint "provider/getPatientById/" (str id))
            {:with-credentials? false
             :oauth-token oauth-token}))


#_
(-> (fetch-patient 5)
    (chan/echo))

(defn fetch-waiting-room-list [id]
  (http/get (endpoint "provider/getwaitingroom/" (str id))
            {; :channel (chan 1 (map :body))
             :with-credentials? false
             :oauth-token oauth-token}))

#_
(endpoint "provider/getwaitingroom/" 2)

#_
(-> (fetch-waiting-room-list 1)
    (chan/echo))

(defn fetch-providers-list [provider-id patient-id]
   (http/get (endpoint "providers/providerlist/"
                       (str provider-id) "/"
                       (str patient-id))
             {:channel (chan 1 (map :body))
              :json-params nil
              :with-credentials? false
              :oauth-token oauth-token}))

#_
(-> (fetch-providers-list 4 1)
    (chan/echo))
