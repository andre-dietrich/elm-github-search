module Github.Code exposing
    ( Code
    , Sort(..)
    , decoder
    , search
    )

import Github.Item exposing (Item)
import Github.Json exposing (required)
import Github.Repository as Repository exposing (Repository)
import Github.Search as Search
import Github.Search.Params exposing (Params)
import Json.Decode exposing (Decoder, float, string, succeed)


search : (Result Search.Error (Item Code) -> msg) -> Params Sort -> Cmd msg
search =
    Search.search decoder sort "code"


type Sort
    = Indexed


sort : Sort -> String
sort _ =
    "indexed"


type alias Code =
    { name : String -- "classes.js"
    , path : String -- "src/attributes/classes.js"
    , sha : String -- "d7212f9dee2dcc18f084d7df8f417b80846ded5a"
    , url : String -- "https://api.github...3694e0cd23ee74895fd5aeb535b27da4"
    , git_url : String -- "https://api.github...cc18f084d7df8f417b80846ded5a"
    , html_url : String -- "https://github...27da4/src/attributes/classes.js"
    , repository : Repository
    , score : Float -- 0.5269679
    }


decoder : Decoder Code
decoder =
    succeed Code
        |> required "name" string
        |> required "path" string
        |> required "sha" string
        |> required "url" string
        |> required "git_url" string
        |> required "html_url" string
        |> required "repository" Repository.decoder
        |> required "score" float
