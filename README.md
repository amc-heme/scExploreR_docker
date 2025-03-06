# Deploy scExploreR with Docker.

Object/project names have been left generic.

Object:  Triana et al (2021) Seurat Object (RDS): [publication url](https://www.nature.com/articles/s41590-021-01059-0)

For more details, see the [scExploreR Docker Vignette](https://amc-heme.github.io/scExploreR/articles/docker.html).

## 1. Clone this Repository Locally

```bash
git clone git@github.com:amc-heme/scExploreR_docker.git 
cd scExploreR_docker
```

## 2. Build the Docker Image

```bash
docker build --platform=linux/amd64 -t scexplorer .
```

- `--platform=linux/amd64` : Builds the image for the amd64 architecture. (remove if not using ARM Mac)
- `-t scexplorer` : Tags the image with the name scexplorer.
- `.` : Specifies the current directory as the build context.

**Troubleshooting:** Building the image may take some time (30+ min) as it installs several packages. If you encounter errors, ensure that all package names and dependencies are correct.

## 3. Run the Docker Container

```bash
docker run --rm -p 3838:3838 scexplorer
```

## 4. Access scExploreR

In your preferred web browser, navigate to [http://localhost:3838/](http://localhost:3838/)
