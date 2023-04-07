import React from "react";

export default class TreeSelect extends React.Component {
    constructor(props){
        super(props)
        this.state = {values:this.props.values}
    }
}