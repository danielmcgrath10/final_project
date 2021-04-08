import logo from './logo.svg';
import './App.scss';
import { Container } from 'react-bootstrap';
import { Route, Switch, Redirect } from 'react-router';
import Login from './pages/login/login';
import {connect} from "react-redux";
import Home from './pages/home/home';
import Navbar from "./components/navbar/navbar";
import 'react-notifications/lib/notifications.css';
import useChannel from './components/socket/channel';
import SocketProvider from './components/socket/socket-provider';


function App({session}) {
  console.log("session", session);
  // const state = useChannel("feed", reducer)
  return (
    <Container fluid className="App">
      {
        session ?
          <SocketProvider value={"/feed"} options={session["token"]}>
            <Navbar/>
            <Switch>
              <Route path={"/home"}>
                <Home/>
              </Route>
              <Route exact path={"/"}>
                <Redirect to={"/home"} />
              </Route>
            </Switch>
          </SocketProvider>
        :
          <Login/>
      }
    </Container>
  );
}

export default connect(({session}) => ({session}))(App);
