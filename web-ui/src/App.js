import logo from './logo.svg';
import './App.scss';
import { Container } from 'react-bootstrap';
import { Route, Switch, Redirect } from 'react-router';
import Login from './pages/login/login';
import {connect} from "react-redux";
import Home from './pages/home/home';
import Navbar from "./components/navbar/navbar";
import 'react-notifications/lib/notifications.css';
import SocketProvider from './components/socket/socket-provider';
import AroundMe from "./pages/around-me/around-me";


function App({session}) {
  return (
    <Container fluid className="App">
      {
        session ?
          <SocketProvider url={"/socket"}>
            <Navbar/>
            <Switch>
              <Route path={"/feed"}>
                <Home/>
              </Route>
              <Route path={"/search"}>
                <AroundMe />
              </Route>
              <Route exact path={"/"}>
                <Redirect to={"/feed"} />
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
