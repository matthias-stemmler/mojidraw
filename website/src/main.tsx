import './index.scss';
import App from './components/app/app';
import { render } from 'preact';

const root = document.getElementById('app');
if (root !== null) {
  render(<App />, document.getElementById('app') as HTMLElement);
}
