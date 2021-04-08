// Taken from https://medium.com/flatiron-labs/improving-ux-with-phoenix-channels-react-hooks-8e661d3a771e
import { useContext, useEffect, useReducer } from "react"
import { NotificationManager } from "react-notifications";
import SocketContext from "./socket-context"

const useChannel = (channel, reducer, initialState) => {
    const socket = useContext(SocketContext);
    const [state, dispatch] = useReducer(reducer, initialState);

    useEffect(() => {
        const channel = socket.channel(channel, {client: "browser"});

        channel.onMessage = (event, payload) => {
            dispatch({event, payload});
            return payload;
        }

        channel.join()
            .receive("ok", ({message}) => NotificationManager.success(`Successfully Joined Channel`, message))
            .receive("error", ({error}) => NotificationManager.error("Error received", error))

        return() => {
            channel.leave();
        }
    }, [channel])

    return state;
}

export default useChannel;