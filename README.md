# github-archive

*⌛ A collection of my old GitHub projects and code.*

I started using Git and GitHub some time ago. Since then, I've learned new things and improved my skills.

I thought it would be useful to preserve some of my old code and projects as an archive of my progress over the years.

Knowledge is never enough — and, as many say, knowledge is power.

## 📦 Repository Archives

Old repositories are stored as `.zip` files.

Since repository archives can be large, this repository uses **Git LFS (Large File Storage)** to store ZIP files without adding large binary files directly to the Git history.

## 🔧 Git LFS Setup

Install Git LFS if it isn't already installed:

```bash
git lfs install
```

Configure Git LFS to track ZIP files:

```bash
git lfs track "*.zip"
```

This creates or updates the `.gitattributes` file with:

```gitattributes
*.zip filter=lfs diff=lfs merge=lfs -text
```

Make sure `.gitattributes` is committed:

```bash
git add .gitattributes
git commit -m "Configure Git LFS for ZIP archives"
```

## 📤 Adding an Archived Repository

Add the ZIP file normally:

```bash
git add old-project.zip
git commit -m "Archive old-project"
git push
```

Git LFS will automatically upload the actual ZIP file to LFS storage.

You can check which files are managed by Git LFS with:

```bash
git lfs ls-files
```

Check the current LFS status with:

```bash
git lfs status
```

## 📥 Cloning the Archive

Clone the repository normally:

```bash
git clone <repository-url>
cd github-archive
```

Make sure Git LFS is installed:

```bash
git lfs install
```

Then download the actual LFS files:

```bash
git lfs pull
```

Without Git LFS, ZIP files may appear as very small files and will not open as valid ZIP archives. These are Git LFS pointer files rather than the actual archived files.

A pointer file looks similar to:

```text
version https://git-lfs.github.com/spec/v1
oid sha256:...
size ...
```

Running:

```bash
git lfs pull
```

replaces these pointers in the working tree with the actual files.

## 🔄 Download All LFS Objects

To fetch all LFS objects referenced by the repository:

```bash
git lfs fetch --all
```

Then check them out into the working tree:

```bash
git lfs checkout
```

Alternatively, for normal usage:

```bash
git lfs pull
```

is usually enough.

## 📤 Ensure All LFS Files Are Uploaded

To explicitly push all LFS objects referenced by the repository to `origin`:

```bash
git lfs push --all origin
```

This can be useful when verifying that an archive has been fully uploaded.

## 🔍 Useful Commands

List files managed by Git LFS:

```bash
git lfs ls-files
```

Check LFS status:

```bash
git lfs status
```

Download required LFS files:

```bash
git lfs pull
```

Fetch every LFS object:

```bash
git lfs fetch --all
```

Restore downloaded LFS objects into the working tree:

```bash
git lfs checkout
```

Upload all LFS objects:

```bash
git lfs push --all origin
```

Show Git LFS environment information:

```bash
git lfs env
```

## ⚠️ Archive Verification

Before deleting an original repository, verify that its archive can be successfully restored.

A good verification process is:

```bash
git clone <repository-url> github-archive-test
cd github-archive-test
git lfs pull
git lfs ls-files
```

Then open and extract the archived ZIP files to make sure they are valid.

> **Important:** A Git commit containing an LFS pointer does not by itself guarantee that the corresponding LFS object is available remotely. Always verify important archives before deleting the original repository.
