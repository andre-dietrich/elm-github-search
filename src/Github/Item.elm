module Github.Item exposing (Item, decoder)

import Json.Decode
    exposing
        ( Decoder
        , bool
        , field
        , int
        , list
        , map3
        )


type alias Item a =
    { total_count : Int -- "40"
    , incomplete_results : Bool -- false
    , items : List a
    }


decoder : Decoder a -> Decoder (Item a)
decoder item_decoder =
    map3 Item
        (field "total_count" int)
        (field "incomplete_results" bool)
        (field "items" (list item_decoder))
