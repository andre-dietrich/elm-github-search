module Github.Json exposing (optional, required)

import Json.Decode
    exposing
        ( Decoder
        , field
        , maybe
        )
import Json.Decode.Extra as JDx


optional key dec =
    field key dec |> maybe |> JDx.andMap


required key dec =
    field key dec |> JDx.andMap
