// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/test;

service ReleaseService on new Listener(listenOn = 9090) {
    remote function onReleased(ReleaseEvent payload) returns error? {
    }

    remote function onDeleted(ReleaseEvent payload) returns error? {
    }

    remote function onPublished(ReleaseEvent payload) returns error? {
    }

    remote function onUnpublished(ReleaseEvent payload) returns error? {
    }

    remote function onCreated(ReleaseEvent payload) returns error? {
    }

    remote function onEdited(ReleaseEvent payload) returns error? {
    }

    remote function onPreReleased(ReleaseEvent payload) returns error? {
    }
}

final http:Client releaseEp = check new ("localhost:9090");

@test:Config {
    groups: ["release"]
}
function testReleaseCreatedEvent() returns error? {
    json releaseCreated = {
        "action": "created",
        "release": {
            "url": "https://api.github.com/repos/AbcUser/abc-repo/releases/100000000",
            "assets_url": "https://api.github.com/repos/AbcUser/abc-repo/releases/100000000/assets",
            "upload_url": "https://uploads.github.com/repos/AbcUser/abc-repo/releases/100000000/assets{?name,label}",
            "html_url": "https://github.com/AbcUser/abc-repo/releases/tag/untagged-f6eaafd5ee28a4e9e297",
            "id": 100000000,
            "author": {
                "login": "AbcUser",
                "id": 120000000,
                "node_id": "MDQ6VXNlcjc3NDkxNTEx",
                "avatar_url": "https://avatars.githubusercontent.com/u/120000000?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/AbcUser",
                "html_url": "https://github.com/AbcUser",
                "followers_url": "https://api.github.com/users/AbcUser/followers",
                "following_url": "https://api.github.com/users/AbcUser/following{/other_user}",
                "gists_url": "https://api.github.com/users/AbcUser/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/AbcUser/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/AbcUser/subscriptions",
                "organizations_url": "https://api.github.com/users/AbcUser/orgs",
                "repos_url": "https://api.github.com/users/AbcUser/repos",
                "events_url": "https://api.github.com/users/AbcUser/events{/privacy}",
                "received_events_url": "https://api.github.com/users/AbcUser/received_events",
                "type": "User",
                "site_admin": false
            },
            "node_id": "RE_kwDOJeMwas4IUobM",
            "tag_name": "v3",
            "target_commitish": "main",
            "name": "Test Release 3",
            "draft": true,
            "prerelease": false,
            "created_at": "2024-02-02T08:01:21Z",
            "published_at": null,
            "assets": [

            ],
            "tarball_url": null,
            "zipball_url": null,
            "body": "This is a sample release which is used for testing. \r\n\r\n**Full Changelog**: https://github.com/AbcUser/abc-repo/commits/v3"
        },
        "repository": {
            "id": 123000000,
            "node_id": "R_kgDOJeMwag",
            "name": "abc-repo",
            "full_name": "AbcUser/abc-repo",
            "private": false,
            "owner": {
                "login": "AbcUser",
                "id": 120000000,
                "node_id": "MDQ6VXNlcjc3NDkxNTEx",
                "avatar_url": "https://avatars.githubusercontent.com/u/120000000?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/AbcUser",
                "html_url": "https://github.com/AbcUser",
                "followers_url": "https://api.github.com/users/AbcUser/followers",
                "following_url": "https://api.github.com/users/AbcUser/following{/other_user}",
                "gists_url": "https://api.github.com/users/AbcUser/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/AbcUser/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/AbcUser/subscriptions",
                "organizations_url": "https://api.github.com/users/AbcUser/orgs",
                "repos_url": "https://api.github.com/users/AbcUser/repos",
                "events_url": "https://api.github.com/users/AbcUser/events{/privacy}",
                "received_events_url": "https://api.github.com/users/AbcUser/received_events",
                "type": "User",
                "site_admin": false
            },
            "html_url": "https://github.com/AbcUser/abc-repo",
            "description": null,
            "fork": false,
            "url": "https://api.github.com/repos/AbcUser/abc-repo",
            "forks_url": "https://api.github.com/repos/AbcUser/abc-repo/forks",
            "keys_url": "https://api.github.com/repos/AbcUser/abc-repo/keys{/key_id}",
            "collaborators_url": "https://api.github.com/repos/AbcUser/abc-repo/collaborators{/collaborator}",
            "teams_url": "https://api.github.com/repos/AbcUser/abc-repo/teams",
            "hooks_url": "https://api.github.com/repos/AbcUser/abc-repo/hooks",
            "issue_events_url": "https://api.github.com/repos/AbcUser/abc-repo/issues/events{/number}",
            "events_url": "https://api.github.com/repos/AbcUser/abc-repo/events",
            "assignees_url": "https://api.github.com/repos/AbcUser/abc-repo/assignees{/user}",
            "branches_url": "https://api.github.com/repos/AbcUser/abc-repo/branches{/branch}",
            "tags_url": "https://api.github.com/repos/AbcUser/abc-repo/tags",
            "blobs_url": "https://api.github.com/repos/AbcUser/abc-repo/git/blobs{/sha}",
            "git_tags_url": "https://api.github.com/repos/AbcUser/abc-repo/git/tags{/sha}",
            "git_refs_url": "https://api.github.com/repos/AbcUser/abc-repo/git/refs{/sha}",
            "trees_url": "https://api.github.com/repos/AbcUser/abc-repo/git/trees{/sha}",
            "statuses_url": "https://api.github.com/repos/AbcUser/abc-repo/statuses/{sha}",
            "languages_url": "https://api.github.com/repos/AbcUser/abc-repo/languages",
            "stargazers_url": "https://api.github.com/repos/AbcUser/abc-repo/stargazers",
            "contributors_url": "https://api.github.com/repos/AbcUser/abc-repo/contributors",
            "subscribers_url": "https://api.github.com/repos/AbcUser/abc-repo/subscribers",
            "subscription_url": "https://api.github.com/repos/AbcUser/abc-repo/subscription",
            "commits_url": "https://api.github.com/repos/AbcUser/abc-repo/commits{/sha}",
            "git_commits_url": "https://api.github.com/repos/AbcUser/abc-repo/git/commits{/sha}",
            "comments_url": "https://api.github.com/repos/AbcUser/abc-repo/comments{/number}",
            "issue_comment_url": "https://api.github.com/repos/AbcUser/abc-repo/issues/comments{/number}",
            "contents_url": "https://api.github.com/repos/AbcUser/abc-repo/contents/{+path}",
            "compare_url": "https://api.github.com/repos/AbcUser/abc-repo/compare/{base}...{head}",
            "merges_url": "https://api.github.com/repos/AbcUser/abc-repo/merges",
            "archive_url": "https://api.github.com/repos/AbcUser/abc-repo/{archive_format}{/ref}",
            "downloads_url": "https://api.github.com/repos/AbcUser/abc-repo/downloads",
            "issues_url": "https://api.github.com/repos/AbcUser/abc-repo/issues{/number}",
            "pulls_url": "https://api.github.com/repos/AbcUser/abc-repo/pulls{/number}",
            "milestones_url": "https://api.github.com/repos/AbcUser/abc-repo/milestones{/number}",
            "notifications_url": "https://api.github.com/repos/AbcUser/abc-repo/notifications{?since,all,participating}",
            "labels_url": "https://api.github.com/repos/AbcUser/abc-repo/labels{/name}",
            "releases_url": "https://api.github.com/repos/AbcUser/abc-repo/releases{/id}",
            "deployments_url": "https://api.github.com/repos/AbcUser/abc-repo/deployments",
            "created_at": "2023-05-03T06:35:16Z",
            "updated_at": "2023-10-13T12:07:12Z",
            "pushed_at": "2024-02-01T11:46:09Z",
            "git_url": "git://github.com/AbcUser/abc-repo.git",
            "ssh_url": "git@github.com:AbcUser/abc-repo.git",
            "clone_url": "https://github.com/AbcUser/abc-repo.git",
            "svn_url": "https://github.com/AbcUser/abc-repo",
            "homepage": null,
            "size": 0,
            "stargazers_count": 0,
            "watchers_count": 0,
            "language": null,
            "has_issues": true,
            "has_projects": true,
            "has_downloads": true,
            "has_wiki": true,
            "has_pages": false,
            "has_discussions": false,
            "forks_count": 0,
            "mirror_url": null,
            "archived": false,
            "disabled": false,
            "open_issues_count": 3,
            "license": null,
            "allow_forking": true,
            "is_template": false,
            "web_commit_signoff_required": false,
            "topics": [

            ],
            "visibility": "public",
            "forks": 0,
            "open_issues": 3,
            "watchers": 0,
            "default_branch": "main"
        },
        "sender": {
            "login": "AbcUser",
            "id": 120000000,
            "node_id": "MDQ6VXNlcjc3NDkxNTEx",
            "avatar_url": "https://avatars.githubusercontent.com/u/120000000?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/AbcUser",
            "html_url": "https://github.com/AbcUser",
            "followers_url": "https://api.github.com/users/AbcUser/followers",
            "following_url": "https://api.github.com/users/AbcUser/following{/other_user}",
            "gists_url": "https://api.github.com/users/AbcUser/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/AbcUser/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/AbcUser/subscriptions",
            "organizations_url": "https://api.github.com/users/AbcUser/orgs",
            "repos_url": "https://api.github.com/users/AbcUser/repos",
            "events_url": "https://api.github.com/users/AbcUser/events{/privacy}",
            "received_events_url": "https://api.github.com/users/AbcUser/received_events",
            "type": "User",
            "site_admin": false
        }
    };
    http:Response res = check releaseEp->post("", releaseCreated, mediaType = "application/json", headers = {"X-GitHub-Event": "release"});
    test:assertEquals(res.statusCode, 200);
}
