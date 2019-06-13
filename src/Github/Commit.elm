module Github.Commit exposing (Commit, Sort(..), decoder, sort)

import Github.Item exposing (Item)
import Github.Json
    exposing
        ( optional
        , required
        )
import Github.Repository as Repository exposing (Repository)
import Github.Search as Search
import Github.Search.Params exposing (Params)
import Github.User as User exposing (User)
import Json.Decode exposing (Decoder, bool, float, int, list, string, succeed)
import Json.Decode.Extra exposing (datetime)
import Time


search : (Result Search.Error (Item Commit) -> msg) -> Params Sort -> Cmd msg
search =
    Search.search decoder sort "commits"


type Sort
    = AuthorDate
    | CommitterDate


sort : Sort -> String
sort by =
    case by of
        AuthorDate ->
            "author-date"

        CommitterDate ->
            "committer-date"


type alias Committer =
    { date : Time.Posix -- "2014-02-04T14:38:36-08:00",
    , name : String -- "The Octocat"
    , email : Maybe String -- "octocat@nowhere.com"
    }


committer : Decoder Committer
committer =
    succeed Committer
        |> required "date" datetime
        |> required "name" string
        |> optional "email" string


type alias Parent =
    { url : String -- "https://api.github.com/repos/octocat/Spoon-Knife/commits/a30c19e3f13765a3b48829788bc1cb8b4e95cee4",
    , html_url : String -- "https://github.com/octocat/Spoon-Knife/commit/a30c19e3f13765a3b48829788bc1cb8b4e95cee4",
    , sha : String -- "a30c19e3f13765a3b48829788bc1cb8b4e95cee4"
    }


parent : Decoder Parent
parent =
    succeed Parent
        |> required "url" string
        |> required "html_url" string
        |> required "sha" string


type alias UrlSha =
    { url : String -- "https://api.github.com/repos/octocat/Spoon-Knife/git/trees/a639e96f9038797fba6e0469f94a4b0cc459fa68",
    , sha : String -- "a639e96f9038797fba6e0469f94a4b0cc459fa68"
    }


urlsha : Decoder UrlSha
urlsha =
    succeed UrlSha
        |> required "url" string
        |> required "sha" string


type alias Record =
    { url : String -- "https://api.github.com/repos/octocat/Spoon-Knife/git/commits/bb4cc8d3b2e14b3af5df699876dd4ff3acd00b7f",
    , author : Committer
    , committer : Committer
    , message : Maybe String -- "Create styles.css and updated README"
    , tree : UrlSha
    , comment_count : Int --  8
    }


record : Decoder Record
record =
    succeed Record
        |> required "url" string
        |> required "author" committer
        |> required "committer" committer
        |> optional "message" string
        |> required "tree" urlsha
        |> required "comment_count" int


type alias Commit =
    { url : String -- "https://api.github.com/repos/octocat/Spoon-Knife/commits/bb4cc8d3b2e14b3af5df699876dd4ff3acd00b7f"
    , sha : String -- "bb4cc8d3b2e14b3af5df699876dd4ff3acd00b7f"
    , html_url : String -- "https://github.com/octocat/Spoon-Knife/commit/bb4cc8d3b2e14b3af5df699876dd4ff3acd00b7f"
    , comments_url : String -- "https://api.github.com/repos/octocat/Spoon-Knife/commits/bb4cc8d3b2e14b3af5df699876dd4ff3acd00b7f/comments",
    , commit : Record
    , author : User
    , committer : User
    , parents : List Parent
    , repository : Repository
    , score : Float
    }


decoder : Decoder Commit
decoder =
    succeed Commit
        |> required "url" string
        |> required "sha" string
        |> required "html_url" string
        |> required "comments_url" string
        |> required "commit" record
        |> required "author" User.decoder
        |> required "committer" User.decoder
        |> required "parents" (list parent)
        |> required "Repository" Repository.decoder
        |> required "score" float
