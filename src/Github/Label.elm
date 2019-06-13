module Github.Label exposing (Label, Sort(..), decoder, search)

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


search : Int -> (Result Search.Error (Item Label) -> msg) -> Params Sort -> Cmd msg
search repository_id msg params =
    { params | misc = "&repository_id=" ++ String.fromInt repository_id }
        |> Search.search decoder sort "labels" msg


type Sort
    = Created
    | Updated


sort : Sort -> String
sort by =
    case by of
        Created ->
            "created"

        Updated ->
            "updated"


type alias Label =
    { id_ : Int -- 418327088
    , node_id : String -- "MDU6TGFiZWw0MTgzMjcwODg="
    , url : String -- "https://api.github.com/re...nguist/labels/enhancement"
    , name : Maybe String --  "enhancement"
    , color : Maybe String -- "84b6eb"
    , default : Maybe Bool -- true
    , description : Maybe String --  "New feature or request."
    , score : Float --  0.1193385
    }


decoder : Decoder Label
decoder =
    succeed Label
        |> required "id" int
        |> required "node_id" string
        |> required "url" string
        |> optional "name" string
        |> optional "color" string
        |> optional "default" bool
        |> optional "description" string
        |> required "score" float
