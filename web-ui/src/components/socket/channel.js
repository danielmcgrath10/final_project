// Taken from https://medium.com/flatiron-labs/improving-ux-with-phoenix-channels-react-hooks-8e661d3a771e
import { useContext, useEffect, useReducer } from "react"
import { NotificationManager } from "react-notifications";
import SocketContext from "./socket-context"

const useChannel = (channelName, reducer, initialState, session) => {
    const socket = useContext(SocketContext);
    const [state, dispatch] = useReducer(reducer, initialState);

    useEffect(() => {
        const channel = socket.channel(channelName + "hello", {params: {session: session}});
        console.log(channel);

        channel.onMessage = (event, payload) => {
            dispatch({event, payload});
            return payload;
        }

        channel.join()
            .receive("ok", ({message}) => console.log(`Successfully Joined Channel`, message))
            .receive("error", ({error}) => {
                console.log(error);
            })

        return() => {
            channel.leave();
        }
    }, [channelName])

    return state;
}

export default useChannel;