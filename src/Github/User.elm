module Github.User exposing (Sort(..), User, decoder, search)

import Github.Item exposing (Item)
import Github.Json exposing (optional, required)
import Github.Search as Search
import Github.Search.Params exposing (Params)
import Json.Decode exposing (Decoder, bool, int, string, succeed)


search : (Result Search.Error (Item User) -> msg) -> Params Sort -> Cmd msg
search =
    Search.search decoder sort "users"


type Sort
    = Followers
    | Repositories
    | Joined


sort : Sort -> String
sort by =
    case by of
        Followers ->
            "followers"

        Repositories ->
            "repositories"

        Joined ->
            "joined"


type alias User =
    { login : String -- "liaBooks"
    , id_ : Int -- 50742085
    , node_id : String --"MDEyOk9yZ2FuaXphdGlvbjUwNzQyMDg1"
    , avatar_url : Maybe String -- "https://avatars1.githubus.../50742085?v=4"
    , gravatar_id : Maybe String -- ""
    , url : String -- "https://api.github.com/users/liaBooks"
    , html_url : Maybe String -- "https://github.com/liaBooks"
    , followers_url : Maybe String -- "https://api.github...iaBooks/followers"
    , following_url : Maybe String -- "https://api.github...wing{/other_user}"
    , gists_url : Maybe String -- "https://api.github...Books/gists{/gist_id}"
    , starred_url : Maybe String -- "https://api.github...rred{/owner}{/repo}"
    , subscriptions_url : Maybe String -- "https://api.githu.../subscriptions"
    , organizations_url : Maybe String -- "https://api.github...liaBooks/orgs"
    , repos_url : Maybe String -- "https://api.github.../users/liaBooks/repos"
    , events_url : Maybe String -- "https://api.github...oks/events{/privacy}"
    , received_events_url : Maybe String -- "https://api.g.../received_events"
    , type_ : String -- "Organization",
    , site_admin : Bool -- false
    }


decoder : Decoder User
decoder =
    succeed User
        |> required "login" string
        |> required "id" int
        |> required "node_id" string
        |> optional "avatar_url" string
        |> optional "gravatar_id" string
        |> required "url" string
        |> optional "html_url" string
        |> optional "followers_url" string
        |> optional "following_url" string
        |> optional "gists_url" string
        |> optional "starred_url" string
        |> optional "subscriptions_url" string
        |> optional "organizations_url" string
        |> optional "repos_url" string
        |> optional "events_url" string
        |> optional "received_events_url" string
        |> required "type" string
        |> required "site_admin" bool
