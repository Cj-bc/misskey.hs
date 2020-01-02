{-# LANGUAGE OverloadedStrings #-}
module Main where
import Text.Show.Unicode (ushow)
import System.Environment (getArgs)
import Network.HTTP.Client
import Network.HTTP.Simple
import Network.Misskey.Type
import qualified Network.Misskey.Api.Users.Notes as UN
import qualified Network.Misskey.Api.Users.Show as USh
import Lens.Simple ((^.))
import Options.Applicative
import Options.Applicative.Types (readerAsk)



wrapWithJustReader :: ReadM (Maybe String)
wrapWithJustReader = readerAsk >>= (\x -> return $ Just (read x))

usersShowParser :: Parser USh.APIRequest
usersShowParser = USh.UserId    <$> strOption       (long "id"       <> metavar "USER-ID"    <> help "Specify target with user id")
              <|> USh.UserIds   <$> some (strOption (long "ids"      <> metavar "USER-IDs"   <> help "Specify list of target user ids"))
              <|> USh.UserName  <$> strOption       (long "username" <> metavar "USER-NAME"  <> help "Specify target with user name")
                                    <*> option wrapWithJustReader
                                              (long "host" <> metavar "HOST" <> value Nothing <> help "Specify host instance that target user is on")

usersShowInfo :: ParserInfo USh.APIRequest
usersShowInfo = Options.Applicative.info (usersShowParser <**> helper) (fullDesc <> progDesc "call users/show API")


parser = subparser (command "users/show" (usersShowInfo))

main :: IO ()
main = do
    apiRequest <- execParser (Options.Applicative.info (parser <**> helper) (fullDesc <> progDesc "call users/show API"))
    let env = MisskeyEnv "" $ "https://" ++ "virtual-kaf.fun"
    print "========== users/show =========="
    response <- runMisskey (USh.usersShow apiRequest) env
    case response of
        Left er   -> print $ "Error occured while users/show: " ++ ushow er
        Right usr -> (putStrLn . ushow) usr

