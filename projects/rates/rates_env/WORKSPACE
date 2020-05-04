load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "meru" ,
    remote = "git@github.com:errangutan/meru.git",
    tag = "0.1.1",
)

load("@meru//:repositories.bzl", "meru_dependencies")
meru_dependencies()
load("@meru//:setup.bzl", "meru_setup")
meru_setup()
