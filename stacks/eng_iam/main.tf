# stacks/eng_iam/main.tf

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Managed Policies

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy" "SystemAdministrator" {
  arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

resource "aws_iam_group_membership" "read-only-group-membership" {
  name = "tf-testing-group-membership"

  users = [
    "${aws_iam_user.jamie-ro.name}",
  ]

  group = "${aws_iam_group.read-only-users.name}"
}

resource "aws_iam_policy_attachment" "read-only-policy-attachment" {
  name       = "read-only-policy-attachment"
  groups     = ["${aws_iam_group.read-only-users.name}"]
  policy_arn = "${data.aws_iam_policy.ReadOnlyAccess.arn}"
}

#----------------------------

resource "aws_iam_group_membership" "admin-group-membership" {
  name = "tf-testing-group-membership"

  users = [
    "${aws_iam_user.jamie-devops.name}",
  ]

  group = "${aws_iam_group.admin.name}"
}

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Policy Attachments

resource "aws_iam_policy_attachment" "read-only-policy-attachment" {
  name       = "read-only-policy-attachment"
  groups     = ["${aws_iam_group.read-only-users.name}"]
  policy_arn = "${data.aws_iam_policy.ReadOnlyAccess.arn}"
}

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Groups

resource "aws_iam_group" "read-only-users" {
  name = "read-only-users"
}

resource "aws_iam_group" "devops-engineers" {
  name = "devops-engineers"
}

resource "aws_iam_group" "administrators" {
  name = "administrators"
}

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Users

resource "aws_iam_user" "jamie-ro" {
  name = "jamie-ro"
}

resource "aws_iam_user" "jamie-devops" {
  name = "jamie-devops"
}

resource "aws_iam_user" "jamie-admin" {
  name = "jamie-admin"
}
