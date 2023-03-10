// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from "react";
import ReactDOM from "react-dom";
import PropTypes from "prop-types";
// import 'foundation-sites/dist/css/foundation.min.css';
import { Button, Colors } from "react-foundation";

const Hello = (props) => (
  <div>
    <span>Hello {props.name}!</span>
    {/* <Button color={Colors.PRIMARY}>OK</Button> */}
  </div>
);

Hello.defaultProps = {
  name: "David",
};

Hello.propTypes = {
  name: PropTypes.string,
};

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <Hello name="PUFF" />,
    document.body.appendChild(document.createElement("div"))
  );
});
