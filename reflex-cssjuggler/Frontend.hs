#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/18.03.tar.gz -i ghcjs -p "(pkgs.haskell.packages.ghcjsHEAD.extend (self: super: with haskell; rec { exception-transformers = haskell.lib.doJailbreak (haskell.lib.dontCheck super.exception-transformers);   \"reflex\" = self.callPackage ({ mkDerivation, base, bifunctors, comonad, containers, criterion , data-default, deepseq, dependent-map, dependent-sum , exception-transformers, fetchgit, haskell-src-exts , haskell-src-meta, lens, loch-th, MemoTrie, monad-control, mtl , prim-uniq, primitive, process, random, ref-tf, reflection , semigroupoids, semigroups, split, stdenv, stm, syb , template-haskell, these, time, transformers, transformers-compat , unbounded-delays , ghcjs-base }: mkDerivation { pname = \"reflex\"; version = \"0.5\"; src = fetchgit { url = \"https://github.com/reflex-frp/reflex\"; sha256 = \"1lbsy7lycxg3g6nzxs57rhh851xj8b61jvnwmvc3acr70wcmdq3w\"; rev = \"5d9c8a00f2eb832f109c870963182149b988062a\"; }; configureFlags = [ \"-fexpose-all-unfoldings\" \"-f-use-template-haskell\" ]; libraryHaskellDepends = [ base bifunctors comonad containers data-default dependent-map dependent-sum exception-transformers haskell-src-exts haskell-src-meta lens MemoTrie monad-control mtl prim-uniq primitive random ref-tf reflection semigroupoids semigroups stm syb template-haskell these time transformers transformers-compat unbounded-delays ghcjs-base ]; testHaskellDepends = [ base bifunctors containers deepseq dependent-map dependent-sum lens mtl ref-tf semigroups split these transformers ]; benchmarkHaskellDepends = [ base containers criterion deepseq dependent-map dependent-sum loch-th mtl primitive process ref-tf split stm time transformers ]; jailbreak = true; doHaddock = false; doCheck = false; homepage = \"https://github.com/reflex-frp/reflex\"; description = \"Higher-order Functional Reactive Programming\"; license = stdenv.lib.licenses.bsd3; }) {}; \"reflex-dom-core\" = self.callPackage ({ mkDerivation, aeson, base, bifunctors, bimap, blaze-builder , bytestring, constraints, containers, contravariant, data-default , dependent-map, dependent-sum, dependent-sum-template, directory , exception-transformers, fetchgit, ghcjs-dom, hlint, jsaddle , jsaddle-warp, keycode, lens, linux-namespaces, monad-control, mtl , network-uri, primitive, process, ref-tf, reflex, semigroups , stdenv, stm, template-haskell, temporary, text, these , transformers, unix, zenc }: mkDerivation { pname = \"reflex-dom-core\"; version = \"0.4\"; src = fetchgit { url = \"https://github.com/reflex-frp/reflex-dom\"; sha256 = \"0fx9dmgzzvy42g5by6g1fgl6ma8qql9qln2kr27rjg36za3prmh0\"; rev = \"14f14464e29a36e473c0bc2a6933575aab8c1ab5\"; }; postUnpack = \"sourceRoot+=/reflex-dom-core; echo source root reset to $sourceRoot\"; libraryHaskellDepends = [ aeson base bifunctors bimap blaze-builder bytestring constraints containers contravariant data-default dependent-map dependent-sum dependent-sum-template directory exception-transformers ghcjs-dom jsaddle keycode lens monad-control mtl network-uri primitive ref-tf reflex semigroups stm template-haskell text these transformers unix zenc ]; testHaskellDepends = [ base hlint jsaddle jsaddle-warp linux-namespaces process reflex temporary unix ]; description = \"Functional Reactive Web Apps with Reflex\"; license = stdenv.lib.licenses.bsd3; }) {}; \"reflex-dom\" = self.callPackage ({ mkDerivation, base, bytestring, fetchgit , reflex, reflex-dom-core, stdenv, text }: mkDerivation { pname = \"reflex-dom\"; version = \"0.4\"; src = fetchgit { url = \"https://github.com/reflex-frp/reflex-dom\"; sha256 = \"0fx9dmgzzvy42g5by6g1fgl6ma8qql9qln2kr27rjg36za3prmh0\"; rev = \"14f14464e29a36e473c0bc2a6933575aab8c1ab5\"; }; postUnpack = \"sourceRoot+=/reflex-dom; echo source root reset to $sourceRoot\"; isLibrary = true; isExecutable = true; libraryHaskellDepends = [ base bytestring reflex reflex-dom-core text ]; description = \"Functional Reactive Web Apps with Reflex\"; license = stdenv.lib.licenses.bsd3; }) {}; \"jsaddle\" = self.callPackage ({ mkDerivation, aeson, attoparsec, base, base64-bytestring , bytestring, containers, deepseq, exceptions, fetchgit, filepath , ghc-prim, http-types, lens, primitive, process, random, ref-tf , scientific, stdenv, stm, text, time, transformers, unliftio-core , unordered-containers, vector , ghcjs-base }: mkDerivation { pname = \"jsaddle\"; version = \"0.9.4.0\"; src = fetchgit { url = \"https://github.com/ghcjs/jsaddle\"; sha256 = \"143r9nfglkydhp6rl0qrsyfpjnxfj04fhn96cf8hkx2mk09baa01\"; rev = \"6a8fbe20cfd4ea00e197acdf311a650b97cb9a61\"; }; postUnpack = \"sourceRoot+=/jsaddle; echo source root reset to $sourceRoot\"; libraryHaskellDepends = [ aeson attoparsec base base64-bytestring bytestring containers deepseq exceptions filepath ghc-prim http-types lens primitive process random ref-tf scientific stm text time transformers unliftio-core unordered-containers vector ghcjs-base ]; description = \"Interface for JavaScript that works with GHCJS and GHC\"; license = stdenv.lib.licenses.mit; }) {}; })).ghcWithPackages (ps: with ps; [exception-transformers jsaddle reflex reflex-dom reflex-dom-core])"

