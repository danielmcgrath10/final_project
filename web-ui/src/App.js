import logo from './logo.svg';
import './App.scss';
import { Container } from 'react-bootstrap';
import { Route, Switch } from 'react-router';
import Login from './pages/login/login';

function App() {
  return (
    <Container fluid className="App">
      {/* {
        session ?

      } */}
      {/* <Switch>
        <Route>
        
        </Route>
      </Switch> */}

      <Login/>
    </Container>
  );
}

export default App;
