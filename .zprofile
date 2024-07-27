eval "$(/opt/homebrew/bin/brew shellenv)"

alias edit="sudo nvim ~/.zshrc"

#git ammend
alias gcommit="git commit --amend --no-edit"

gpush(){
gsafe
fpush $(git rev-parse --abbrev-ref HEAD)
}

gup(){
gsafe
git push -u origin $(git rev-parse --abbrev-ref HEAD)
}

gadd(){
git status
git add .
git status
}

gout(){
git checkout $1
}

gmap(){
git checkout -b $1
}

gsafe(){
echo $(git rev-parse --abbrev-ref HEAD)
}

gpull(){
gfetch
greset
}

gfetch(){
git fetch
}

greset(){
git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
}

fpush(){
git push origin $1 --force-with-lease
}