{-# LANGUAGE PackageImports #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE JavaScriptFFI #-}

import           "base"       Control.Monad.IO.Class (liftIO)
import           "base"       Data.Maybe
import qualified "containers" Data.Map as M
import           "aeson"      Data.Aeson (decodeStrict)
import           "bytestring" Data.ByteString.Char8 as B8 (ByteString)
import           "text"       Data.Text                   (Text)
import           "ghcjs-base" GHCJS.Types (JSVal)
import           "ghcjs-base" GHCJS.Marshal (toJSVal_aeson)
import           "reflex"     Reflex
import           "reflex-dom" Reflex.Dom


main :: IO ()
main = mainWidget $ do
    elAttr' "script" ("src" =: "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js") blank
    cssjuggler


cssjuggler :: forall t m. (MonadWidget t m) => m ()
cssjuggler = do
    let unused = ["" :: Text] <$ never
    ws <- webSocket "ws://localhost:9160" $ def & webSocketConfig_send .~ unused
    let (bsE :: Event t ByteString) = _webSocket_recv ws
    let mapE = fromJust . decodeStrict <$> bsE
    mapD <- holdDyn M.empty mapE

    ------------------------------
    -- magic
    -- choose "next" from map
    (nextE :: Event t ()) <- button "Next"
    counterD :: Dynamic t Integer <-  count nextE
    let filepathCSSTupleD = assocAtIndex <$> mapD
                                         <*> counterD
    -- magic
    ------------------------------

    let filepathD :: Dynamic t FilePath = fst <$> filepathCSSTupleD
    let cssD      :: Dynamic t Text     = snd <$> filepathCSSTupleD
    let cssE = updated cssD :: Event t Text

    {-display filepathD-}
    performEvent_ $ ffor cssE $ \css -> liftIO $ do
        injectStylesheet css

    el "hr" blank
    return ()
    where
        assocAtIndex :: M.Map FilePath Text -> Integer -> (FilePath, Text)
        assocAtIndex m idx = selected
            where
                list_ :: [(FilePath, Text)]
                list_ = M.toList m

                index :: Int
                index = fromInteger idx `mod` length list_

                selected :: (FilePath, Text)
                selected = if null list_
                           then ("", "")
                           else list_ !! index


injectStylesheet :: Text -> IO ()
injectStylesheet css = do
    js_css <- toJSVal_aeson css
    print css
    js_injectStylesheet js_css


foreign import javascript unsafe
    "(function() {                                                                          \
    \   var div = jQuery('<div />', {html: '&shy;<style>' + $1 + '</style>'}).appendTo('body');  \
    \}){}"
    js_injectStylesheet :: JSVal
                        -- ^ CSS text
                        -> IO ()
