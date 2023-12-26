{ buildPythonApplication
, cairosvg
, calibre
, chardet
, cssselect
, cssutils
, ftfy
, gitpython
, jdk17_headless
, lib
, lxml
, natsort
, pillow
, psutil
, pyphen
, pytestCheckHook
, pythonRelaxDepsHook
, regex
, requests
, rich
, roman
, selenium
, setuptools
, smartypants
, tinycss2
, titlecase
, unidecode
}: buildPythonApplication {
  pname = "standardebooks";
  version = "2.6.1";
  src = ./.;
  pyproject = true;

  nativeBuildInputs = [ setuptools pythonRelaxDepsHook ];
  pythonRemoveDeps = [ "importlib.resources" ];
  pythonRelaxDeps = true;

  buildInputs = [ calibre jdk17_headless ];
  propagatedBuildInputs = [
    cairosvg
    chardet
    cssselect
    cssutils
    ftfy
    gitpython
    lxml
    natsort
    pillow
    psutil
    pyphen
    regex
    requests
    rich
    roman
    selenium
    smartypants
    tinycss2
    titlecase
    unidecode
  ];

  postPatch = ''
    substituteInPlace \
      se/se_epub_build.py \
      --replace 'shutil.which("ebook-convert")' '"${calibre}/bin/ebook-convert"'
    substituteInPlace \
      se/se_epub_build.py \
      --replace 'shutil.which("java")' '"${jdk17_headless}/bin/java"'
    # Replace package importlib_resources with stdlib importlib.resources.
    # This is acceptable because we know that we have a new enough Python.
    substituteInPlace \
      $(grep -R -l --include '*.py' 'importlib_resources' .) \
      --replace 'importlib_resources' 'importlib.resources'
  '';

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    # Move source to prevent it from being imported during tests...
    mv se se-src
    # Put the built package on PATH for tests...
    export PATH="$out/bin:$PATH"
  '';

  meta = {
    description = "The toolset used to produce Standard Ebooks epub ebooks";
    homepage = "https://standardebooks.org/";
    changelog = "https://github.com/standardebooks/tools/blob/master/CHANGELOG.md";
    # N.B.: This license covers the *code* of this package,
    # but there is also data covered by various other licenses
    # as described in LICENSE.md files throughout the tree.
    license = lib.licenses.gpl3Only;
    mainProgram = "se";
  };
}
