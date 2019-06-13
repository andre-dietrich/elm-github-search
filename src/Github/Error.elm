module Github.Error exposing (Error, decoder, toString)

import Json.Decode
    exposing
        ( Decoder
        , field
        , list
        , map3
        , maybe
        , string
        , succeed
        )


type alias Error =
    { message : String -- "Validation Failed"
    , errors : Maybe (List Detail)
    , documentation_url : String -- "https://developer.github.com/v3/search"
    }


type alias Detail =
    { resource : String -- "Search"
    , field : String -- "q"
    , code : String -- "missing"
    }


decoder : Decoder Error
decoder =
    map3 Error
        (field "message" string)
        (maybe <| field "errors" details)
        (field "documentation_url" string)


details : Decoder (List Detail)
details =
    list <|
        map3 Detail
            (field "resource" string)
            (field "field" string)
            (field "code" string)


toString : Error -> String
toString err =
    err.errors
        |> Maybe.withDefault []
        |> List.map detailToString
        |> String.concat
        |> (++) ("message: " ++ err.message)


detailToString detail =
    "resource: "
        ++ detail.resource
        ++ "; field: "
        ++ detail.field
        ++ "; code: "
        ++ detail.code
        ++ "\n"
