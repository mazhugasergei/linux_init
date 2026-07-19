# Debian init

This is a script to quickly install needed packages including optional minimal desktop environment.

Do have minimal desktop, uncheck "Debian desktop environment" and "GNOME" during Debian installation.

## Usage

```
su -c "bash <(wget -O- https://raw.githubusercontent.com/mazhugasergei/debian_init/main/install.sh)"
```

## Development

Do not inlude shebang (`#!/bin/bash`) in any script files except `build.sh`.

Do not forget to run build sctipt before committing.

### Build

```
chmod +x build.sh
./build.sh
```
