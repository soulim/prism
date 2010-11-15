# Prism

## Overview

Prism is websocket server which was created specially for [TextRows app](http://textro.ws).
It depends from [EventMachine](https://github.com/eventmachine/eventmachine) and [em-websocket](https://github.com/igrigorik/em-websocket). Prism uses [Signature](https://github.com/mloughran/signature) gem for request authentication.

## Usage

    # start Prism
    $ cd [prism_dir]
    $ script/daemon start -- ENV    # ENV = production | development

    # Prism status
    $ cd [prism_dir]
    $ script/daemon status          #=> runner: running [pid 2273]

    # stop prism
    $ cd [prism_dir]
    $ script/daemon stop

## License

The MIT License

Copyright (c) 2010, Alex Soulim