import React, { useContext, useEffect } from "react";
import { connect } from "react-redux";
import "./home.scss";
import store from "../../store";
import SocketContext from "../../components/socket/socket-context";
import _ from "lodash";
import FeedCard from "../../components/feed-card/feed-card";

function Home({session, feed}) {
    const socket = useContext(SocketContext);

    // Portions inspired by:
    // https://medium.com/flatiron-labs/improving-ux-with-phoenix-channels-react-hooks-8e661d3a771e
    useEffect(() => {
        const channel = socket.channel("feed:", {params: {session: session}});

        channel.onMessage = (event, payload) => {
            if(event === "phx_reply"){
                let action = {
                    type: "feed/set",
                    data: payload,
                };
                store.dispatch(action);
            } else if (event === "feed/update"){
                let action = {
                    type: event,
                    data: payload
                }
                store.dispatch(action);
            }
            return payload;
        }

        channel.join()
            .receive("ok", ({message, payload}) => console.log(`Successfully Joined Channel`, message, payload))
            .receive("error", ({error}) => {
                console.log(error);
            })

        return()  => {
            channel.leave();
        }
    }, [])

    return(
        <div id={"home-page"}>  
            {
                _.isEmpty(feed) ?
                    <h1>No Current Events</h1>
                :
                    _.map(feed.reverse(), (post, index) => (
                        <FeedCard key={index} session={session} post={post}/>
                    ))
            }
        </div>
    )
}

export default connect(({session, feed}) => ({session, feed}))(Home);
