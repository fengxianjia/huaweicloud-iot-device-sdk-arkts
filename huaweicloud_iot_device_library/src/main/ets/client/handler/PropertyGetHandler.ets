import { PropsGet } from "../../requests/PropsGet";
import { RawMessage } from "../../requests/RawMessage";
import { IoTUtil } from "../../utils/IoTUtil";
import { LogUtil } from "../../utils/LogUtil";
import { DeviceClient } from "../DeviceClient";
import { MessageReceivedHandler } from "./MessageReceivedHandler";


export class PropertyGetHandler implements MessageReceivedHandler {
  private deviceClient: DeviceClient;

  constructor(deviceClient: DeviceClient) {
    this.deviceClient = deviceClient;
  }

  messageHandler(message: RawMessage): void {
    const requestId = IoTUtil.getRequestId(message.topic);
    try {
      const propsGet: PropsGet = JSON.parse(message.payload);
      const propertyListener = this.deviceClient.propertyListener;
      if (propertyListener !== null && (propsGet.object_device_id == null || propsGet.object_device_id
        === this.deviceClient.device.deviceId)) {
        propertyListener.onPropertiesGet(requestId, propsGet.service_id);
        return;
      }

      this.deviceClient.device.onPropertiesGet(requestId, propsGet);
    } catch (e) {
      LogUtil.error("invalid propsGet");
      return;
    }

  }
}