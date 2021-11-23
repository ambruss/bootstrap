#!/usr/bin/env bash

is_installed() {
    cmd jira
}

install() {
    JIRA_VER=$(latest go-jira/jira)
    JIRA_URL=https://github.com/go-jira/jira/releases/download/$JIRA_VER/jira-linux-amd64
    curl -o "$BIN/jira" "$JIRA_URL"
    chmod +x "$BIN/jira"
}


RC="$(cat <<'RC'
#!/usr/bin/env bash
cat <<EOF
endpoint: https://flywheelio.atlassian.net
login: ambrussimon@flywheel.io
user: ambrussimon
password-source: keyring
editor: micro
EOF
case $JIRA_OPERATION in
    list) echo "template: table";;
esac
RC
)"
