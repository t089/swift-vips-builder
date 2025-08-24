#
# Build dependencies
#
ARG SWIFT_VERSION=6.1.2
FROM public.ecr.aws/docker/library/swift:${SWIFT_VERSION}-noble AS deps

ARG VIPS_VERSION=8.16.0
ENV VIPS_VERSION=${VIPS_VERSION}


ENV LIBJXL_VERSION=0.11.0
ENV LIBJPEGTURBO_VERSION=2.1.5.1
ENV LIBRAW_VERSION=8afe44cd0e96611ba3cb73779b83ad05e945634c
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV CPATH=/usr/local/include

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
  automake \
  build-essential \
  clang \
  curl \
  git \
  gpg \
  liblcms2-dev \
  libexif-dev \
  libexpat1-dev \
  libfftw3-dev \
  libglib2.0-dev  \
  libheif-dev \
  libjpeg-turbo8-dev \
  libpango1.0-dev \
  libpng-dev \
  libbrotli-dev \
  libssl-dev \
  libtiff5-dev \
  libtool \
  libwebp-dev \
  ninja-build \
  pkg-config  \
  python3 \
  python3-full \
  python3-venv \
  python3-pip \
  python3-setuptools \
  python3-wheel \
  tzdata \
  zlib1g-dev

# Create and activate virtual environment for meson
RUN python3 -m venv /opt/meson-venv
ENV PATH="/opt/meson-venv/bin:$PATH"
RUN pip install meson

# CMake
RUN curl -Ls https://apt.kitware.com/keys/kitware-archive-latest.asc \
      | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
      echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ noble main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
      apt-get -qq update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
         cmake && \
      rm -r /var/lib/apt/lists/* \
       && cmake --version

RUN mkdir libjxl && cd libjxl && curl -Ls https://github.com/libjxl/libjxl/archive/refs/tags/v${LIBJXL_VERSION}.tar.gz \
       | tar -xzC . --strip-components=1 && \
       bash deps.sh && \
       mkdir build && cd build &&\
       CC=clang CXX=clang++ cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF -DCMAKE_POLICY_VERSION_MINIMUM=3.5 .. && \
       CC=clang CXX=clang++ cmake --build . -- -j$(nproc) && \
       CC=clang CXX=clang++ cmake --install . && \
       cd / && rm -rf libjxl
      


RUN mkdir libjasper && \
    cd libjasper && \
    curl -Ls https://github.com/jasper-software/jasper/archive/refs/tags/version-2.0.33.tar.gz \
    | tar -xzC . --strip-components=1 && \
    mkdir .build && \
     cmake \
      -G"Unix Makefiles" \
      -B.build \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      && \
      cd .build && \
      make install \
      && cd / && rm -rf libjasper
      
RUN git clone https://github.com/LibRaw/LibRaw.git && \
    cd LibRaw && \
    git checkout ${LIBRAW_VERSION} && \
    autoreconf --install && \
    ./configure && \
    make && \
    make install && \
    cd / && rm -rf LibRaw

#libvips
RUN curl -O -L -s --fail -v "https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz" \
    && tar -xf vips-${VIPS_VERSION}.tar.xz && \
    cd vips-$VIPS_VERSION && \
    meson setup build-dir --prefix=/usr/local --buildtype=release \
                --libdir=lib \
                -Dintrospection=disabled && \
    cd build-dir && \
    meson compile && \
    meson install && \
    cd / && rm -rf vips-${VIPS_VERSION} vips-${VIPS_VERSION}.tar.xz