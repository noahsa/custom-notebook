FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.3.0

LABEL name="s2i-generic-data-science-streamlit-notebook:latest" \
      summary="Generic Data Science Jupyter Notebook Source-to-Image for Python 3.9 applications." \
      description="Notebook image based on Source-to-Image.These images can be used in OpenDatahub JupterHub." \
      io.k8s.description="Notebook image based on Source-to-Image.These images can be used in OpenDatahub JupterHub." \
      io.k8s.display-name="Generic Data Science with Streamlit Notebook Python 3.9-ubi8 S2I" \
      io.openshift.expose-services="8888:http" \
      io.openshift.tags="python,python39" \
      authoritative-source-url="https://quay.io/nsayre/s2i-generic-data-science-streamlit-notebook" \
      io.openshift.s2i.build.commit.ref="main" \
      io.openshift.s2i.build.source-location="https://github.com/guimou/custom-notebooks" \
      io.openshift.s2i.build.image="quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.2.2"

USER root

WORKDIR /tmp/

# Copying custom packages
COPY pyproject.toml poetry.lock /tmp/

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
ENV PATH="$HOME/.poetry/bin:${PATH}"
RUN cd /tmp && poetry export -f requirements.txt --output requirements.txt --without-hashes && rm -f poetry.lock && rm -f pyproject.toml


RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt

RUN jupyter lab build && \
    jupyter lab clean && \
    npm cache clean --force && \
    rm -rf /usr/local/share/.cache/yarn && \
    fix-permissions /opt/app-root

WORKDIR /opt/app-root/src
USER 1001

CMD /opt/app-root/bin/start-singleuser.sh --ip=0.0.0.0 --port=8080
