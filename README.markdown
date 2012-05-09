# Prism

## Overview

Prism is websocket server. It depends from
[EventMachine](https://github.com/eventmachine/eventmachine) and
[em-websocket](https://github.com/igrigorik/em-websocket). Prism uses
[Signature](https://github.com/mloughran/signature) gem for request
authentication.

## Usage

    # start Prism
    $ cd [prism_dir]
    $ script/daemon start -- ENV    # ENV = production | development

You will be able to connect to Prism.

    // javascript example
    var url = "ws://yourserver.com?auth_timestamp=1289849097&auth_signature=11f3dd9521a1593aebdba8572f1d4d3ed9f7bf9d09184a764a43c6dbe477d54b&auth_version=1.0&auth_key=PUT-SOME-UNIQ-CODE-HERE";
    var ws = new WebSocket(url);

## Other stuff

    # Prism status
    $ cd [prism_dir]
    $ script/daemon status          #=> runner: running [pid 2273]

    # stop prism
    $ cd [prism_dir]
    $ script/daemon stop

## License

The MIT License

Copyright (c) 2010, Alex Soulim
