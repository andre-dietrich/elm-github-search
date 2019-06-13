module Github.Issues exposing (Issue, Sort(..), search)

import Github.Item exposing (Item)
import Github.Json exposing (optional, required)
import Github.Label as Label exposing (Label)
import Github.Search as Search
import Github.Search.Params exposing (Params)
import Github.User as User exposing (User)
import Json.Decode
    exposing
        ( Decoder
        , field
        , float
        , int
        , list
        , map3
        , maybe
        , string
        , succeed
        )
import Json.Decode.Extra exposing (datetime)
import Time


search : (Result Search.Error (Item Issue) -> msg) -> Params Sort -> Cmd msg
search =
    Search.search decoder sort "issues"


type Sort
    = Comments
    | Reactions
    | Reactions_Plus
    | Reactions_Minus
    | Reactions_Smile
    | Reactions_ThinkingFace
    | Reactions_Heart
    | Reactions_Tada
    | Interactions
    | Created
    | Updated


sort : Sort -> String
sort by =
    case by of
        Comments ->
            "comments"

        Reactions ->
            "reactions"

        Reactions_Plus ->
            "reactions-+1"

        Reactions_Minus ->
            "reactions--1"

        Reactions_Smile ->
            "reactions-smile"

        Reactions_ThinkingFace ->
            "reactions-thinking-face"

        Reactions_Heart ->
            "reactions-heart"

        Reactions_Tada ->
            "reactions-tada"

        Interactions ->
            "interactions"

        Created ->
            "created"

        Updated ->
            "updated"


type alias Issue =
    { url : String -- "https://api.github...rseapower/pinyin-toolkit/issues/132"
    , repository_url : String -- "https://api.github...rseapower/pinyin-toolkit"
    , labels_url : String -- "https://api.github...kit/issues/132/labels{/name}"
    , comments_url : String -- "https://api.github...oolkit/issues/132/comments"
    , events_url : String -- "https://api.github...in-toolkit/issues/132/events"
    , html_url : String -- "https://github...seapower/pinyin-toolkit/issues/132"
    , id_ : Int -- 35802
    , node_id : String -- "MDU6SXNzdWUzNTgwMg=="
    , number : Int -- 132
    , title : String -- "Line Number Indexes Beyond 20 Not Displayed"
    , user : User
    , labels : List Label
    , state : String -- "open"
    , assignee : Maybe String -- null
    , milestone : Maybe String -- null
    , comments : Int -- 15
    , created_at : Time.Posix -- "2009-07-12T20:10:41Z"
    , updated_at : Maybe Time.Posix -- "2009-07-19T09:23:43Z"
    , closed_at : Maybe Time.Posix -- null
    , pull_request : PullRequest
    , body : Maybe String -- "..."
    , score : Float -- 1.3859273
    }


decoder : Decoder Issue
decoder =
    succeed Issue
        |> required "url" string
        |> required "repository_url" string
        |> required "labels_url" string
        |> required "comments_url" string
        |> required "events_url" string
        |> required "html_url" string
        |> required "id" int
        |> required "node_id" string
        |> required "number" int
        |> required "title" string
        |> required "user" User.decoder
        |> required "labels" (list Label.decoder)
        |> required "state" string
        |> optional "assignee" string
        |> optional "milestone" string
        |> required "comments" int
        |> required "created_at" datetime
        |> optional "updated_at" datetime
        |> optional "closed_at" datetime
        |> required "pull_request" pullRequest
        |> optional "body" string
        |> required "score" float


type alias PullRequest =
    { html_url : Maybe String -- null
    , diff_url : Maybe String -- null
    , patch_url : Maybe String --  null
    }


pullRequest : Decoder PullRequest
pullRequest =
    map3 PullRequest
        (field "html_url" (maybe string))
        (field "diff_url" (maybe string))
        (field "patch_url" (maybe string))
