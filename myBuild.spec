# -*- mode: python ; coding: utf-8 -*-

"""
This file is a technical file that give the specification for building the application.
It was generated using both
pyi-makespec main.py
pyi-makespec MyOGPrinter.py
and combining the results + adding files.

Then, one can build the application using
pyinstaller myBuild.spec
"""

added_files = [
         ('README.md', '.'),
         ('inputData/', 'inputData/'),
         ('GUI/', 'GUI/'),
         ('temp/', 'temp/')
         ]

# specifications generated for main.py
a_main = Analysis(
    ['main.py'],
    pathex=[],
    binaries=[],
    datas=added_files,
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz_main = PYZ(a_main.pure)

exe_main = EXE(
    pyz_main,
    a_main.scripts,
    [],
    exclude_binaries=True,
    name='main',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)


# specifications generated for MyOGPrinter.py
a_printer = Analysis(
    ['MyOGPrinter.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz_printer = PYZ(a_printer.pure)

exe_printer = EXE(
    pyz_printer,
    a_printer.scripts,
    [],
    exclude_binaries=True,
    name='MyOGPrinter',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)

coll = COLLECT(
    exe_main,
    a_main.binaries,
    a_main.datas,
    exe_printer,
    a_printer.binaries,
    a_printer.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='main',
)
