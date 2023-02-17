#!/bin/sh

# color support
bold=`echo -en "\e[1m"`; underline=`echo -en "\e[4m"`; dim=`echo -en "\e[2m"`; strickthrough=`echo -en "\e[9m"`; blink=`echo -en "\e[5m"`; reverse=`echo -en "\e[7m"`; hidden=`echo -en "\e[8m"`; normal=`echo -en "\e[0m"`; black=`echo -en "\e[30m"`; red=`echo -en "\e[31m"`; green=`echo -en "\e[32m"`; orange=`echo -en "\e[33m"`; blue=`echo -en "\e[34m"`; purple=`echo -en "\e[35m"`; aqua=`echo -en "\e[36m"`; gray=`echo -en "\e[37m"`; darkgray=`echo -en "\e[90m"`; lightred=`echo -en "\e[91m"`; lightgreen=`echo -en "\e[92m"`; lightyellow=`echo -en "\e[93m"`; lightblue=`echo -en "\e[94m"`; lightpurple=`echo -en "\e[95m"`; lightaqua=`echo -en "\e[96m"`; white=`echo -en "\e[97m"`; default=`echo -en "\e[39m"`; BLACK=`echo -en "\e[40m"`; RED=`echo -en "\e[41m"`; GREEN=`echo -en "\e[42m"`; ORANGE=`echo -en "\e[43m"`; BLUE=`echo -en "\e[44m"`; PURPLE=`echo -en "\e[45m"`; AQUA=`echo -en "\e[46m"`; GRAY=`echo -en "\e[47m"`; DARKGRAY=`echo -en "\e[100m"`; LIGHTRED=`echo -en "\e[101m"`; LIGHTGREEN=`echo -en "\e[102m"`; LIGHTYELLOW=`echo -en "\e[103m"`; LIGHTBLUE=`echo -en "\e[104m"`; LIGHTPURPLE=`echo -en "\e[105m"`; LIGHTAQUA=`echo -en "\e[106m"`; WHITE=`echo -en "\e[107m"`; DEFAULT=`echo -en "\e[49m"`;

usage() {
  echo "Usage: $0 [-b|--branch branch] [-p|--push] [-n|--no-push]"
}

while getopts "bpn:-:" opt; do
  case $opt in
    b)
      BRANCH_OPT=$OPTARG
      ;;
    p)
      PUSH="true"
      ;;
    n)
      PUSH="false"
      ;;
    -)
      case $OPTARG in
        branch=*)
          BRANCH_OPT==${OPTARG#*=}
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
    -h)
      usage
      exit 1
      ;;
  esac
done

logs() {
  echo "$lightyellow[LOGS]$normal $@"
}

errors() {
  echo "$red[ERR]$normal"
  echo "$red[ERR]$normal $@"
  echo "$red[ERR]$normal"
}

# Some noise stuff
#logs "Cleaning logs..."
> ./git-sync.log.txt
#logs "Cleaned logs!"

request_commit_message()
{
  echo -n "Please enter your commit message (default: Update): "
  read COMMIT_MESSAGE
  if [ -z "$COMMIT_MESSAGE" ]; then
    COMMIT_MESSAGE="Update"
  fi
}

push_changes()
{
  if [ -z "$BRANCH_OPT" ]
  then
    echo -n "Please choose the branch you want to commit (example: dev, main): "
    read BRANCH
  else
    BRANCH="$BRANCH_OPT"
    echo "Commiting on branch $BRANCH"
  fi

  CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

  if [ "$BRANCH" = "$CURRENT_BRANCH" ]; then
    echo "Allready on branch $CURRENT_BRANCH"
  else
    git checkout $BRANCH > ./git-sync.log.txt
    if [ $? -ne 0 ]; then
      errors "Failed to move in branch $BRANCH"
      echo -n "Would you like to commit your changes before moving branch ? (Y/n): "
      read RESPONSE

      if [ -z "$RESPONSE" ]; then
        RESPONSE="y"
      fi

      if [ "${RESPONSE,,}" = "y" ]; then
        echo "Commiting..."
        request_commit_message
        git add -A && git commit -m "$COMMIT_MESSAGE"
      else
        echo "Aborting."
        return 1
      fi
    fi
  fi

  request_commit_message
  echo "Commiting and pushing with message: $COMMIT_MESSAGE"

  git add -A && git commit -m \""$COMMIT"\"

  if [ -z "$PUSH" ]; then
    echo -n "Would you like to push the changes ? (Y/n): "
    read PUSH_RESPONSE

    if [ -z "$PUSH_RESPONSE" ]; then
      PUSH_RESPONSE="y"
    fi

    if [ "${PUSH_RESPONSE,,}" = "y" ]; then
      echo "Pushing..."
      git push
    fi
  else
    if [ "$PUSH" = "true" ]; then
      echo "Pushing..."
      git push > ./git-sync.log.txt
      if [ $? -ne 0 ]; then
        echo "Failed to push"
        return 1
      else
        echo "Successfully pushed changes"
      fi
    fi
  fi
}

if [[ `git status --porcelain` ]]; then
  push_changes
  exit 0
else
  echo "There is no changes to commit."
fi