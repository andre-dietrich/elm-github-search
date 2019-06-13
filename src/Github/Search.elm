module Github.Search exposing
    ( Error(..)
    , errorToString
    , search
    )

import Github.Error as Error
import Github.Item exposing (Item)
import Github.Search.Params as Params exposing (Params)
import Http
import Json.Decode exposing (Decoder, decodeString)
import Task


type Error
    = GithubError Error.Error
    | HttpError Http.Error


httpErr : Http.Error -> Result Error value
httpErr =
    HttpError >> Err


responseHandler : Decoder a -> Http.Response String -> Result Error a
responseHandler decoder response =
    case response of
        Http.BadUrl_ url ->
            httpErr (Http.BadUrl url)

        Http.Timeout_ ->
            httpErr Http.Timeout

        Http.BadStatus_ { statusCode } info ->
            if statusCode == 422 then
                case decodeString Error.decoder info of
                    Ok json ->
                        json |> GithubError |> Err

                    Err msg ->
                        httpErr (Http.BadBody info)

            else
                httpErr (Http.BadStatus statusCode)

        Http.NetworkError_ ->
            httpErr Http.NetworkError

        Http.GoodStatus_ _ body ->
            case decodeString decoder body of
                Err _ ->
                    httpErr (Http.BadBody body)

                Ok rslt ->
                    Ok rslt


github : String
github =
    "https://api.github.com/search/"


search : Decoder i -> (t -> String) -> String -> (Result Error (Item i) -> msg) -> Params t -> Cmd msg
search decoder by uid msg params =
    Params.toString uid params by
        |> get decoder msg params.headers


get : Decoder a -> (Result Error (Item a) -> msg) -> List Http.Header -> String -> Cmd msg
get decoder msg headers param_string =
    { method = "get"
    , headers = [ Http.header "User-Agent" "https://api.github.com/liascript" ]
    , url = github ++ param_string
    , body = Http.emptyBody
    , resolver = decoder |> Github.Item.decoder |> responseHandler |> Http.stringResolver
    , timeout = Nothing
    }
        |> Http.task
        |> Task.attempt msg


errorToString : Error -> String
errorToString error =
    case error of
        HttpError Http.Timeout ->
            "HTTP timeout"

        HttpError Http.NetworkError ->
            "HTTP network error"

        HttpError (Http.BadStatus stat) ->
            "HTTP bad status " ++ String.fromInt stat

        HttpError (Http.BadUrl info) ->
            "HTTP bad url " ++ info

        HttpError (Http.BadBody info) ->
            "HTTP bad body " ++ info

        GithubError info ->
            "Github \n" ++ Error.toString info
