use std::ffi::{OsStr, OsString};
use std::fmt::{self, Display, Formatter};
use std::path::{Path, PathBuf};

use anyhow::{anyhow, Result};

pub fn dir_of_file(path: &Path) -> Result<&Path> {
    if path.is_file() {
        path.parent()
            .ok_or_else(|| anyhow!("Could not determine directory from path"))
    } else {
        Err(anyhow!("Not a file"))
    }
}

pub fn amend_extension<P>(path: P, amendment: &str, default_extension: &str) -> PathBuf
where
    P: AsRef<Path>,
{
    let path = path.as_ref();

    let extension = path
        .extension()
        .unwrap_or_else(|| OsStr::new(default_extension));

    let target_extension = {
        let mut target_extension = OsString::from(amendment);
        target_extension.push(".");
        target_extension.push(extension);
        target_extension
    };

    match path.file_name() {
        Some(..) => path.with_extension(target_extension),
        None => PathBuf::from(target_extension),
    }
}

pub trait NormalizedPathExt {
    fn normalized(&self) -> NormalizedPath;
}

impl<P> NormalizedPathExt for P
where
    P: AsRef<Path>,
{
    fn normalized(&self) -> NormalizedPath<'_> {
        NormalizedPath(self.as_ref())
    }
}

pub struct NormalizedPath<'a>(&'a Path);

impl Display for NormalizedPath<'_> {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}",
            self.0
                .components()
                .map(|component| {
                    let path: &Path = component.as_ref();
                    path.to_string_lossy().into_owned()
                })
                .collect::<Vec<_>>()
                .join("/")
        )
    }
}
