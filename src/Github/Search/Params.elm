module Github.Search.Params exposing
    ( Order(..)
    , Params
    , add_header
    , add_qualifier
    , add_topic
    , empty
    , order
    , query
    , sort
    , toString
    )

import Http
import Url exposing (percentEncode)


type alias Params s =
    { sort : Maybe s
    , order : Maybe Order
    , q : List String
    , topics : List String
    , qualifiers : List String
    , misc : String
    , headers : List Http.Header
    }


type Order
    = Asc
    | Desc


empty : Params s
empty =
    Params Nothing Nothing [] [] [] "" []


add_topic : String -> Params s -> Params s
add_topic str p =
    { p | topics = str :: p.topics }


add_qualifier : String -> Params s -> Params s
add_qualifier str p =
    { p | qualifiers = str :: p.qualifiers }


query : String -> Params s -> Params s
query str p =
    { p | q = String.split " " str }


order : Order -> Params s -> Params s
order by p =
    { p | order = Just by }


sort : s -> Params s -> Params s
sort by p =
    { p | sort = Just by }


add_header : String -> String -> Params s -> Params s
add_header key value p =
    { p | headers = Http.header key value :: p.headers }


queryToString : Params s -> String
queryToString params =
    (params.q
        |> List.map percentEncode
        |> String.join "+"
        |> (++) "q="
    )
        ++ topicsToString params.topics
        ++ qualifiersToString params.qualifiers


topicsToString : List String -> String
topicsToString list =
    if List.isEmpty list then
        ""

    else
        list
            |> List.map (percentEncode >> (++) "topic:")
            |> String.join "+"
            |> (++) "+"


qualifiersToString : List String -> String
qualifiersToString list =
    if List.isEmpty list then
        ""

    else
        list
            |> List.map percentEncode
            |> String.join "+"
            |> (++) "+"


orderToString : Params a -> String
orderToString params =
    case params.order of
        Nothing ->
            ""

        Just Asc ->
            "&order=asc"

        Just Desc ->
            "&order=desc"


sortToString : (a -> String) -> Params a -> String
sortToString fn params =
    case params.sort of
        Nothing ->
            ""

        Just s ->
            "&sort=" ++ fn s


toString : String -> Params a -> (a -> String) -> String
toString uid params by =
    uid
        ++ "?"
        ++ queryToString params
        ++ params.misc
        ++ orderToString params
        ++ sortToString by params
