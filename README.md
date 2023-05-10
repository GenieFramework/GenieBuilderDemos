# GenieBuilderDemos

This repository contains the code for the Genie Builder demos. For step-by-step tutorials, check out the [Genie Framework Blog](https://genieframework.com/blog/index.html).

To run the demos, install the Genie Builder VSCode plugin and copy the contents of this repository into `~/.julia/geniebuilder/`.

## Boostrapping your Genie Cloud account / Genie Builder

To preload these apps into your GC account, follow the steps below.

1. Open a terminal and go into `~.julia/geniebuilder/`
```bash
cd ~.julia/geniebuilder/

![](img/newterminal.png)
```
2. Remove the `apps` folder:
```bash
rm -rf apps
```
3. Clone this repository into a new `apps` folder:
```bash
git clone https://github.com/GenieFramework/GenieBuilderDemos.git apps

```

4. Go into `apps` and install the required packages for each app:
```
cd apps
```

```bash
for dir in */ ; do
  if [ -d "$dir" ]; then
    echo "Processing $dir"
    cd "$dir"
    julia --project=. -e 'using Pkg; Pkg.instantiate()'
    cd ..
  fi
done

```
