# How to port changes from repkgs

## 1. Sync

```console
git fetch --no-tags --prune repkgs 'refs/heads/main:refs/remotes/repkgs/main'
git fetch origin --prune
```

## 2. See what's new

```console
git log --oneline origin/main..repkgs/main
```

## 3. Port

### Single commit

```console
git cherry-pick <sha>
```

### Range / several commits

```console
git cherry-pick <oldest-sha>^..<newest-sha>
```

### Everything at once

```console
git merge repkgs/main --no-ff
```
