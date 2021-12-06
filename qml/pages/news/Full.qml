import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Terminalaccess 1.0
import Ubuntu.Components.Popups 0.1


Page {
    id: pageNews
    property string fullText: ""
    property string title: ""
    property string url: ""
    property string headertext: ""

    header: PageHeader {
        id: headerSettings
        title: pageNews.headertext;
       StyleHints {
           foregroundColor: "#FFFFFF";
           backgroundColor: "#111111";
       }
            leadingActionBar.actions: [
                Action {
                    iconName: "back"
                    text: "Back"
                    onTriggered: {
                        pageStack.pop();
                    }
                }
		
            ]        
	    trailingActionBar.numberOfSlots: 2
		trailingActionBar.actions: [
			Action {
                    iconName: "stock_website"
                    text: "Open in browser"
                    onTriggered: {
			Qt.openUrlExternally(url)
                    }
		    },
			Action {
                    iconName: "share"
                    text: "Share url"
                    onTriggered: {
			pageStack.push(Qt.resolvedUrl("Share.qml"),{url: url})
		    }
		    }
		]
   }
    
Rectangle {
    id:mainsettings
        anchors.fill: parent
        color: "#111111"
        anchors.topMargin: units.gu(6)
    
    Flickable {
        id: flickableSettings
        anchors.fill: parent
        contentHeight: detailRSSColumn.height+units.gu(3)
        flickableDirection: Flickable.VerticalFlick
        clip: true
            
 Column {
            id: detailRSSColumn
            spacing: units.gu(2)
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: units.gu(1)
                leftMargin: units.gu(1)
                rightMargin: units.gu(1)
            }
            
	Label {
		id:title
		text: pageNews.title
		color:"white"
		width:parent.width
		textSize: Label.Large
		wrapMode:Text.WordWrap
	}
	Text {
		id: textDescrNews
		width:parent.width
		wrapMode:Text.WordWrap
		horizontalAlignment:Text.AlignJustify
		color:"white"
		text: pageNews.fullText
	}
	}//column
    } //flickable
 } //rectangle settings
    
    
    
}
