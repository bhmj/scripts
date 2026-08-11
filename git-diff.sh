function git-diff () {
        local exclude_file=.vscode/exclude.txt 
        if [[ -f "$exclude_file" ]]
        then
                git diff HEAD --numstat -- $(sed 's#^#:(exclude)#' "$exclude_file")
                git ls-files --others --exclude-standard | grep -v -F -f "$exclude_file" | while IFS= read -r file
                do
                        awk 'END { print NR "\t0\t" FILENAME }' "$file"
                done
        else
                git diff HEAD --numstat
                git ls-files --others --exclude-standard | while IFS= read -r file
                do
                        awk 'END { print NR "\t0\t" FILENAME }' "$file"
                done
        fi
}

function git-diff-total () {
        git-diff | awk '{ added += $1; deleted += $2 }
          END { printf "+%d -%d\n", added, deleted }'
}
