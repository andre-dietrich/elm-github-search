module Github.Topic exposing (Topic, decoder, search)

import Github.Item exposing (Item)
import Github.Json exposing (..)
import Github.Search as Search
import Github.Search.Params exposing (Params)
import Json.Decode
    exposing
        ( Decoder
        , bool
        , float
        , int
        , string
        , succeed
        )
import Json.Decode.Extra exposing (datetime)
import Time


search : (Result Search.Error (Item Topic) -> msg) -> Params () -> Cmd msg
search msg params =
    { params | sort = Nothing, order = Nothing, topics = [] }
        |> Search.search decoder (\_ -> "") "topics" msg


type alias Topic =
    { name : String -- "ruby"
    , display_name : String -- "Ruby"
    , short_description : Maybe String -- "Ruby is a scripting language ... "
    , description : Maybe String -- "Ruby was developed by Yukihiro \"Matz\" ..."
    , created_by : String -- "Yukihiro Matsumoto"
    , released : Maybe String -- "December 21, 1995"
    , created_at : Time.Posix -- "2016-11-28T22:03:59Z"
    , updated_at : Maybe Time.Posix -- "2017-10-30T18:16:32Z"
    , featured : Bool -- true
    , curated : Bool -- true
    , score : Float -- 1750.5872
    }


decoder : Decoder Topic
decoder =
    succeed Topic
        |> required "name" string
        |> required "display_name" string
        |> optional "short_description" string
        |> optional "description" string
        |> required "created_by" string
        |> optional "released" string
        |> required "created_at" datetime
        |> optional "updated_at" datetime
        |> required "featured" bool
        |> required "curated" bool
        |> required "score" float
