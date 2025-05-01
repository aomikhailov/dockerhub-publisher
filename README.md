# Dockerhub Publisher

<img src="https://flagcdn.com/w20/ru.png" alt="RU flag"> [Читать по-русски](README.ru.md)
 
## Description
**Dockerhub Publisher** is a script for automating the build and publishing of Docker images to Docker Hub.

If you regularly work with Docker and often build and publish local images, sooner or later you'll face these questions:
- Where to store build parameters and additional files?
- How to securely pass login and access token to Docker Hub?
- How to simplify and speed up the entire process?

**Dockerhub Publisher** solves these problems: it simplifies configuration, makes the process reproducible and safe, and reduces manual actions to a minimum.

## Installation

1. Clone the repository and enter it:
   ```bash
   git clone https://github.com/aomikhailov/dockerhub-publisher.git
   cd dockerhub-publisher
   ```

2. Run the setup script:

In the example below, `/opt/dockerhub-publisher/` is the folder where your image build projects will be stored, and `docker-image` is the name of a specific image project.
Note: Writing to `/opt/dockerhub-publisher/` requires root access, but you're free to use any directory where you have write permission. If you use another path, adjust the parameter accordingly.

```bash
./setup.sh install /opt/dockerhub-publisher/docker-image
```

You can also install a demo project with a preconfigured image build setup:

```bash
./setup.sh install-demo /opt/dockerhub-publisher/demo
```

## Usage

1. Make sure Docker is installed. Otherwise, why do you need this script? This command will show the Docker version or return an error:

```bash
docker --version
```

2. Navigate to your project folder:

If you installed the demo project with `./setup.sh install-demo /opt/dockerhub-publisher/demo`, use:

```bash
cd /opt/dockerhub-publisher/demo
```

3. Set the build and push parameters in the `.env` file:

```bash
DOCKERHUB_USERNAME=<your_username>
DOCKERHUB_TOKEN=<your_token>
DOCKER_IMAGE_NAME=<image_name>
DOCKER_IMAGE_TAG=<image_tag>
DOCKER_BUILD_ARGS=<optional_build_args>
```

4. Available commands:

- Build image:
  ```bash
  ./publisher.sh build
  ```

- Push image:
  ```bash
  ./publisher.sh push
  ```

- Full build and push process:
  ```bash
  ./publisher.sh all
  ```

## Security Recommendations
Make sure the `.env` file in your project is not readable by other users. For example:

```bash
chmod 600 .env
```

## More Info

- **My Docker Hub profile:** [almihub](https://hub.docker.com/u/almihub)
- **Demo image:** [almihub/tomcat11-jdk23](https://hub.docker.com/r/almihub/tomcat11-jdk23)

### Pull demo image:
```bash
docker pull almihub/tomcat11-jdk23
```

### Run container from demo image:
```bash
docker run -d -p 8080:8080 \
-e TOMCAT_ADMIN_PASSWORD=<your_admin_password> \
--name tomcat almihub/tomcat11-jdk23
```

### Verify the container is running:
```bash
docker ps
```
The container should appear with the name `tomcat`.

Open your browser and go to [http://localhost:8080](http://localhost:8080).

If everything is configured correctly, you will see the web app page.

## License
This project is licensed under the MIT License. See [LICENSE](./LICENSE) for details.

