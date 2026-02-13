# Python + uv

## Why uv?

`uv` is a Rust-based Python package manager that replaces pip, pip-tools, and virtualenv. It's 10-100x faster than pip for installs and resolution.

## Aliases

```bash
py          # python3
uvv         # uv venv (create .venv in current dir)
uva         # source .venv/bin/activate
uvd         # deactivate
uvi         # uv pip install <package>
uvir        # uv pip install -r requirements.txt
jn          # jupyter notebook
jl          # jupyter lab
```

## Workflow

### New Python project

```bash
mkdir my-project && cd my-project
uvv                             # creates .venv/
uva                             # activates it
uvi jupyter jupyterlab          # install jupyter
uvi pandas numpy                # install packages
jl                              # launch Jupyter Lab
```

### Jupyter notebooks

Jupyter is installed per-project via `uv` (not globally). This keeps environments clean and reproducible.

```bash
uvv && uva                      # create + activate venv
uvi jupyter jupyterlab          # install jupyter in venv
jl                              # launch Jupyter Lab in browser
```

### Requirements file

```bash
uvi -r requirements.txt         # install from file
uv pip freeze > requirements.txt # export current env
```

## Starship integration

When a Python virtualenv is active, Starship shows the venv name in the prompt:

```
~/projects/my-analysis  main !  my-analysis >
```

This only appears when a venv is active -- no noise otherwise.

## Environment variables

Set in `.exports`:
- `PYTHONDONTWRITEBYTECODE=1` -- no `__pycache__` clutter
- `UV_CACHE_DIR=~/.cache/uv` -- centralized cache
