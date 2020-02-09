alias project="echo '---------------------------------'; echo 'My Project Name'; echo '---------------------------------'; cd ~/My/Projects/secret;ls"

alias artisan="php artisan"
alias art="php artisan"
alias status="git status"

pull() {
    git pull origin $1
}

commit() {
    git status ; git add . ; git commit -m $1 ; git status
}

push() {
    git push origin $1
}

seed() {
    php artisan migrate --seed
}

storage() {
    sudo chmod -R 777 storage/
}
