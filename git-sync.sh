#!/bin/sh

# color support
#bold=`echo -en "\e[1m"`; underline=`echo -en "\e[4m"`; dim=`echo -en "\e[2m"`; strickthrough=`echo -en "\e[9m"`; blink=`echo -en "\e[5m"`; reverse=`echo -en "\e[7m"`; hidden=`echo -en "\e[8m"`; normal=`echo -en "\e[0m"`; black=`echo -en "\e[30m"`; red=`echo -en "\e[31m"`; green=`echo -en "\e[32m"`; orange=`echo -en "\e[33m"`; blue=`echo -en "\e[34m"`; purple=`echo -en "\e[35m"`; aqua=`echo -en "\e[36m"`; gray=`echo -en "\e[37m"`; darkgray=`echo -en "\e[90m"`; lightred=`echo -en "\e[91m"`; lightgreen=`echo -en "\e[92m"`; lightyellow=`echo -en "\e[93m"`; lightblue=`echo -en "\e[94m"`; lightpurple=`echo -en "\e[95m"`; lightaqua=`echo -en "\e[96m"`; white=`echo -en "\e[97m"`; default=`echo -en "\e[39m"`; BLACK=`echo -en "\e[40m"`; RED=`echo -en "\e[41m"`; GREEN=`echo -en "\e[42m"`; ORANGE=`echo -en "\e[43m"`; BLUE=`echo -en "\e[44m"`; PURPLE=`echo -en "\e[45m"`; AQUA=`echo -en "\e[46m"`; GRAY=`echo -en "\e[47m"`; DARKGRAY=`echo -en "\e[100m"`; LIGHTRED=`echo -en "\e[101m"`; LIGHTGREEN=`echo -en "\e[102m"`; LIGHTYELLOW=`echo -en "\e[103m"`; LIGHTBLUE=`echo -en "\e[104m"`; LIGHTPURPLE=`echo -en "\e[105m"`; LIGHTAQUA=`echo -en "\e[106m"`; WHITE=`echo -en "\e[107m"`; DEFAULT=`echo -en "\e[49m"`;

app_name="git-sync"

usage() {
  echo "Usage: $app_name [-b|--branch branch] [-p|--push] [-n|--no-push]"
}

while getopts "pnhb:-:" opt; do
  case $opt in
    b)
      BRANCH_OPT="${OPTARG}"
      ;;
    p)
      PUSH="true"
      ;;
    n)
      PUSH="false"
      ;;
    h)
      usage
      exit 0
      ;;
    -)
      case $OPTARG in
        branch=*)
          BRANCH_OPT=${OPTARG#*"="}
          ;;
        push)
          PUSH="true"
          ;;
        no-push)
          PUSH="false"
          ;;
        *)
          usage
          exit 1
          ;;
      esac
      ;;
    \?)
      usage
      exit 1
      ;;
  esac
done

#logs() {
#  echo "$lightyellow\[LOGS]$normal $*"
#

errors() {
  red=$(printf "\e[31m")
  normal=$(printf "\e[0m")
  
  echo "$red\[ERR]$normal"
  echo "$red\[ERR]$normal $*"
  echo "$red\[ERR]$normal"
}

# Some noise stuff
#logs "Cleaning logs..."
true > ./git-sync.log.txt
#logs "Cleaned logs!"

request_commit_message()
{
  printf "Please enter your commit message (default: Update): "
  read -r COMMIT_MESSAGE
  if [ -z "$COMMIT_MESSAGE" ]; then
    COMMIT_MESSAGE="Update"
  fi
}

commit() {
  git add -A && git commit -m "$1"
}

error_fixing() {
  echo "Choose an option between the following options:

  0: Commit your changes before moving branch
  1: Create a new branch
  2: Abort.
  "
  read -r RESPONSE

  if [ -z "$RESPONSE" ]; then
    echo "Invalid response, retry"
    error_fixing
  fi

  if [ "$RESPONSE" = "0" ]; then
    echo "Commiting..."
    request_commit_message
    commit "$COMMIT_MESSAGE"
  elif [ "$RESPONSE" = "1" ]; then
    echo "Creating new branch $BRANCH..."
    if ! git checkout -b "$BRANCH"; then
      echo "Failed to create branch named $BRANCH"
      exit 1
    fi
    echo "Successfully created and moved to $BRANCH"
  elif [ "$RESPONSE" = "2" ]; then
    echo "Aborting."
    return 1
  else
    echo "Invalid response, retry"
    error_fixing
  fi
}

push_command() {
  git push --set-upstream origin "$BRANCH" > ./git-sync.log.txt
}

main() {
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  if [ -z "$BRANCH_OPT" ]
  then
    printf "Please choose the branch you want to commit (example: dev, master): "
    read -r BRANCH
    if [ -z "$BRANCH" ]; then
      BRANCH="$CURRENT_BRANCH"
    fi
  else
    BRANCH="$BRANCH_OPT"
    echo "Commiting on branch $BRANCH"
  fi

  if [ "$(git status --porcelain)" != "" ]; then
    CHANGES=1
  else
    CHANGES=0
  fi

  if [ "$BRANCH" = "$CURRENT_BRANCH" ] && [ $CHANGES = 0 ] ; then
    echo "No changes to commit"
    exit 0
  fi

  if [ "$BRANCH" != "$CURRENT_BRANCH" ]; then
    if ! git checkout "$BRANCH" > ./git-sync.log.txt; then
      errors "Failed to move in branch $BRANCH"
      if ! error_fixing; then
        exit 1
      fi
    fi
  fi

  request_commit_message
  echo "Commiting and pushing with message: $COMMIT_MESSAGE"

  commit "$COMMIT_MESSAGE"

  if [ -z "$PUSH" ]; then
    printf "Would you like to push the changes ? (Y/n): "
    read -r PUSH_RESPONSE

    if [ -z "$PUSH_RESPONSE" ]; then
      PUSH_RESPONSE="y"
    fi

    if [ "${PUSH_RESPONSE,,}" = "y" ]; then
      echo "Pushing..."
      if ! push_command; then
        echo "Failed to push"
        return 1
      else
        echo "Successfully pushed changes"
      fi
    fi
  else
    if [ "$PUSH" = "true" ]; then
      echo "Pushing..."
      push_command
      if ! push_command; then
        echo "Failed to push"
        return 1
      else
        echo "Successfully pushed changes"
      fi
    fi
  fi
}

if ! command -v git >/dev/null 2>&1; then
  echo "Git is not installed."
  exit 1
fi

main