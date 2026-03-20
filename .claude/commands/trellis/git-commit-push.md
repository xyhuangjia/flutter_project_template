# Git Commit & Push

Optimize code, format, commit and push to remote repository.

## Steps

### 1. Optimize Code

Call `/simplify` to review and optimize changed code:

```
/simplify
```

### 2. Format Code

Run Dart format on all files:

```bash
dart format .
```

### 3. Verify Code Quality

Ensure no errors before committing:

```bash
flutter analyze
```

### 4. Check Changes

Review what will be committed:

```bash
git status
git diff --stat
```

### 5. Create Commit

Create a descriptive commit message following conventional commits:

```bash
git add -A
git commit -m "<type>: <description>"
```

**Types**: feat, fix, refactor, docs, test, chore, perf, ci

### 6. Push to Remote

Push to remote repository:

```bash
git push
```

For new branch, use:

```bash
git push -u origin <branch-name>
```

## Output

```
✅ Code optimized and formatted
✅ Commit: <commit-hash>
✅ Pushed to <remote>/<branch>
```