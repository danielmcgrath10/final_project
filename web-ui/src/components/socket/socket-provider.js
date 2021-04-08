// This is taken from https://medium.com/flatiron-labs/improving-ux-with-phoenix-channels-react-hooks-8e661d3a771e
import React, { useEffect } from 'react';
import {Socket} from "phoenix";
import SocketContext from './socket-context';

const SocketProvider = ((url, options, children) => {
    const socket = new Socket(url, {params: options})

    useEffect(() => {
        socket.connect()
    }, [options, url])

    return(
        <SocketContext.Provider value={socket}>
            {children}
        </SocketContext.Provider>
    )
});

export default SocketProvider;
