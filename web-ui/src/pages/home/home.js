import React from "react";
import { connect } from "react-redux";
import useChannel from "../../components/socket/channel";
import { feed_reducer } from "../../store";
import "./home.scss";

function Home({session}) {
    const initialState = {feed: {}};
    const {feed} = useChannel("feed:", feed_reducer, initialState, session);
    return(
        <div>  
            Hello World
        </div>
    )
}

export default connect(({session}) => ({session}))(Home);
