import os
import shutil
import subprocess
import tempfile


# thanks to https://stackoverflow.com/a/12514470/6164984
def copytree(src, dst, symlinks=False, ignore=None):
    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, symlinks, ignore)
        else:
            shutil.copy2(s, d)

def run(command, **kwargs):
    print(f"$ {' '.join(command)}")
    if 'capture_output' not in kwargs:
        kwargs['capture_output'] = True

    result = subprocess.run(command, **kwargs)
    if result.returncode != 0:
        print('Stdout:')
        print(result.stdout.decode('utf-8'))
        print('Stderr:')
        print(result.stderr.decode('utf-8'))
        raise ValueError(f'Command returned {result.returncode}')
    return result

root = run(['git', 'rev-parse', '--show-toplevel']).stdout.decode('utf-8').strip()
print(f'Root at {root!r}')

commithash = run(['git', 'rev-parse', '--short', 'HEAD']).stdout.decode('utf-8').strip()
print(f'Commit hash {commithash}')

sourcebranch = run(['git', 'rev-parse', '--abbrev-ref', 'HEAD']).stdout.decode('utf-8').strip()
print(f'git source branch: {sourcebranch!r}')

if sourcebranch == 'master':
    raise ValueError("The source branch shouldn't be 'master'")

tempdir = tempfile.mkdtemp()

run(['hugo', '-d', tempdir])

run(['git', 'checkout', 'master'])

print('Removing previous build')

IGNORE = ['.git', 'themes', 'README.md', '.gitignore']

for file in os.listdir(root):
    if file in IGNORE:
        continue
    if os.path.isdir(file):
        shutil.rmtree(file)
    else:
        os.unlink(file)

print(f'Moving from {tempdir} to {root}')
for file in os.listdir(tempdir):
    print('moving', repr(file))
    shutil.move(os.path.join(tempdir, file), root)

run(['git', 'add', '.'])
run(['git', 'commit', '-m', f'Automatic build source: {commithash}'])
run(['git', 'checkout', sourcebranch])
run(['git', 'push', 'origin', 'dev'])
run(['git', 'push', 'origin', 'master'])
