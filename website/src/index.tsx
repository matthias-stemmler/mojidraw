import './index.scss';
import App from './components/app/app';
import { render } from 'preact';

const root: HTMLElement | null = document.getElementById('root');
if (root !== null) {
  render(<App />, root);
}
