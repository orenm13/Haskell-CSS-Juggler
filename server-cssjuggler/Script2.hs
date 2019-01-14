{-# LANGUAGE OverloadedStrings #-}
module Script2 where

import Data.Text             (Text)
import Data.Text.Lazy hiding (Text)
import Clay

main :: IO Text
main = return
     . toStrict
     . render
     $ stylesheet


stylesheet :: Css
stylesheet = body ? do
    background blue
    color      red
    border     dashed (px 2) black

