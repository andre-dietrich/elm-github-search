module Github.Repository exposing
    ( Repository
    , Sort(..)
    , decoder
    , search
    )

import Github.Item exposing (Item)
import Github.Json exposing (optional, required)
import Github.Search as Search
import Github.Search.Params exposing (Params)
import Github.User as User exposing (User)
import Json.Decode
    exposing
        ( Decoder
        , bool
        , float
        , int
        , string
        , succeed
        )
import Json.Decode.Extra exposing (datetime)
import Time


search : (Result Search.Error (Item Repository) -> msg) -> Params Sort -> Cmd msg
search =
    Search.search decoder sort "repositories"


type Sort
    = Stars
    | Forks
    | Updated
    | HelpWantedIssues


sort : Sort -> String
sort by =
    case by of
        Stars ->
            "start"

        Forks ->
            "forks"

        Updated ->
            "updated"

        HelpWantedIssues ->
            "help-wanted-issues"


type alias Repository =
    { id_ : Int -- 187215944
    , node_id : String -- "MDEwOlJlcG9zaXRvcnkxODcyMTU5NDQ="
    , name : String -- "C-Programming"
    , full_name : String -- "liaBooks/C-Programming"
    , private : Bool -- false
    , owner : User
    , html_url : Maybe String -- "https://github.com/liaBooks/C-Programming"
    , description : Maybe String -- "Interactive Port of the Wikibook C-..."
    , fork : Maybe Bool -- false
    , url : Maybe String -- "https://api.github.com/repos/liaBooks/C-Pro..."
    , forks_url : Maybe String -- "https://api.github.com/repos/l...g/forks"
    , keys_url : Maybe String -- "https://api.github.com/r.../keys{/key_id}"
    , collaborators_url : Maybe String --"https://ap...ators{/collaborator}"
    , teams_url : Maybe String --"https://api.githu...s/C-Programming/teams"
    , hooks_url : Maybe String --"https://api.github.c...-Programming/hooks"
    , issue_events_url : Maybe String --"https://api...sues/events{/number}"
    , events_url : Maybe String --"https://api.git...s/C-Programming/events"
    , assignees_url : Maybe String --"https://api.gith...g/assignees{/user}"
    , branches_url : Maybe String --"https://api.gith...g/branches{/branch}"
    , tags_url : Maybe String --"https://api.github...ks/C-Programming/tags"
    , blobs_url : Maybe String --"https://api.github.c...ng/git/blobs{/sha}"
    , git_tags_url : Maybe String --"https://api.githu...ing/git/tags{/sha}"
    , git_refs_url : Maybe String --"https://api.git...mming/git/refs{/sha}"
    , trees_url : Maybe String --"https://api.github...ming/git/trees{/sha}"
    , statuses_url : Maybe String --"https://api.github...ng/statuses/{sha}"
    , languages_url : Maybe String --"https://api.github...amming/languages"
    , stargazers_url : Maybe String --"https://api.github...ming/stargazers"
    , contributors_url : Maybe String --"https://api.github.../contributors"
    , subscribers_url : Maybe String --"https://api.github...ng/subscribers"
    , subscription_url : Maybe String -- "https://api.github...subscription"
    , commits_url : Maybe String -- "https://api.github...ing/commits{/sha}"
    , git_commits_url : Maybe String -- "https://api.github...commits{/sha}"
    , comments_url : Maybe String --"https://api.github...comments{/number}"
    , issue_comment_url : Maybe String --"https://api.github...nts{/number}"
    , contents_url : Maybe String --"https://api.github.../contents/{+path}"
    , compare_url : Maybe String --"https://api.github...re/{base}...{head}"
    , merges_url : Maybe String --"https://api.github...-Programming/merges"
    , archive_url : Maybe String --"https://api.g.../{archive_format}{/ref}"
    , downloads_url : Maybe String --"https://api.github...amming/downloads"
    , issues_url : Maybe String --"https://api.github...ing/issues{/number}"
    , pulls_url : Maybe String --"https://api.github...mming/pulls{/number}"
    , milestones_url : Maybe String --"https://api.github...stones{/number}"
    , notifications_url : Maybe String --"http...{?since,all,participating}"
    , labels_url : Maybe String --"https://api.github...mming/labels{/name}"
    , releases_url : Maybe String --"https://api.github...ing/releases{/id}"
    , deployments_url : Maybe String --"https://api.github...ng/deployments"
    , created_at : Time.Posix -- "2019-05-17T12:52:22Z"
    , updated_at : Maybe Time.Posix -- "2019-06-04T08:17:10Z"
    , pushed_at : Maybe Time.Posix -- "2019-06-04T08:17:08Z"
    , git_url : Maybe String -- "git://github.../liaBooks/C-Programming.git"
    , ssh_url : Maybe String --"git@github.com:liaBooks/C-Programming.git"
    , clone_url : Maybe String --"https://github...aBooks/C-Programming.git"
    , svn_url : Maybe String -- "https://github.com/liaBooks/C-Programming"
    , homepage : Maybe String -- "https://liascri...amming/master/README.md"
    , size : Int -- 93
    , stargazers_count : Int -- 0
    , watchers_count : Int -- 0
    , language : Maybe String -- null
    , has_issues : Maybe Bool -- true
    , has_projects : Bool -- true
    , has_downloads : Bool -- true
    , has_wiki : Bool -- true
    , has_pages : Bool -- false
    , forks_count : Int -- 0
    , mirror_url : Maybe String -- null
    , archived : Bool -- false
    , disabled : Bool -- false
    , open_issues_count : Int -- 0
    , license : Maybe String -- null
    , forks : Int -- 0
    , open_issues : Int -- 0
    , watchers : Int -- 0
    , default_branch : String -- "master"
    , score : Float -- 13.155699
    }


