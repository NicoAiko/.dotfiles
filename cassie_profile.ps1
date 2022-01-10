function Write-BranchName() {
    try {
        $branch = git rev-parse --abbrev-ref HEAD

        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
            Write-Host " ($branch)" -ForegroundColor "red"
        } else {
            # we're on an actual branch
            Write-Host " ($branch)" -ForegroundColor "blue"
        }
    } catch {
        # if newly initiated repo
        Write-Host " (no branches yet)" -ForegroundColor "yellow"
    }
}

function prompt {
    $base = "PS "
    $path = "$($ExecutionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$('>' * ($NestedPromptLevel + 1)) "

    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    Write-Host "`n$base" -NoNewline

    if (git rev-parse --is-inside-work-tree) {
        Write-Host $path -NoNewline -ForegroundColor "green"
        Write-BranchName
    } else {
        # we're not in a repo so don't bother displaying whatever
        Write-Host $path -ForegroundColor "green"
    }

    return $userPrompt
}