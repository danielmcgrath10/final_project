// This is taken from https://medium.com/flatiron-labs/improving-ux-with-phoenix-channels-react-hooks-8e661d3a771e
import React, { useEffect } from 'react';
import {Socket} from "phoenix";
import SocketContext from './socket-context';

const SocketProvider = ({url, options, children}) => {
    let socket_url = `wss://final.danny-mcgrath.com${url}`;
    const socket = new Socket(socket_url, {params: options})

    useEffect(() => {
        socket.connect()
    }, [options, url])

    return(
        <SocketContext.Provider value={socket}>
            {children}
        </SocketContext.Provider>
    )
};

export default SocketProvider;
