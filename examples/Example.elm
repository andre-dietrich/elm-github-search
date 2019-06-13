module Example exposing (main)

import Browser
import Github.Item exposing (Item)
import Github.Repository as Repository exposing (Repository)
import Github.Search as Search
import Github.Search.Params as Params
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events exposing (onClick)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type State
    = Loading
    | Failure String
    | Success


type alias Model =
    { input : String
    , rslt : Maybe (Item Repository)
    , state : State
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model
        ""
        Nothing
        Loading
    , Cmd.none
    )


type Msg
    = Load
    | GotText (Result Search.Error (Item Repository))
    | Input String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Load ->
            ( model
            , if model.input == "" then
                Cmd.none

              else
                Params.empty
                    |> Params.add_topic "liascript"
                    |> Params.add_qualifier "fork:true"
                    |> Params.add_qualifier "in:readme"
                    |> Params.query model.input
                    |> Repository.search GotText
            )

        Input str ->
            ( { model | input = str }, Cmd.none )

        GotText result ->
            case result of
                Ok fullText ->
                    ( { model
                        | state = Success
                        , rslt = Just fullText
                      }
                    , Cmd.none
                    )

                Err info ->
                    ( { model | state = Failure <| Search.errorToString info }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.input [ Html.Events.onInput Input ] [ Html.text model.input ]
        , Html.button [ Html.Events.onClick Load ] [ Html.text "load" ]
        , case model.state of
            Failure info ->
                Html.text info

            Loading ->
                Html.text ""

            Success ->
                case model.rslt of
                    Just rslt ->
                        rslt.items
                            |> List.map showRepo
                            |> Html.div []

                    _ ->
                        Html.text "nothing"
        ]


showRepo : Repository -> Html msg
showRepo repo =
    Html.div []
        [ Html.div [] [ Html.text repo.name ]
        , Html.div []
            [ repo.description
                |> Maybe.withDefault ""
                |> Html.text
            ]
        ]
