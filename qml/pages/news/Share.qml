import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3

Page {
	id: shareView
	title: i18n.tr("Send URL To...")

	property var url

	function shareLink(url) {
		cpp.contentType = ContentType.Links
		shareView.url = url
	}

	ContentPeerPicker {
		id: cpp
		objectName: "sharePicker"
		anchors.fill: parent
		contentType: ContentType.Pictures
		handler: ContentHandler.Share
		showTitle: false

		onPeerSelected: {
			pageStack.pop()
			var activeTransfer = peer.request()
			if (activeTransfer.state === ContentTransfer.InProgress) {
				activeTransfer.items = [ resultComponent.createObject(parent, {"url": parent.url}) ]
				activeTransfer.state = ContentTransfer.Charged
			}
		}

		onCancelPressed: pageStack.pop()
	}

	Component {
		id: resultComponent
		ContentItem {}
	}
}
