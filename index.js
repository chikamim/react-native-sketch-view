import React, { PropTypes, Component } from 'react';
import { requireNativeComponent, View, UIManager, findNodeHandle, DeviceEventEmitter } from 'react-native';

class SketchView extends Component {
  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
    this.subscriptions = [];
  }

  onChange(event) {
    console.log('save event: ', event.nativeEvent);
    if (event.nativeEvent.type === 'onSaveSketch') {
      if (!this.props.onSaveSketch) {
        return;
      }

      this.props.onSaveSketch({
        localFilePath: event.nativeEvent.event.localFilePath,
        imageWidth: event.nativeEvent.event.imageWidth,
        imageHeight: event.nativeEvent.event.imageHeight,
      });
    } else if (event.nativeEvent.type === 'onExportSketch') {
      if (!this.props.onExportSketch) {
        return;
      }

      this.props.onExportSketch({
        base64Encoded: event.nativeEvent.event.base64Encoded,
      });
    }
  }

  componentDidMount() {
    if (this.props.onSaveSketch) {
      let sub = DeviceEventEmitter.addListener('onSaveSketch', this.props.onSaveSketch);
      this.subscriptions.push(sub);
    }
    if (this.props.onExportSketch) {
      let sub = DeviceEventEmitter.addListener('onExportSketch', this.props.onExportSketch);
      this.subscriptions.push(sub);
    }
  }

  componentWillUnmount() {
    this.subscriptions.forEach(sub => sub.remove());
    this.subscriptions = [];
  }

  render() {
    return <RNSketchView {...this.props} onChange={this.onChange} />;
  }

  clearSketch() {
    UIManager.dispatchViewManagerCommand(findNodeHandle(this), UIManager.RNSketchView.Commands.clearSketch, []);
  }

  saveSketch() {
    UIManager.dispatchViewManagerCommand(findNodeHandle(this), UIManager.RNSketchView.Commands.saveSketch, []);
  }

  changeTool(toolId) {
    UIManager.dispatchViewManagerCommand(findNodeHandle(this), UIManager.RNSketchView.Commands.changeTool, [toolId]);
  }

  exportSketch() {
    UIManager.dispatchViewManagerCommand(findNodeHandle(this), UIManager.RNSketchView.Commands.exportSketch, []);
  }
}

SketchView.constants = {
  toolType: {
    pen: {
      id: 0,
      name: 'Pen',
    },
    eraser: {
      id: 1,
      name: 'Eraser',
    },
  },
};

SketchView.propTypes = {
  ...View.propTypes, // include the default view properties
  selectedTool: PropTypes.number,
  localSourceImagePath: PropTypes.string,
  toolThickness: PropTypes.number,
};

let RNSketchView = requireNativeComponent('RNSketchView', SketchView, {
  nativeOnly: { onChange: true },
});

export default SketchView;
