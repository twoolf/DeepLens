(ns app.view.page
  (:require-macros
   [kioo.reagent
    :refer [defsnippet deftemplate snippet]])
  (:require
   [kioo.reagent
    :refer [html-content content append after set-attr do->
            substitute listen unwrap]]
   [reagent.core :as reagent
    :refer [atom]]
   [reagent.dom.server
    :refer [render-to-string]]
   [goog.string :as gstring]
   [app.view.view
    :refer [view]]))

(defn script-element [src]
  [:script
     (if (map? src)
       src
       {:dangerouslySetInnerHTML
        {:__html src}})])

(defsnippet page "template.html" [:html]
  [state & {:keys [scripts title forkme]}]
  {[:head :title] (if title (content title) identity)
   [:main] (content [view state])
   [:#forkme] (if forkme identity (content nil))
   [:body] (append [:div (for [[ix src] (map-indexed vector scripts)]
                           ^{:key (str ix)}
                           (script-element src))])})

(defn html5 [content]
  (->> (render-to-string content)
       (str "<!DOCTYPE html>\n")))
