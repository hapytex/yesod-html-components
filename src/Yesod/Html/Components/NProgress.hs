{-# LANGUAGE OverloadedStrings, QuasiQuotes #-}

module Yesod.Html.Components.NProgress where

import Css.Selector(SelectorGroup, csssel)

import Data.Aeson(ToJSON(toJSON), object, (.=))
import Data.Default(Default(def))
import Data.Text(Text)

import Text.Julius(JavascriptUrl, ToJavascript(toJavascript))

import Yesod.Core(MonadWidget, hamlet, julius)
import Yesod.Core.Widget(addStylesheetRemote, toWidgetBody, toWidgetHead)

jsFile :: Text
jsFile = "https://unpkg.com/nprogress@0.2.0/nprogress.js"

cssFile :: Text
cssFile = "https://unpkg.com/nprogress@0.2.0/nprogress.css"

cssFileInclude :: MonadWidget m => m ()
cssFileInclude = addStylesheetRemote cssFile

jsFileInclude :: MonadWidget m => m ()
jsFileInclude = toWidgetHead [hamlet|<script language=javascript src=#{jsFile}>|]

startDoneProgress :: JavascriptUrl url
startDoneProgress = [julius|NProgress.start();NProgress.done();|]

configureProgress :: NProgressConfig -> JavascriptUrl url
configureProgress npc = [julius|NProgress.configure(#{npc});|]

data NProgressConfig = NProgressConfig { minimum :: Float, trickle :: Bool, trickleSpeed :: Int, showSpinner :: Bool, parent :: SelectorGroup }

instance ToJSON NProgressConfig where
    toJSON (NProgressConfig mn t ts ss p) = object [
        "minimum" .= mn,
        "trickle" .= t,
        "trickleSpeed" .= ts,
        "showSpinner" .= ss,
        "parent" .= p
      ]

instance ToJavascript NProgressConfig where
    toJavascript = toJavascript . toJSON

instance Default NProgressConfig where
    def = NProgressConfig 0.08 True 200 True [csssel|body|]

nProgressWidget :: MonadWidget m => m ()
nProgressWidget = cssFileInclude >> jsFileInclude >> toWidgetBody startDoneProgress

nProgressWidgetConfig :: MonadWidget m => NProgressConfig -> m ()
nProgressWidgetConfig npc = cssFileInclude >> jsFileInclude >> toWidgetBody (configureProgress npc <> startDoneProgress)
