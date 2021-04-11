import _ from "lodash";
import { NotificationManager } from "react-notifications";
import {createStore, combineReducers} from "redux";

function users(state=[], action){
    switch(action.type) {
        case 'users/set':
            return action.data;
        default:
            return state;
    }
}

function save_session(sess) {
    let session = Object.assign({}, sess, { time: Date.now() });
    localStorage.setItem("session", JSON.stringify(session));
  }
  
  function stop_session() {
    localStorage.removeItem("session");
    if(!localStorage.getItem("session")){
      NotificationManager.success("Successfully Logged Out");
    } else {
      NotificationManager.error("Something Went Wrong, Please Try Again");
    }
  }
  
  function restore_session() {
    let session = localStorage.getItem("session");
    if (!session) {
      return null;
    }
  
    session = JSON.parse(session);
    let age = Date.now() - session.time;
    let hours = 60 * 60 * 1000;
    if (age < 24 * hours) {
      return session;
    } else {
      return null;
    }
  }
  
  function session(state = restore_session(), action) {
    switch (action.type) {
      case "session/set":
        save_session(action.data);
        return action.data;
      case "session/clear":
        stop_session();
        return null;
      default:
        return state;
    }
  }

function reviews(state=[], action){
  switch(action.type) {
    case "reviews/set":
      return action.data;
    case "reviews/add_review":
      let data = action.data;
      return Object.assign({}, state, {
        review: data,
      })
    default:
      return state;
  }
}

function error(state=null, action) {
  switch(action.type) {
    case "session/set":
      return null;
    case "error/set":
      return action.data;
    default:
      return state;
  }
}

export function feed(state=[], action){
  let data;
  switch(action.type) {
    case "feed/set":
      data = action.data.response.data;
      if(_.isEmpty(data)){
        return state;
      } else {
        return _.reverse(data);
      }
    case "feed/update":
      data = action.data.data;
      if(_.isEmpty(data)){
        return state;
      } else {
        return _.reverse(data);
      }
    default:
      return state;
  }
}

function root_reducer(state, action) {
    let reducer = combineReducers({
        users, session, error, feed, reviews
    });
    return reducer(state, action);
}

let store = createStore(root_reducer);
export default store;