import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.0

Page {
    id: about

    header: PageHeader {
        title: i18n.tr("About");
       StyleHints {
           foregroundColor: "#FFFFFF";
           backgroundColor: "#111111";
       }
   }


    Rectangle {
        id:rect1
        color: "#111111"
        anchors {
            fill: parent
            topMargin: units.gu(6)
        }

Item {
      width: parent.width
      height: parent.height

    Column {
        anchors {
            left: parent.left
            right: parent.right
        }

        Item {
            width: parent.width
            height: units.gu(5)
            Label {
                text: "Launcher Modular"
                anchors.centerIn: parent
                fontSize: "x-large"
                color: "#ffffff"
            }
        }

        Item {
            width: parent.width
            height: units.gu(14)

            UbuntuShape {
                radius: "medium"
                source: Image {
                    source: Qt.resolvedUrl("../assets/logo.svg");
                }
                height: units.gu(12); width: height;
                anchors.centerIn: parent;


            } // shape
        }/// item

        Item {
            width: parent.width
            height: units.gu(4)
            Label {
                text: "Version 0.1.11"
                fontSize: "large"
                anchors.centerIn: parent
                color: "#ffffff"
            }
        }

        Item {
            width: parent.width
            height: units.gu(2)
        }

        Item {
            width: parent.width
            height: thankLabel.height + units.gu(2)
            Label {
                id: thankLabel
                text: "<b>Crédits</b><br />@Kazord<br />Jimmy Lejeune"
                anchors.centerIn: parent
                wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                width: parent.width - units.gu(12)
                color: "#ffffff"
            }
        }

    }
}
}
// ABOUT PAGE






}
