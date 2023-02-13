{-# Language TemplateHaskell #-}
{-# Language OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-|
Module      : Web.Misskey.Api.Notes.Timeline
Description : Misskey API Endpoint and Request for notes/timeline
Copyright   : (c) Cj.bc_sd a.k.a Cj-bc, 2020
Maintainer  : cj.bc-sd@outlook.jp
Stability   : experimental

Call `notes/timeline` Misskey API
-}
module Web.Misskey.Api.Notes.Timeline
( APIRequest(APIRequest)
, notesTimeline

-- ** Lenses for APIRequest
, limit, sinceId, untilId, sinceDate, untilDate
, includeMyRenotes, includeRenotedMyNotes
, includeLocalRenotes, withFiles
) where

import RIO
import Data.Time (UTCTime)
import Control.Lens (makeLenses)
import Web.Misskey.Type
import Web.Misskey.Api.Internal
import Data.Aeson (ToJSON(..), object)

data APIRequest = APIRequest { _limit                 :: Maybe Int -- [1..100]
                             , _sinceId               :: Maybe String
                             , _untilId               :: Maybe String
                             , _sinceDate             :: Maybe UTCTime
                             , _untilDate             :: Maybe UTCTime
                             , _includeMyRenotes      :: Bool
                             , _includeRenotedMyNotes :: Bool
                             , _includeLocalRenotes   :: Bool
                             , _withFiles             :: Bool
                             }
makeLenses ''APIRequest

-- | This can't be auto-generate because I need to convert 'UTCTime' to 'EpochTime', which
-- default 'ToJSON' doesn't do
instance ToJSON APIRequest where
  toJSON req = object body
    where
        limitBody                 = createMaybeObj   "limit"                 (req^.limit)
        sinceIdBody               = createMaybeObj   "sinceId"               (req^.sinceId)
        untilIdBody               = createMaybeObj   "untilId"               (req^.untilId)
        sinceDateBody             = createUTCTimeObj "sinceDate"             (req^.sinceDate)
        untilDateBody             = createUTCTimeObj "untilDate"             (req^.untilDate)
        includeMyRenotesBody      = createObj        "includeMyRenotes"      (req^.includeMyRenotes)
        includeRenotedMyNotesBody = createObj        "includeRenotedMyNotes" (req^.includeRenotedMyNotes)
        includeLocalRenotesBody   = createObj        "includeLocalRenotes"   (req^.includeLocalRenotes)
        withFilesBody             = createObj        "withFiles"             (req^.withFiles)
        body                      = mconcat [ limitBody, sinceIdBody, untilIdBody
                                            , sinceDateBody, untilDateBody, includeMyRenotesBody
                                            , includeRenotedMyNotesBody, includeLocalRenotesBody, withFilesBody
                                            ]
  
notesTimeline :: (HasMisskeyEnv env) => APIRequest -> RIO env [Note]
notesTimeline = postRequest "/api/notes/timeline" . toJSON
