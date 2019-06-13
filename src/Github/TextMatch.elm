module Main exposing (Match, TextMatch)

import Github.Json exposing (optional, required)
import Json.Decode exposing (Decoder, int, list, string, succeed)


type alias Match =
    { text : String
    , indices : List Int
    }


type alias TextMatch =
    { object_url : Maybe String -- "https://api.github.com/repositories/215..."
    , object_type : Maybe String -- "Issue"
    , property : Maybe String -- "body"
    , fragment : Maybe String -- "comprehensive windows font I know of).\n\..."
    , matches : List Match
    }


match : Decoder Match
match =
    succeed Match
        |> required "text" string
        |> required "indices" (list int)


decoder : Decoder TextMatch
decoder =
    succeed TextMatch
        |> optional "object_url" string
        |> optional "object_type" string
        |> optional "property" string
        |> optional "fragment" string
        |> required "matches" (list match)