decoder : Decoder Repository
decoder =
    succeed Repository
        |> required "id" int
        |> required "node_id" string
        |> required "name" string
        |> required "full_name" string
        |> required "private" bool
        |> required "owner" User.decoder
        |> optional "html_url" string
        |> optional "description" string
        |> optional "fork" bool
        |> optional "url" string
        |> optional "forks_url" string
        |> optional "keys_url" string
        |> optional "collaborators_url" string
        |> optional "teams_url" string
        |> optional "hooks_url" string
        |> optional "issue_events_url" string
        |> optional "events_url" string
        |> optional "assignees_url" string
        |> optional "branches_url" string
        |> optional "tags_url" string
        |> optional "blobs_url" string
        |> optional "git_tags_url" string
        |> optional "git_refs_url" string
        |> optional "trees_url" string
        |> optional "statuses_url" string
        |> optional "languages_url" string
        |> optional "stargazers_url" string
        |> optional "contributors_url" string
        |> optional "subscribers_url" string
        |> optional "subscription_url" string
        |> optional "commits_url" string
        |> optional "git_commits_url" string
        |> optional "comments_url" string
        |> optional "issue_comment_url" string
        |> optional "contents_url" string
        |> optional "compare_url" string
        |> optional "merges_url" string
        |> optional "archive_url" string
        |> optional "downloads_url" string
        |> optional "issues_url" string
        |> optional "pulls_url" string
        |> optional "milestones_url" string
        |> optional "notifications_url" string
        |> optional "labels_url" string
        |> optional "releases_url" string
        |> optional "deployments_url" string
        |> required "created_at" datetime
        |> optional "updated_at" datetime
        |> optional "pushed_at" datetime
        |> optional "git_url" string
        |> optional "ssh_url" string
        |> optional "clone_url" string
        |> optional "svn_url" string
        |> optional "homepage" string
        |> required "size" int
        |> required "stargazers_count" int
        |> required "watchers_count" int
        |> optional "language" string
        |> optional "has_issues" bool
        |> required "has_projects" bool
        |> required "has_downloads" bool
        |> required "has_wiki" bool
        |> required "has_pages" bool
        |> required "forks_count" int
        |> optional "mirror_url" string
        |> required "archived" bool
        |> required "disabled" bool
        |> required "open_issues_count" int
        |> optional "license" string
        |> required "forks" int
        |> required "open_issues" int
        |> required "watchers" int
        |> required "default_branch" string
        |> required "score" float
